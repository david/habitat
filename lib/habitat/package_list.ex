defmodule Habitat.PackageList do
  require Logger

  def init(manifest, %{packages: packages}) do
    Map.put(manifest, :packages, Enum.map(packages, &normalize/1))
  end

  def init(manifest, _), do: init(manifest, %{packages: []})

  def update(manifest, mod, spec, blueprint) do
    if function_exported?(mod, :packages, 2) do
      update_in(
        manifest,
        [:packages],
        fn packages ->
          packages ++ for(p <- mod.packages(spec, blueprint), p, do: normalize(p))
        end
      )
    else
      manifest
    end
  end

  def sync(%{packages: packages}, %{id: id} = container) do
    Logger.info("[#{id}] Syncing packages")
    Logger.debug("[#{id}] #{inspect(packages)}")

    for package <- packages, do: Habitat.Container.install(container, package)
  end

  defp normalize(package_name) when is_binary(package_name), do: {:brew, package_name, []}
  defp normalize({provider, package_name}), do: {provider, package_name, []}
  defp normalize({provider, package_name, opts}), do: {provider, package_name, opts}
end
