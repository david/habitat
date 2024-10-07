defmodule Habitat.Tasks.SyncPackages do
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

  def sync(%{packages: packages}) do
    Logger.info("Syncing packages: #{inspect(packages)}")

    packages
    |> Enum.group_by(&elem(&1, 0))
    |> Enum.each(fn {k, pkgs} ->
      Habitat.PackageManager.get(k).install(for({_, pkg, opts} <- pkgs, do: {pkg, opts}))
    end)
  end

  defp normalize(package_name) when is_binary(package_name), do: {:brew, package_name, []}
  defp normalize({provider, package_name}), do: {provider, package_name, []}
  defp normalize({provider, package_name, opts}), do: {provider, package_name, opts}
end
