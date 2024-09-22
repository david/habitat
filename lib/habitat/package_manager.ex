defmodule Habitat.PackageManager do
  def get(:apt), do: Habitat.PackageManager.Apt
  def get(:brew), do: Habitat.PackageManager.Brew
end
