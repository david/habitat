defmodule Habitat.Traits.Files do
  require Logger

  def post_install({_, [files: files]} = spec, container) do
    for {from, to} <- files do
      link(Path.expand(from), String.replace(to, ~r/^~/, container.home))
    end

    spec
  end

  def post_install({package, _} = spec, container) do
    from = "files" |> Path.expand() |> Path.join(package)

    if File.dir?(from) do
      to = Path.join([container.home, ".config", package])

      link(from, to)
    end

    spec
  end

  defp link(from, to) do
    cond do
      !File.exists?(from) ->
        Logger.warning("#{from} does not exist")

      File.dir?(from) ->
        link_dir(from, to)
        link_all(from, to)

      true ->
        link_file(from, to)
    end
  end

  defp link_file(from, to) do
    link =
      case File.read_link(to) do
        {:ok, ln} -> ln
        {:error, _} -> nil
      end

    cond do
      link && link != from ->
        Logger.warning("#{to} is a symbolic link to #{link}")
        Logger.warning("Replacing with symbolic link to #{from}")

        File.rm!(to)
        File.ln_s!(from, to)

      link ->
        Logger.debug("#{to} is already a symbolic link to #{from}")

      File.regular?(to) ->
        Logger.warning("#{to} is a regular file")
        Logger.warning("Backing up and replacing with symbolic link to #{from}")

        backup(to)
        File.rm!(to)
        File.ln_s!(from, to)

      File.dir?(to) ->
        Logger.warning("#{to} is a directory")
        Logger.warning("Backing up and replacing with symbolic link to #{from}")

        backup(to)
        File.rm_rf!(to)
        File.ln_s!(from, to)

      true ->
        Logger.info("Creating symbolic link from #{from} to #{to}")

        File.ln_s!(from, to)
    end
  end

  defp link_dir(from, to) do
    link =
      case File.read_link(to) do
        {:ok, ln} -> ln
        {:error, _} -> nil
      end

    cond do
      link ->
        Logger.warning("#{to} is a symbolic link to #{link}")
        Logger.warning("Replacing with directory")

        File.rm!(to)
        File.mkdir_p!(to)

      File.regular?(to) ->
        Logger.warning("#{to} is a regular file")
        Logger.warning("Backing up #{to} and replacing with directory")

        backup(to)
        File.rm!(to)
        File.mkdir_p!(to)

      File.dir?(to) ->
        Logger.debug("#{to} is already a directory")

      true ->
        Logger.info("Creating directory #{to}")

        File.mkdir_p!(to)
    end
  end

  defp link_all(from, to) do
    File.ls!(from)
    |> Enum.map(&Path.join(from, &1))
    |> Enum.each(&link_file(&1, Path.join(to, Path.basename(&1))))
  end

  defp backup(from, version \\ 1) do
    to = "#{from}.#{version}.bak"

    cond do
      File.exists?(to) ->
        Logger.warning("Backup #{to} exists")
        Logger.warning("Trying another backup file name")
        backup(from, version + 1)

      File.dir?(from) ->
        Logger.info("Creating backup #{to} of #{from}")
        File.cp_r!(from, to)

      true ->
        Logger.info("Creating backup #{to} of #{from}")
        File.cp!(from, to)
    end
  end
end
