defmodule Habitat.Tasks.FilesTest do
  use ExUnit.Case

  alias Habitat.Tasks.Files

  doctest Files

  @from Path.expand("test/fixtures")
  @to Path.expand("test/tmp/target")

  setup do
    on_exit(fn -> File.rm_rf!(@to) end)
  end

  describe "first sync" do
    test "creates all relevant files and directories" do
      assert [] = Path.wildcard("#{@to}/**", match_dot: true)

      container =
        Map.put(container(), :files, [
          {"#{@from}/dir1/file1.txt", "#{@to}/.config/alt_name/file1.txt"},
          {"#{@from}/dir2/file1.txt", "#{@to}/.config/dir2/file1.txt"},
          {"#{@from}/dir2/file2.txt", "#{@to}/.config/dir2/file2.txt"},
          {"#{@from}/dir2/inner/file3.txt", "#{@to}/.config/dir2/inner/file3.txt"}
        ])

      Files.sync(container, %{files: []})

      fs = [
        "#{@to}/.config",
        "#{@to}/.config/alt_name",
        "#{@to}/.config/alt_name/file1.txt",
        "#{@to}/.config/dir2",
        "#{@to}/.config/dir2/file1.txt",
        "#{@to}/.config/dir2/file2.txt",
        "#{@to}/.config/dir2/inner",
        "#{@to}/.config/dir2/inner/file3.txt"
      ]

      assert fs == Path.wildcard("#{@to}/**", match_dot: true)

      assert symlink?("#{@from}/dir1/file1.txt", "#{@to}/.config/alt_name/file1.txt")
      assert symlink?("#{@from}/dir2/file1.txt", "#{@to}/.config/dir2/file1.txt")
      assert symlink?("#{@from}/dir2/file2.txt", "#{@to}/.config/dir2/file2.txt")

      assert symlink?(
               "#{@from}/dir2/inner/file3.txt",
               "#{@to}/.config/dir2/inner/file3.txt"
             )
    end

    test "file links override regular files" do
      file = "#{@to}/.config/dir2/file1.txt"
      file |> Path.dirname() |> File.mkdir_p!()
      File.touch!(file)

      container = Map.put(container(), :files, [{"#{@from}/dir2/file1.txt", file}])

      Files.sync(container, %{files: []})

      assert File.read_link!(file) == "#{@from}/dir2/file1.txt"
    end

    test "generated files override previously generated ones" do
      file = "#{@to}/.config/dir2/file4.txt"
      file |> Path.dirname() |> File.mkdir_p!()
      File.write!(file, "hello")

      container = Map.put(container(), :files, [{{:text, "bye"}, file}])

      Files.sync(container, %{files: []})

      assert File.regular?(file)
      assert File.read!(file) == "bye"
    end

    test "symbolic links override symbolic links" do
      file = "#{@to}/.config/dir2/file1.txt"

      file |> Path.dirname() |> File.mkdir_p!()
      File.ln_s!("#{@from}/dir2/file2.txt", file)

      container = Map.put(container(), :files, [{"#{@from}/dir2/file1.txt", file}])

      Files.sync(container, %{files: []})

      assert File.read_link!(file) == "#{@from}/dir2/file1.txt"
    end
  end

  describe "subsequent syncs" do
    test "generated files override previously generated ones" do
      file = "#{@to}/.config/dir2/file4.txt"
      file |> Path.dirname() |> File.mkdir_p!()
      File.write!(file, "hello")

      container = Map.put(container(), :files, [{{:text, "bye"}, file}])

      Files.sync(container, %{files: [file]})

      assert File.regular?(file)
      assert File.read!(file) == "bye"
    end
  end

  defp container do
    %{
      root: @to
    }
  end

  defp symlink?(from, to) do
    link =
      case File.read_link(to) do
        {:ok, ln} -> ln
        {:error, _} -> nil
      end

    Path.expand(link) == from
  end
end
