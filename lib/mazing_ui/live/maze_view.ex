defmodule MazingUi.MazeView do
  use Phoenix.LiveView
  alias Mazing.Maze
  alias Mazing.Dfs
  alias Mazing.Traverse.Bfs
  alias Mazing.Graph
  alias Mazing.Digraph
  alias Phoenix.View
  alias MazingUi.PageView

  def render(assigns) do
    MazingUi.PageView.render("index-live.html", assigns)
  end

  def mount(session, socket) do
    :timer.send_interval(100, :refresh)
    :timer.send_interval(1000, :refresh_agent)

    {:ok,
     assign(socket,
       maze: session[:maze],
       dfs: session[:dfs],
       bfs: nil,
       generators: session[:generators],
       objects: session[:objects],
       deploy_step: "Ready!",
       generator: :binary_tree,
       active_agent: :avatar,
       agent_info: "No info",
       agent_description: "No description",
       agent_name: "No name"
     )}
  end

  @doc """
  Refresh maze state from the server. Push to clients.
  """
  def handle_info(:refresh, socket) do
    maze = Maze.get_maze(:maze_server)
    dfs = Dfs.dfs(maze.graph, 1)
    start_cell = Map.get(socket.assigns, :cell, 2)
    bfs = Bfs.traverse(maze.graph, start_cell)
    # html = View.render_to_string PageView, "maze.html", maze: maze, dfs: dfs, bfs: bfs
    # broadcast! socket, "new_maze", %{html: html }

    {:noreply, assign(socket, maze: maze, dfs: dfs, bfs: bfs, deploy_step: Enum.random(1..20))}
  end

  def handle_info(:refresh_agent, socket) do
    agent = Map.get(socket.assigns, :active_agent, :avatar)
    info = Mazing.Maze.agent_info(agent)
    description = Mazing.Maze.agent_description(agent)

    {:noreply,
     assign(socket, agent_info: info, agent_description: description, agent_name: agent)}
  end

  @doc """
  Generate a new maze.
  """
  def handle_event("maze_me", _generator, socket) do
    options = %{
      generator: Map.get(socket.assigns, :generator),
      size: 9
    }

    maze = Maze.generate_maze(:maze_server, options)
    dfs = Dfs.dfs(maze.graph, 1)
    start_cell = Map.get(socket.assigns, :cell, 2)
    bfs = Bfs.traverse(maze.graph, start_cell)

    {:noreply, assign(socket, maze: maze, dfs: dfs, bfs: bfs)}
  end

  def handle_event("move", direction, socket) do
    Mazing.Agent.Avatar.move(String.to_atom(direction))
    IO.puts("move" <> direction)
    {:noreply, socket}
  end

  @doc """
  Set start cell. Bfs is calculated from here. Store start cell in socket.
  """
  def handle_event("set-start-cell", cell, socket) do
    {:noreply, assign(socket, cell: String.to_integer(cell))}
  end

  def handle_event("generator-change", %{"generator" => generator}, socket) do
    {:noreply, assign(socket, generator: String.to_atom(generator))}
  end

  def handle_event("crash_me", agent_string, socket) do
    # :timer.sleep(3000)
    IO.puts("crash..")
    GenServer.cast(String.to_atom(agent_string), {:crash})
    IO.puts("crash-sent")
    {:noreply, socket}
  end

  def handle_event("active-agent-change", %{"active-agent" => agent_string}, socket) do
    agent = String.to_atom(agent_string)
    info = Mazing.Maze.agent_info(agent)
    description = Mazing.Maze.agent_description(agent)

    {:noreply,
     assign(socket,
       active_agent: agent,
       agent_info: info,
       agent_description: description,
       agent_name: agent
     )}
  end
end
