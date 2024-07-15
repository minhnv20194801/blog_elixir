defmodule Blog.Comments.Comment do
  @moduledoc """
  Comment model, handle accessing comment entity in the database
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "comments" do
    field :content, :string
    belongs_to :post, Blog.Posts.Post, foreign_key: :post_id, references: :id
    belongs_to :user, Blog.Accounts.User, foreign_key: :user_id, references: :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content, :post_id, :user_id])
    |> validate_required([:content, :post_id, :user_id])
  end
end
