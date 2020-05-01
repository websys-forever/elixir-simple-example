defmodule Api.App do
  use Application
  require Logger

  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Router, options: [port: cowboy_port()]}
    ]

    Logger.info("Started ApiApp!!!")

    opts = [strategy: :one_for_one, name: Api.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp cowboy_port, do: Application.get_env(:app, :cowboy_port, 8080)
end