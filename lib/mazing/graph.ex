defmodule Mazing.Graph do
  defstruct nodes: [], edges: []
  alias Mazing.Node
  alias Mazing.Edge
  alias Mazing.Graph

  def add_node( %Graph{} = g, %Node{} = node) do
    %{ g | nodes: g.nodes ++ [node]}
  end

  def add_nodes( %Graph{} = g,  nodes) do
      %{ g | nodes: g.nodes ++ nodes}
  end

  def count_nodes( %Graph{} = g) do
    length(g.nodes)
  end

  def add_edge(%Graph{} = g, %Edge{} = edge) do
    %Graph{ g | edges: g.edges ++ [edge]}
  end

  def add_edge(%Graph{} = g, %Node{} = n1, %Node{} = n2) do
    add_edge(g, Edge.new(n1, n2))
  end

  def count_edges(g) do
    length(g.edges)
  end

  def square_grid(n) do
    nodes = for x <- 1..n, y <- 1..n do
      %Node{ x: x, y: y}
    end
    %Graph{}
     |> add_nodes(nodes)
  end

  def edges(g, node) do
    g.edges
      |> Enum.filter(&(MapSet.member? &1.nodes, node))
  end

  def render_ascii(g) do

  end
end
