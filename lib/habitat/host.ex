defmodule Habitat.Host do
  alias Habitat.{Distrobox, OS}

  require Logger

  def list_containers do
    {:ok, out} = cmd(["distrobox", "list", "--no-color"])

    out
    |> String.trim()
    |> String.split("\n")
    |> tl()
    |> Enum.map(&String.split(&1, "|"))
    |> Enum.map(fn [_id, name | _rest] -> String.trim(name) end)
  end

  def create_container(container) do
    Logger.info("Creating container #{container.name}")

    Distrobox.create(container)
    container.os.post_create(container)
  end

  def delete_container(container) do
    Logger.info("Deleting container #{container.name}")

    Distrobox.stop(container)
    Distrobox.rm(container)
  end

  def cmd(cmd) do
    case System.cmd("distrobox-host-exec", cmd) do
      {out, 0} -> {:ok, out}
      {err, _} -> {:error, err}
    end
  end
end
