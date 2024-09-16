defmodule Habitat.PackageList do
  require Logger

  alias Habitat.Distrobox

  @brew "/home/linuxbrew/.linuxbrew/bin/brew"

  def sync(%{id: id, packages: packages} = container) do
    Logger.info("[#{id}] Syncing packages")
    Logger.debug("[#{id}] #{inspect(packages)}")

    id = to_string(id)

    for {_, opts} <- packages, tap = Keyword.get(opts, :tap), tap do
      Distrobox.cmd(id, [@brew, "tap", "--shallow", tap])
    end

    pkgs = for pkg <- packages do
      case pkg do
        p when is_binary(p) -> p
        {p, _} -> p
      end
    end

    Distrobox.cmd(id, [@brew, "install"] ++ pkgs)
  end
end
