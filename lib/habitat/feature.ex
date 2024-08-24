defmodule Habitat.Feature do
  alias Habitat.Tasks.{Files, Mise, Packages, Shells}

  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
      require Logger
    end
  end

  def put_file(container, from, to) do
    Files.put(container, from, to)
  end

  def put_files(container, files) do
    Files.put(container, files)
  end

  def put_package(container, package) do
    Packages.put(container, package)
  end

  def put_packages(container, packages) do
    Packages.put(container, packages)
  end

  def put_package(container, :mise, package, opts \\ []) do
    Mise.put_package(container, package, opts)
  end

  def put_string(container, to, string) do
    Files.put_string(container, string, to)
  end

  def put_shell_config(container, shell, name, body) do
    Shells.put(container, shell, name, body)
  end
end
