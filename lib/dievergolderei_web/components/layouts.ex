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
      <.link
        :for={item <- @item}
        class="block sm:flex-1 small-caps tracking-wide hover:text-white text-md text-center hover:bg-dvblue-500 py-1"
        navigate={item.to}
      >
        <%= render_slot(item) %>
      </.link>
    </nav>
    """
  end
end
