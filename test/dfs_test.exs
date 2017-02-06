defmodule Mazing.DfsTest do
  use ExUnit.Case

  alias Mazing.Node
  alias Mazing.Graph
  alias Mazing.Digraph
  alias Mazing.Dfs
  require Logger

  test "testSomething" do
      g = Graph.square_grid(5)
      s = Enum.at(g.nodes, 0);
      dfs = Dfs.dfs(g, s)

    #  Logger.debug(fully_traversed?)
    #  assert () == false
  end

  test "dfs finds connected nodes in digraph" do
    g = Digraph.new(5)
      |> Digraph.add_edge(1, 2)

    s = 1
    dfs = Dfs.dfs(g, s)

    fully_traversed? = not (Enum.any? Map.values(dfs), fn x -> x == nil end)
    assert fully_traversed? == true
  end
end
