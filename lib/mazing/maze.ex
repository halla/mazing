defmodule Mazing.Maze do
  @moduledoc"""
  GenServer serving mazes on demand.
  """

  use GenServer
  alias Mazing.Graph
  alias Mazing.Digraph
  alias Mazing.Grid
  alias Mazing.Node
  alias Mazing.Edge

  def debug(x) do
    IO.puts (inspect x)
    x
  end

  # Client API
  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: :maze_server)
  end

  @doc"""
  Generate a square maze of size n.
  """
  def generate_maze(server, n) do
    GenServer.call(server, {:generate_maze_2, n})
  end

  # Server Implementation

  # Callbacks

  def init(:ok) do
    {:ok,%{}}
  end

  def handle_call({:generate_maze, n}, _from, state) do
    maze = Graph.square_grid(n)
      |> binary_tree()
      |> Graph.as_grid()
    {:reply, maze, state}
  end

  def handle_call({:generate_maze_2, n}, _from, state) do
    maze = Grid.square_grid(n)
      |> binary_tree()      
    {:reply, maze, state}
  end

  # Other

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
