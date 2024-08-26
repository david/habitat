defmodule Habitat.Files do
  require Logger

  def sync(container) do
    Logger.info("Syncing files")
    Logger.debug(inspect(container.files))

    for {target, src} <- container.files, do: sync_path(container, src, target)
  end

  def sync_path(container, src, target) do
    cond do
      src == nil && match?({_, _}, target) ->
        create_path(container, target)

      match?({:string, _}, src) && is_binary(target) ->
        create_path(container, {:dir, Path.dirname(target)})
        write_string(container, elem(src, 1), target)

      File.dir?(src) ->
        sync_dir(container, Path.expand(src), target)

      File.regular?(src) ->
        sync_file(container, Path.expand(src), target)
    end
  end

  defp create_path(container, {:dir, target}) do
    target |> expand(container.root) |> File.mkdir_p!()
  end

  defp write_string(container, contents, target) do
    target = expand(target, container.root)

    case File.lstat(target) do
      {:ok, %{type: :symlink}} ->
        linked = File.read_link!(target)
        Logger.warning("Boldly replacing symlink from #{target} to #{linked} with a plain file")

        File.rm!(target)
        write_string(container, contents, target)

      {:ok, %{type: :directory}} ->
        Logger.warning("Cowardly refusing to replace directory #{target} with a file")

      _ ->
        File.write!(target, contents)
    end
  end

  defp sync_file(container, src, target) do
    target = expand(target, container.root)

    case File.lstat(target) do
      {:ok, %{type: :regular}} ->
        Logger.warning("Cowardly refusing to replace file #{target} with a symlink")

      {:ok, %{type: :directory}} ->
        Logger.warning("Cowardly refusing to replace directory #{target} with a symlink")

      {:ok, %{type: :symlink}} ->
        src = Path.expand(src)
        linked = File.read_link!(target)

        unless linked == src do
          Logger.warning(
            "Boldly replacing symlink from #{target} to #{linked} with symlink to #{src}"
          )

          File.rm(target)
          sync_file(container, src, target)
        end

      _ ->
        File.ln_s!(src, target)
    end
  end

  defp sync_dir(container, src, {:symlink, target}) do
    target = expand(target, container.root)

    case File.lstat(target) do
      {:ok, %{type: :regular}} ->
        Logger.warning("Cowardly refusing to replace file #{target} with a symlink")

      {:ok, %{type: :directory}} ->
        Logger.warning("Cowardly refusing to replace directory #{target} with a symlink")

      _ ->
        File.rm(target)
        File.ln_s!(src, target)
    end
  end

  defp sync_dir(container, src, target) do
    target = expand(target, container.root)

    case File.lstat(target) do
      {:ok, %{type: :symlink}} ->
        linked = File.read_link!(target)
        Logger.warning("Boldly replacing symlink from #{target} to #{linked} with a directory")

        File.rm!(target)
        sync_dir(container, target, src)

      {:ok, %{type: :regular}} ->
        Logger.warning("Cowardly refusing to replace file #{target} with a directory")

      _ ->
        File.mkdir_p!(target)

        for f <- File.ls!(src) do
          sync_path(
            container,
            Path.join(src, f),
            Path.join(target, f)
          )
        end
    end
  end

  defp expand(path, root) do
    path |> String.replace("~", root) |> Path.expand()
  end
end
