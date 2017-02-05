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

end
