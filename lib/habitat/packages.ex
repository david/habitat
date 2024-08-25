defmodule Habitat.Packages do
  alias Habitat.OS

  require Logger

  def init(container) do
    Map.put_new(container, :packages, [])
  end

  def put(container, package) when is_binary(package) do
    update_in(container, [:packages], &[package | &1])
  end

  def put(container, packages) when is_list(packages) do
    update_in(container, [:packages], &(&1 ++ packages))
  end

  def sync(%{packages: []} = container), do: container

  def sync(%{packages: packages} = container) do
    OS.get(container.os).install(container, packages)
  end
end
