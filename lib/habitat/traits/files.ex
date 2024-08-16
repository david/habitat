defmodule Habitat.Traits.Files do
  require Logger

  def post_install(container) do
    for {to, from} <- container.files do
      link(from, String.replace(to, ~r/^~/, container.root))
    end

    for pkg <- container.packages do
      from = "files" |> Path.expand() |> Path.join(pkg)

      if File.dir?(from) do
        link(from, Path.join([container.root, ".config", pkg]))
      end
    end
  end

  defp link({:text, contents}, to) do
    link =
      case File.read_link(to) do
        {:ok, ln} -> ln
        {:error, _} -> nil
      end

    cond do
      link ->
        Logger.warning("#{to} is a symbolic link to #{link}")

        File.rm!(to)
        File.write(to, contents)

      # TODO: This may be a file with the same contents, and should not be backed up
      File.regular?(to) ->
        Logger.warning("#{to} is a regular file")

        backup(to)
        File.rm!(to)
        File.write(to, contents)

      File.dir?(to) ->
        Logger.warning("#{to} is a directory")

        backup(to)
        File.rm_rf!(to)
        File.write(to, contents)

      true ->
        Logger.info("Writing file #{to}")

        File.write(to, contents)
    end
  end

  defp link(from, to) do
    from = Path.expand(from)

    to |> Path.dirname() |> File.mkdir_p!()

    cond do
      !File.exists?(from) ->
        Logger.warning("#{from} does not exist")

      File.dir?(from) ->
        mkdir(to)
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
        nil

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

  defp mkdir(to) do
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
        nil

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
