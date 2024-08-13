import Config

config :habitat, :ecto_repos, [Habitat.Repo]

config :habitat, Habitat.Repo,
  database: Path.join(System.user_home(), ".local/share/habitat/habitat.db"),
  pool_size: 5

config :logger, level: :debug
