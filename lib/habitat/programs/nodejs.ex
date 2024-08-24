defmodule Habitat.Programs.Nodejs do
  alias Habitat.Tasks.Mise
  require Logger

  def pre_sync(container, spec) do
    Logger.info("Configuring nodejs")

    container
    |> Mise.put("node", version: version(spec))
    |> put_yarn(spec)
  end

  defp put_yarn(container, spec) do
    if Keyword.get(spec, :package_manager) == :yarn do
      Mise.put(container, "npm:yarn")
    else
      container
    end
  end

  defp version([]), do: nil
  defp version(v) when is_binary(v), do: v
  defp version(opts) when is_list(opts), do: Keyword.get(opts, :version, version([]))
end
