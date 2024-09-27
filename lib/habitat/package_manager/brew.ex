defmodule Habitat.PackageManager.Brew do
  alias Habitat.Distrobox

  @bin "/home/linuxbrew/.linuxbrew/bin/brew"

  def files(_, %{shell: shell}) do
    IO.inspect(shell)

    [
      case shell do
        :bash -> {"~/.bashrc", env: "eval \"$(#{@bin} shellenv)\""}
        :fish -> {"~/.config/fish/config.fish", env: "#{@bin} shellenv | source"}
        :zsh -> {"~/.zshrc", env: "eval \"$(#{@bin} shellenv)\""}
      end
    ]
  end

  def install(container_id, package, opts) do
    if tap = Keyword.get(opts, :tap), do: add_tap(container_id, tap)
    Distrobox.cmd(container_id, [@bin, "install", package])
  end

  defp add_tap(container_id, tap) do
    Distrobox.cmd(container_id, [@bin, "tap", tap])
  end
end
