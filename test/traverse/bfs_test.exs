defmodule Mazing.Traverse.BfsTest do
  use ExUnit.Case

  alias Mazing.Digraph
  alias Mazing.Traverse.Bfs
  alias Mazing.Generator
  alias Mazing.Grid

  test "trivial case" do
    {distances, _} = Digraph.new(1)
      |> Bfs.traverse(1)

    assert distances[1] == 0
  end

  test "single edge" do
    {distances, _} = Digraph.new(2)
      |> Digraph.add_edge(1,2)
      |> Bfs.traverse(1)

    assert distances[2] == 1
  end

  test "grid is fully traversed" do
    n = 10
    {distances, _} = Grid.square_grid(n)
      |> Generator.binary_tree()
      |> Bfs.traverse(1)

    assert Enum.count(Map.keys(distances)) == n*n
  end

  test "distance to start is zero" do
    n = 10
    s = 1
    {distances, _} = Grid.square_grid(n)
      |> Generator.binary_tree()
      |> Bfs.traverse(s)
    assert distances[s] == 0
  end

  test "distance should always increment by one" do
    n = 10
    s = 1
    {distances, _} = Grid.square_grid(n)
      |> Generator.binary_tree()
      |> Bfs.traverse(s)
    distances = Map.values(distances)
      |> Enum.sort
      |> Enum.uniq

    singlesteps = Enum.into 0..(Enum.count(distances) -1), []
    assert distances == singlesteps
  end

  test "there is a prev for each node" do
    n = 10
    s = 1
    {distances, prevs} = Grid.square_grid(n)
      |> Generator.binary_tree()
      |> Bfs.traverse(s)
    assert Enum.count(Map.keys(prevs)) == n*n
  end
end
