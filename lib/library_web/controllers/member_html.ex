defmodule LibraryWeb.MemberHTML do
  use LibraryWeb, :html

  embed_templates "member_html/*"

  @doc """
  Renders a member form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def member_form(assigns)

  def due_date(book) do
    {:ok, dt, _} = DateTime.from_iso8601(book.checked_out_at)
    type = String.to_existing_atom(book.type)

    DateTime.add(
      dt,
      book.limit,
      type
    )
  end
end
