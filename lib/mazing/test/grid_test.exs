defmodule Mazing.GridTest do
  use ExUnit.Case

  alias Mazing.Grid
  import Mazing.Grid
  alias Mazing.Digraph

  require Logger
  def debug(x) do
    IO.puts(inspect x)
  end

  test "1x1 grid node has no neighbors" do
    g = square_grid(1)
    assert Digraph.adj(g, List.last(Digraph.vertices(g))) == MapSet.new
  end

  test "v2 is right from v1 on 2x2 grid" do
    g = square_grid(2)
    assert neighbor(g, 1, :right) == 2
  end


  test "v1 has right on 2x2 grid" do
    g = square_grid(2)
    assert has_right(g, 1) == true
  end

  test "v2 has top on 2x2 grid" do
    g = square_grid(2)
    assert has_top(g, 2) == true
  end

  test "v2 doesn't have right on 2x2 grid" do
    g = square_grid(2)
    assert has_right(g, 2) == false
  end

  test "v4 doesn't have right on 2x2 grid" do
    g = square_grid(2)
    assert has_right(g, 4) == false
  end

  test "v4 doesn't have top on 2x2 grid" do
    g = square_grid(2)
    assert has_top(g, 4) == false
  end


  test "x of v2 is 1 on 2x2 grid" do
    g = square_grid(2)
    assert x(g, 2) == 1
  end

  test "x of v3 is 0 on 2x2 grid" do
    g = square_grid(2)
    assert x(g, 3) == 0
  end


  test "y of v1 is 0 on 2x2 grid" do
    g = square_grid(2)
    assert y(g, 1) == 0
  end

  test "y of v4 is 1 on 2x2 grid" do
    g = square_grid(2)
    assert y(g, 4) == 1
  end

  test "nil is right from v2 on 2x2 grid" do
    g = square_grid(2)
    assert neighbor(g, 2, :right) == nil
  end

  test "2x2 grid last node has two neighbors" do # bidirectional
    g = square_grid(2)
      |> build_edges()
    assert MapSet.size(Digraph.adj(g, List.last(Digraph.vertices(g)))) == 2
  end

  test "2x2 grid first node has two neighbors" do
    g = square_grid(2)
      |> build_edges()
    assert MapSet.size(Digraph.adj(g, Enum.at(Digraph.vertices(g), 0))) == 2
  end

  test "5x5 grid 11 is top of 6" do
    g = square_grid(5)
    assert top(g, 6) == 11
  end

  test "available_paths" do
    g = square_grid(5)
      |> Digraph.add_edge(1, 2)

    available_paths(g, 1)
  end

  test "random" do
    g = square_grid(5)
      |> Digraph.add_edge(1, 2)

    Grid.random_v(g)
  end
end
