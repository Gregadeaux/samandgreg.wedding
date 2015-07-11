use Mix.Config

config :wedding, Wedding.Endpoint,
  http: [port: {:system, "PORT"}, compress: true],
  url: [host: "www.samandgreg.wedding"]

config :logger, level: :info

import_config "prod.secret.exs"
