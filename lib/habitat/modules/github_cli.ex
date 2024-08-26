defmodule Habitat.Modules.GithubCli do
  use Habitat.Module

  @release_url "https://github.com/cli/cli/releases/download/v{{v}}/gh_{{v}}_linux_amd64.tar.gz"
  @version "2.55.0"

  def pre_sync(container_id, opts, _) do
    install(container_id, {"gh", url()})

    if config = Keyword.get(opts, :config) do
      put_string(container_id, "~/.config/gh/config.yml", yaml(config))
    end
  end

  defp url do
    String.replace(@release_url, "{{v}}", @version)
  end
end
