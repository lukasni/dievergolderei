defmodule Dievergolderei.Shop do
  import Ecto.Query, warn: false
  alias Dievergolderei.Repo

  alias Dievergolderei.Shop.{Item, Image}

  def list_items() do
    Item
    |> order_by(desc: :inserted_at, desc: :id)
    |> Repo.all()
  end

  def get_item!(id) do
    Repo.get(Item, id)
  end

  def create_item(attrs) do
    case Map.get(attrs, "photo", :error) do
      %Plug.Upload{} = upload ->
        create_item_from_plug_upload(upload, attrs)

      _ ->
        Item.changeset(%Item{}, attrs)
        |> Ecto.Changeset.apply_action(:insert)
    end
  end

  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> Repo.update()
  end

  def delete_item(%Item{} = item) do
    Repo.delete(item)
  end

  def change_item(%Item{} = item) do
    Item.changeset(item, %{})
  end

  def create_item_from_plug_upload(%Plug.Upload{} = plug, attrs \\ %{}) do
    hash = Dievergolderei.FileUtil.hash(plug.path, :sha256)

    Repo.transaction(fn ->
      with {:ok, %File.Stat{size: size}} <- File.stat(plug.path),
           {:ok, upload} <- Repo.insert(create_changeset(plug, hash, size, attrs)),
           {:ok, _} <- Image.reduce_and_save(plug.path, Item.local_path(upload)) do
        upload
      else
        {:error, reason} -> Repo.rollback(reason)
      end
    end)
  end

  def create_changeset(plug, hash, size, attrs) do
    %Item{}
    |> Item.changeset(
      %{
        "filename" => plug.filename,
        "content_type" => plug.content_type,
        "hash" => hash,
        "size" => size
      }
      |> Enum.into(attrs)
    )
  end
end
