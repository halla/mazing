defmodule Mazing.Agent.Avatar do
  @moduledoc """
  Avatar moves only if controlled from the outside.
  """

  @name :avatar
  use GenServer

  alias Mazing.Maze

  # Client API
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
end
