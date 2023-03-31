defmodule LibraryWeb.MemberHTML do
  use LibraryWeb, :html

  embed_templates "member_html/*"

  @doc """
  Renders a member form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def member_form(assigns)
end
