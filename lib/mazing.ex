defmodule Mazing do
  use Application
  require Logger

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    Logger.debug "start() " <> to_string Mix.env
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    # Starts a worker by calling: Jarjar.Worker.start_link(arg1, arg2, arg3)
    # worker(Jarjar.Worker, [arg1, arg2, arg3]),
    children = [worker(Mazing.Maze, [])]


    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Mazing.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
