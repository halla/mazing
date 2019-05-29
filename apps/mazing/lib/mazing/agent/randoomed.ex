defmodule Mazing.Agent.Randoomed do
  @moduledoc """
  Randoomed moves randomly around.
  No memory. No goals.
  """

  use GenServer

  alias Mazing.Maze

  # Client API
  def start_link() do
    # singleton for now
    GenServer.start_link(__MODULE__, :ok, name: :randoomed)
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

  def handle_call({:agent_description}, _from, _state) do
    {:reply, "I move in random direction.", _state}
  end

  def handle_call({:agent_info}, _from, state) do
    {:reply, "No info...", state}
  end

  def handle_cast({:crash}, _from, _state) do
    {:error} = 1
  end
end
