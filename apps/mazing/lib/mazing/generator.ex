defmodule Mazing.Generator do
  @moduledoc """
  Maze generator algorithms.
  """

  alias Mazing.Graph
  alias Mazing.Digraph
  alias Mazing.Grid
  alias Mazing.Node
  alias Mazing.Node
  alias Mazing.Edge

  def list_generators() do
    [%{title: "Binary tree", code: :binary_tree}, %{title: "Sidewinder", code: :sidewinder}]
  end

  def binary_tree(%Graph{} = g) do
    edges =
      g.nodes
      |> Enum.map(fn n -> random_neighbor_edge(g, n) end)

    Graph.add_edges(g, edges)
  end

  @doc """
  Generate a maza using the binary tree algorithm.
  Go through every node, randomly create an opening to right or up.
  """
  def binary_tree(%Digraph{} = g) do
    edges =
      Digraph.vertices(g)
      |> Enum.map(fn v -> random_neighbor_edge(g, v) end)

    Enum.reduce(edges, g, fn e, acc -> Digraph.add_edge(acc, e) end)
  end

  @doc """
  Sidewinder algorithm.
  """
  def sidewinder(%Digraph{} = g) do
    rows =
      Digraph.vertices(g)
      |> Enum.chunk(Grid.width(g))

    g =
      Enum.reduce(rows, g, fn row, acc ->
        sidewinder_edges(acc, row)
      end)

    # special case for sidewinder corridor
    Digraph.add_path(g, List.last(rows))
  end

  def sidewinder_edges(g, row) do
    runs =
      Enum.map(row, fn v -> {v, Enum.random([0, 1])} end)
      |> Enum.chunk_by(fn {v, x} -> x == 1 end)

    # x-paths
    g =
      Enum.reduce(runs, g, fn run, acc ->
        run_vertices = Enum.map(run, fn {v, _} -> v end)
        Digraph.add_path(acc, run_vertices)
      end)

    # y-paths
    g =
      Enum.reduce(runs, g, fn run, acc ->
        {v, _} = Enum.random(run)
        Digraph.add_edge(acc, v, Grid.top(g, v))
      end)

    g
  end

  @doc """
  Given a Graph and a Node, return a random Edge
  """
  def random_neighbor_edge(%Graph{} = g, %Node{} = n) do
    ns = Graph.neighbors(g, n)

    n2 =
      if ns == [] do
        nil
      else
        Enum.random(ns)
      end

    if n2 do
      Edge.new(n, n2)
    else
      nil
    end
  end

  def random_neighbor_edge(%Digraph{} = g, v) do
    neighbor_cells = Grid.neighbor_cells(g, v)

    v2 =
      if neighbor_cells == [] do
        nil
      else
        Enum.random(neighbor_cells)
      end

    {v, v2}
  end

  def generate(size), do: generate(size, :binary_tree)

  def generate(size, :binary_tree) do
    Graph.square_grid(size)
    |> binary_tree()
    |> Graph.render_ascii()
  end
end
