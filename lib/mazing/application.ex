defmodule Mazing.Application do
  use Application
  require Logger

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    Logger.debug("start() " <> to_string(Mix.env()))
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    # Starts a worker by calling: Jarjar.Worker.start_link(arg1, arg2, arg3)
    # worker(Jarjar.Worker, [arg1, arg2, arg3]),
    children = [
      supervisor(MazingUi.Endpoint, []),
      worker(Mazing.Maze, []),
      # Start your own worker by calling: MazingUi.Worker.start_link(arg1, arg2, arg3)
      # worker(MazingUi.Worker, [arg1, arg2, arg3]),
      # worker(Mazing.Maze, [])
      worker(Mazing.Agent.Randoomed, []),
      worker(Mazing.Agent.Straightguy, []),
      worker(Mazing.Agent.Avatar, []),
      worker(Mazing.Agent.GeneratorTrap, []),
      worker(Mazing.Agent.CautiousWanderer, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Mazing.Supervisor, max_restarts: 20, max_seconds: 1]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MazingUi.Endpoint.config_change(changed, removed)
    :ok
  end
end
