defmodule LibraryWeb.BookController do
  use LibraryWeb, :controller

  alias Library.Utility
  alias Library.Catalogue
  alias Library.Catalogue.Book
  alias Utility

  def index(conn, _params) do
    books = Catalogue.list_books()
    render(conn, :index, books: books)
  end

  def new(conn, _params) do
    changeset = Catalogue.change_book(%Book{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"book" => book_params}) do
    case Catalogue.create_book(book_params) do
      {:ok, book} ->
        conn
        |> put_flash(:info, "Book created successfully.")
        |> redirect(to: ~p"/books/#{book}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    book = Catalogue.get_book!(id)
    render(conn, :show, book: book)
  end

  def edit(conn, %{"id" => id}) do
    book = Catalogue.get_book!(id)
    changeset = Catalogue.change_book(book)
    render(conn, :edit, book: book, changeset: changeset)
  end

  def update(conn, %{"id" => id, "book" => book_params}) do
    book = Catalogue.get_book!(id)

    case Catalogue.update_book(book, book_params) do
      {:ok, book} ->
        conn
        |> put_flash(:info, "Book updated successfully.")
        |> redirect(to: ~p"/books/#{book}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, book: book, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    book = Catalogue.get_book!(id)
    {:ok, _book} = Catalogue.delete_book(book)

    conn
    |> put_flash(:info, "Book deleted successfully.")
    |> redirect(to: ~p"/books")
  end

  def new_import(conn, _) do
    render(conn, :new_import)
  end

  def import_books(conn, %{"csv" => csv}) do
    Utility.csv_decoder(csv)
    |> import_book_list()

    conn
    |> put_flash(:info, "Books imported successfully!")
    |> redirect(to: ~p"/books")
  end

  defp import_book_list(data) do
    {:ok, _} =
      data
      |> Enum.map(fn {:ok, book} -> book end)
      |> Catalogue.convert_params()

    # |> Book.insert_book
  end
end
