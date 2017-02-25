defmodule Mazing.DfsTest do
  use ExUnit.Case

  alias Mazing.Graph
  alias Mazing.Dfs
  alias Mazing.Grid
  alias Mazing.Generator

  require Logger

  test "testSomething" do
      g = Graph.square_grid(5)
        |> Generator.binary_tree()
      s = Enum.at(g.nodes, 0);
      dfs = Dfs.dfs(g, s)
      assert dfs == %{} # why?
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
