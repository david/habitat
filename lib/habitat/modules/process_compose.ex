defmodule Habitat.Modules.ProcessCompose do
  use Habitat.Module

  def packages(_, _) do
    ["f1bonacc1/tap/process-compose"]
  end
end
