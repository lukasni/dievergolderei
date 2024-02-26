defmodule DievergoldereiWeb.Components.Uploads do
  use DievergoldereiWeb, :html

  attr :schema, :any
  attr :rest, :global

  def image_for(%{schema: %Dievergolderei.Gallery.Photo{}} = assigns) do
    ~H"""
    <img src={~p"/uploads/#{@schema}"} {@rest} />
    """
  end

  def image_for(%{schema: %Dievergolderei.Shop.Item{}} = assigns) do
    ~H"""
    <img src={~p"/uploads/shop/#{@schema}"} {@rest} />
    """
  end
end
