defmodule Habitat.Container do
  alias Habitat.Distrobox

  require Logger

  def install(%{id: id}, {:apt, package, opts}) do
    Habitat.PackageManager.Apt.install(id, package, opts)
  end

  def install(%{id: id}, {:brew, package, opts}) do
    Habitat.PackageManager.Brew.install(id, package, opts)
  end

  def write(%{root: root}, target, body) do
    target |> Path.dirname() |> File.mkdir_p!()
    File.write!(target, body)
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
    Logger.info("[#{id}] Exporting export")
    Logger.debug("[#{id}] #{inspect(export)}")

    Distrobox.cmd(id, ["distrobox-export", "--delete", "--app", export])

    :ok = Distrobox.cmd(id, ["distrobox-export", "--app", export])
  end
end
