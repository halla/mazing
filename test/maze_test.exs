defmodule Mazing.MazeTest do
  use ExUnit.Case

  alias Mazing.Graph
  alias Mazing.Maze
  alias Mazing.Grid

  def debug(x) do
    IO.puts (inspect x)
    x
  end

  test "random neighbor edge is neighbor" do
    g = Graph.square_grid(5)
    Maze.random_neighbor_edge(g, Enum.at(g.nodes, 0))
  end

  test "binary algorith works somehow" do
    g = Graph.square_grid(5)
    g2 = Maze.binary_tree(g)
#    IO.puts (inspect g2.edges)
  end

  test "random neighbor edge is neighbor in digraph/grid" do
    g = Grid.square_grid(5)
    v1 = 1
    {v1, v2} = Maze.random_neighbor_edge(g, v1)
    assert (v2 == Grid.right(g, v1) || v2 == Grid.top(g, v1))
  end

  test "binary algorith works somehow in digraph/grid" do
    g = Grid.square_grid(5)
      |> Maze.binary_tree()

  end


end
