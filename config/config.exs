use Mix.Config

config :wedding, Wedding.Endpoint,
  url: [host: "localhost"],
  root: Path.expand("..", __DIR__),
  debug_errors: false,
  pubsub: [name: Wedding.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :joken,
  secret_key: "Kx4f-PUUUE7FAO9NGbv-F3DVRlcvk4grGE2jRvr2SPDDQ7RrVnpsJpjhaZUxLtk-PDY",
  json_module: Wedding.JSON

import_config "#{Mix.env}.exs"
