defmodule Habitat.Application do
  use Application

  def start(_type, _args) do
    children =
      for c <- Habitat.Blueprint.containers() do
        %{id: Keyword.fetch!(c, :id), start: {Habitat.Container, :start_link, [c]}}
      end

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
