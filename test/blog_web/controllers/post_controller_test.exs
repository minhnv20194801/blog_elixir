defmodule BlogWeb.PostControllerTest do
  use BlogWeb.ConnCase

  import Blog.PostsFixtures
  import Blog.TagsFixtures
  import Blog.AccountsFixtures

  @create_attrs %{
    title: "some title",
    content: "some content",
    published_on: ~D[2024-07-08],
    visibility: true
  }
  @update_attrs %{
    title: "some updated title",
    content: "some updated content",
    published_on: ~D[2024-07-09],
    visibility: false,
    tag_ids: []
  }
  @invalid_attrs %{title: nil, content: nil, published_on: nil, visibility: nil}

  describe "index" do
    test "lists all posts", %{conn: conn} do
      conn = get(conn, ~p"/posts")
      assert html_response(conn, 200) =~ "Listing Posts"
    end

    test "lists all posts filter by visibility", %{conn: conn} do
      {_, post} = post_fixture(title: "invisible post", visibility: false)
      conn = get(conn, ~p"/posts")
      refute html_response(conn, 200) =~ post.title
    end

    test "list of posts from newest to oldest", %{conn: conn} do
      {_, older_post} = post_fixture(title: "older post")
      {_, newer_post} = post_fixture(title: "newer post", published_on: ~D[2024-07-10])
      conn = get(conn, ~p"/posts")
      response = html_response(conn, 200)

      assert elem(:binary.match(response, older_post.title), 0) >
               elem(:binary.match(response, newer_post.title), 0)
    end

    test "list of posts filter posts with future published date", %{conn: conn} do
      {_, post} = post_fixture(title: "future post", published_on: ~D[2025-01-01])
      conn = get(conn, ~p"/posts")
      refute html_response(conn, 200) =~ post.title
    end
  end

  describe "new post" do
    test "renders form", %{conn: conn} do
      user = user_fixture()
      conn = conn |> log_in_user(user) |> get(~p"/posts/new")
      assert html_response(conn, 200) =~ "New Post"
    end
  end

  describe "create post" do
    test "with tags", %{conn: conn} do
      user = user_fixture()
      tag = tag_fixture()
      tag_ids = [tag.id]
      post_create_attrs = Map.put(@create_attrs, :created_user_id, user.id)

      conn =
        conn |> log_in_user(user) |> post(~p"/posts", post: post_create_attrs, tag_ids: tag_ids)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/posts/#{id}"
    end

    test "redirects to show when data is valid", %{conn: conn} do
      user = user_fixture()
      post_create_attrs = Map.put(@create_attrs, :created_user_id, user.id)
      conn = conn |> log_in_user(user) |> post(~p"/posts", post: post_create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/posts/#{id}"

      conn = get(conn, ~p"/posts/#{id}")
      assert html_response(conn, 200) =~ @create_attrs.title
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = user_fixture()
      conn = conn |> log_in_user(user) |> post(~p"/posts", post: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Post"
    end

    test "redirect to login page when trying to create post without login", %{conn: conn} do
      conn = post(conn, ~p"/posts", post: @create_attrs)

      assert html_response(conn, 302) =~
               "<html><body>You are being <a href=\"/users/log_in\">redirected</a>.</body></html>"
    end
  end

  describe "edit post" do
    setup [:create_post]

    test "renders form for editing chosen post", %{conn: conn, post: post, user: user} do
      post = Map.delete(post, :tags)
      conn = conn |> log_in_user(user) |> get(~p"/posts/#{post}/edit")
      assert html_response(conn, 200) =~ "Edit Post"
    end

    test "redirect to login page when trying to edit post without login", %{
      conn: conn,
      post: post
    } do
      conn = get(conn, ~p"/posts/#{post}/edit")

      assert html_response(conn, 302) =~
               "<html><body>You are being <a href=\"/users/log_in\">redirected</a>.</body></html>"
    end

    test "error when trying to edit other user post", %{conn: conn, post: post, user: user} do
      new_user = user_fixture()
      assert new_user != user
      conn = conn |> log_in_user(new_user) |> get(~p"/posts/#{post}/edit")

      assert html_response(conn, 302) =~
               "<html><body>You are being <a href=\"/posts/#{post.id}\">redirected</a>.</body></html>"
    end
  end

  describe "update post" do
    setup [:create_post]

    test "add tags", %{conn: conn, post: post, user: user} do
      tag = tag_fixture()
      tag_ids = [tag.id]
      updated_attrs = Map.put(@update_attrs, :tag_ids, tag_ids)

      conn =
        conn |> log_in_user(user) |> put(~p"/posts/#{post}", post: updated_attrs)

      assert redirected_to(conn) == ~p"/posts/#{post}"

      conn = get(conn, ~p"/posts/#{post}")
      assert html_response(conn, 200) =~ "##{tag.name}"
    end

    test "delete tags", %{conn: conn, post: post, user: user} do
      tag = tag_fixture()
      tag_ids = [tag.id]
      updated_attrs = Map.put(@update_attrs, :tag_ids, tag_ids)

      conn =
        conn
        |> log_in_user(user)
        |> put(~p"/posts/#{post}", post: updated_attrs)
        |> put(~p"/posts/#{post}", post: @update_attrs)

      conn = get(conn, ~p"/posts/#{post}")
      refute html_response(conn, 200) =~ "##{tag.name}"
    end

    test "redirects when data is valid", %{conn: conn, post: post, user: user} do
      conn =
        conn
        |> log_in_user(user)
        |> put(~p"/posts/#{post}", post: @update_attrs)

      assert redirected_to(conn) == ~p"/posts/#{post}"

      conn = get(conn, ~p"/posts/#{post}")
      assert html_response(conn, 200) =~ "some updated title"
    end

    test "renders errors when data is invalid", %{conn: conn, post: post, user: user} do
      conn =
        conn
        |> log_in_user(user)
        |> put(~p"/posts/#{post}",
          post: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Edit Post"
    end

    test "redirect to login page when update post without login", %{
      conn: conn,
      post: post
    } do
      conn =
        conn
        |> put(~p"/posts/#{post}",
          post: @create_attrs
        )

      assert html_response(conn, 302) =~
               "<html><body>You are being <a href=\"/users/log_in\">redirected</a>.</body></html>"
    end

    test "error when update post from different user", %{
      conn: conn,
      post: post
    } do
      new_user = user_fixture()

      conn =
        conn
        |> log_in_user(new_user)
        |> put(~p"/posts/#{post}",
          post: @invalid_attrs
        )

      assert html_response(conn, 302) =~
               "<html><body>You are being <a href=\"/posts/#{post.id}\">redirected</a>.</body></html>"
    end
  end

  describe "delete post" do
    setup [:create_post]

    test "deletes chosen post", %{conn: conn, post: post, user: user} do
      conn =
        conn
        |> log_in_user(user)
        |> delete(~p"/posts/#{post}")

      assert_error_sent(404, fn ->
        get(conn, ~p"/posts/#{post}")
      end)
    end

    test "deletes post with tags", %{conn: conn, post: post, user: user} do
      tag = tag_fixture()
      tag_ids = [tag.id]
      updated_attrs = Map.put(@update_attrs, :tag_ids, tag_ids)

      conn =
        conn |> log_in_user(user) |> put(~p"/posts/#{post}", post: updated_attrs)

      conn =
        conn
        |> delete(~p"/posts/#{post}")

      assert_error_sent(404, fn ->
        get(conn, ~p"/posts/#{post}")
      end)
    end

    test "redirect to login page when delete post without login", %{
      conn: conn,
      post: post
    } do
      conn =
        conn
        |> delete(~p"/posts/#{post}")

      assert html_response(conn, 302) =~
               "<html><body>You are being <a href=\"/users/log_in\">redirected</a>.</body></html>"
    end

    test "error when delete post from different user", %{
      conn: conn,
      post: post
    } do
      new_user = user_fixture()

      conn =
        conn
        |> log_in_user(new_user)
        |> delete(~p"/posts/#{post}")

      assert html_response(conn, 302) =~
               "<html><body>You are being <a href=\"/posts/#{post.id}\">redirected</a>.</body></html>"
    end
  end

  describe "search post by title" do
    test "search for posts - non-matching", %{conn: conn} do
      {_, post} = post_fixture(title: "some title")
      conn = get(conn, ~p"/posts", title: "Non-Matching")
      refute html_response(conn, 200) =~ post.title
    end

    test "search for posts - exact match", %{conn: conn} do
      {_, post} = post_fixture(title: "some title")
      conn = get(conn, ~p"/posts", title: "some title")
      assert html_response(conn, 200) =~ post.title
    end

    test "search for posts - partial match", %{conn: conn} do
      {_, post} = post_fixture(title: "some title")
      conn = get(conn, ~p"/posts", title: "itl")
      assert html_response(conn, 200) =~ post.title
    end
  end

  defp create_post(_) do
    {user, post} = post_fixture()
    %{post: post, user: user}
  end
end
