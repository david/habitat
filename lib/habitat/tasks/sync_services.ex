defmodule Habitat.Tasks.SyncServices do
  alias Habitat.Formats.YAML

  require Logger

  def init(manifest, %{services: services}) do
    Map.put(manifest, :services, services)
  end

  def init(manifest, _), do: init(manifest, %{services: []})

  def update(manifest, mod, spec, blueprint) do
    if function_exported?(mod, :services, 2) do
      update_in(manifest, [:services], &(&1 ++ mod.services(spec, blueprint)))
    else
      manifest
    end
  end

  def sync(%{services: services}) do
    Logger.info("Configuring services: #{inspect(services)}")

    File.write!(
      Path.join([Path.expand("~"), ".config", "process-compose.yml"]),
      YAML.from_code([processes: services], 0)
    )
  end
end
