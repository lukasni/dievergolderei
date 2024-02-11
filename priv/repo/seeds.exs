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
alias Dievergolderei.Gallery.Photo

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

    %Post{}
    |> Post.changeset(%{title: title, publish_on: publish_on, content: content})
    #|> Repo.insert!()
  end
end

index_page = """
## Herzlich Willkommen

Das Rahmenatelier "Die Vergolderei" ist ihr Werkstattladen für individuelle Bilderrahmen, Einrahmungen und Spiegel in Rheinfelden.

Dazu führe ich eine kleine, feine Auswahl an Künstlerbedarf.
"""

Repo.insert!(%StaticPage{
  name: "index",
  content: index_page
})

contact_page = """
## Kontakt
<address class="border-l-2 border-dvblue-500 pl-4 not-italic" >
Die Vergolderei<br>
Regula Stindt<br>
Brodlaube 9<br>
CH-4310 Rheinfelden<br>
Schweiz<br>
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

<div class="md:flex items-center justify-between">
<div class="flex-1"><img src="/uploads/1"></div>
<div class="md:ml-1 flex-1"><img src="/uploads/3"></div>
<div class="md:ml-1 flex-1"><img src="/uploads/2"></div>
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

shop_page = """
## Aktuell im Verkauf

In diesem virtuellen Schaufenster sehen Sie eine Auswahl der Bilder und Spiegel die aktuell im Verkauf sind. Bei Interesse können Sie mich gerne [kontaktieren](/kontakt) um ein Bild zu reservieren.

### TheFramer von Emsa
Die Vergolderei ist ein Partner von TheFramer von EMSA. Auf deren Webseite können Sie bequem von zuhause einen individuellen Bilderrahmen gestalten.
[![TheFramer](/images/theframer.png) {: .block .h-32} Der Rahmenkonfigurator von EMSA](https://www.theframer.ch/) {: .flex .items-center}
"""

Repo.insert!(%StaticPage{
  name: "shop",
  content: shop_page
})

featured_page = """
[![TheFramer](/images/theframer.png) {: .block .h-32} Der Rahmenkonfigurator von Emsa](https://www.theframer.ch/) {: .flex .items-center}
"""

Repo.insert!(%StaticPage{
  name: "featured",
  content: featured_page
})

photos = [
  %{
    id: 3,
    in_gallery: false,
    description: nil,
    title: "Geschichte 3",
    slug: nil,
    content_type: "image/jpeg",
    filename: "3.jpeg",
    hash: "a97e6205727fa7007ff23d467535375144bf54c98e0cee79028136461c69c5f7",
    size: 89982,
    inserted_at: NaiveDateTime.utc_now(:second),
    updated_at: NaiveDateTime.utc_now(:second)
  },
  %{
    id: 2,
    in_gallery: false,
    description: nil,
    title: "Geschichte 2",
    slug: nil,
    content_type: "image/jpeg",
    filename: "2.jpeg",
    hash: "905915a82b3fcde52abfa4a0e5aacca9d62166bfaf2a5a136402f1c7bd3977eb",
    size: 103565,
    inserted_at: NaiveDateTime.utc_now(:second),
    updated_at: NaiveDateTime.utc_now(:second)
  },
  %{
    id: 1,
    in_gallery: false,
    description: nil,
    title: "Geschichte 1",
    slug: nil,
    content_type: "image/jpeg",
    filename: "1.jpeg",
    hash: "24bcb6b9a8a8490feb7dc48166d1dcdbbcc4e7abb952426f88df3ebd2cb6c290",
    size: 95389,
    inserted_at: NaiveDateTime.utc_now(:second),
    updated_at: NaiveDateTime.utc_now(:second)
  }
]

Repo.insert_all(Photo, photos)
