defmodule Dievergolderei.Gallery do
  @moduledoc """
  The Gallery context.
  """

  import Ecto.Query, warn: false
  alias Dievergolderei.Repo

  alias Dievergolderei.Gallery.{Image, Photo}

  @doc """
  Returns the list of photos.

  ## Examples

      iex> list_photos()
      [%Photo{}, ...]

  """
  def list_photos do
    Photo
    |> order_by(desc: :inserted_at, desc: :id)
    |> Repo.all()
  end

  @doc """
  Return list of `count` most recent gallery photos
  """
  def list_gallery_photos(count \\ 15) do
    Photo
    |> where([q], q.in_gallery)
    # order by desc: :id to solve issues with photos created in the same second
    |> order_by(desc: :inserted_at, desc: :id)
    |> limit(^count)
    |> Repo.all()
  end

  @doc """
  Gets a single photo.

  Raises `Ecto.NoResultsError` if the Photo does not exist.

  ## Examples

      iex> get_photo!(123)
      %Photo{}

      iex> get_photo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_photo!(id), do: Repo.get!(Photo, id)

  @doc """
  Creates a photo.

  ## Examples

      iex> create_photo(%{field: value})
      {:ok, %Photo{}}

      iex> create_photo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_photo(attrs \\ %{}) do
    case Map.get(attrs, "photo", :error) do
      %Plug.Upload{} = upload ->
        create_photo_from_plug_upload(upload, attrs)

      _ ->
        Photo.changeset(%Photo{}, attrs)
        |> Ecto.Changeset.apply_action(:insert)
    end
  end

  @doc """
  Updates a photo.

  ## Examples

      iex> update_photo(photo, %{field: new_value})
      {:ok, %Photo{}}

      iex> update_photo(photo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_photo(%Photo{} = photo, attrs) do
    photo
    |> Photo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Photo.

  ## Examples

      iex> delete_photo(photo)
      {:ok, %Photo{}}

      iex> delete_photo(photo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_photo(%Photo{} = photo) do
    photo |> Photo.local_path() |> File.rm()
    Repo.delete(photo)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking photo changes.

  ## Examples

      iex> change_photo(photo)
      %Ecto.Changeset{source: %Photo{}}

  """
  def change_photo(%Photo{} = photo) do
    Photo.changeset(photo, %{})
  end

  def create_photo_from_plug_upload(%Plug.Upload{} = plug, attrs \\ %{}) do
    hash = Dievergolderei.FileUtil.hash(plug.path, :sha256)

    Repo.transaction(fn ->
      with {:ok, %File.Stat{size: size}} <- File.stat(plug.path),
           {:ok, upload} <- create_changeset(plug, hash, size, attrs) |> Repo.insert(),
           {:ok, _} <- Image.reduce_and_save(plug.path, Photo.local_path(upload)) do
        upload
      else
        {:error, reason} -> Repo.rollback(reason)
      end
    end)
  end

  defp create_changeset(plug, hash, size, attrs) do
    %Photo{}
    |> Photo.changeset(
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
