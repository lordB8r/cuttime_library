defmodule Library.Catalogue do
  @moduledoc """
  The Catalogue context.
  """

  import Ecto.Query, warn: false
  alias Library.Repo

  alias Library.Catalogue.Book

  def list_books do
    Repo.all(Book)
  end

  def get_book!(id), do: Repo.get!(Book, id)

  def create_book(attrs \\ %{}) do
    %Book{}
    |> Book.changeset(attrs)
    |> Repo.insert()
  end

  def update_book(%Book{} = book, attrs) do
    book
    |> Book.changeset(attrs)
    |> Repo.update()
  end

  def delete_book(%Book{} = book) do
    Repo.delete(book)
  end

  def change_book(%Book{} = book, attrs \\ %{}) do
    Book.changeset(book, attrs)
  end

  def convert_params(data) do
    data
  end

  def convert(data) do
    for {k, v} <- data, into: %{}, do: {String.to_atom(k), v}
  end

  def available_for_checkout?(%Book{} = book) do
    available_for_checkout?(book.id)
  end

  def available_for_checkout?(id) do
    case available_stock(id) do
      x when x > 0 -> true
      _ -> false
    end
  end

  def checkout_book(%Book{} = book) do
    book
    |> Book.changeset(%{count_checked_out: book.count_checked_out + 1})
    |> Repo.update()
  end

  def checkout_book(id) do
    get_book!(id)
    |> checkout_book()
  end

  def return_book(%Book{} = book) do
    book
    |> Book.changeset(%{count_checked_out: book.count_checked_out - 1})
    |> Repo.update()
  end

  def return_book(id) do
    get_book!(id)
    |> return_book()
  end

  def available_stock(%Book{} = book) do
    book.stock - book.count_checked_out
  end

  def available_stock(id) do
    get_book!(id)
    |> available_stock()
  end
end
