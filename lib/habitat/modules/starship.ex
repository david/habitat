defmodule Habitat.Modules.Starship do
  use Habitat.Module

  def pre_sync(container_id, opts, _) do
    put_package(container_id, "starship", provider: Habitat.PackageManager.Brew)

    if config = Keyword.get(opts, :config) do
      put_file(container_id, "~/.config/starship.toml", toml(config))
    end

    put_file(container_id, "~/.bashrc", interactive: "eval \"$(starship init bash)\"")
    put_file(container_id, "~/.zshrc", interactive: "eval \"$(starship init zsh)\"")
    put_file(container_id, "~/.config/fish/config.fish", interactive: "starship init fish | source")
  end
end
