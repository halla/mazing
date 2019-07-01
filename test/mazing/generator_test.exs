defmodule Mazing.GeneratorTest do
  use ExUnit.Case

  alias Mazing.Graph
  alias Mazing.Grid
  alias Mazing.Generator

  def debug(x) do
    IO.puts (inspect x)
    x
  end

  test "random neighbor edge is neighbor" do
    g = Graph.square_grid(5)
    e = Generator.random_neighbor_edge(g, Enum.at(g.nodes, 0))
    assert Enum.count(e.nodes) == 2

  end

  test "binary algorith works somehow" do
    g = Graph.square_grid(5)
      |> Generator.binary_tree()
    assert Enum.count(g.edges) == 25
#    IO.puts (inspect g2.edges)
  end

  test "random neighbor edge is neighbor in digraph/grid" do
    g = Grid.square_grid(5)
    v1 = 1
    {v1, v2} = Generator.random_neighbor_edge(g, v1)
    assert (v2 == Grid.neighbor(g, v1, :east) || v2 == Grid.neighbor(g, v1, :north))
  end

  test "binary algorith works somehow in digraph/grid" do
    g = Grid.square_grid(5)
      |> Generator.binary_tree()
    assert Enum.count(g.adj) == 25
  end

  test "sidewinder edges works somehow" do
    g = Grid.square_grid(5)
    vertices = [1,2,3,4,5]
    edges = Generator.sidewinder_edges(g, vertices)
    assert Enum.count(edges.adj) == 25
  end

  test "sidewinder works somehow" do
    g = Grid.square_grid(5)
      |> Generator.sidewinder()

    assert Enum.count(g.adj) == 25
  end
end
