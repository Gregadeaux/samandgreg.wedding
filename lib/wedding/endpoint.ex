defmodule Wedding.Endpoint do
  use Phoenix.Endpoint, otp_app: :wedding
  import Phoenix.Controller, only: [accepts: 2]

  plug Plug.Logger

  if Mix.env == :dev || Mix.env == :test do
    plug Corsica,
      origins: ["*"],
      allow_methods: ["HEAD", "GET", "POST", "PUT", "PATCH", "DELETE"],
      allow_headers: ["Authorization", "Content-Type", "Accept", "Origin"]
  end

  if Mix.env == :prod do
    plug Plug.SSL
    plug Corsica,
      origins: ["www.samandgreg.wedding"],
      allow_methods: ["HEAD", "GET", "POST", "PUT", "PATCH", "DELETE"],
      allow_headers: ["Authorization", "Content-Type", "Accept", "Origin"]
  end

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head


  plug :accepts, ~w(json)
  plug :router, Wedding.Router
end
