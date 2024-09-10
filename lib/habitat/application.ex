defmodule Habitat.Application do
  use Application

  alias Habitat.OS

  def start(_type, _args) do
    children =
      for c <- Habitat.Blueprint.containers(), container = Map.new(c) do
        %{
          id: container.id,
          start: {Habitat.Container, :start_link, [Map.put(container, :os, OS.get(container.os))]}
        }
      end

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
