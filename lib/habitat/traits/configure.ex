defmodule Habitat.Traits.Configure do
  require Logger

  def post_install({package, _} = spec, container) do
    source = Path.join("files", package)

    if File.dir?(source) do
      Logger.info("Configuring #{package} with #{source}")

      target = Path.join([container.home, ".config", package])

      mkdir(target)

      File.ls!(source)
      |> Enum.map(&Path.join(source, &1))
      |> Enum.each(&link(&1, Path.join(target, Path.basename(&1))))
    end

    spec
  end

  defp mkdir(dir) do
    link =
      case File.read_link(dir) do
        {:ok, ln} -> ln
        {:error, _} -> nil
      end

    cond do
      link ->
        Logger.warning("#{dir} is a symbolic link to #{link} and will be replaced")

        File.rm!(dir)

      File.regular?(dir) ->
        Logger.warning("#{dir} is a regular file and will be replaced")

        backup(dir)
        File.rm(dir)
        mkdir(dir)

      File.dir?(dir) ->
        Logger.debug("Directory #{dir} already exists")

      true ->
        Logger.info("Creating directory #{dir}")

        File.mkdir_p(dir)
    end
  end

  defp link(from, to) do
    link =
      case File.read_link(to) do
        {:ok, ln} -> ln
        {:error, _} -> nil
      end

    cond do
      link && from != link ->
        Logger.warning("#{to} is a symbolic link to #{link} and will be replaced")

        File.rm!(to)

      link ->
        Logger.debug("#{to} already links to #{from}")

      File.regular?(to) ->
        backup(to)
        File.rm(to)
        link(from, to)

      true ->
        Logger.info("Linking #{from} to #{to}")

        File.ln_s(from, to)
    end
  end

  defp backup(source, version \\ 1) do
    target = "#{source}.#{version}.bak"

    cond do
      File.exists?(target) ->
        backup(source, version + 1)

      File.dir?(source) ->
        Logger.info("Creating backup #{target} of directory #{source}")
        File.cp_r!(source, target)

      true ->
        Logger.info("Creating backup #{target} of file #{source}")
        File.cp!(source, target)
    end
  end

  def post_install(spec, _container), do: spec
end
