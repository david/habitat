defmodule Habitat.Modules.Zoxide do
  use Habitat.Module

  def pre_sync(container_id, _, _) do
    put_package(container_id, "zoxide", provider: Habitat.PackageManager.Brew)

    put_file(container_id, "~/.bashrc", interactive: "eval \"$(zoxide init bash)\"")
    put_file(container_id, "~/.zshrc", interactive: "eval \"$(zoxide init zsh)\"")
    put_file(container_id, "~/.config/fish/config.fish", interactive: "zoxide init fish | source")
  end
end
