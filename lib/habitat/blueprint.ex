defmodule Habitat.Blueprint do
  defmacro __using__(_) do
    quote do
      Application.put_env(:habitat, :blueprint, __MODULE__)

      import Habitat.Blueprint.DSL
    end
  end

  alias Habitat.Module, as: Mod

  require Logger

  @default_os :ubuntu
  @default_image "ghcr.io/david/habitat-ubuntu"

  def load(file_path \\ "blueprint.exs") do
    if File.exists?(file_path) do
      Code.require_file(file_path)
    end

    case Application.fetch_env(:habitat, :blueprint) do
      {:ok, mod} ->
        {:ok, erl_hostname} = :inet.gethostname()
        ex_hostname = to_string(erl_hostname)

        if host = Enum.find(mod.hosts(), &(Keyword.get(&1, :hostname) == ex_hostname)) do
          host
          |> normalize()
          |> Map.new()
          |> update_in([:containers], fn cs -> Enum.map(cs, &normalize/1) end)
          |> then(&{:ok, &1})
        else
          {:error, :host_not_found}
        end

      :error ->
        {:error, nil}
    end
  end

  def to_manifest(blueprint) do
    {:ok, Habitat.Manifest.new(blueprint)}
  end

  def get_container_blueprint(blueprint, id) do
    case Enum.find(blueprint.containers, &(&1.id == id)) do
      nil -> {:error, :container_not_found}
      container -> {:ok, container}
    end
  end

  def get_container_manifest(blueprint, container_id) do
    case get_container_blueprint(blueprint, container_id) do
      {:ok, container} -> {:ok, Habitat.Manifest.new(container)}
      otherwise -> otherwise
    end
  end

  defp normalize(blueprint) do
    blueprint
    |> Map.new()
    |> canonicalize_root()
    |> normalize_os()
    |> normalize_modules()
    |> normalize_homebrew()
    |> normalize_shell()
    |> normalize_service_manager()
    |> normalize_xdg()
  end

  defp normalize_homebrew(blueprint) do
    brew = {:brew, Mod.get_module(Habitat.PackageManager.Brew), []}

    update_in(blueprint, [:modules], &[brew | &1])
  end

  defp normalize_modules(%{modules: modules} = blueprint) do
    put_in(blueprint, [:modules], Enum.map(modules, &get_module/1))
  end

  defp normalize_modules(blueprint) do
    put_in(blueprint, [:modules], [])
  end

  defp normalize_os(blueprint) do
    blueprint
    |> Map.put_new(:os, @default_os)
    |> Map.put_new(:image, @default_image)
  end

  defp canonicalize_root(blueprint) do
    update_in(blueprint, [:root], &Path.expand/1)
  end

  defp normalize_service_manager(%{service_manager: sm} = blueprint) when not is_nil(sm) do
    update_in(blueprint, [:modules], &(&1 ++ [get_module(sm)]))
  end

  defp normalize_service_manager(blueprint), do: blueprint

  defp normalize_shell(%{shell: shell} = blueprint) do
    update_in(blueprint, [:modules], &(&1 ++ [get_module(shell)]))
  end

  defp normalize_shell(blueprint) do
    blueprint
    |> put_in([:shell], :bash)
    |> update_in([:modules], &(&1 ++ [get_module(:bash)]))
  end

  defp normalize_xdg(blueprint) do
    update_in(blueprint, [:modules], &(&1 ++ [{:xdg, Habitat.Xdg, %{}}]))
  end

  defp get_module(key) when is_atom(key) do
    {key, Mod.get_module(key), %{}}
  end

  defp get_module({key, spec}) when is_list(spec) do
    {key, Mod.get_module(key), Map.new(spec)}
  end

  defp get_module({key, spec}) do
    {key, Mod.get_module(key), spec}
  end

  defmodule DSL do
    def file(path) do
      {:file, path}
    end

    def link(path) do
      {:link, path}
    end

    def link(dest, glob) do
      for path <- Path.wildcard(glob) do
        {Path.join(dest, Path.basename(path)), {:link, path}}
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
