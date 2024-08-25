defmodule Habitat.PackageManager.Zypper do
  alias Habitat.Container

  require Logger

  def install(container, packages, opts \\ []) when is_list(packages) do
    zypper(
      container,
      "install",
      [] ++ if(Keyword.get(opts, :force), do: ["--force-resolution"], else: []) ++ packages
    )
  end

  defp zypper(container, command, args) do
    cmd = ["zypper", "--non-interactive"] ++ [command] ++ args

    Logger.debug("[zypper] Running `#{Enum.join(cmd, " ")}`")

    case Container.cmd(container, cmd, root: true) do
      {_, 0} ->
        :ok

      {error, code} ->
        Logger.debug("[zypper] Return value: #{code}")

        {:error, error}
    end
  end
end
