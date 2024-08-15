defmodule Habitat.Container do
  alias Habitat.{PackageDB, Traits}

  require Logger

  defstruct [:home, :name, :os, :packages]

  def configure(opts) do
    container = struct(__MODULE__, opts)

    Logger.info("Configuring container #{container.name}")
    Logger.debug(container)

    PackageDB.sync(container)

    container.packages
    |> Enum.map(&spec/1)
    |> Enum.each(&Traits.Export.post_install(&1))
  end

  def list_packages(container, filter \\ :all) do
    if filter == :wanted do
      container.packages |> Enum.map(&unspec/1)
    else
      package_manager(container).list(container, filter)
    end
  end

  defp spec(name) when is_binary(name), do: {name, []}
  defp spec(spec), do: spec

  defp unspec(name) when is_binary(name), do: name
  defp unspec({name, _opts}) when is_binary(name), do: name

  def install_packages(container, packages) do
    package_manager(container).install(container, packages)
  end

  def uninstall_packages(container, packages) do
    package_manager(container).uninstall(container, packages)
  end

  def package_manager(container) do
    case container.os do
      :archlinux -> Habitat.PackageManager.Pacman
    end
  end
end
