defmodule MazingUi.PageView do
  use MazingUi.Web, :view

  alias Mazing.Cell
  alias Mazing.Digraph
  alias Mazing.Grid
  alias Mazing.Maze

  def classes_for_cell(_, %Cell{} = c) do
    b = if c.bottom do "bottom" else "" end
    t = if c.top do "top" else "" end
    l = if c.left do "left" else "" end
    r = if c.right do "right" else "" end
    "#{b} #{t} #{l} #{r}"
  end

  @doc"""
  The visual propeties of a cell are marked using css classes.
  """
  def classes_for_cell(%Maze{} = maze, v) do
    g = maze.graph
    trs = trails(maze)
    obs = objects(maze)

    t = if Grid.has_path(g, v, :top) do "top" else "" end
    r = if Grid.has_path(g, v, :right) do "right" else "" end
    l = if Grid.has_path(g, v, :left) do "left" else "" end
    b = if Grid.has_path(g, v, :bottom) do "bottom" else "" end

    obj_class = Map.get(obs, v, [])
      |> Enum.map(fn x -> to_string(x) end)
      |> Enum.join(" ")
    tr_class = Map.get(trs, v, [])
      |> Enum.map(fn x -> to_string(x) <> "-trail" end)
      |> Enum.join(" ")
    "#{b} #{t} #{l} #{r} #{obj_class} #{tr_class}"
  end


  def rows(%Digraph{} = g) do
    Enum.reverse Grid.rows(g)
  end

  def rows(x), do: x


  @doc """
    V -> objects lookup
  """
  def objects(m) do
    locations = for {obj, v} <- m.objects do
      {v, obj}
    end
    cells = Enum.reduce locations, %{}, fn({v, obj}, acc) ->
      xs = Map.get(acc, v, [])
      xs = xs ++ [obj]
      put_in acc[v], xs
    end
    cells
  end

  def object_for_cell(maze, cell) do
    Enum.filter(maze.objects, fn {obj, v} -> v == cell end)
    |> List.first
  end

  @doc """
   V -> trail lookup
  """
  def trails(g) do
    marks = for {obj, trail} <- g.trails do
        for c <- :queue.to_list(trail) do
          {c, obj}
        end
    end

    cells = Enum.reduce List.flatten(marks), %{}, fn({v, obj}, acc) ->
      xs = Map.get(acc, v, [])
      xs = xs ++ [obj]
      put_in acc[v], xs
    end
    cells
  end

  def cell_content(_maze, c, _dfs, bfs) do
    if bfs do
      {dists , prevs} = bfs
      # TODO select type of content, eg #{prevs[c]}
      "#{dists[c]}"
    end
  end

  def cell_color({distances, _} = _bfs, cell) do
    max_dist = Enum.max(Map.values(distances))
    alpha = distances[cell] / max_dist
    "background: rgba(200,200,200, #{alpha})"
  end


  def show_object(nil) do
  end

  @object_images %{ #TODO should need to tweak views every time when adding agents
    avatar: "avatar.svg",
    randoomed: "randoomed.svg",
    straightguy: "straightguy.svg",
    generator_trap: "generator_trap.svg",
    cautious_wanderer: "cautious_wanderer.svg"

  }

  def show_object({obj, v}) do

    if Map.has_key?(@object_images, obj) do
      "<img src='/images/#{Map.get(@object_images, obj)}'> </img>"
    end
  end


end
