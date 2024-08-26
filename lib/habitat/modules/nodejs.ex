defmodule Habitat.Modules.Nodejs do
  def pre_sync(container, spec, _) do
    container
    |> put_yarn(spec)
  end

  defp put_yarn(container, spec) do
    if Keyword.get(spec, :package_manager) == :yarn do
      # Mise.put(container, "npm:yarn")
      container
    else
      container
    end
  end
end
