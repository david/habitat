defmodule Habitat.PackageManager.Brew do
  require Logger

  @bin "/home/linuxbrew/.linuxbrew/bin/brew"

  def files(_, %{shell: shell}) do
    [
      case shell do
        :bash -> {"~/.bashrc", env: "eval \"$(#{@bin} shellenv)\""}
        :fish -> {"~/.config/fish/config.fish", env: "#{@bin} shellenv | source"}
        :zsh -> {"~/.zshrc", env: "eval \"$(#{@bin} shellenv)\""}
      end
    ]
  end

  def install(packages) do
    Logger.info("Installing packages (brew): #{inspect(packages)}")

    for {_, opts} <- packages, tap = Keyword.get(opts, :tap), do: add_tap(tap)

    brew("install", for({pkg, _} <- packages, do: pkg))

  end

  defp brew(command, args) do
    System.cmd(@bin, [command] ++ args)
  end

  defp add_tap(tap) do
    brew("tap", [tap])
  end
end
