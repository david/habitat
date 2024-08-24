defmodule Habitat.Programs.Nodejs do
  alias Habitat.Tasks.Mise
  require Logger

  def pre_sync(container, spec) do
    Logger.info("Configuring nodejs")

    container
    |> Mise.put("node", spec)
    |> put_yarn(spec)
  end

  defp put_yarn(container, spec) do
    if Keyword.get(spec, :package_manager) == :yarn do
      Mise.put(container, "npm:yarn")
    else
      container
    end
  end
end
