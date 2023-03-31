defmodule Library.CatalogueTest do
  use Library.DataCase

  alias Library.Catalogue
  alias Library.Catalogue.Book

  import Library.CatalogueFixtures

  describe "books" do
    @invalid_attrs %{
      author: nil,
      count_checked_out: nil,
      cover_image_url: nil,
      stock: nil,
      isbn: nil,
      published_on: nil,
      title: nil
    }

    test "list_books/0 returns all books" do
      book = book_fixture()
      assert Catalogue.list_books() == [book]
    end

    test "get_book!/1 returns the book with given id" do
      book = book_fixture()
      assert Catalogue.get_book!(book.id) == book
    end

    test "create_book/1 with valid data creates a book" do
      valid_attrs = %{
        author: "some author",
        count_checked_out: 42,
        cover_image_url: "some cover_image_url",
        stock: 42,
        isbn: "some isbn",
        published_on: ~D[2023-03-28],
        title: "some title"
      }

      assert {:ok, %Book{} = book} = Catalogue.create_book(valid_attrs)
      assert book.author == "some author"
      assert book.count_checked_out == 42
      assert book.cover_image_url == "some cover_image_url"
      assert book.stock == 42
      assert book.isbn == "some isbn"
      assert book.published_on == ~D[2023-03-28]
      assert book.title == "some title"
    end

    test "create_book/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalogue.create_book(@invalid_attrs)
    end

    test "update_book/2 with valid data updates the book" do
      book = book_fixture()

      update_attrs = %{
        author: "some updated author",
        count_checked_out: 43,
        cover_image_url: "some updated cover_image_url",
        stock: 43,
        isbn: "some updated isbn",
        published_on: ~D[2023-03-29],
        title: "some updated title"
      }

      assert {:ok, %Book{} = book} = Catalogue.update_book(book, update_attrs)
      assert book.author == "some updated author"
      assert book.count_checked_out == 43
      assert book.cover_image_url == "some updated cover_image_url"
      assert book.stock == 43
      assert book.isbn == "some updated isbn"
      assert book.published_on == ~D[2023-03-29]
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

    test "book is available for checkout" do
      book = book_available_fixture()

      assert Catalogue.available_for_checkout?(book)
    end

    test "book is not available for checkout" do
      book = book_fixture()

      refute Catalogue.available_for_checkout?(book)
    end

    test "return book decreases available stock" do
      book_to_return = book_fixture()
      Catalogue.return_book(book_to_return)

      returned_book = Catalogue.get_book!(book_to_return.id)

      assert returned_book.count_checked_out == book_to_return.count_checked_out - 1
    end

    test "checkout book increases available stock" do
      book_to_checkout = book_available_fixture()
      Catalogue.checkout_book(book_to_checkout)

      checked_out = Catalogue.get_book!(book_to_checkout.id)

      assert checked_out.count_checked_out == book_to_checkout.count_checked_out + 1
    end
  end
end
