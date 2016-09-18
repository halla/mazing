defmodule Mazing.MazeTest do
  use ExUnit.Case

  alias Mazing.Graph
  alias Mazing.Maze

  test "random neighbor edge is neighbor" do
    g = Graph.square_grid(5)
    Maze.random_neighbor_edge(g, Enum.at(g.nodes, 0))
  end
  
  test "binary algorith works somehow" do
    g = Graph.square_grid(5)
    g2 = Maze.binary_tree(g)
    IO.puts (inspect g2.edges)
  end
end
