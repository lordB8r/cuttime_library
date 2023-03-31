defmodule Library.Accounts.CheckOut do
  @derive Jason.Encoder
  defstruct [:book_id, :checked_out_at, :limit, :type]

  @types %{
    book_id: :integer,
    checked_out_at: :utc_datetime,
    limit: :integer,
    type: :any
  }

  # @limit_types [:second, :minute, :day]
  alias Library.Accounts.CheckOut
  import Ecto.Changeset

  def changeset(%CheckOut{} = book, attrs) do
    {book, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_required([:book_id, :checked_out_at])
  end
end
