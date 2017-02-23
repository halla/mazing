defmodule Mazing.Agent.Avatar do
  @moduledoc """
  Avatar moves only if controlled from the outside.
  """

  @behaviour Mazing.Agent

  @name :avatar
  use GenServer

  alias Mazing.Maze

  # Client API
  def agent_info() do
    GenServer.call(@name, {:agent_info})
  end

  def move(direction) do
    Maze.move(:maze_server, @name, direction)
  end

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: @name) # singleton for now
  end

  def init(_args) do
    Maze.enter(@name)
    {:ok, %{}}
  end

  def handle_call({:agent_info}, _from, state) do
    paths = Maze.available_paths(@name)
    {:reply, "Heading: #{inspect paths}", state}
  end
end
