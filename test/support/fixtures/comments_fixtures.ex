defmodule Blog.CommentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Blog.Comments` context.
  """

  @doc """
  Generate a comment.
  """
  def comment_fixture(attrs \\ %{}) do
    user = Blog.AccountsFixtures.user_fixture()

    {:ok, comment} =
      attrs
      |> Enum.into(%{
        content: "some content",
        user_id: user.id
      })
      |> Blog.Comments.create_comment()

    {user, comment}
  end
end
