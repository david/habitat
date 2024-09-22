defmodule Habitat.Modules.ProcessCompose do
  use Habitat.Module

  def sync(manifest, _, _) do
    manifest
    |> add_package("f1bonacc1/tap/process-compose")
  end
end
