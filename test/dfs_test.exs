defmodule Mazing.DfsTest do
  use ExUnit.Case

  alias Mazing.Node
  alias Mazing.Graph
  alias Mazing.Digraph
  alias Mazing.Dfs
  alias Mazing.Grid
  alias Mazing.Maze
  alias Mazing.Generator

  require Logger

  test "testSomething" do
      g = Graph.square_grid(5)
      s = Enum.at(g.nodes, 0);
      dfs = Dfs.dfs(g, s)

    #  Logger.debug(fully_traversed?)
    #  assert () == false
  end

  test "dfs finds connected nodes in digraph" do
    g = Grid.square_grid(5)
      |> Generator.binary_tree()

    s = 1
    dfs = Dfs.dfs(g, s)
    fully_traversed? = not (Enum.any? Map.values(dfs), fn x -> x == nil end)
    assert fully_traversed? == true
    assert map_size(dfs) == 25

  end
end
