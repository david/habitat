defmodule Habitat.PackageManager.Apt do
  alias Habitat.Distrobox

  def install(container_id, packages) do
    apt(container_id, ["install"] ++ packages)
  end

  defp apt(container_id, args) do
    cmd = ["sudo", "apt-get", "--assume-yes"] ++ args

    Distrobox.cmd(container_id, cmd)
  end
end
