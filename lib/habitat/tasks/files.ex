defmodule Habitat.Tasks.Files do
  require Logger

  defmodule Glob do
    def glob({_, _} = from, to) do
      [{from, to}]
    end

    def glob(wildcard, to) do
      if wildcard?(wildcard) do
        [{"", to}] ++
          (wildcard
           |> Path.expand()
           |> Path.wildcard()
           |> Enum.map(&{&1, translate(&1, to, wildcard)}))
      else
        [{Path.expand(wildcard), to}]
      end
    end

    defp translate(from, to, wildcard) do
      static =
        wildcard
        |> Path.split()
        |> Enum.take_while(&(!wildcard?(&1)))
        |> Path.join()
        |> Path.expand()

      Path.join(to, String.replace(from, static, ""))
    end

    defp wildcard?(s) when is_binary(s) do
      s =~ ~r/\*/ || s =~ ~r/\[.+\]/ || s =~ ~r/\{.+\}/
    end

    defp wildcard?(_), do: false
  end

  alias __MODULE__.Glob

  def expand_mappings(container) do
    update_in(
      container,
      [:files],
      &Enum.flat_map(&1, fn {from, to} ->
        Glob.glob(
          from,
          to |> String.replace("~", container.root) |> Path.expand()
        )
      end)
    )
  end

  def sync(curr, prev) do
    Logger.info("Syncing files")

    mappings = curr.files |> Map.new(fn {k, v} -> {v, k} end)
    curr_tos = Map.keys(mappings)
    prev_tos = prev.files

    to_unmanage = prev_tos -- curr_tos

    Logger.info("Unmanaging #{inspect(to_unmanage)}")

    to_unmanage
    |> Enum.sort_by(&(-path_weight(&1)))
    |> Enum.each(&unmanage/1)

    to_manage = curr_tos -- prev_tos

    Logger.info("Managing #{inspect(to_manage)}")

    to_manage
    |> Enum.sort_by(&path_weight/1)
    |> Enum.each(fn to -> manage(to, mappings[to]) end)
  end

  # Put directories first, sorted by how close they are to the root, then files
  defp path_weight(path) do
    if File.dir?(path) do
      path |> Path.split() |> Enum.count()
    else
      100_000
    end
  end

  defp manage(to, from) do
    cond do
      from == "" ->
        File.mkdir_p!(to)

      is_binary(from) && File.dir?(from) && File.dir?(to) ->
        nil

      File.dir?(to) ->
        Logger.warning("#{to} is a directory. Skipping.")

      is_binary(from) && File.dir?(from) ->
        Logger.debug("Creating directory #{to}")

        File.mkdir!(to)

      is_binary(from) ->
        from = Path.expand(from)

        link =
          case File.read_link(to) do
            {:ok, ln} -> if Path.expand(ln) == from, do: :skip, else: ln
            {:error, _} -> nil
          end

        case link do
          nil ->
            Logger.debug("Creating symbolic link from #{from} to #{to}")

            File.ln_s!(from, to)

          :skip ->
            nil

          _ ->
            Logger.warning("#{to} is a symbolic link to #{link}. Skipping.")
        end

      ({:text, contents} = from) && File.exists?(to) && contents == File.read!(to) ->
        nil

      ({:text, _} = from) && File.exists?(to) ->
        Logger.warning("#{to} exists. Skipping.")

      {:text, contents} = from ->
        File.write!(to, contents)
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
