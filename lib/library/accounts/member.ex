defmodule Library.Accounts.Member do
  use Ecto.Schema
  import Ecto.Changeset

  schema "members" do
    field :first_name, :string
    field :last_name, :string
    field :checked_out_books, {:array, :map}

    timestamps()
  end

  @doc false
  def changeset(member, attrs) do
    member
    |> cast(attrs, [:first_name, :last_name, :checked_out_books])
    |> validate_required([:first_name, :last_name])
  end
end
