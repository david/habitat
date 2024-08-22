defmodule Habitat.Tasks.Files do
  require Logger

  defmodule Glob do
    def glob({_, _} = from, to, root) do
      [{from, expand(to, root)}]
    end

    def glob(wildcard, to, root) do
      wildcard = Path.expand(wildcard)

      if wildcard?(wildcard) do
        wildcard
        |> Path.wildcard()
        |> Enum.reject(&File.dir?(&1))
        |> Enum.map(&{&1, &1 |> translate(to, wildcard) |> expand(root)})
      else
        [{wildcard, expand(to, root)}]
      end
    end

    defp translate(from, to, wildcard) do
      static =
        wildcard
        |> Path.split()
        |> Enum.take_while(&(!wildcard?(&1)))
        |> Path.join()

      Path.join(to, String.replace(from, static, ""))
    end

    defp wildcard?(s) when is_binary(s) do
      s =~ ~r/\*/ || s =~ ~r/\[.+\]/ || s =~ ~r/\{.+\}/
    end

    defp wildcard?(_), do: false

    defp expand(path, root) do
      path |> String.replace("~", root) |> Path.expand()
    end
  end

  alias __MODULE__.Glob

  def init(container) do
    Map.put_new(container, :files, [])
  end

  def pre_sync(container) do
    update_in(
      container,
      [:files],
      &Enum.flat_map(&1, fn {from, to} ->
        Glob.glob(
          from,
          to |> String.replace("~", container.root) |> Path.expand(),
          container.root
        )
      end)
    )
  end

  def sync(curr, prev) do
    Logger.info("Syncing files")

    mappings = curr.files |> Map.new(fn {k, v} -> {v, k} end)
    curr_tos = mappings |> Map.keys() |> MapSet.new()
    prev_tos = MapSet.new(prev.files)

    to_unmanage = MapSet.difference(prev_tos, curr_tos)
    Logger.info("Unmanaging #{inspect(to_unmanage)}")
    Enum.each(to_unmanage, &unmanage/1)

    to_manage = curr_tos
    Logger.info("Managing #{inspect(to_manage)}")
    Enum.each(to_manage, &manage(&1, mappings[&1]))
  end

  defp manage(to, from) do
    cond do
      from == :dir ->
        Logger.debug("Creating directory #{to}")
        File.mkdir_p!(Path.expand(to))

      match?({:text, _}, from) ->
        {:text, contents} = from
        Logger.debug("Writing text to #{to}")
        to |> Path.dirname() |> File.mkdir_p!()
        File.write!(Path.expand(to), contents)

      File.dir?(to) ->
        Logger.warning("#{to}: Cowardly refusing to override a directory with a symbolic link")

      true ->
        if File.exists?(to), do: File.rm!(to)

        Logger.debug("Creating symbolic link from #{from} to #{to}")
        to |> Path.dirname() |> File.mkdir_p!()
        from |> Path.expand() |> File.ln_s!(Path.expand(to))
    end
  end

  def unmanage(to) do
    cond do
      File.dir?(to) ->
        File.rmdir!(to)

      File.exists?(to) ->
        File.rm!(to)

      true ->
        nil
    end
  end
end
