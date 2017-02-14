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
  alias Mazing.Maze

  defstruct graph: nil, objects: %{}

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

  @doc"""
  Get current state.
  """
  def get_maze(server) do
    GenServer.call(server, {:get_maze})
  end

  @doc"""
  Move and object TBD
  """
  def move(server, object, direction) do
    GenServer.call(server, {:move, object, direction})
  end

  def available_paths(object) do
    GenServer.call(:maze_server, {:available_paths, object})
  end

  def enter(object) do
    GenServer.call(:maze_server, {:enter, object})
  end

  # Server Implementation

  # Callbacks

  def init(:ok) do
    IO.puts("Maze server init. \n")
    :timer.send_interval(1_000, :tick)

    {:ok, generate_maze_impl(7)}
  end

  def handle_info(:tick, state) do
    #newstate = movegenerate_maze_impl(7)
    newstate = move_impl(state, :monsterino, Enum.random(Grid.available_paths(state.graph, state.objects.monsterino)))
    {:noreply, newstate}
  end

  def handle_call({:available_paths, object}, _from, state) do
    paths = Grid.available_paths(state.graph, state.objects[object])
    {:reply, paths, state }
  end

  def handle_call({:enter, object}, _from, state) do
    state = put_in state.objects[object], Grid.random_v(state.graph)
    {:reply, state, state}
  end

  def handle_call({:generate_maze, n}, _from, state) do
    grid = Graph.square_grid(n)
      |> binary_tree()
      |> Graph.as_grid()
    maze = %Maze{
      graph: grid,
      objects: %{ monsterino: Enum.random(Digraph.vertices(grid)) }
    }
    {:reply, maze, maze}
  end

  def handle_call({:generate_maze_2, n}, _from, state) do
    IO.puts("Generate\n")
    maze = generate_maze_impl(n)

    {:reply, maze, maze}
  end

  def handle_call({:get_maze}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:move, object, direction}, _from, state) do
    #state = put_in state.objects[object], Enum.random(Digraph.vertices(state.grid))
    IO.puts(inspect state)
    state = move_impl(state, object, direction)

    {:reply, state, state}
  end

  # Other
  defp move_impl(state, object, direction) do
    g = state.graph
    v1 = state.objects[object]
    v2 = case direction do
      :up -> if Grid.has_top_path(g, v1) do Grid.top(g, v1) end
      :down -> if Grid.has_bottom_path(g, v1) do Grid.bottom(g, v1) end
      :left -> if Grid.has_left_path(g, v1) do Grid.left(g, v1) end
      :right -> if Grid.has_right_path(g,v1) do Grid.right(g, v1) end
    end
    if v2 do
      state = put_in state.objects[object], v2
    end
    state
  end

  defp generate_maze_impl(n) do
    grid = Grid.square_grid(n)
    |> binary_tree()
    maze = %Maze{
      graph: grid,
      objects: %{ monsterino: Enum.random(Digraph.vertices(grid)) }
    }
    maze
  end


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
