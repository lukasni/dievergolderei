defmodule Dievergolderei.GalleryImageTest do
  use ExUnit.Case

  @testfile "test/support/data/large_image.jpg"
  @destination "test/support/data/reduced_image.jpg"

  alias Dievergolderei.Gallery.Image

  describe "image tests" do
    setup do
      on_exit(fn ->
        File.rm_rf(@destination)
      end)
    end

    test "reduce_and_save/2 reduces size and saves the file" do
      {:ok, %{size: original_size}} = File.stat(@testfile)
      {:ok, %{size: reduced_size}} = Image.reduce_and_save(@testfile, @destination)
      reduced_image = @destination |> Mogrify.open() |> Mogrify.verbose()

      assert original_size > reduced_size
      assert reduced_image.width <= 1080
      assert reduced_image.height <= 1080
    end
  end
end
