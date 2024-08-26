defmodule Habitat.Modules.Bash do
  use Habitat.Module

  def pre_sync(container_id, _, _) do
    install(container_id, "bash")
    put_string(container_id, "~/.bash_profile", "source ~/.bashrc")
    put_string(container_id, "~/.bashrc", "[[ $- == *i* ]] || return")
  end
end
