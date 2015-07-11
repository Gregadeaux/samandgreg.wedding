use Mix.Config

config :wedding, Wedding.Endpoint,
  http: [port: 4001],
  server: false

config :logger, level: :warn

config :wedding, Wedding.Repo,
  adapter: Ecto.Adapters.Postgres,
  extensions: [{Extensions.JSON, library: Poison}],
  database: "wedding_test",
  size: 1,
  max_overflow: false
