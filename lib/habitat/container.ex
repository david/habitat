defmodule Habitat.Container do
  alias Habitat.Distrobox

  require Logger

  def write(%{root: root}, target, body) do
    target = expand_path(root, target)

    Logger.debug("Writing to #{target}")
    Logger.debug(body)

    target |> Path.dirname() |> File.mkdir_p!()
    File.write!(target, body)
  end

  def link(%{id: id, root: root}, target, path) do
    target = expand_path(root, target)
    source = Path.join("/run/host", Path.expand(path))

    Logger.debug("Linking #{source} to #{target}")

    target |> Path.dirname() |> File.mkdir_p!()

    Distrobox.shell(id, ["rm -f #{target}"])
    Distrobox.shell(id, ["ln -sf #{source} #{target}"])
  end

  defp expand_path(root, path) do
    String.replace(path, ~r/^~/, root)
  end

  def chsh(container, path) do
    cmd(container, ["sudo", "chsh", "--shell", path, userid(container)])
  end

  def cmd(id, args, opts \\ []) do
    Distrobox.cmd(id, args, opts)
  end

  def userid(container) do
    {user, 0} = __MODULE__.cmd(container, ["whoami"])

    String.trim(user)
  end

  def export(%{id: id}, export) do
    Logger.info("[#{id}] Exporting #{export}")
    Logger.debug("[#{id}] #{inspect(export)}")

    Distrobox.cmd(id, ["distrobox-export", "--delete", "--app", export])

    :ok = Distrobox.cmd(id, ["distrobox-export", "--app", export])
  end
end
