defmodule Habitat.Installer do
  alias Habitat.{Container, Distrobox}

  require Logger

  @package_dir "/usr/local/habitat"

  def sync(container_id, packages) do
    for {package, src} <- packages do
      sync_pkg(container_id, package, src)
    end
  end

  defp sync_pkg(container_id, package, src) do
    {:ok, extracted_path} = download(src)
    {:ok, extracted_dir} = extract(extracted_path)

    dest_dir = Path.expand(@package_dir, package)

    {:ok, install_dir} = install(container_id, extracted_dir, package)

    share(container_id, install_dir)
  end

  defp extract(path) do
    basename = Path.basename(path)
    dir = Temp.path!(%{prefix: basename, basedir: "/run/host/tmp"})

    Logger.debug("Extracting #{path} to #{dir}")

    File.mkdir!(dir)

    case System.cmd("tar", ["--extract", "--file=#{path}", "--directory=#{dir}"]) do
      {_, 0} -> :ok
      {err, _} -> {:error, err}
    end

    for(f <- File.ls!(dir), p = Path.join(dir, f), File.dir?(p), do: {:ok, p}) |> hd()
  end

  defp install(container_id, src, package) do
    dest = Path.join(@package_dir, package)

    Logger.debug("Installing #{src} to #{dest}")

    :ok = Distrobox.cmd(container_id, ["mkdir", "-p", @package_dir], root: true)
    :ok = Distrobox.cmd(container_id, ["cp", "--recursive", src, dest], root: true)

    {:ok, dest}
  end

  defp download(src) do
    Logger.debug("Downloading #{src}")

    filename = Path.basename(src)
    basedir = Temp.path!(%{prefix: to_string(filename), basedir: "/run/host/tmp"})
    dest_path = Path.join(basedir, filename)

    File.mkdir!(basedir)

    {:ok, :saved_to_file} =
      :httpc.request(
        :get,
        {to_charlist(src), []},
        [],
        body_format: :binary,
        stream: to_charlist(dest_path)
      )

    {:ok, dest_path}
  end

  defp share(container_id, src) do
    dest = Path.dirname(@package_dir)

    Logger.debug("Sharing #{src} to #{dest}")

    Distrobox.cmd(
      container_id,
      ["stow", "--dir=#{Path.dirname(src)}", "--target=#{dest}", Path.basename(src)],
      root: true
    )
  end
end
