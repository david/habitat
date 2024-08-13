defmodule Habitat.Repo do
  use Ecto.Repo, otp_app: :habitat, adapter: Ecto.Adapters.SQLite3
end
