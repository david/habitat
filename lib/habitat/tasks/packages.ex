defmodule Habitat.Tasks.Packages do
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

  def sync(curr, _) do
    install(curr)
  end

  defp install(%{packages: []}), do: nil

  defp install(%{packages: packages} = container) do
    container.os.install(container, packages)
  end
end
