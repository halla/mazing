defmodule Mazing.MazeTest do
  use ExUnit.Case

  alias Mazing.Maze
  require Logger

  test "generate_maze/2 generates something like a maze w empty trails" do
    maze = Maze.generate_maze(:maze_server, %{generator: :sidewinder, size: 5})
    assert %{graph: _graph, objects: _objects, trails: %{}} = maze
  end


end
