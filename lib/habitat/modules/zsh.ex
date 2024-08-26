defmodule Habitat.Modules.Zsh do
  use Habitat.Module

  alias Habitat.Files

  require Logger

  def pre_sync(container_id, _, _) do
    install(container_id, "zsh")
    put_string(container_id, "~/.zprofile", "source ~/.zshrc")
    put_string(container_id, "~/.zshrc", "")
  end
end
