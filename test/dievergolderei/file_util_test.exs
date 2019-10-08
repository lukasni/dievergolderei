defmodule Dievergolderei.FilesTest do
  use ExUnit.Case

  describe "File Hashing" do
    @test_file %{
      path: "test/support/data/image.jpg",
      sha256: "7f8bce0108837a53bc65d9c51ec3e3f2652d2bc78cc219409d402967ff35fab5",
      md5: "d9df30f323b5fb11cb10706882d5f6c1"
    }

    test "SHA-256 hash gets calculated correctly" do
      hash = Dievergolderei.FileUtil.hash(@test_file.path, :sha256)

      assert @test_file.sha256 == hash
    end

    test "MD5 hash gets calculated correctly" do
      hash = Dievergolderei.FileUtil.hash(@test_file.path, :md5)

      assert @test_file.md5 == hash
    end
  end
end
