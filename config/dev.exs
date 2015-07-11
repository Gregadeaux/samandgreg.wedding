use Mix.Config

config :wedding, Wedding.Endpoint,
  http: [port: 4000],
  debug_errors: false,
  code_reloader: true,
  cache_static_lookup: false,
  watchers: []

config :wedding, Wedding.Repo,
  adapter: Ecto.Adapters.Postgres,
  extensions: [{Extensions.JSON, library: Poison}],
  database: "wedding_dev"
