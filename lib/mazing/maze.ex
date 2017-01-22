defmodule Mazing.Maze do
  @moduledoc"""
  GenServer serving mazes on demand.
  """

  use GenServer
  alias Mazing.Graph
  alias Mazing.Node
  alias Mazing.Edge

  # Client API
  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: :maze_server)
  end

  @doc"""
  Generate a square maze of size n.
  """
  def generate_maze(server, n) do
    GenServer.call(server, {:generate_maze, n})
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

  # Other

  def binary_tree(%Graph{} = g) do
    edges = g.nodes
    |> Enum.map(fn(n) -> random_neighbor_edge(g, n) end)

    Graph.add_edges(g, edges)
  end

  @doc """
  Given a Graph and a Node, return a random Edge
  """
  def random_neighbor_edge(g, %Node{} = n) do
    ns = Graph.neighbors(g, n)
    n2 = if ns == [] do nil else  Enum.random(ns) end

    if n2 do Edge.new(n, n2) else nil end
  end

  def generate(size), do: generate(size, :binary_tree)

  def generate(size, :binary_tree ) do
    Graph.square_grid(size)
    |> binary_tree()
    |> Graph.render_ascii()
  end
end
