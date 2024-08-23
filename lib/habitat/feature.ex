defmodule Habitat.Feature do
  alias Habitat.Programs
  alias Habitat.Tasks.Mise

  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
      require Logger
    end
  end

  def put_file(container, from, to) do
    update_in(container, [:files], &[{from, to} | &1])
  end

  def put_files(container, files) do
    update_in(container, [:files], &(&1 ++ files))
  end

  def put_package(container, package) do
    update_in(container, [:packages], &[package | &1])
  end

  def put_package(container, :mise, package, opts \\ []) do
    Mise.put_package(container, package, opts)
  end

  def put_packages(container, packages) do
    update_in(container, [:packages], &(&1 ++ packages))
  end

  def put_text(container, to, text) do
    put_file(container, {:text, text}, to)
  end

  def put_shell_config(container, shell, priority \\ :low, name, body) do
    if Programs.enabled?(container, shell) do
      prefix =
        case priority do
          :high -> "000"
          :low -> "zzz"
        end

      put_file(container, {:text, body}, "~/.config/#{shell}/rc.d/#{prefix}.#{name}.sh")
    else
      container
    end
  end
end
