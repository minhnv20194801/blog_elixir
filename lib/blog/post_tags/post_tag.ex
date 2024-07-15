defmodule Blog.PostTags.PostTag do
  @moduledoc """
  PostTag relation, handle accessing post_tags relationship in the database
  """
  use Ecto.Schema
  import Ecto.Changeset

  @foreign_key_type :binary_id
  schema "post_tags" do
    field :post_id, :binary_id, primary_key: true
    field :tag_id, :binary_id, primary_key: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post_tag, attrs) do
    post_tag
    |> cast(attrs, [:post_id, :tag_id])
    |> validate_required([:post_id, :tag_id])
  end
end
