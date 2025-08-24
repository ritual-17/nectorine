import Config

config :nectorine, Nectorine.Repo,
  database: ":memory:",
  pool_size: 1,
  pool: Ecto.Adapters.SQL.Sandbox

# config :nectorine, ecto_repos: [Nectorine.Repo]
