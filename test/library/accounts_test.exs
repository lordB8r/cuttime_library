defmodule Library.AccountsTest do
  use Library.DataCase

  alias Library.Catalogue
  alias Library.CatalogueFixtures
  alias Library.Accounts

  describe "members" do
    alias Library.Accounts.Member

    import Library.AccountsFixtures
    import Library.CatalogueFixtures

    @invalid_attrs %{first_name: nil, last_name: nil}

    test "list_members/0 returns all members" do
      member = member_fixture()
      assert Accounts.list_members() == [member]
    end

    test "get_member!/1 returns the member with given id" do
      member = member_fixture()
      assert Accounts.get_member!(member.id) == member
    end

    test "create_member/1 with valid data creates a member" do
      valid_attrs = %{first_name: "some first_name", last_name: "some last_name"}

      assert {:ok, %Member{} = member} = Accounts.create_member(valid_attrs)
      assert member.first_name == "some first_name"
      assert member.last_name == "some last_name"
    end

    test "create_member/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_member(@invalid_attrs)
    end

    test "update_member/2 with valid data updates the member" do
      member = member_fixture()
      update_attrs = %{first_name: "some updated first_name", last_name: "some updated last_name"}

      assert {:ok, %Member{} = member} = Accounts.update_member(member, update_attrs)
      assert member.first_name == "some updated first_name"
      assert member.last_name == "some updated last_name"
    end

    test "update_member/2 with invalid data returns error changeset" do
      member = member_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_member(member, @invalid_attrs)
      assert member == Accounts.get_member!(member.id)
    end

    test "delete_member/1 deletes the member" do
      member = member_fixture()
      assert {:ok, %Member{}} = Accounts.delete_member(member)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_member!(member.id) end
    end

    test "change_member/1 returns a member changeset" do
      member = member_fixture()
      assert %Ecto.Changeset{} = Accounts.change_member(member)
    end

    test "checkout_book/2 allows user to check out a book" do
      member = member_fixture()
      book = CatalogueFixtures.book_available_fixture()
      {:ok, updated_member} = Accounts.checkout_book(member, book.id)

      [checked_out_book | _] = updated_member.checked_out_books

      assert length(updated_member.checked_out_books) > 0

      assert checked_out_book.book_id == book.id
    end

    test "checkout_book/2 updates catalogue book stock" do
      member = member_fixture()
      book = CatalogueFixtures.book_available_fixture()
      {:ok, updated_member} = Accounts.checkout_book(member, book.id)

      [checked_out_book | _] = updated_member.checked_out_books
      catalogue_book = Catalogue.get_book!(checked_out_book.book_id)
      assert catalogue_book.count_checked_out == book.count_checked_out + 1
    end

    test "checkout_book/2 won't checkout if the stock is depleted" do
      member = member_fixture()
      book = CatalogueFixtures.book_fixture()
      response = Accounts.checkout_book(member, book.id)
      assert is_nil(response)
    end

    test "checkout_book/2 won't work if member is at limit" do
      member = member_fixture()
      book = CatalogueFixtures.book_fixture()

      Enum.map(0..3, fn _ ->
        Accounts.checkout_book(member, book.id)
      end)

      response = Accounts.checkout_book(member, book.id)
      assert is_nil(response)
    end

    test "return_book/2 will remove the book from the member's checked_out_book list" do
      member = member_fixture()
      book = CatalogueFixtures.book_available_fixture()
      {:ok, checkout_response} = Accounts.checkout_book(member, book.id)

      {:ok, return_response} = Accounts.return_book(member, book.id)

      assert length(return_response.checked_out_books) ==
               length(checkout_response.checked_out_books) - 1
    end

    test "return_book/2 will reduce the stock count in the book's catalogue" do
      member = member_fixture()
      book = CatalogueFixtures.book_available_fixture()
      Accounts.checkout_book(member, book.id)
      catalogue_checked_out = Catalogue.get_book!(book.id)

      Accounts.return_book(member, book.id)
      catalogue_returned = Catalogue.get_book!(book.id)

      assert catalogue_checked_out.count_checked_out == catalogue_returned.count_checked_out + 1
    end
  end
end
