defmodule Blog.CommentsTest do
  use Blog.DataCase

  alias Blog.Comments

  describe "comments" do
    alias Blog.Posts
    alias Blog.Posts.Post
    alias Blog.Comments.Comment

    import Blog.CommentsFixtures
    import Blog.AccountsFixtures
    import Blog.PostsFixtures

    @invalid_attrs %{content: nil}

    test "list_comments/0 returns all comments of a post" do
      {_, post} = post_fixture()
      {_, comment} = comment_fixture(post_id: post.id)
      assert Comments.list_comments(post.id) == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      {_, post} = post_fixture()
      {_, comment} = comment_fixture(post_id: post.id)

      assert Map.put(Comments.get_comment!(comment.id), :user, %{}) ==
               Map.put(comment, :user, %{})
    end

    test "create_comment/1 with valid data creates a comment" do
      {_, post} = post_fixture()
      user = user_fixture()

      valid_attrs = %{content: "some content", post_id: post.id, user_id: user.id}

      assert {:ok, %Comment{} = comment} = Comments.create_comment(valid_attrs)
      assert comment.content == "some content"
    end

    test "create_comment/1 without user" do
      {_, post} = post_fixture()

      no_user_attrs = %{content: "some content", post_id: post.id}
      assert {:error, %Ecto.Changeset{}} = Comments.create_comment(no_user_attrs)
    end

    test "create_comment/1 without post" do
      {user, _post} = post_fixture()

      no_post_attrs = %{content: "some content", user_id: user.id}
      assert {:error, %Ecto.Changeset{}} = Comments.create_comment(no_post_attrs)
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Comments.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      {_, post} = post_fixture()
      user = user_fixture()

      {_, comment} = comment_fixture(post_id: post.id, user_id: user.id)
      update_attrs = %{content: "some updated content"}

      assert {:ok, %Comment{} = comment} = Comments.update_comment(comment, update_attrs)
      assert comment.content == "some updated content"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      {_, post} = post_fixture()
      {_, comment} = comment_fixture(post_id: post.id)
      assert {:error, %Ecto.Changeset{}} = Comments.update_comment(comment, @invalid_attrs)

      assert Map.put(comment, :user, %{}) ==
               Map.put(Comments.get_comment!(comment.id), :user, %{})
    end

    test "delete_comment/1 deletes the comment" do
      {_, post} = post_fixture()
      {_, comment} = comment_fixture(post_id: post.id)
      assert {:ok, %Comment{}} = Comments.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Comments.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      {_, post} = post_fixture()
      {_, comment} = comment_fixture(post_id: post.id)
      assert %Ecto.Changeset{} = Comments.change_comment(comment)
    end

    test "delete_post/1 deletes the post and associated comments" do
      {_, post} = post_fixture()
      {_, comment} = comment_fixture(post_id: post.id)
      assert {:ok, %Post{}} = Posts.delete_post(post)

      assert_raise Ecto.NoResultsError, fn -> Posts.get_post!(post.id) end
      assert_raise Ecto.NoResultsError, fn -> Comments.get_comment!(comment.id) end
    end
  end
end
