defmodule Habitat.Blueprint do
  defmacro __using__(_) do
    quote do
      Application.put_env(:habitat, :blueprint, __MODULE__)

      import Habitat.Blueprint.DSL
    end
  end

  def container_path(%{root: root}, path) do
    String.replace(path, ~r/^~/, root)
  end

  def load(file_path \\ "blueprint.exs") do
    if File.exists?(file_path) do
      Code.require_file(file_path)
    end

    case Application.fetch_env(:habitat, :blueprint) do
      {:ok, mod} -> {:ok, Enum.map(mod.containers(), &normalize/1)}
      :error -> {:error, nil}
    end
  end

  defp normalize(blueprint) do
    shell = Map.get(blueprint, :shell, :bash)
    mods = Enum.map(blueprint.modules, &Habitat.Module.load/1)

    mods =
      if Enum.find(mods, fn {k, _} -> k == shell end) do
        mods
      else
        mods ++ [Habitat.Module.load(shell)]
      end

    Map.put(blueprint, :modules, mods)
  end

  defmodule DSL do
    def path(path) do
      cond do
        File.dir?(path) -> {:dir, path}
        File.regular?(path) -> {:file, path}
      end
    end
  end
end
