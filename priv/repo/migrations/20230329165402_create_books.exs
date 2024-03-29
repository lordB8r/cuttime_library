defmodule Library.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :title, :string
      add :published_on, :date
      add :isbn, :string
      add :author, :string
      add :cover_image_url, :string
      add :stock, :integer
      add :count_checked_out, :integer

      timestamps()
    end
  end
end
