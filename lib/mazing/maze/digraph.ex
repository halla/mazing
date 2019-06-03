defmodule Mazing.Digraph do
  @moduledoc """
  Graph API

  Maze can be modeled as a graph. This is a adjacency set implementation.

  """

  alias Mazing.Digraph

  @doc """
  adj is a map of vertices to adjancency sets .
  %{ 1 => MapSet, 2 => MapSet ... }
  """
  defstruct adj: nil

  @doc """
  Create new Digraph of n vertices
  """
  def new(n) do
    vs = Enum.into 1..n, []
    #adj = for x <- 1..n, do: { x, MapSet.new }
    adj = Enum.reduce vs, %{}, fn(v, acc) ->
      Map.put(acc, v, MapSet.new)
    end
    %Digraph{ adj: adj }
  end

  # to simplify grid building
  def add_edge(g, _v, nil), do: g

  @doc """
  Add an (undirected) edge to graph
  """
  def add_edge(g, v, w) do
    adj_v = MapSet.put(g.adj[v], w)
    adj_w = MapSet.put(g.adj[w], v)
    g
     |> put_in([Access.key(:adj), v], adj_v)
     |> put_in([Access.key(:adj), w], adj_w)
  end

  @doc """
  Convinience method to allow tuples as edge definitions
  """
  def add_edge(g, {v, w}) do
    add_edge(g, v, w)
  end

  def add_edges(g, edges) do
    Enum.reduce(edges, g, fn([v,w], acc) ->
      add_edge(acc, v, w)
    end)
  end

  @doc """
  Get the adjacency set of a vertex
  """
  def adj(g, v) do
    g.adj[v]
  end

  @doc """
  Number of vertices
  """
  def v(g) do
    Enum.count g.adj
  end

  def vertices(g) do
    Enum.sort Map.keys(g.adj)
  end

  @doc """
  Number of edges
  """
  def e(g) do

  end

  def has_edge(_g, _v1, nil), do: false
  def has_edge(g, v1, v2) do
    MapSet.member?(adj(g, v1), v2)
  end


  def add_path(g, nil), do: g
  def add_path(g, path) do
    edges = Enum.chunk_every(path, 2, 1, :discard)
    add_edges(g, edges)
  end
end
