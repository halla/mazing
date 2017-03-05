defmodule Mazing.Dfs do
  alias Mazing.Graph
  alias Mazing.Node
  alias Mazing.Digraph
  require Logger



  @doc """
  Depth first search entry point for Digraph.

  Returns a map V -> prev
  """
  def dfs(%Digraph{} = g, start) do
    prevs =
      Enum.reduce Map.keys(g.adj), %{}, fn v, acc ->
        Map.put acc, v, nil
      end
    prevs = put_in prevs[start], -1 # marker for first node
    seen = MapSet.new
      |> MapSet.put(start)
    neighbors = Digraph.adj(g, start)

    acc = %{g: g, prevs: prevs, seen: seen, prev: start}
    #IO.puts(inspect neighbors)
    result = Enum.reduce(neighbors, acc, &dfs_reducer/2)
    result.prevs
  end

  def dfs_reducer(v,  %{g: g, seen: seen, prevs: prevs, prev: prev} = acc) do
    unseen? = fn v -> not (MapSet.member? seen, v) end

    if (unseen?.(v)) do
      seen = MapSet.put seen, v
      prevs = put_in prevs[v], prev
      neighbors = Digraph.adj(g, v)
      Enum.reduce(neighbors, %{g: g, prevs: prevs, seen: seen, prev: v}, &dfs_reducer/2)
    else
      acc
      
    end
  end

  @doc """
  Depth first search entry point for Graph
  """
  def dfs(%Graph{} = g, %Node{} = start) do
    prevs = %{}
    seen = []
    dfs(g, start, prevs, seen)
  end

  def dfs(%Graph{} = g, %Node{} = start, prevs, seen) do
    neighbors = Graph.neighbors(g, start)
  #  Logger.debug(inspect start)
  #  Logger.debug(inspect neighbors)
    unseen? = fn(x) -> Enum.find(seen, fn (y) -> x == y end) == nil end
    next = Enum.find(neighbors, unseen?)
    if next == nil do
      prevs
    else

      seen = seen ++ [next]
    #  Logger.debug(inspect seen)
      key = {next.x, next.y}
      put_in prevs, [next], start
      dfs(g, next, prevs, seen)
    end
  end

end
