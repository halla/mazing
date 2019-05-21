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
        {:ok, assign(socket, maze: session[:maze], dfs: session[:dfs], 
            bfs: nil, generators: session[:generators], objects: session[:objects], deploy_step: "Ready!", generator: :binary_tree )}
    end

 @doc """
  Refresh maze state from the server. Push to clients.
  """
  def handle_info(:refresh, socket) do
    maze = Maze.get_maze(:maze_server)
    dfs = Dfs.dfs(maze.graph, 1)
    start_cell = Map.get socket.assigns, :cell, 2
    bfs = Bfs.traverse(maze.graph, start_cell)
    #html = View.render_to_string PageView, "maze.html", maze: maze, dfs: dfs, bfs: bfs
    #broadcast! socket, "new_maze", %{html: html }

    {:noreply, assign(socket, maze: maze, dfs: dfs, bfs: bfs, deploy_step: Enum.random(1..20))}
  end

  @doc """
  Generate a new maze.
  """
  def handle_event("maze_me", generator, socket) do    
    options = %{
      generator: :binary_tree, #String.to_atom(generator),
      size: 9
    }
    maze = Maze.generate_maze(:maze_server, options)
    dfs = Dfs.dfs(maze.graph, 1)
    start_cell = Map.get socket.assigns, :cell, 2
    bfs = Bfs.traverse(maze.graph, start_cell)
    
    {:noreply, assign(socket, maze: maze, dfs: dfs, bfs: bfs )}
  end

  def handle_event("move", direction, socket) do
    Mazing.Agent.Avatar.move(String.to_atom(direction))
    IO.puts("move" <> direction)
    {:noreply, socket}
  end


  @doc """
  Set start cell. Bfs is calculated from here. Store start cell in socket.
  """
  def handle_event("set-start-cell", cell , socket) do    
    {:noreply, assign(socket, cell: String.to_integer(cell)) }
  end

  def handle_event("generator-change", %{"generator" => generator}, socket) do
    {:noreply, assign(socket, generator: String.to_atom(generator)) }
  end
end