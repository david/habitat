defmodule Habitat.Modules.Nodejs do
  use Habitat.Module

  def packages(version, blueprint) when is_binary(version) do
    packages(%{version: version}, blueprint)
  end

  def packages(%{version: version} = config, _) do
    [{:brew, "node@#{version}"}, put_package_manager(config)]
  end

  defp put_package_manager(%{package_manager: :yarn}), do: {:brew, "yarn"}
end
