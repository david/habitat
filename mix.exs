defmodule Habitat.MixProject do
  use Mix.Project

  def project do
    [
      app: :habitat,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      default_task: "habitat"
    ]
  end

  def application do
    [
      mod: {Habitat.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ecto_sqlite3, "~> 0.16"}
    ]
  end
end
