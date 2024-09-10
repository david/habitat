defmodule Habitat.Modules.GithubCli do
  use Habitat.Module

  alias Habitat.PackageManager.Brew

  def pre_sync(container_id, opts, _) do
    install(container_id, "gh", provider: Brew)

    if config = Keyword.get(opts, :config) do
      insert(container_id, "~/.config/gh/config.yml", yaml(config))
    end
  end

  defp url do
    String.replace(@release_url, "{{v}}", @version)
  end
end
