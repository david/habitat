defmodule Habitat.Programs.Ruby do
  alias Habitat.Tasks.{Mise, Packages}
  require Logger

  def pre_sync(container, spec) do
    Logger.info("Configuring ruby")

    container
    |> Packages.put(["rust", "libffi", "libyaml", "openssl", "zlib"])
    |> Mise.put("ruby", version: version(spec))
  end

  defp version([]), do: nil
  defp version(v) when is_binary(v), do: v
  defp version(opts) when is_list(opts), do: Keyword.get(opts, :version, version([]))
end
