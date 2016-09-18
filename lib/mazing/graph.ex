defmodule Mazing.Graph do
  defstruct nodes: [], edges: []
  alias Mazing.Node
  alias Mazing.Graph

  def add_node( %Graph{} = g, %Node{} = node) do
    %{ g | nodes: g.nodes ++ [node]}
  end

  def count_nodes( %Graph{} = g) do
    length(g.nodes)
  end
end
