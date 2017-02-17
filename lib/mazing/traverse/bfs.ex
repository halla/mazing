defmodule Mazing.Traverse.Bfs do
  alias Mazing.Digraph

  def traverse(%Digraph{} = g, s) do
    q = :queue.new
    q = :queue.in(s, q)

    distances = %{}
      |> Map.put(s, 0)
    visited = []
    traverse_inner(g, q, distances, visited, 1)

  end

  def traverse_inner(g, q, distances, visited, l) do
    if :queue.is_empty(q) do
      distances
    else
      {{:value, v}, q} = :queue.out(q)
      neighbors = Digraph.adj(g, v)

      visited = visited ++ [v]
      q = Enum.reduce(neighbors, q, fn w, acc ->
        if Enum.member?(visited, w) do
          acc
        else
          :queue.in w, acc
        end
      end)
      # distance gets overridden. how do I test for this?
      distances = Enum.reduce(neighbors, distances, fn w, acc ->
        if Enum.member?(visited, w) do
          acc
        else
          Map.put acc, w, l
        end
      end)

      traverse_inner(g, q, distances, visited, l + 1)
    end

  end
end
