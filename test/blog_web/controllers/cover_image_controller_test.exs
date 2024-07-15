# defmodule BlogWeb.CoverImageControllerTest do
#   use BlogWeb.ConnCase

#   import Blog.CoverImagesFixtures

#   @create_attrs %{url: "some url"}
#   @update_attrs %{url: "some updated url"}
#   @invalid_attrs %{url: nil}

#   describe "index" do
#     test "lists all coverimages", %{conn: conn} do
#       conn = get(conn, ~p"/coverimages")
#       assert html_response(conn, 200) =~ "Listing Coverimages"
#     end
#   end

#   describe "new cover_image" do
#     test "renders form", %{conn: conn} do
#       conn = get(conn, ~p"/coverimages/new")
#       assert html_response(conn, 200) =~ "New Cover image"
#     end
#   end

#   describe "create cover_image" do
#     test "redirects to show when data is valid", %{conn: conn} do
#       conn = post(conn, ~p"/coverimages", cover_image: @create_attrs)

#       assert %{id: id} = redirected_params(conn)
#       assert redirected_to(conn) == ~p"/coverimages/#{id}"

#       conn = get(conn, ~p"/coverimages/#{id}")
#       assert html_response(conn, 200) =~ "Cover image #{id}"
#     end

#     test "renders errors when data is invalid", %{conn: conn} do
#       conn = post(conn, ~p"/coverimages", cover_image: @invalid_attrs)
#       assert html_response(conn, 200) =~ "New Cover image"
#     end
#   end

#   describe "edit cover_image" do
#     setup [:create_cover_image]

#     test "renders form for editing chosen cover_image", %{conn: conn, cover_image: cover_image} do
#       conn = get(conn, ~p"/coverimages/#{cover_image}/edit")
#       assert html_response(conn, 200) =~ "Edit Cover image"
#     end
#   end

#   describe "update cover_image" do
#     setup [:create_cover_image]

#     test "redirects when data is valid", %{conn: conn, cover_image: cover_image} do
#       conn = put(conn, ~p"/coverimages/#{cover_image}", cover_image: @update_attrs)
#       assert redirected_to(conn) == ~p"/coverimages/#{cover_image}"

#       conn = get(conn, ~p"/coverimages/#{cover_image}")
#       assert html_response(conn, 200) =~ "some updated url"
#     end

#     test "renders errors when data is invalid", %{conn: conn, cover_image: cover_image} do
#       conn = put(conn, ~p"/coverimages/#{cover_image}", cover_image: @invalid_attrs)
#       assert html_response(conn, 200) =~ "Edit Cover image"
#     end
#   end

#   describe "delete cover_image" do
#     setup [:create_cover_image]

#     test "deletes chosen cover_image", %{conn: conn, cover_image: cover_image} do
#       conn = delete(conn, ~p"/coverimages/#{cover_image}")
#       assert redirected_to(conn) == ~p"/coverimages"

#       assert_error_sent 404, fn ->
#         get(conn, ~p"/coverimages/#{cover_image}")
#       end
#     end
#   end

#   defp create_cover_image(_) do
#     cover_image = cover_image_fixture()
#     %{cover_image: cover_image}
#   end
# end
