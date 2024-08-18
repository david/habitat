defmodule Habitat.Tasks.Files.GlobTest do
  use ExUnit.Case

  alias Habitat.Tasks.Files.Glob

  doctest Glob

  @from Path.expand("test/fixtures")
  @to Path.expand("test/tmp/target")

  test "ignores tuple sources" do
    to = ".config/dir1/file1.txt"
    from = {:text, "hello"}

    assert [{from, "#{@to}/#{to}"}] == Glob.glob(from, "~/#{to}", @to)
  end

  test "maps full paths" do
    from = "#{@from}/dir1/file1.txt"
    to = "#{@to}/.config/dir1/file1.txt"

    assert [{from, to}] == Glob.glob(from, to, @to)
  end

  test "maps relative paths" do
    from = "dir1/file1.txt"
    to = ".config/dir1/file1.txt"

    assert [{"#{@from}/#{from}", "#{@to}/#{to}"}] ==
             Glob.glob("test/fixtures/#{from}", "~/#{to}", @to)
  end

  test "maps simple globs" do
    tree = [
      {"#{@from}/dir2/file1.txt", "#{@to}/.config/dir2/file1.txt"},
      {"#{@from}/dir2/file2.txt", "#{@to}/.config/dir2/file2.txt"}
    ]

    assert tree == Glob.glob("test/fixtures/dir2/*", "~/.config/dir2", @to)
  end

  test "maps recursive globs" do
    tree = [
      {"#{@from}/dir2/file1.txt", "#{@to}/.config/dir2/file1.txt"},
      {"#{@from}/dir2/file2.txt", "#{@to}/.config/dir2/file2.txt"},
      {"#{@from}/dir2/inner/file3.txt", "#{@to}/.config/dir2/inner/file3.txt"}
    ]

    assert tree == Glob.glob("test/fixtures/dir2/**", "~/.config/dir2", @to)
  end
end
