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
  @overdue_type "day"

  def list_members do
    Repo.all(Member)
    |> Enum.map(fn member ->
      member |> set_member_map()
    end)
  end

  # consider creating a struct for the checked_out_books for struct safety
  def get_member!(id) do
    Repo.get!(Member, id)
    |> set_member_map()
  end

  defp set_member_map(member) do
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

  def checkout_book(%Member{} = member, book_id, limit \\ @overdue_limit, type \\ @overdue_type) do
    case allowed_to_check_out?(member) && Catalogue.available_for_checkout?(book_id) do
      true ->
        {:ok, _book} = Catalogue.checkout_book(book_id)

        {:ok, checked_out} =
          %CheckOut{}
          |> CheckOut.changeset(%{
            book_id: book_id,
            checked_out_at: DateTime.now!("Etc/UTC"),
            limit: limit,
            type: type
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

  def has_overdue_books?(%Member{} = member) do
    member.checked_out_books
    |> Enum.map(fn book ->
      is_over_due?(book)
    end)
    |> Enum.find_value(false, fn x -> x == true end)
  end

  def due_date(book) do
    prep_due_date(book)
    |> DateTime.to_date()
  end

  defp prep_due_date(book) do
    type = String.to_existing_atom(book.type)

    DateTime.add(
      process_datetime(book.checked_out_at),
      book.limit,
      type
    )
  end

  def is_over_due?(book) do
    due = prep_due_date(book) |> IO.inspect(label: "due: accounts.ex:138")
    {:ok, now} = DateTime.now("Etc/UTC")
    now |> IO.inspect(label: "now: accounts.ex:140")

    DateTime.diff(due, now) |> IO.inspect(label: "diff: accounts.ex:142")

    case DateTime.diff(due, now) do
      x when x > 0 -> false
      x when x <= 0 -> true
    end
  end

  defp process_datetime(checked_out_at) do
    {:ok, dt, _} = DateTime.from_iso8601(checked_out_at)
    dt
  end
end
