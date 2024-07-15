defmodule Blog.Posts.Post do
  @moduledoc """
  Post model, handle accessing post entity in the database
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "posts" do
    field :title, :string
    field :content, :string
    field :published_on, :date
    field :visibility, :boolean, default: false
    has_many :comments, Blog.Comments.Comment, on_delete: :delete_all
    has_one :cover_image, Blog.CoverImages.CoverImage, on_replace: :update, on_delete: :delete_all
    belongs_to :user, Blog.Accounts.User, foreign_key: :created_user_id, references: :id
    many_to_many :tags, Blog.Tags.Tag, join_through: "post_tags", on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs, tags \\ []) do
    post
    |> cast(attrs, [:title, :content, :published_on, :visibility, :created_user_id])
    |> validate_required([:title, :content, :published_on, :visibility, :created_user_id])
    |> unique_constraint(:title, message: "This title is already recorded!")
    |> put_assoc(:tags, tags)
    |> cast_assoc(:cover_image)
  end
end
