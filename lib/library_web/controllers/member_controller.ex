defmodule LibraryWeb.MemberController do
  use LibraryWeb, :controller

  alias Library.Accounts
  alias Library.Accounts.Member
  alias Library.Catalogue

  def index(conn, _params) do
    members = Accounts.list_members()
    render(conn, :index, members: members, filter_overdue: false)
  end

  def overdue(conn, _params) do
    members = Accounts.list_members()

    members =
      Enum.reject(members, fn member ->
        Accounts.has_overdue_books?(member) == false
      end)

    render(conn, :index, members: members, filter_overdue: true)
  end

  def new(conn, _params) do
    changeset = Accounts.change_member(%Member{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"member" => member_params}) do
    case Accounts.create_member(member_params) do
      {:ok, member} ->
        conn
        |> put_flash(:info, "Member created successfully.")
        |> redirect(to: ~p"/members/#{member}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    member = Accounts.get_member!(id)

    checked_out =
      Enum.map(member.checked_out_books, fn x ->
        %{
          book: Catalogue.get_book!(x.book_id),
          checked_out: x,
          member_id: member.id
        }
      end)

    has_overdues = Accounts.has_overdue_books?(member)

    render(conn, :show, member: member, checked_out: checked_out, has_overdues: has_overdues)
  end

  def edit(conn, %{"id" => id}) do
    member = Accounts.get_member!(id)
    changeset = Accounts.change_member(member)
    render(conn, :edit, member: member, changeset: changeset)
  end

  def update(conn, %{"id" => id, "member" => member_params}) do
    member = Accounts.get_member!(id)

    case Accounts.update_member(member, member_params) do
      {:ok, member} ->
        conn
        |> put_flash(:info, "Member updated successfully.")
        |> redirect(to: ~p"/members/#{member}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, member: member, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    member = Accounts.get_member!(id)
    {:ok, _member} = Accounts.delete_member(member)

    conn
    |> put_flash(:info, "Member deleted successfully.")
    |> redirect(to: ~p"/members")
  end

  def return(conn, %{"member_id" => member_id, "book_id" => book_id}) do
    member = Accounts.get_member!(member_id)

    Accounts.return_book(member, book_id)

    conn
    |> put_flash(:info, "Book returned successfully.")
    |> redirect(to: ~p"/members/#{member}")
  end

  def checkout(conn, %{"member_id" => member_id, "book_id" => book_id}) do
    member = Accounts.get_member!(member_id)

    Accounts.checkout_book(member, book_id)

    conn
    |> put_flash(:info, "Book checked out successfully")
    |> redirect(to: ~p"/members/#{member}")
  end

  def checkout_overdue(conn, %{
        "member_id" => member_id,
        "book_id" => book_id,
        "type" => type,
        "limit" => limit
      }) do
    member = Accounts.get_member!(member_id)

    Accounts.checkout_book(member, book_id, limit, type)

    conn
    |> put_flash(:info, "Book checked out successfully")
    |> redirect(to: ~p"/members/#{member}")
  end

  def list_books(conn, %{"member_id" => member_id}) do
    member = Accounts.get_member!(member_id)
    books = Catalogue.list_books()

    render(conn, :checkout, member: member, books: books)
  end
end
