defmodule Habitat.Module do
  alias Habitat.OS

  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
    end
  end

  def install(container, package) when is_binary(package) do
    :ok = OS.get(container.os).install(container, [package])

    container
  end
end
