defmodule Habitat.MixProject do
  use Mix.Project

  def project do
    [
      app: :habitat,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Habitat.Application, []},
      extra_applications: [:inets, :logger, :ssl]
    ]
  end

  defp deps do
    [
      {:json, "~> 1.4"},
      {:temp, "~> 0.4"}
    ]
  end
end
