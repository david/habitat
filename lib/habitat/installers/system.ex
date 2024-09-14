defmodule Habitat.Installers.System do
  def sync(%{os: :ubuntu} = container, package, _) do
    Habitat.PackageManager.Apt.install(container, [package])
  end

  def sync(container, _, _), do: container
end
