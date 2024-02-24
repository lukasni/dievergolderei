defmodule DievergoldereiWeb.Layouts do
  use DievergoldereiWeb, :html

  embed_templates "layouts/*"

  slot :item, doc: "Navigation links" do
    attr :to, :string, required: false, doc: "Link target"
  end

  def main_nav(assigns) do
    ~H"""
    <nav
      role="navigation"
      class="sm:flex items-center justify-between bg-gray-300 bg-opacity-25 border-y border-black"
    >
      <%= for item <- @item do %>
        <.link
          :if={item[:to]}
          class="block sm:flex-1 small-caps tracking-wide hover:text-white text-md text-center hover:bg-dvblue-500 py-1"
          navigate={item.to}
        >
          <%= render_slot(item) %>
        </.link>
        <div
          :if={!item[:to]}
          class="block small-caps tracking-wide hover:text-white text-md text-center hover:bg-dvblue-500 py-1"
        >
          <%= render_slot(item) %>
        </div>
      <% end %>
    </nav>
    """
  end
end
