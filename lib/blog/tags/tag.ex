defmodule Blog.Tags.Tag do
  @moduledoc """
  Tag model, handle accessing tag entity in the database
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tags" do
    field :name, :string
    many_to_many :posts, Blog.Posts.Post, join_through: "post_tags", on_replace: :delete
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
