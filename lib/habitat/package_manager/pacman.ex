defmodule Habitat.PackageManager.Pacman do
  require Logger

  def install(container, packages) do
    {_, 0} = pacman(container, ["--sync", "--needed", "--refresh"] ++ packages)
  end

  def uninstall(container, packages) do
    {_, 0} = pacman(container, ["--remove", "--nosave", "--recursive"] ++ packages)
  end

  def list(container, filter) do
    flags = ["--query"] ++ if(filter == :explicit, do: ["--explicit"], else: [])

    {pkgs, 0} = pacman(container, flags)

    pkgs
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn str -> String.split(str) |> List.first() end)
  end

  defp pacman(container, args) do
    cmd = pacman_cmd(container, args)

    Logger.debug("[pacman] Running `#{Enum.join(cmd, " ")}`")

    {out, code} = System.cmd("distrobox-host-exec", cmd)

    Logger.debug("[pacman] Return value: #{code}")

    {out, code}
  end

  defp pacman_cmd(container, args) do
    [
      "distrobox",
      "enter",
      "--name",
      container.name,
      "--",
      "sudo",
      "pacman",
      "--noconfirm"
    ] ++ args
  end
end
