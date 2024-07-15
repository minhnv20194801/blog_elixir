defmodule BlogWeb.CoverImageController do
  use BlogWeb, :controller

  alias Blog.CoverImages
  alias Blog.CoverImages.CoverImage

  def index(conn, _params) do
    coverimages = CoverImages.list_coverimages()
    render(conn, :index, coverimages: coverimages)
  end

  def new(conn, _params) do
    changeset = CoverImages.change_cover_image(%CoverImage{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"cover_image" => cover_image_params}) do
    case CoverImages.create_cover_image(cover_image_params) do
      {:ok, _cover_image} ->
        conn
        |> put_flash(:info, "Cover image created successfully.")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    cover_image = CoverImages.get_cover_image!(id)
    render(conn, :show, cover_image: cover_image)
  end

  def edit(conn, %{"id" => id}) do
    cover_image = CoverImages.get_cover_image!(id)
    changeset = CoverImages.change_cover_image(cover_image)
    render(conn, :edit, cover_image: cover_image, changeset: changeset)
  end

  def update(conn, %{"id" => id, "cover_image" => cover_image_params}) do
    cover_image = CoverImages.get_cover_image!(id)

    case CoverImages.update_cover_image(cover_image, cover_image_params) do
      {:ok, _cover_image} ->
        conn
        |> put_flash(:info, "Cover image updated successfully.")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, cover_image: cover_image, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    cover_image = CoverImages.get_cover_image!(id)
    {:ok, _cover_image} = CoverImages.delete_cover_image(cover_image)

    conn
    |> put_flash(:info, "Cover image deleted successfully.")
  end
end
