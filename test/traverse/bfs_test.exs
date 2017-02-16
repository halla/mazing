defmodule Mazing.Traverse.BfsTest do
  use ExUnit.Case

  alias Mazing.Digraph
  alias Mazing.Traverse.Bfs
  alias Mazing.Generator
  alias Mazing.Grid

  test "trivial case" do
    bfs = Digraph.new(1)
      |> Bfs.traverse(1)

    assert bfs[1] == 0
  end

  test "single edge" do
    bfs = Digraph.new(2)
      |> Digraph.add_edge(1,2)
      |> Bfs.traverse(1)

    assert bfs[2] == 1
  end

  test "grid is fully traversed" do
    n = 10
    bfs = Grid.square_grid(n)
      |> Generator.binary_tree()
      |> Bfs.traverse(1)

    assert Enum.count(Map.keys(bfs)) == n*n
  end

end
