defmodule Habitat.Container do
  alias Habitat.{Package, PackageDB, Snapshots}
  alias Habitat.Traits

  defstruct [:package_manager, :spec]

  defmodule Spec do
    defstruct [:packages, :specs]

    def new(packages) do
      %__MODULE__{
        packages: packages |> Enum.map(&to_name/1),
        specs: packages |> Enum.map(&to_spec/1)
      }
    end

    defp to_name(name) when is_binary(name), do: name
    defp to_name({name, _opts}), do: to_string(name)

    defp to_spec(name) when is_binary(name), do: {name, []}
    defp to_spec(spec), do: spec
  end

  def new(opts) do
    case Keyword.get(opts, :os) do
      :archlinux ->
        %__MODULE__{
          package_manager: Habitat.PackageManager.Pacman,
          spec: Habitat.Container.Spec.new(Keyword.get(opts, :packages))
        }
    end
  end

  def sync_packages(container) do
    IO.puts("-- Syncing packages")

    PackageDB.ensure_prepared(container)
    PackageDB.sync(container)
  end

  def configure(container) do
    IO.inspect(container)

    for s <- container.spec.specs do
      Traits.Export.post_install(s)
    end
  end

  def list_packages(container, filter \\ :all) do
    container.package_manager.list(filter)
  end

  defp name_to_package(name) when is_binary(name), do: %Package{name: name}
  defp name_to_package({name, _opts}), do: %Package{name: Atom.to_string(name)}
end
