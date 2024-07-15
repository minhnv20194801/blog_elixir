defmodule BlogWeb.PageController do
  use BlogWeb, :controller

  alias Blog.Posts
  alias Blog.Tags

  def home(conn, params) do
    # The home page is often custom made,
    # so skip the default app layout.
    title_query = Map.get(params, "title")
    tag_query = Map.get(params, "tag_ids", [])

    posts =
      Posts.list_posts(title_query, tag_query)
      |> Enum.map(fn post ->
        Map.put(
          post,
          :tags,
          Enum.map(Posts.get_tags!(post.id), fn tag ->
            tag.name
          end)
        )
      end)
      |> Enum.map(fn post -> Blog.Repo.preload(post, :cover_image) end)

    selected_tag_ids = Map.get(params, "tags", [])

    tag_options =
      Tags.list_tags()
      |> Enum.map(fn tag ->
        [key: tag.name, value: tag.id, selected: tag.id in selected_tag_ids]
      end)

    render(conn, :home, layout: false, posts: posts, tag_options: tag_options)
  end
end
