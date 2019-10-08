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
alias Dievergolderei.Pages.StaticPage

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

if Mix.env() == :dev do
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
end

index_page = """
## Herzlich Willkommen

Das Rahmenatelier „Die Vergolderei“ ist ihr Werkstattladen für individuelle Bilderrahmen, Einrahmungen und Spiegel in Rheinfelden.

Dazu führe ich eine kleine, feine Auswahl an Künstlerbedarf.
"""

Repo.insert!(%StaticPage{
  name: "index",
  content: index_page
})

contact_page = """
## Kontakt
<address>Die Vergolderei
Brodlaube 9
CH-4310 Rheinfelden
Schweiz
</address>

[061 831 14 84](tel:+41618311484)
[regula.stindt@dievergolderei.ch](mailto:regula.stindt@dievergolderei.ch)

"""

Repo.insert!(%StaticPage{
  name: "contact",
  content: contact_page
})

history_page = """
## Geschichte

Im Dezember 1986 übernahm ich die Vergolderei an der Brodlaube 29.

Gestartet habe ich mit klassischer Rahmenvergolderei, Einrahmungen und Restaurationen.

------

Vor 1990 grosser Umzug an den Obertorplatz 9. Hier baue ich als zweites Standbein den Künstlerbedarf auf.

Da arbeite ich mit den Firmen Talens und Lascaux zusammen.

------

Seit Sommer 2001 bin ich an der Brodlaube 9 im schönen Lokal im Haus der Familie Thurnheer.

<div class="row">
<div class="column"><img src="/photos/4"></div>
<div class="column"><img src="/photos/5"></div>
<div class="column"><img src="/photos/6"></div>
</div>

Neu dazu führe ich ein kleine Auswahl von Kunst, Acrylbilder und Kunstdrucke nach Wahl auf Bestellung.

------

Am 2. September 2016 durfte ich zusammen mit meiner Kundschaft, Freunden und Familie im Rahmen der Usestuhlete meinen 30. Geschäftsgeburtstag feiern.

*VIELEN DANK*
"""

Repo.insert!(%StaticPage{
  name: "history",
  content: history_page
})
