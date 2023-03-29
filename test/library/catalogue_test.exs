defmodule Library.CatalogueTest do
  use Library.DataCase

  alias Library.Catalogue

  describe "books" do
    alias Library.Catalogue.Book

    import Library.CatalogueFixtures

    @invalid_attrs %{author: nil, count_checked_out: nil, cover_image_url: nil, initial_stock: nil, isbn: nil, published_date: nil, title: nil}

    test "list_books/0 returns all books" do
      book = book_fixture()
      assert Catalogue.list_books() == [book]
    end

    test "get_book!/1 returns the book with given id" do
      book = book_fixture()
      assert Catalogue.get_book!(book.id) == book
    end

    test "create_book/1 with valid data creates a book" do
      valid_attrs = %{author: "some author", count_checked_out: 42, cover_image_url: "some cover_image_url", initial_stock: 42, isbn: "some isbn", published_date: ~D[2023-03-28], title: "some title"}

      assert {:ok, %Book{} = book} = Catalogue.create_book(valid_attrs)
      assert book.author == "some author"
      assert book.count_checked_out == 42
      assert book.cover_image_url == "some cover_image_url"
      assert book.initial_stock == 42
      assert book.isbn == "some isbn"
      assert book.published_date == ~D[2023-03-28]
      assert book.title == "some title"
    end

    test "create_book/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalogue.create_book(@invalid_attrs)
    end

    test "update_book/2 with valid data updates the book" do
      book = book_fixture()
      update_attrs = %{author: "some updated author", count_checked_out: 43, cover_image_url: "some updated cover_image_url", initial_stock: 43, isbn: "some updated isbn", published_date: ~D[2023-03-29], title: "some updated title"}

      assert {:ok, %Book{} = book} = Catalogue.update_book(book, update_attrs)
      assert book.author == "some updated author"
      assert book.count_checked_out == 43
      assert book.cover_image_url == "some updated cover_image_url"
      assert book.initial_stock == 43
      assert book.isbn == "some updated isbn"
      assert book.published_date == ~D[2023-03-29]
      assert book.title == "some updated title"
    end

    test "update_book/2 with invalid data returns error changeset" do
      book = book_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalogue.update_book(book, @invalid_attrs)
      assert book == Catalogue.get_book!(book.id)
    end

    test "delete_book/1 deletes the book" do
      book = book_fixture()
      assert {:ok, %Book{}} = Catalogue.delete_book(book)
      assert_raise Ecto.NoResultsError, fn -> Catalogue.get_book!(book.id) end
    end

    test "change_book/1 returns a book changeset" do
      book = book_fixture()
      assert %Ecto.Changeset{} = Catalogue.change_book(book)
    end
  end
end
