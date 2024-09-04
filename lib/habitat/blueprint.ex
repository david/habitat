defmodule Habitat.Blueprint do
  defmacro __using__(_) do
    quote do
      Application.put_env(:habitat, :blueprint, __MODULE__)

      import Habitat.Blueprint.DSL
    end
  end

  def containers() do
    if mod = get() do
      mod.containers()
    else
      []
    end
  end

  def get_container(id) do
    case Enum.find(containers(), &(&1.id == id)) do
      nil -> {:error, :not_found}
      val -> {:ok, val}
    end
  end

  defp get do
    if File.exists?("blueprint.exs") do
      Code.require_file("blueprint.exs")
    end

    case Application.fetch_env(:habitat, :blueprint) do
      {:ok, mod} -> mod
      :error -> nil
    end
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
