defmodule DievergoldereiWeb.Components.Controls do
  use Phoenix.Component

  import DievergoldereiWeb.CoreComponents

  attr :icon, :string, required: true
  attr :to, :string, required: true
  attr :text, :string, default: nil

  def fab(assigns) do
    ~H"""
    <.link
      navigate={@to}
      class={[
        "fixed bottom-0 right-0 flex items-center justify-between p-2 m-6",
        "rounded-full bg-dvblue-500 hover:bg-dvblue-300 text-white shadow z-20",
        @text && "px-4 gap-2"
      ]}
    >
      <.icon name={@icon} />
      <%= @text %>
    </.link>
    """
  end
end
