defmodule Habitat.Blueprint do
  defmacro __using__(_) do
    quote do
      Application.put_env(:habitat, :blueprint, __MODULE__)

      import Habitat.Blueprint.DSL
    end
  end

  require Logger

  @default_os :ubuntu
  @default_image "ghcr.io/david/habitat-ubuntu"

  def load(file_path \\ "blueprint.exs") do
    if File.exists?(file_path) do
      Code.require_file(file_path)
    end

    case Application.fetch_env(:habitat, :blueprint) do
      {:ok, mod} ->
        {:ok, Enum.map(host(mod) ++ mod.containers(), &normalize/1)}

      :error ->
        {:error, nil}
    end
  end

  defp normalize(blueprint) do
    brew = {:brew, to_module(Habitat.PackageManager.Brew), %{}}
    modules = get_modules(blueprint)
    shell = get_shell(blueprint)
    xdg = get_xdg(blueprint)

    blueprint
    |> Map.put_new(:os, @default_os)
    |> Map.put_new(:image, @default_image)
    |> update_in([:root], &Path.expand/1)
    |> Map.put(:modules, [brew] ++ modules ++ [xdg, shell])
  end

  defp get_modules(%{modules: modules}) do
    Enum.map(modules, &get_module/1)
  end

  defp get_modules(_), do: []

  defp get_module(key) when is_atom(key) do
    {key, to_module(key), %{}}
  end

  defp get_module({key, spec}) when is_list(spec) do
    {key, to_module(key), Map.new(spec)}
  end

  defp get_module({key, spec}) do
    {key, to_module(key), spec}
  end

  @host_defaults %{
    id: :host,
    os: @default_os,
    image: @default_image,
    modules: []
  }

  defp host(mod) do
    if function_exported?(mod, :host, 0) do
      [Map.merge(@host_defaults, mod.host())]
    else
      []
    end
  end

  defp get_shell(blueprint) do
    key = Map.get(blueprint, :shell, :bash)

    {key, to_module(key, "Habitat.Modules"), %{}}
  end

  defp get_xdg(blueprint) do
    spec = Map.get(blueprint, :xdg, %{})

    {:xdg, Habitat.Xdg, spec}
  end

  defp to_module(modish, namespace \\ "Habitat.Modules") do
    name = to_string(modish)

    with {:module, mod} <-
           (if(String.match?(name, ~r/^Elixir\./)) do
              modish
            else
              name
              |> Macro.camelize()
              |> then(&Module.concat(namespace, &1))
            end)
           |> Code.ensure_loaded() do
      mod
    else
      {:error, :nofile} -> Logger.error("No module named #{modish}")
    end
  end

  defmodule DSL do
    def file(path) do
      {:file, path}
    end

    def link(path) when is_binary(path) do
      {:link, path}
    end

    def link(paths) when is_list(paths) do
      for path <- paths do
        cond do
          File.regular?(path) -> {:file, path}
          File.dir?(path) -> {:dir, path}
        end
      end
    end

    def glob(glob) do
      glob
      |> Path.expand()
      |> Path.wildcard()
      |> Enum.sort()
    end
  end
end
