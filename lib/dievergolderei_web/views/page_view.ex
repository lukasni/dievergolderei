defmodule DievergoldereiWeb.PageView do
  use DievergoldereiWeb, :html

  embed_templates "../templates/page/*"

  alias Decimal, as: D

  defp format_chf(%D{} = number) do
    case D.compare(number, D.round(number)) do
      :eq -> "CHF #{number}.–"
      _ -> "CHF #{D.round(number, 2)}"
    end
  end

  attr :class, :string, default: nil
  attr :title, :string, required: true

  slot :button, required: true do
    attr :to, :string, required: true
    attr :class, :string
  end

  slot :footer

  def admin_section(assigns) do
    ~H"""
    <section class={["shadow bg-gray-200 bg-opacity-50 p-4 rounded mt-4 md:mt-0", @class]}>
      <header>
        <h2 class="text-2xl"><%= @title %></h2>
      </header>
      <ul class="mt-4">
        <li :for={button <- @button} class="mb-4 last:mb-0">
          <.link
            navigate={button.to}
            class={[
              "button",
              button[:class] || "button-gray"
            ]}
          >
            <%= render_slot(button) %>
          </.link>
        </li>
      </ul>
      <footer :if={@footer != []} class="mt-4">
        <%= render_slot(@footer) %>
      </footer>
    </section>
    """
  end
end
