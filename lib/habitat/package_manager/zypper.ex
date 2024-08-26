defmodule Habitat.PackageManager.Zypper do
  alias Habitat.Container

  require Logger

  def install(container_id, packages, opts \\ []) when is_list(packages) do
    zypper(container_id, "install", packages)
  end

  defp zypper(container_id, command, args) do
    cmd = ["zypper", "--non-interactive"] ++ [command, "--force-resolution"] ++ args

    Logger.debug("[zypper] Running `#{Enum.join(cmd, " ")}`")

    Container.cmd(container_id, cmd, root: true)
  end
end
