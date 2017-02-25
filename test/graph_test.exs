defmodule Mazing.GraphTest do
  use ExUnit.Case

  alias Mazing.Graph
  import Mazing.Graph
  import Mazing.Node
  alias Mazing.Node
  alias Mazing.Edge

  require Logger

  test "adding nodes adds nodes" do
    nodes = for x <- 1..5, y <- 1..5 do
      %Node{x: x, y: y}
    end
    
    g = %Graph{}

    assert count_nodes(g) == 0

    g2 = add_node(g, %Node{x: 1, y: 2})
    assert count_nodes(g2) == 1


    g3 = add_nodes(g, nodes)
    assert count_nodes(g3) == length(nodes)
  end

  test "adding edges adds edges" do
    nodes = for x <- 1..5, y <- 1..5 do
      %Node{x: x, y: y}
    end
    edge = %Edge{nodes: (Enum.into [Enum.at(nodes, 0), Enum.at(nodes,1)], MapSet.new) }
    g = %Graph{}
    assert count_edges(g) == 0
    g2 = add_edge(g, edge)
    assert count_edges(g2) == 1
  end

  test "finds edges for a node" do
    g = square_grid(5)
    {n1, n2} = { Enum.at(g.nodes, 0), Enum.at(g.nodes, 1)}
    g2 = add_edge(g, n1, n2)
    es = edges(g2, n1)

    assert length(es) == 1
    assert has_edge?(g2, n1, n2) == true
  end

  test "1x1 grid node has no neighbors" do
    g = square_grid(1)
    assert neighbors(g, List.last(g.nodes)) == []
  end

  test "2x2 grid last node has no neighbors" do
    g = square_grid(2)
    assert length(neighbors(g, List.last(g.nodes))) == 0
  end

  test "2x2 grid first node has tw neighbors" do
    g = square_grid(2)
    assert length(neighbors(g, Enum.at(g.nodes, 0))) == 2
  end

  test "as grid returns list of lists" do
    g = square_grid(2)
    g = as_grid(g)
    assert Enum.count(g) == 2
  end
end
