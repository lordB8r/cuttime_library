defmodule LibraryWeb.MemberHTML do
  alias Library.Accounts
  alias Library.Catalogue
  use LibraryWeb, :html

  embed_templates("member_html/*")

  @doc """
  Renders a member form.
  """
  attr(:changeset, Ecto.Changeset, required: true)
  attr(:action, :string, required: true)

  def member_form(assigns)

  def due_date(book) do
    Accounts.due_date(book)
  end

  def show_available(book) do
    Catalogue.available_stock(book)
  end
end
