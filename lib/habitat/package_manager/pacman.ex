defmodule Habitat.PackageManager.Pacman do
  def install(packages) do
    {_, 0} = pacman(["--sync", "--needed"] ++ packages)
  end

  def uninstall(packages) do
    {_, 0} = pacman(["--remove", "--nosave", "--recursive"] ++ packages)
  end

  def list(filter) do
    flags = ["--query"] ++ if(filter == :explicit, do: ["--explicit"], else: [])

    {pkgs, 0} = pacman(flags)

    pkgs
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn str -> String.split(str) |> List.to_tuple() |> Habitat.Package.new() end)
  end

  defp pacman(args) do
    cmd = ["pacman", "--noconfirm"] ++ args

    IO.puts("Running `#{Enum.join(cmd, " ")}`")

    {out, code} = System.cmd("sudo", ["pacman", "--noconfirm"] ++ args)

    IO.inspect([out, code])

    {out, code}
  end
end
