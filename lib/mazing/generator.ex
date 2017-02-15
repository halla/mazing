defmodule Mazing.Generator do
  @moduledoc"""
  Maze generator algorithms.
  """

  alias Mazing.Graph
  alias Mazing.Digraph
  alias Mazing.Grid
  alias Mazing.Node
  alias Mazing.Node
  alias Mazing.Edge


  def binary_tree(%Graph{} = g) do
    edges = g.nodes
    |> Enum.map(fn(n) -> random_neighbor_edge(g, n) end)

    Graph.add_edges(g, edges)
  end

  def binary_tree(%Digraph{} = g) do
    edges = Digraph.vertices(g)
      |> Enum.map(fn v -> random_neighbor_edge(g, v) end)
    Enum.reduce(edges, g, fn e, acc -> Digraph.add_edge(acc, e) end)
  end


  @doc """
  Given a Graph and a Node, return a random Edge
  """
  def random_neighbor_edge(g, %Node{} = n) do
    ns = Graph.neighbors(g, n)
    n2 = if ns == [] do nil else  Enum.random(ns) end

    if n2 do Edge.new(n, n2) else nil end
  end

  def random_neighbor_edge(%Digraph{} = g, v) do
    neighbor_cells = Grid.neighbor_cells(g, v)

    v2 = if neighbor_cells == [] do nil else  Enum.random(neighbor_cells) end
    {v, v2}
  end

  def generate(size), do: generate(size, :binary_tree)

  def generate(size, :binary_tree ) do
    Graph.square_grid(size)
    |> binary_tree()
    |> Graph.render_ascii()
  end

end
