defmodule MazingUi.PageController do
  use MazingUi.Web, :controller
  alias Phoenix.LiveView

  def index(conn, _params) do
    maze = %{graph: [], trails: %{}, objects: %{}}

    generators = Mazing.Generator.list_generators()
    objects = Mazing.Maze.objects()

    dfs = nil #Dfs.dfs(maze, Enum.at(maze.nodes, 0))
    LiveView.Controller.live_render(conn, MazingUi.MazeView, session: %{maze: maze, dfs: dfs, bfs: nil, objects: objects, generators: generators})
  end

  def avatar_local(conn, _params) do
    render conn, "avatar_local.html"
  end
end
