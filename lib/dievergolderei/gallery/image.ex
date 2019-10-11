defmodule Dievergolderei.Gallery.Image do
  @moduledoc """
  Image transformation operations
  """

  @max_size "1080x1080"
  @quality 85

  def reduce_and_save(path, save_path) do
    path
    |> Mogrify.open()
    |> Mogrify.quality(@quality)
    |> Mogrify.resize_to_limit(@max_size)
    |> Mogrify.save(path: save_path)

    File.stat(save_path)
  end
end
