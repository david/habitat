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
    Habitat.Module.put_file(container_id, "~/.bashrc", interactive: "eval \"$(#{cmd("bash")})\"")
    Habitat.Module.put_file(container_id, "~/.zshrc", interactive: "eval \"$(#{cmd("zsh")})\"")

    Habitat.Module.put_file(
      container_id,
      "~/.config/fish/config.fish",
      interactive: "#{cmd("fish")} | source"
    )
  end

  def install(container_id, packages) when is_list(packages) do
    for {_, opts} <- packages, tap = Keyword.get(opts, :tap) do
      Distrobox.cmd(container_id, [@bin, "tap", tap])
    end

    for {p, _} <- packages, do: Distrobox.cmd(container_id, [@bin, "install", p])
  end

  defp cmd(shell), do: "#{@bin} shellenv #{shell}"
end
