defmodule Mazing.Agent.Randoomed do
  @moduledoc"""
  Randoomed moves randomly around.
  No memory. No goals.
  """

  use GenServer

  alias Mazing.Maze

  # Client API
  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: :randoomed) # singleton for now
  end


  def init(_args) do
    :timer.send_interval(1_000, :tick)
    Maze.enter(:randoomed)
    {:ok, %{}}
  end


  def handle_info(:tick, state) do
    paths = Maze.available_paths(:randoomed)
    Maze.move(:maze_server, :randoomed, Enum.random(paths))
    {:noreply, state}
  end

end
