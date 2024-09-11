defmodule Habitat.Modules.Atuin do
  use Habitat.Module

  def pre_sync(container_id, opts, _) do
    put_package(container_id, "atuin", provider: Habitat.PackageManager.Brew)

    if config = Keyword.get(opts, :config) do
      put_file(container_id, "~/.config/atuin/config.toml", toml(config))
    end

    put_file(container_id, "~/.bashrc", interactive: "eval \"$(atuin init bash)\"")
    put_file(container_id, "~/.zshrc", interactive: "eval \"$(atuin init zsh)\"")
    put_file(container_id, "~/.config/fish/config.fish", interactive: "atuin init fish | source")
  end
end
