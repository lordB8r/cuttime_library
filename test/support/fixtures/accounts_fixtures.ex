defmodule Library.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Library.Accounts` context.
  """

  alias Library.Accounts.CheckOut

  @doc """
  Generate a member.
  """
  def member_fixture(attrs \\ %{}) do
    {:ok, member} =
      attrs
      |> Enum.into(%{
        first_name: "some first_name",
        last_name: "some last_name",
        checked_out_books: []
      })
      |> Library.Accounts.create_member()

    member
  end

  def member_checked_out_overdue_fixture(attrs \\ %{}) do
    book = Library.CatalogueFixtures.book_available_fixture()

    {:ok, member} =
      attrs
      |> Enum.into(%{
        first_name: "some first_name",
        last_name: "some last_name",
        checked_out_books: [
          %CheckOut{
            book_id: book.id,
            checked_out_at: DateTime.now!("Etc/UTC"),
            limit: 1,
            type: :second
          }
        ]
      })
      |> Library.Accounts.create_member()

    member
  end

  def member_checked_out_fixture(attrs \\ %{}) do
    book = Library.CatalogueFixtures.book_available_fixture()

    {:ok, member} =
      attrs
      |> Enum.into(%{
        first_name: "some first_name",
        last_name: "some last_name",
        checked_out_books: [
          %CheckOut{
            book_id: book.id,
            checked_out_at: DateTime.now!("Etc/UTC"),
            limit: 1,
            type: :day
          }
        ]
      })
      |> Library.Accounts.create_member()

    member
  end
end
