defmodule Blog.Posts do
  @moduledoc """
  The Posts context.
  """

  import Ecto.Query, warn: false
  alias Blog.Repo

  alias Blog.Posts.Post
  alias Blog.Comments.Comment
  alias Blog.Tags.Tag
  alias Blog.PostTags.PostTag

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts(title \\ "", tags \\ []) do
    Post
    |> where([p], ilike(p.title, ^"%#{title}%"))
    |> where([p], p.visibility)
    |> where([p], p.published_on <= ^DateTime.utc_now())
    |> order_by([p], desc: p.published_on)
    |> Repo.all()
    |> Enum.filter(fn post ->
      post_tags = get_tags!(post.id)
      Enum.empty?(tags -- Enum.map(post_tags, fn tag -> tag.id end))
    end)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id) do
    comment_order_query = from(c in Comment, order_by: {:desc, c.updated_at})

    from(p in Post, preload: [:user, comments: ^comment_order_query])
    |> Repo.get!(id)
  end

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}, tags \\ []) do
    %Post{}
    |> Post.changeset(attrs, tags)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs, tags \\ []) do
    post
    |> Repo.preload(:tags)
    |> Repo.preload(:cover_image)
    |> Post.changeset(attrs, tags)
    |> Repo.update()
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}, tags \\ []) do
    post
    |> Repo.preload(:tags)
    |> Post.changeset(attrs, tags)
  end

  def get_tags!(postId) do
    from(p in Post,
      join: pt in PostTag,
      on: pt.post_id == p.id,
      join: t in Tag,
      on: pt.tag_id == t.id,
      where: p.id == ^postId,
      select: %{id: t.id, name: t.name}
    )
    |> Repo.all()
  end
end
