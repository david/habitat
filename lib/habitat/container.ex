defmodule Habitat.Container do
  alias Habitat.{Exports, Files, Mise, Packages, Programs, Shells}

  require Logger

  def create(container) do
    Logger.info("Creating container #{container.name}")

    {_, 0} =
      System.cmd("distrobox-host-exec", [
        "distrobox",
        "create",
        "--image",
        to_string(container.os.image()) <> ":latest",
        "--name",
        container.name,
        "--home",
        container.root
      ])

    container.os.post_create(container)
  end

  def delete(container) do
    Logger.info("Deleting container #{container.name}")

    System.cmd("distrobox-host-exec", ["distrobox", "stop", container.name])
    System.cmd("distrobox-host-exec", ["distrobox", "rm", container.name])
  end

  def sync(container) do
    Logger.info("Configuring container #{container.name}")
    Logger.debug(container)

    container =
      container
      |> Exports.init()
      |> Files.init()
      |> Mise.init()
      |> Packages.init()
      |> Shells.init()
      |> Programs.pre_sync()
      |> Mise.pre_sync()
      |> Shells.pre_sync()
      |> Files.pre_sync()

    Files.sync(container)
    Packages.sync(container)
    Mise.sync(container)
    Exports.sync(container)
    Shells.sync(container)

    Programs.post_sync(container)
  end

  def cmd(container, args, env \\ %{}) do
    env_strs = for {k, v} <- env, do: "#{k}=#{v}"

    System.cmd(
      "distrobox-host-exec",
      ["distrobox", "enter", "--name", container.name, "--", "env"] ++ env_strs ++ args
    )
  end

  def username(container) do
    {user, 0} = __MODULE__.cmd(container, ["whoami"])

    String.trim(user)
  end
end
