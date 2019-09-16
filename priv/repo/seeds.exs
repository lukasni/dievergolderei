# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Dievergolderei.Repo.insert!(%Dievergolderei.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Dievergolderei.Repo
alias Dievergolderei.Blog.Post
alias Dievergolderei.OpeningHours.Hours

Repo.insert!(%Hours{label: "Montag", times: "geschlossen", active: true, list_position: 0})

Repo.insert!(%Hours{
  label: "Dienstag – Freitag",
  times: "09:00 – 12:30\n14:00 – 18:00",
  active: true,
  list_position: 1
})

Repo.insert!(%Hours{label: "Samstag", times: "09:00 – 12:30", active: true, list_position: 2})
Repo.insert!(%Hours{label: "Sonntag", times: "geschlossen", active: true, list_position: 3})

Repo.insert!(%Hours{
  label: "Ferien",
  times: "vom [start] bis [end] bleibt der Laden geschlossen",
  active: false,
  list_position: 4
})

for _ <- 1..10 do
  title = Faker.Lorem.words(2..5) |> Enum.join(" ") |> String.capitalize()
  publish_on = Faker.Date.backward(365 * 3)
  content = Faker.Lorem.paragraphs() |> Enum.join("\n\n")

  Repo.insert!(%Post{
    title: title,
    publish_on: publish_on,
    content: content,
    slug: Slugger.slugify_downcase(title) |> Slugger.truncate_slug(16)
  })
end
