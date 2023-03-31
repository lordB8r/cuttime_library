defmodule Library.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Library.Catalogue
  alias Library.Repo

  alias Library.Accounts.Member
  alias Library.Accounts.CheckOut

  @book_checkout_limit 3
  @overdue_limit 30
  @overdue_type :day

  def list_members do
    Repo.all(Member)
  end

  # consider creating a struct for the checked_out_books for struct safety
  def get_member!(id) do
    member = Repo.get!(Member, id)

    changes =
      Enum.map(member.checked_out_books, fn x ->
        %{
          book_id: Map.get(x, "book_id"),
          checked_out_at: Map.get(x, "checked_out_at"),
          limit: Map.get(x, "limit"),
          type: Map.get(x, "type")
        }
      end)

    {:ok, m} =
      member
      |> Member.changeset(%{checked_out_books: changes})
      |> Ecto.Changeset.apply_action(:insert)

    m
  end

  def create_member(attrs \\ %{}) do
    %Member{}
    |> Member.changeset(attrs)
    |> Repo.insert()
  end

  def update_member(%Member{} = member, attrs) do
    member
    |> Member.changeset(attrs)
    |> Repo.update()
  end

  def delete_member(%Member{} = member) do
    Repo.delete(member)
  end

  def change_member(%Member{} = member, attrs \\ %{}) do
    Member.changeset(member, attrs)
  end

  def count_books_checked_out(%Member{} = member) do
    length(member.checked_out_books)
  end

  def allowed_to_check_out?(%Member{} = member) do
    count_books_checked_out(member) < @book_checkout_limit
  end

  def allowed_to_check_out?(id) do
    get_member!(id)
    |> allowed_to_check_out?()
  end

  def checkout_book(%Member{} = member, book_id) do
    case allowed_to_check_out?(member) && Catalogue.available_for_checkout?(book_id) do
      true ->
        {:ok, _book} = Catalogue.checkout_book(book_id)

        {:ok, checked_out} =
          %CheckOut{}
          |> CheckOut.changeset(%{
            book_id: book_id,
            checked_out_at: DateTime.now!("Etc/UTC"),
            limit: @overdue_limit,
            type: @overdue_type
          })
          |> Ecto.Changeset.apply_action(:insert)

        update_member(member, %{checked_out_books: [checked_out | member.checked_out_books]})

      false ->
        nil
    end
  end

  def return_book(%Member{} = member, book_id) do
    {:ok, book} = Catalogue.return_book(book_id)

    attrs =
      Enum.reject(
        member.checked_out_books,
        fn x ->
          x.book_id == book.id
        end
      )

    update_member(member, %{checked_out_books: attrs})
  end

  def get_list_checked_out_books(%Member{} = member) do
    member.checked_out_books
  end
end
