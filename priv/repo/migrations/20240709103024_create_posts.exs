defmodule Blog.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :content, :text
      add :published_on, :date
      add :visibility, :boolean, default: false, null: false

      add :created_user_id, references(:users, on_delete: :delete_all, type: :binary_id),
        null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:posts, :title)
    create index(:posts, [:created_user_id])
  end
end
