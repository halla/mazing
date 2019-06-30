defmodule Mazing.Maze do
  @moduledoc """
  GenServer serving mazes on demand.

  A Maze
  """

  use GenServer
  alias Mazing.Graph
  alias Mazing.Grid
  alias Mazing.Maze
  alias Mazing.Generator

  defstruct graph: nil, objects: %{}, trails: %{}

  def debug(x) do
    IO.puts(inspect(x))
    x
  end

  # Client API
  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: :maze_server)
  end

  @doc """
  Generate a square maze of size n.
  """
  def generate_maze(server, %{generator: generator, size: n}) do
    GenServer.call(server, {:generate_maze_2, generator, n})
  end

  @doc """
  Get current state.
  """
  def get_maze(server) do
    GenServer.call(server, {:get_maze})
  end

  @doc """
  Move an object
  """
  def move(server, object, direction) do
    GenServer.call(server, {:move, object, direction})
  end

  def objects() do
    GenServer.call(:maze_server, :objects)
  end

  @doc """
  Available directions for given objects location.
  """
  def available_paths(object) do
    GenServer.call(:maze_server, {:available_paths, object})
  end

  @doc """
  Look at all directions until next wall.
  Return objects and distance.

  Control should probably be other way round
  """
  def look_around(object) do
    GenServer.call(:maze_server, {:look_around, object})
  end

  def enter(object) do
    GenServer.call(:maze_server, {:enter, object})
  end

  def insert_object(agent, object) do
    GenServer.call(:maze_server, {:insert_object, agent, object})
  end

  def agent_info(agent) do
    GenServer.call(agent, {:agent_info})
  end

  def agent_description(agent) do
    GenServer.call(agent, {:agent_description})
  end

  # Server Implementation

  # Callbacks

  def init(:ok) do
    IO.puts("Maze server init. \n")
    :timer.send_interval(500, :tick)

    {:ok, generate_maze_impl(:binary_tree, 9)}
  end

  def handle_info(:tick, state) do
    # TBD calculations, physics, animation frame?

    {:noreply, state}
  end

  def handle_call({:available_paths, object}, _from, state) do
    paths = Grid.available_paths(state.graph, state.objects[object])
    {:reply, paths, state}
  end

  def handle_call({:look_around, object}, _from, state) do
    paths = Grid.lines_of_sight(state.graph, state.objects[object])
      |> Enum.map(fn {key, cells} -> {key, objects_at_cells(state.objects, cells) } end)
      |> Enum.into(%{})
    {:reply, paths, state}
  end

  def handle_call({:insert_object, agent, object}, _from, state) do
    state = put_in(state, [:objects, object], state.objects[agent])
    {:reply, state, state}
  end

  def handle_call({:enter, object}, _from, state) do
    state = put_in(state.objects[object], Grid.random_v(state.graph))
    {:reply, state, state}
  end

  def handle_call({:generate_maze, n}, _from, _state) do
    grid =
      Graph.square_grid(n)
      |> Generator.binary_tree()
      |> Graph.as_grid()

    maze = %Maze{
      graph: grid,
      objects: %{},
      trails: %{}
    }

    {:reply, maze, maze}
  end

  def handle_call({:generate_maze_2, generator, n}, _from, state) do
    IO.puts("Generate\n")
    maze = generate_maze_impl(generator, n)
    maze = put_in(maze.objects, state.objects)
    {:reply, maze, maze}
  end

  def handle_call({:get_maze}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:move, object, direction}, _from, state) do
    v1 = state.objects[object]
    trail = Map.get(state.trails, object, :queue.new())
    trail = :queue.in(v1, trail)

    trail_new =
      if :queue.len(trail) > 3 do
        {_, trail2} = :queue.out(trail)
        trail2
      else
        trail
      end

    state = put_in(state.trails[object], trail_new)
    state = move_impl(state, object, direction)
    {:reply, state, state}
  end

  def handle_call(:objects, _from, state) do
    {:reply, state.objects, state}
  end

  def code_change(old_vsn, state, extra) do
    IO.puts("New version. Moving out of #{old_vsn} #{inspect(extra)}")
    {:ok, state}
  end

  defp objects_at_cells(objects, cells) do
    cells
    |> Enum.map(fn cell -> objects_at_cell(objects, cell) end)
  end

  defp objects_at_cell(objects, i_cell) do
    objects
    |> Enum.filter(fn {_object, v} -> v == i_cell end )
    |> Enum.map(fn {object, _v} -> object end)
  end

  # Other
  defp move_impl(state, object, direction) do
    g = state.graph
    v1 = state.objects[object]

    v2 =
      if Grid.has_path(g, v1, direction) do
        Grid.neighbor(g, v1, direction)
      end

    if v2 do
      collisions = objects_at_cell(state.objects, v2)
      new_state = put_in(state.objects[object], v2)
      if Enum.member?(collisions, :generator_trap) do # todo somethig smarter
        Mazing.Agent.GeneratorTrap.trap()
      end
      new_state
    else
      state
    end
  end

  defp generate_maze_impl(generator, n) do
    gen_fn =
      case generator do
        :sidewinder -> &Generator.sidewinder/1
        :binary_tree -> &Generator.binary_tree/1
      end

    grid =
      Grid.square_grid(n)
      |> gen_fn.()

    maze = %Maze{
      graph: grid,
      objects: %{},
      trails: %{}
    }

    maze
  end
end
