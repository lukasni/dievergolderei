defmodule Dievergolderei.Photo do
  use Waffle.Definition

  # Include ecto support (requires package waffle_ecto installed):
  use Waffle.Ecto.Definition

  @extension_whitelist ~w(.jpg .jpeg .gif .png)
  @thumbnail_size %{w: 150, h: 150}
  @big_size %{w: 1080, h: 1080}

  @versions [:original, :thumb, :big]

  # Override the bucket on a per definition basis:
  # def bucket do
  #   :custom_bucket_name
  # end

  # Whitelist file extensions:
  def validate({file, _}) do
    extension = file.file_name |> Path.extname() |> String.downcase()
    Enum.member?(@extension_whitelist, extension)
  end

  # Define a thumbnail transformation:
  def transform(:thumb, _) do
    {:convert,
     "-strip -thumbnail #{@thumbnail_size.w}x#{@thumbnail_size.h}^ -gravity center -extent #{
       @thumbnail_size.w
     }x#{@thumbnail_size.h} -format png", :png}
  end

  # Define a thumbnail transformation:
  def transform(:big, _) do
    {:convert, "-strip -resize #{@big_size.w}x#{@big_size.h}>"}
  end

  # Override the persisted filenames:
  def filename(version, {_file, scope}) do
    "#{scope.uuid}_#{version}"
  end

  # Override the storage directory:
  def storage_dir(_version, {_file, _scope}) do
    Application.get_env(:dievergolderei, Dievergolderei.Photo, [])
    |> Keyword.get(:upload_directory)
    |> Kernel.<>("photos/")
  end

  # Provide a default URL if there hasn't been a file uploaded
  # def default_url(version, scope) do
  #   "/images/avatars/default_#{version}.png"
  # end

  # Specify custom headers for s3 objects
  # Available options are [:cache_control, :content_disposition,
  #    :content_encoding, :content_length, :content_type,
  #    :expect, :expires, :storage_class, :website_redirect_location]
  #
  # def s3_object_headers(version, {file, scope}) do
  #   [content_type: MIME.from_path(file.file_name)]
  # end
end
