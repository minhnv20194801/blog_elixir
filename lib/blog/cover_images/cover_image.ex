defmodule Blog.CoverImages.CoverImage do
  @moduledoc """
  CoverImage model, handle accessing cover_images entity in the database
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "coverimages" do
    field :url, :string
    belongs_to :post, Blog.Posts.Post, foreign_key: :post_id, references: :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(cover_image, attrs) do
    cover_image
    |> cast(attrs, [:url])
    |> validate_required([:url])
  end
end
