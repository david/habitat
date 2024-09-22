defmodule Habitat.PackageList do
  require Logger

  alias Habitat.PackageManager.{Apt, Brew}

  @brew "/home/linuxbrew/.linuxbrew/bin/brew"

  def sync(%{id: id, packages: packages} = container) do
    Logger.info("[#{id}] Syncing packages")
    Logger.debug("[#{id}] #{inspect(packages)}")

    id = to_string(id)

    packages
    |> normalize()
    |> Enum.group_by(&elem(&1, 0))
    |> Enum.each(fn {provider_id, packages} ->
      Habitat.PackageManager.get(provider_id).install(
        id,
        for({_, pkg, opts} <- packages, do: {pkg, opts})
      )
    end)
  end

  defp normalize(packages) do
    for p <- packages do
      case p do
        name when is_binary(name) -> {:brew, name, []}
        {provider, name} when is_binary(name) -> {provider, name, []}
        {_provider, _name, _opts} -> p
      end
    end
  end
end
