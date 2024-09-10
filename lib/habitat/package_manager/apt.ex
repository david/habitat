defmodule Habitat.PackageManager.Apt do
  alias Habitat.Distrobox

  def install(container_id, packages) do
    apt(container_id, ["install", "--no-install-recommends"] ++ packages)
  end

  defp apt(container_id, args) do
    cmd = ["sudo", "apt-get", "--assume-yes"] ++ args

    Distrobox.cmd(container_id, cmd)
  end

  def add_repo(container_id, repo, key) do
    :ok =
      Distrobox.shell(
        container_id,
        [
          "curl -fsSL https://apt.fury.io/wez/gpg.key" <>
            " | " <>
            "sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg"
        ]
      )

    :ok =
      Distrobox.shell(
        container_id,
        [
          "echo deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ \\* \\*" <>
            " | " <>
            "sudo tee /etc/apt/sources.list.d/wezterm.list"
        ]
      )

    :ok = Distrobox.cmd(container_id, ["sudo", "apt-get", "update"])
  end
end
