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
    nodes = for y <- 1..n, x <- 1..n  do
      %Node{ x: x, y: y}
    end
    %Graph{}
     |> add_nodes(nodes)
  end

  def edges(g, node) do
    g.edges
      |> Enum.filter(&(MapSet.member? &1.nodes, node))
  end

  def has_edge?(g, n1, n2) do
      Enum.any? g.edges, &(&1 == Edge.new(n1,n2))
  end

  def render_ascii(g) do
    #rows = as_rows(g)
    rows = Enum.group_by(g.nodes, &(&1.y))
    for {_j, r} <- rows do
      IO.puts render_row_walls(g, r)
      IO.puts render_row_bottoms(g, r)
    end
  end

  def wall_for_node(g, node) do
    top = if node.y == 1 do "‾" else " " end
    left = if node.x == 1 do "|" else "" end
    right = if has_edge?(g, node, %Node{ y: node.y, x: node.x + 1}) do "¯" else "|" end
    "#{left}#{top}#{right}"
  end

  def render_row_walls(g, row) do
    row
    |> Enum.map(&(wall_for_node g, &1))
    |> Enum.join("")
  end

  def bottom_for_node(g, node) do
    left  = if node.x == 1 do "+" else "" end
    bottom = if has_edge?(g, node, %Node{x: node.x, y: node.y + 1}) do " " else "-" end
     "#{left}#{bottom}+"
  end

  def render_row_bottoms(g, row) do
    row
    |> Enum.map(fn(x) -> bottom_for_node(g, x) end)
    |> Enum.join("")
  end

  def as_rows(g) do
    for n <- g.nodes do
      { n.y, n}
    end
  end
end
