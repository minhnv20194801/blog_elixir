defmodule Blog.PostsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Blog.Posts` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    user = Blog.AccountsFixtures.user_fixture()

    {:ok, post} =
      attrs
      |> Enum.into(%{
        content: "some content",
        published_on: ~D[2024-07-08],
        title: "some title",
        visibility: true,
        created_user_id: user.id,
        cover_image: %{url: "https://i.ibb.co/yB3scXR/test.jpg"}
      })
      |> Blog.Posts.create_post()

    {user, post}
  end
end
