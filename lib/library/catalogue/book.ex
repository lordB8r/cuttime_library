defmodule Library.Catalogue.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :author, :string
    field :count_checked_out, :integer, default: 0
    field :cover_image_url, :string
    field :stock, :integer
    field :isbn, :string
    field :published_on, :date
    field :title, :string

    timestamps()
  end

  # consider 2 changesets, default and import

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [
      :title,
      :published_on,
      :isbn,
      :author,
      :cover_image_url,
      :stock,
      :count_checked_out
    ])
    |> validate_required([
      :title,
      :published_on,
      :isbn,
      :author,
      :cover_image_url,
      :stock
    ])
  end
end
