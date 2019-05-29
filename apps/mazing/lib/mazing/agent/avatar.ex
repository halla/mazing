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
    GenServer.call(@name, {:agent_info}, 100)
  end

  def move(direction) do
    Maze.move(:maze_server, @name, direction)
  end

  def start_link() do
    # singleton for now
    GenServer.start_link(__MODULE__, :ok, name: @name)
  end

  def init(_args) do
    Maze.enter(@name)
    {:ok, %{}}
  end

  def handle_call({:agent_info}, _from, state) do
    paths = Maze.available_paths(@name)
    {:reply, "You can go: #{inspect(paths)}", state}
  end

  def handle_call({:agent_description}, _from, _state) do
    {:reply, "You can control me.", _state}
  end

  def handle_cast({:crash}, _state) do
    {:error} = 1
  end
end
