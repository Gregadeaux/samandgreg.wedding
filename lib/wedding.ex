defmodule Wedding do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = [
      supervisor(Wedding.Endpoint, []),
      worker(Wedding.Repo, [])
    ]
    opts = [strategy: :one_for_one, name: Wedding.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    Wedding.Endpoint.config_change(changed, removed)
  end
end
