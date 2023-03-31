defmodule LibraryWeb.MemberController do
  use LibraryWeb, :controller

  alias Library.Accounts
  alias Library.Accounts.Member
  alias Library.Catalogue

  @duedate_limit 30
  @duedate_type "days"

  def index(conn, _params) do
    members = Accounts.list_members()
    render(conn, :index, members: members)
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

    render(conn, :show, member: member, checked_out: checked_out)
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
    |> IO.inspect(label: "member_controller.ex:82")

    conn
    |> put_flash(:info, "Book returned successfully.")
    |> redirect(to: ~p"/members/#{member}")
  end
end
