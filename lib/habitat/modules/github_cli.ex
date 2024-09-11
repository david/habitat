defmodule Habitat.Modules.GithubCli do
  use Habitat.Module

  def pre_sync(container_id, opts, _) do
    put_package(container_id, "gh", provider: Habitat.PackageManager.Brew)

    if config = Keyword.get(opts, :config) do
      insert(container_id, "~/.config/gh/config.yml", yaml(config))
    end
  end
end
