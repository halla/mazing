defmodule Mazing.Graph do
  @moduledoc """
  Maze implementation as a graph, as list of nodes and edges. Not terribly efficient,
  can't remember why I thought this was a good idea and didn't use an adjacency list instead.
  """

  defstruct nodes: [], edges: []

  alias Mazing.Node
  alias Mazing.Edge
  alias Mazing.Graph
  alias Mazing.Cell

  # nodes

  def add_node( %Graph{} = g, %Node{} = node) do
    %{ g | nodes: g.nodes ++ [node]}
  end

  def add_nodes( %Graph{} = g,  nodes) do
      %{ g | nodes: g.nodes ++ nodes}
  end

  def count_nodes( %Graph{} = g) do
    length(g.nodes)
  end

  # edges

  def add_edge(%Graph{} = g, %Edge{} = edge) do
    %Graph{ g | edges: g.edges ++ [edge]}
  end

  def add_edges(%Graph{} = g, edges) do
    %Graph{ g | edges: g.edges ++ edges}
  end

  def add_edge(%Graph{} = g, %Node{} = n1, %Node{} = n2) do
    add_edge(g, Edge.new(n1, n2))
  end

  def count_edges(g) do
    length(g.edges)
  end

  def edges(g, node) do
    g.edges
    |> Enum.filter(&(MapSet.member? &1.nodes, node))
  end

  def has_edge?(g, n1, n2) do
    Enum.any? g.edges, &(&1 == Edge.new(n1,n2))
  end

  @doc """
  Generate a Graph representing a square grid of size n
  """
  def square_grid(n) do
    nodes = for y <- 1..n, x <- 1..n  do
      %Node{ x: x, y: y}
    end
    %Graph{}
     |> add_nodes(nodes)
  end

  @doc """
  Render a Graph as an Ascii maze
  """
  def render_ascii(g) do
    rows = Enum.group_by(g.nodes, &(&1.y))
    for {_j, r} <- rows do
      IO.puts render_row_walls(g, r)
      IO.puts render_row_bottoms(g, r)
    end
    g
  end


  # assuming square grid
  def size(%Graph{} = g) do
    g.nodes
    |> length
    |> :math.sqrt
    |> round
  end


  def has_neighbor(%Graph{} = g, %Node{} = node, :top) do
     has_edge?(g, node, %Node{x: node.x, y: node.y - 1})
  end

  def has_neighbor(%Graph{} = g, %Node{} = node, :bottom) do
     has_edge?(g, node, %Node{x: node.x, y: node.y + 1})
  end

  def has_neighbor(%Graph{} = g, %Node{} = node, :left) do
     has_edge?(g, node, %Node{x: node.x - 1, y: node.y})
  end

  def has_neighbor(%Graph{} = g, %Node{} = node, :right) do
     has_edge?(g, node, %Node{x: node.x + 1, y: node.y})
  end

  @doc """
  Get neighbors in the grid, whether there is a path or not...
  """
  def neighbors(%Graph{} = g, %Node{} = node) do
    right = if (node.x) < size(g) do [%Node{x: node.x+1, y: node.y}] else [] end
    bottom = if (node.y) < size(g) do [%Node{x: node.x, y: node.y+1}] else [] end
    right ++ bottom
  end



  @doc """
  Transforms a Graph to a 2-dimensional array of Cells.
  """
  def as_grid(g) do
    rows = Enum.group_by(g.nodes, &(&1.y))
    for {_j, r} <- rows do
      Enum.map(r, &(as_cell(g, &1)))
    end
  end

  def as_cell(%Graph{} = g, %Node{} = node) do
    %Cell{top: has_neighbor(g, node, :top), right: has_neighbor(g, node, :right), bottom: has_neighbor(g, node, :bottom), left: has_neighbor(g, node, :left)}
  end


  # Ascii rendering

  defp wall_for_node(g, node) do
    top = if node.y == 1 do "‾" else " " end
    left = if node.x == 1 do "|" else "" end
    right = if has_edge?(g, node, %Node{ y: node.y, x: node.x + 1}) do " " else "|" end
    "#{left}#{top}#{right}"
  end

  defp render_row_walls(g, row) do
    row
    |> Enum.map(&(wall_for_node g, &1))
    |> Enum.join("")
  end

  defp render_row_bottoms(g, row) do
    row
    |> Enum.map(fn(x) -> bottom_for_node(g, x) end)
    |> Enum.join("")
  end

  defp bottom_for_node(g, node) do
    left  = if node.x == 1 do "+" else "" end
    bottom = if has_edge?(g, node, %Node{x: node.x, y: node.y + 1}) do " " else "-" end
     "#{left}#{bottom}+"
  end

end
