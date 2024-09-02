defmodule Habitat.Modules.Atuin do
  use Habitat.Module

  def pre_sync(container_id, opts, _) do
    install(container_id, "atuin")

    if config = Keyword.get(opts, :config) do
      put_string(container_id, "~/.config/atuin/config.toml", toml(config))
    end

    append(container_id, "~/.bashrc", "eval \"$(atuin init bash)\"")
    append(container_id, "~/.zshrc", "eval \"$(atuin init zsh)\"")

    append(
      container_id,
      "~/.config/fish/config.fish",
      "if status is-interactive; atuin init fish | source; end"
    )
  end
end
