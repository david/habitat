defmodule Habitat.PackageManager.Brew do
  @install_script "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
  @bin "/home/linuxbrew/.linuxbrew/bin/brew"

  alias Habitat.Distrobox

  def post_create(container_id) do
    Distrobox.cmd(
      container_id,
      ["bash", "-c", "curl -fsSL #{@install_script} | bash"],
      env: [{"NONINTERACTIVE", "1"}]
    )
  end

  def pre_sync(container_id) do
    Habitat.Module.insert(container_id, "~/.bashrc", interactive: "eval \"$(#{cmd("bash")})\"")
    Habitat.Module.insert(container_id, "~/.zshrc", interactive: "eval \"$(#{cmd("zsh")})\"")

    Habitat.Module.insert(
      container_id,
      "~/.config/fish/config.fish",
      interactive: "#{cmd("fish")} | source"
    )
  end

  def install(container_id, packages) when is_list(packages) do
    Distrobox.cmd(container_id, [@bin, "install"] ++ packages)
  end

  defp cmd(shell), do: "#{@bin} shellenv #{shell}"
end
