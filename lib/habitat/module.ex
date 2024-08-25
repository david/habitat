defmodule Habitat.Module do
  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
    end
  end

  def install(container, package) when is_binary(package) do
    :ok = container.os.install(container, [package])

    container
  end
end
