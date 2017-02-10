defmodule Mazing.Grid do
  @moduledoc """
  Grid wraps a graph implementation to facilitate working with, well, grids.

  Assuming squa<e atm.
  -------------
  | 7 | 8 | 9 |
  -------------
  | 4 | 5 | 6 |
  |------------
  | 1 | 2 | 3 |
  -------------
    0   1   2  x
  """

  alias Mazing.Digraph
  import Digraph

  @doc """
  Construct a square grid-shaped graph
  """
  def square_grid(n) do
    g = Digraph.new(:math.pow(n,2) |> round)
      #|> build_edges()
  end

  def build_edges(g) do
    vertices(g)
     |> Enum.reduce(g, fn(v, acc) -> build_edges(acc, v) end)
  end

  def build_edges(g, v) do
    g
     |> add_edge(v, right(g, v))
     |> add_edge(v, top(g, v))
  end

  @doc """
  Assumes square grid
  """
  def width(g) do
    vertices(g)
      |> length
      |> :math.sqrt
      |> round
  end

  def height(g) do
    width(g)
  end

  @doc """
  graph starts from 1
  x/y starts from 0
  """
  def x(g, v) do
    rem(v - 1, width(g))
  end

  def y(g, v) do
    div(v - 1, height(g))
  end

  def has_right(g, v) do
    x(g, v) < width(g) - 1
  end

  def has_top(g, v) do
    y(g, v) < height(g) - 1
  end

  def has_left(g, v) do
    x(g, v) > 0
  end

  def has_bottom(g, v) do
    y(g, v) > 0
  end


  def right(g, v) do
    if has_right(g,v)
    do
      v + 1
    else
      nil
    end
  end

  def top(g, v) do
    if has_top(g, v)
    do
      v + width(g)
    else
      nil
    end
  end

  def left(g, v) do
    if has_left(g,v)
    do
      v - 1
    else
      nil
    end
  end

  def bottom(g, v) do
    if has_bottom(g, v)
    do
      v - width(g)
    else
      nil
    end
  end

  def has_right_path(g, v) do
    Digraph.has_edge(g, v, right(g, v))
  end

  def has_top_path(g, v) do
    Digraph.has_edge(g, v, top(g, v))
  end

  def has_left_path(g, v) do
    Digraph.has_edge(g, v, left(g, v))
  end

  def has_bottom_path(g, v) do
    Digraph.has_edge(g, v, bottom(g, v))
  end

  @doc """
  neighbor cells, whethere there is path or not.
  """
  def neighbor_cells(g, v) do
    [top(g, v), right(g, v)]
      |> Enum.reject(fn x -> x == nil end)
  end

  def rows(g) do
    Enum.chunk Digraph.vertices(g), width(g)
  end
end
