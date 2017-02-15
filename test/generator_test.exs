defmodule Mazing.GeneratorTest do
  use ExUnit.Case

  alias Mazing.Graph
  alias Mazing.Maze
  alias Mazing.Grid
  alias Mazing.Generator

  def debug(x) do
    IO.puts (inspect x)
    x
  end

  test "random neighbor edge is neighbor" do
    g = Graph.square_grid(5)
    Generator.random_neighbor_edge(g, Enum.at(g.nodes, 0))
  end

  test "binary algorith works somehow" do
    g = Graph.square_grid(5)
    g2 = Generator.binary_tree(g)
#    IO.puts (inspect g2.edges)
  end

  test "random neighbor edge is neighbor in digraph/grid" do
    g = Grid.square_grid(5)
    v1 = 1
    {v1, v2} = Generator.random_neighbor_edge(g, v1)
    assert (v2 == Grid.right(g, v1) || v2 == Grid.top(g, v1))
  end

  test "binary algorith works somehow in digraph/grid" do
    g = Grid.square_grid(5)
      |> Generator.binary_tree()

  end

  test "sidewinder edges works somehow" do
    g = Grid.square_grid(5)
    vertices = [1,2,3,4,5]
    edges = Generator.sidewinder_edges(g, vertices)
    #IO.puts(inspect edges)
  end

  test "sidewinder works somehow" do
    g = Grid.square_grid(5)
      |> Generator.sidewinder()
  end
end
