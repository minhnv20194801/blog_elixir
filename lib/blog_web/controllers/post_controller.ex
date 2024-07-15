defmodule BlogWeb.PostController do
  use BlogWeb, :controller

  alias Blog.Comments
  alias Blog.Comments.Comment
  alias Blog.Posts
  alias Blog.Posts.Post
  alias Blog.Tags
  alias Blog.Tags.Tag

  plug :require_user_owns_post when action in [:edit, :update, :delete]

  @default_cover_image_url "https://i.ibb.co/yB3scXR/test.jpg"

  def index(conn, params) do
    title_query = Map.get(params, "title")
    posts = Posts.list_posts(title_query)
    render(conn, :index, posts: posts, title_query: title_query)
  end

  def new(conn, _params) do
    changeset = Posts.change_post(%Post{})
    tagchangeset = Tags.change_tag(%Tag{})
    tag_options = tag_options()
    render(conn, :new, changeset: changeset, tagchangeset: tagchangeset, tag_options: tag_options)
  end

  def create(conn, %{"post" => post_params}) do
    tags = Map.get(post_params, "tag_ids", []) |> Enum.map(&Tags.get_tag!/1)

    post_params =
      if !Map.has_key?(post_params, "cover_image") || post_params["cover_image"]["url"] == "" do
        Map.put(post_params, "cover_image", %{url: @default_cover_image_url})
      else
        post_params
      end

    case Posts.create_post(post_params, tags) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: ~p"/posts/#{post}")

      {:error, %Ecto.Changeset{} = changeset} ->
        tag_options = tag_options()
        render(conn, :new, changeset: changeset, tag_options: tag_options)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Posts.get_post!(id)
    tags = Posts.get_tags!(id)

    comment_changeset = Comments.change_comment(%Comment{})

    post = Blog.Repo.preload(post, :cover_image)

    render(conn, :show,
      post: post,
      tags:
        Enum.map(tags, fn tag ->
          tag.name
        end),
      comment_changeset: comment_changeset,
      comments:
        Enum.map(post.comments, fn comment ->
          Comments.get_comment!(comment.id)
        end)
    )
  end

  def edit(conn, %{"id" => id}) do
    post = Posts.get_post!(id)
    post = Blog.Repo.preload(post, :tags, force: true)
    post = Blog.Repo.preload(post, :cover_image)
    changeset = Posts.change_post(post, %{}, post.tags)
    tag_options = tag_options(Enum.map(post.tags, fn tag -> tag.id end))
    render(conn, :edit, post: post, changeset: changeset, tag_options: tag_options)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Posts.get_post!(id)
    tags = Map.get(post_params, "tag_ids", []) |> Enum.map(&Tags.get_tag!/1)

    post_params =
      if !Map.has_key?(post_params, "cover_image") || post_params["cover_image"]["url"] == "" do
        Map.put(post_params, "cover_image", %{url: @default_cover_image_url})
      else
        post_params
      end

    case Posts.update_post(post, post_params, tags) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: ~p"/posts/#{post}")

      {:error, %Ecto.Changeset{} = changeset} ->
        tag_options = tag_options()
        render(conn, :edit, post: post, changeset: changeset, tag_options: tag_options)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Posts.get_post!(id)
    {:ok, _post} = Posts.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: ~p"/")
  end

  defp tag_options(selected_ids \\ []) do
    Tags.list_tags()
    |> Enum.map(fn tag ->
      [key: tag.name, value: tag.id, selected: tag.id in selected_ids]
    end)
  end

  defp require_user_owns_post(conn, _params) do
    post_id = conn.path_params["id"]
    post = Posts.get_post!(post_id)

    if conn.assigns[:current_user].id == post.created_user_id do
      conn
    else
      conn
      |> put_flash(:error, "You can only edit or delete your own posts.")
      |> redirect(to: ~p"/posts/#{post_id}")
      |> halt()
    end
  end
end
