defmodule Dievergolderei.PageFixtures do
  def required_pages() do
    [
      %{
        name: "index",
        content: "Index Page"
      },
      %{
        name: "featured",
        content: "Featured Page"
      },
      %{
        name: "contact",
        content: "Contact Page"
      },
      %{
        name: "history",
        content: "History Page"
      },
      %{
        name: "shop",
        content: "Shop Page"
      },
    ]
  end

  def page_fixtures() do
    for attrs <- required_pages() do
      {:ok, page} =
        attrs
        |> Dievergolderei.Pages.create_static_page()

      {
        String.to_atom(attrs.name),
        page
      }
    end
  end
end
