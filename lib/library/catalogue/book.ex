defmodule Library.Catalogue.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :author, :string
    field :count_checked_out, :integer
    field :cover_image_url, :string
    field :initial_stock, :integer
    field :isbn, :string
    field :published_date, :date
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:title, :published_date, :isbn, :author, :cover_image_url, :initial_stock, :count_checked_out])
    |> validate_required([:title, :published_date, :isbn, :author, :cover_image_url, :initial_stock, :count_checked_out])
  end
end
