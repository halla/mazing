defmodule Mazing.Grid do
  @moduledoc """
  Grid wraps a graph implementation to facilitate working with, well, grids.

  Assuming square atm.
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
  Construct a square grid-shaped graph -- no edges
  """
  def square_grid(n) do
    g = Digraph.new(:math.pow(n, 2) |> round)
    # |> build_edges()
  end

  @deprecated "to be removed"
  def build_edges(g) do
    vertices(g)
    |> Enum.reduce(g, fn v, acc -> build_edges(acc, v) end)
  end

  @deprecated "to be removed"
  def build_edges(g, v) do
    g
    |> add_edge(v, neighbor(g, v, :right))
    |> add_edge(v, neighbor(g, v, :top))
  end

  @doc """
  Assumes square grid
  """
  def width(g) do
    vertices(g)
    |> length
    |> :math.sqrt()
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

  def has_neighbor(g, v, :left), do: x(g, v) > 0
  def has_neighbor(g, v, :right), do: x(g, v) < width(g) - 1
  def has_neighbor(g, v, :top), do:   y(g, v) < height(g) - 1
  def has_neighbor(g, v, :bottom), do: y(g, v) > 0

  def neighbor(g, v, :right) do
    if has_neighbor(g, v, :right) do
      v+1
    else
      nil
    end
  end

  def neighbor(g, v, :top) do
    if has_neighbor(g, v, :top) do
      v + width(g)
    else
      nil
    end
  end

  def neighbor(g, v, :left) do
    if has_neighbor(g, v, :left) do
      v - 1
    else
      nil
    end
  end

  def neighbor(g, v, :bottom) do
    if has_neighbor(g, v, :bottom) do
      v - width(g)
    else
      nil
    end
  end

#  def has_path(g, v, direction) do
#    Digraph.has_edge(g, v, adjacent(g, v, direction))
#  end

  def has_path(g, v, direction), do: Digraph.has_edge(g, v, neighbor(g, v, direction))

  def available_paths(g, v) do
    all = [:down, :up, :left, :right] # TODO top vs up mismatch
    #paths = all |> Enum.map(fn x -> has_path(g, v, x) end)
    paths = [
      has_path(g, v, :bottom),
      has_path(g, v, :top),
      has_path(g, v, :left),
      has_path(g, v, :right)
    ]

    Enum.zip(all, paths)
    |> Enum.filter(fn {_x, t} -> t end)
    |> Enum.map(fn {x, _t} -> x end)
  end

  def line(g, v, direction) do
    if has_path(g, v, direction) do
      adj = neighbor(g, v, direction)
      [ adj | line(g, adj, direction)]
    else
      []
    end
  end

  def lines_of_sight(g, v) do
    down = line(g, v, :bottom)
    left = line(g, v, :left)
    right = line(g, v, :right)
    up = line(g, v, :top)
    %{ up: up, down: down, left: left, right: right}
  end

  @doc """
  neighbor cells, whethere there is path or not.
  """
  def neighbor_cells(g, v) do
    [neighbor(g, v, :top), neighbor(g, v, :right)]
    |> Enum.reject(fn x -> x == nil end)
  end

  def rows(g) do
    Enum.chunk_every(Digraph.vertices(g), width(g))
  end

  def random_v(g) do
    Enum.random(Digraph.vertices(g))
  end
end
