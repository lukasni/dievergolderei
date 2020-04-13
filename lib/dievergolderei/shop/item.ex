defmodule Dievergolderei.Shop.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :price, :decimal
    field :reserved, :boolean, default: false
    field :title, :string

    field :content_type, :string
    field :filename, :string
    field :hash, :string
    field :size, :integer

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:title, :price, :filename, :hash, :size, :reserved, :content_type])
    |> validate_required([:title, :price, :filename, :hash, :size, :reserved, :content_type])
  end

  def local_path(%{id: id, filename: filename}) do
    [upload_directory(), "#{id}-#{filename}"]
    |> Path.join()
  end

  def upload_directory() do
    Application.get_env(:dievergolderei, Dievergolderei.Shop, [])
    |> Keyword.get(:upload_directory)
    |> Path.join("shop_items")
  end
end
