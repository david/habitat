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

  def install(container_id, packages) do
    for {_, opts} <- packages, tap = Keyword.get(opts, :tap) do
      add_tap(container_id, tap)
    end

    brew(container_id, ["install"] ++ for({pkg, _} <- packages, do: pkg))
  end

  defp brew(container_id, args) do
    Distrobox.cmd(container_id, [@bin] ++ args)
  end

  defp add_tap(container_id, tap) do
    Distrobox.cmd(container_id, [@bin, "tap", tap])
  end
end
