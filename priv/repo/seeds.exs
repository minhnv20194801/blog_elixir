# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Blog.Repo.insert!(%Blog.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Blog.Tags.Tag.changeset(%Blog.Tags.Tag{}, %{name: "Action"})
|> Blog.Repo.insert!()

Blog.Tags.Tag.changeset(%Blog.Tags.Tag{}, %{name: "Adventure"})
|> Blog.Repo.insert!()

Blog.Tags.Tag.changeset(%Blog.Tags.Tag{}, %{name: "Comedy"})
|> Blog.Repo.insert!()

Blog.Tags.Tag.changeset(%Blog.Tags.Tag{}, %{name: "Drama"})
|> Blog.Repo.insert!()

Blog.Tags.Tag.changeset(%Blog.Tags.Tag{}, %{name: "Fantasy"})
|> Blog.Repo.insert!()

Blog.Tags.Tag.changeset(%Blog.Tags.Tag{}, %{name: "Historical"})
|> Blog.Repo.insert!()

Blog.Tags.Tag.changeset(%Blog.Tags.Tag{}, %{name: "Horror"})
|> Blog.Repo.insert!()

Blog.Tags.Tag.changeset(%Blog.Tags.Tag{}, %{name: "Mature"})
|> Blog.Repo.insert!()

Blog.Tags.Tag.changeset(%Blog.Tags.Tag{}, %{name: "Romance"})
|> Blog.Repo.insert!()

Blog.Tags.Tag.changeset(%Blog.Tags.Tag{}, %{name: "Sport"})
|> Blog.Repo.insert!()
