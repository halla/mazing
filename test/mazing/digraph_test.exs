defmodule Mazing.DigraphTest do
  use ExUnit.Case

  alias Mazing.Digraph

  test "testNew" do
    g = Digraph.new(2)
    empty = MapSet.new
    assert %{ 1 => empty, 2 => empty } == g.adj
  end

  test "add first edge" do
    g = Digraph.new(2)
      |> Digraph.add_edge(1, 2)

    adj1 = MapSet.new
      |> MapSet.put(2)
    adj2 = MapSet.new
      |> MapSet.put(1)

    assert %{ 1 => adj1, 2 => adj2 } == g.adj
  end

  test "add edge to nil returns original graph" do
    g = Digraph.new(2)
    g2 = Digraph.add_edge(g, 1, nil)
    assert g == g2
  end


  test "adjacency set is returned" do
    g = Digraph.new(2)
      |> Digraph.add_edge(1, 2)

    adj1 = MapSet.new
      |> MapSet.put(2)

    assert adj1 == Digraph.adj(g, 1)
  end

  test "number of vertices" do
    n = 634
    g = Digraph.new(n)
    assert Digraph.v(g) == 634
  end

  test "add path" do
    path = [1,2,3,4,5]
    g = Digraph.new(5)
      |> Digraph.add_path(path)
    assert Digraph.has_edge(g, 3, 4) == true
  end
end
