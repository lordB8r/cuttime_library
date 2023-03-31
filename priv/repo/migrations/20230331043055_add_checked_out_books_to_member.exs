defmodule Library.Repo.Migrations.AddCheckedOutBooksToMember do
  use Ecto.Migration

  def change do
    alter table(:members) do
      add :checked_out_books, {:array, :map}, default: []
    end
  end
end
