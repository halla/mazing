defmodule Mazing.Traverse.Bfs do
  alias Mazing.Digraph

  def traverse(%Digraph{} = g, s) do
    q = :queue.new
    q = :queue.in({s, 1}, q)

    distances = %{}
      |> Map.put(s, 0)
    visited = []
    prevs = %{}
      |> Map.put(s, -1)
    traverse_inner(g, q, distances, prevs, visited)

  end

  def traverse_inner(g, q, distances, prevs, visited) do
    if :queue.is_empty(q) do
      { distances, prevs }
    else
      {{:value, {v, d}}, q} = :queue.out(q)
      neighbors = Digraph.adj(g, v)

      visited = visited ++ [v]
      q = Enum.reduce(neighbors, q, fn w, acc ->
        if Enum.member?(visited, w) do
          acc
        else
          :queue.in {w, d + 1}, acc
        end
      end)
      # distance gets overridden. how do I test for this?
      distances = Enum.reduce(neighbors, distances, fn w, acc ->
        if Enum.member?(visited, w) do
          acc
        else
          Map.put acc, w, d
        end
      end)
      prevs = Enum.reduce(neighbors, prevs, fn w, acc ->
        if Enum.member?(visited, w) do
          acc
        else
          Map.put acc, w, v
        end
      end)


      traverse_inner(g, q, distances, prevs, visited)
    end

  end
end
