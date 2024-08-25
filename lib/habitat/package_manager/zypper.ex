defmodule Habitat.PackageManager.Zypper do
  alias Habitat.Container

  require Logger

  def install(container, package, opts \\ [])

  def install(container, package, opts) when is_binary(package) do
    install(container, [package], opts)
  end

  def install(container, packages, opts) when is_list(packages) do
    {_, 0} =
      zypper(
        container,
        "install",
        [] ++ if(Keyword.get(opts, :force), do: ["--force-resolution"], else: []) ++ packages
      )
  end

  defp zypper(container, command, args) do
    cmd = ["zypper", "--non-interactive"] ++ [command] ++ args

    Logger.debug("[zypper] Running `#{Enum.join(cmd, " ")}`")

    {out, code} = Container.cmd(container, cmd, root: true)

    Logger.debug("[zypper] Return value: #{code}")

    {out, code}
  end
end
