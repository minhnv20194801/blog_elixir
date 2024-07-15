defmodule Blog.Repo.Migrations.CreateCoverimages do
  use Ecto.Migration

  def change do
    create table(:coverimages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :url, :text
      add :post_id, references(:posts, on_delete: :delete_all, type: :binary_id), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:coverimages, [:post_id])
  end
end
