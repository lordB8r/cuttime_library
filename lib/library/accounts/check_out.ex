defmodule Library.Accounts.CheckOut do
  defstruct [:book_id, :checked_out_at]
  @types %{book_id: :integer, checked_out_at: :date}

  alias Library.Accounts.CheckOut
  import Ecto.Changeset

  def changeset(%CheckOut{} = book, attrs) do
    {book, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_required([:book_id, :checked_out_at])
  end
end
