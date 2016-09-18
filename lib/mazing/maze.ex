defmodule Mazing.Maze do

  alias Mazing.Graph
  alias Mazing.Node
  alias Mazing.Edge

  def binary_tree(%Graph{} = g) do
    IO.puts (inspect(g.nodes))
    edges = g.nodes
      |> Enum.map(fn(n) -> random_neighbor_edge(g, n) end)

    Graph.add_edges(g, edges)
  end

  def random_neighbor_edge(g, %Node{} = n) do
    ns = Graph.neighbors(g, n)
    n2 = if ns == [] do nil else  Enum.random(ns) end

    if n2 do Edge.new(n, n2) else nil end
  end
end
