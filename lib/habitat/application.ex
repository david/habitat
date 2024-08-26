defmodule Habitat.Application do
  use Application

  def start(_type, _args) do
    children =
      for bp <- Habitat.Blueprint.containers() do
        %{id: bp.id, start: {Habitat.Container, :start_link, [bp]}}
      end

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
