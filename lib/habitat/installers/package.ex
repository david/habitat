defmodule Habitat.Installers.Package do
  require Logger

  alias Habitat.Distrobox

  @base_dir Path.expand("~/.cache/habitat")
  @download_dir Path.join(@base_dir, "archives")
  @src_dir Path.join(@base_dir, "src")
  @build_dir Path.join(@base_dir, "build")
  @install_dir "/usr/local"

  def sync(container, package_name, %{download: source, install: install}) do
    {:ok, archive_path} = download(source)
    {:ok, src_dir} = extract(archive_path)
    {:ok, build_dir} = build(container, src_dir)
    {:ok, _} = install(build_dir, container, install)

    :ok
  end

  def sync(container, _, _), do: container

  defp download(%{url: url, archive: file_name}) do
    file_name = file_name || Path.basename(url)

    :ok = File.mkdir_p(@download_dir)

    file_path = Path.join(@download_dir, file_name)

    if File.regular?(file_path) do
      Logger.debug("File #{file_path} is cached")
    else
      Logger.debug("Downloading #{url} to #{file_path}")

      {:ok, :saved_to_file} =
        :httpc.request(
          :get,
          {to_charlist(url), []},
          [],
          body_format: :binary,
          stream: to_charlist(file_path)
        )
    end

    {:ok, file_path}
  end

  defp extract(archive_path) do
    src_dir = Path.join(@src_dir, Path.basename(archive_path))

    :ok = File.mkdir_p(src_dir)

    if File.ls!(src_dir) != [] do
      Logger.debug("Source dir #{src_dir} is cached")
    else
      Logger.debug("Extracting #{archive_path} to #{src_dir}")

      base_args = ["--extract", "--file=#{archive_path}", "--directory=#{src_dir}"]

      {_, 0} = System.cmd("tar", base_args ++ ["--strip-components=1"] )

      if File.ls!(src_dir) == [] do
        Logger.debug("Extracting without stripping top dir #{archive_path} to #{src_dir}")
        {_, 0} = System.cmd("tar", base_args)
      end
    end

    {:ok, src_dir}
  end

  def build(%{id: id}, src_dir) do
    base_name = Path.basename(src_dir)
    build_dir = Path.join(@build_dir, base_name)

    cond do
      File.regular?(Path.join(src_dir, "configure")) ->
        :ok = File.mkdir_p(build_dir)

        Distrobox.cmd(id, [Path.join(src_dir, "configure")], cd: build_dir)
        Distrobox.cmd(id, ["make"], cd: build_dir)

        {:ok, build_dir}

      true ->
        {:ok, src_dir}
    end
  end

  defp install(%{id: id, root: root}, build_dir, nil) do
    cond do
      File.regular?(Path.join(build_dir, "Makefile")) ->
        Distrobox.cmd(id, ["make", "install"], cd: build_dir)

      true ->
        for to <- File.ls!(build_dir) do
          from_path = Path.join(build_dir, to)
          install_dir = Path.join(@install_dir, to)
          Logger.debug("Copying #{from_path} to #{@install_dir}")

          :ok = Distrobox.cmd(id, ["sudo", "mkdir", "-p", install_dir])
          :ok = Distrobox.cmd(id, ["sudo", "cp", "-r", from_path, @install_dir])
        end
    end
  end

  defp install(source_dir, %{id: id, root: root}, mappings) do
    Logger.debug("Installing #{source_dir}")

    for {from, to} <- mappings do
      [path, opts] = case to do
        [p | o] -> [p, o]
        _ -> [to, []]
      end

      from_path = Path.join(source_dir, from)
      to_path = Path.join(@install_dir, path)

      Logger.debug("Installing #{from_path}")

      cond do
        File.regular?(from_path) ->
          install_dir = Path.dirname(to_path)

          Logger.debug("Copying #{from_path} to #{install_dir}")

          :ok = Distrobox.cmd(id, ["sudo", "mkdir", "-p", install_dir])
          :ok = Distrobox.cmd(id, ["sudo", "cp", from_path, to_path])

          if perms = Keyword.get(opts, :permissions) do
            :ok = Distrobox.cmd(id, ["sudo", "chmod", perms, to_path])
          end

        File.dir?(from_path) ->
          install_dir = Path.join(@install_dir, to)
          Logger.debug("Copying #{from_path} to #{install_dir}")

          :ok = Distrobox.cmd(id, ["sudo", "mkdir", "-p", install_dir])
          :ok = Distrobox.cmd(id, ["sudo", "cp", "-r", from_path, install_dir])
      end
    end

    {:ok, nil}
  end
end
