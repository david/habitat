defmodule Habitat.FileList do
  require Logger

  def init(manifest, %{files: files}), do: Map.put(manifest, :files, files)
  def init(manifest, _), do: init(manifest, %{files: %{}})

  def sync(manifest, container) do
    files = Map.get(manifest, :files)

    Logger.info("Syncing files")
    Logger.debug(inspect(files))

    for {target, src} <- files, do: sync_path(manifest, target, src, container)
  end

  def sync_path(_manifest, _target, _src, _container) do
  end

  def _sync_path(manifest, target, src, _container) do
    cond do
      src == nil && match?({_, _}, target) ->
        create_path(manifest, target)

      match?({:string, _}, src) && is_binary(target) ->
        create_path(manifest, {:dir, Path.dirname(target)})
        write_string(manifest, elem(src, 1), target)

      File.dir?(src) ->
        sync_dir(manifest, Path.expand(src), target)

      File.regular?(src) ->
        sync_file(manifest, Path.expand(src), target)
    end
  end

  defp create_path(%{blueprint: %{root: root}}, {:dir, target}) do
    target |> expand(root) |> File.mkdir_p!()
  end

  defp write_string(%{blueprint: %{root: root}} = manifest, contents, target) do
    target = expand(target, root)

    case File.lstat(target) do
      {:ok, %{type: :symlink}} ->
        linked = File.read_link!(target)
        Logger.warning("Boldly replacing symlink from #{target} to #{linked} with a plain file")

        File.rm!(target)
        write_string(manifest, contents, target)

      {:ok, %{type: :directory}} ->
        Logger.warning("Cowardly refusing to replace directory #{target} with a file")

      _ ->
        File.write!(target, contents)
    end
  end

  defp sync_file(%{blueprint: %{root: root}} = manifest, src, target) do
    target = expand(target, root)

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
          sync_file(manifest, src, target)
        end

      _ ->
        File.ln_s!(src, target)
    end
  end

  defp sync_dir(%{blueprint: %{root: root}}, src, {:symlink, target}) do
    target = expand(target, root)

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

  defp sync_dir(%{blueprint: %{root: root}} = manifest, src, target) do
    target = expand(target, root)

    case File.lstat(target) do
      {:ok, %{type: :symlink}} ->
        linked = File.read_link!(target)
        Logger.warning("Boldly replacing symlink from #{target} to #{linked} with a directory")

        File.rm!(target)
        sync_dir(manifest, target, src)

      {:ok, %{type: :regular}} ->
        Logger.warning("Cowardly refusing to replace file #{target} with a directory")

      _ ->
        File.mkdir_p!(target)

        for f <- File.ls!(src) do
          sync_path(
            manifest,
            Path.join(src, f),
            Path.join(target, f),
            %{}
          )
        end
    end
  end

  defp expand(path, root) do
    path |> String.replace("~", root) |> Path.expand()
  end
end
