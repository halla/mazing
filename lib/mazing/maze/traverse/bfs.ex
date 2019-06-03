defmodule Mazing.Traverse.Bfs do
  alias Mazing.Digraph

  def traverse(%Digraph{} = g, s) do
    q = :queue.new()
    q = :queue.in({s, 1}, q)

    distances =
      %{}
      |> Map.put(s, 0)

    visited = MapSet.new()

    prevs =
      %{}
      |> Map.put(s, -1)

    traverse_inner(g, q, distances, prevs, visited)
  end

  def traverse_inner(g, queue, distances, prevs, visited) do
    if :queue.is_empty(queue) do
      {distances, prevs}
    else
      {{:value, {v, d}}, queue} = :queue.out(queue)
      neighbors = Digraph.adj(g, v)

      visited = MapSet.put(visited, v)

      # distance gets overridden. how do I test for this?
      {queue, distances, prevs} =
        Enum.reduce(neighbors, {queue, distances, prevs}, fn w,
                                                             {acc_queue, acc_distances, acc_prevs} =
                                                               acc ->
          if Enum.member?(visited, w) do
            acc
          else
            distances_ = Map.put(acc_distances, w, d)
            prevs_ = Map.put(acc_prevs, w, v)
            queue_ = :queue.in({w, d + 1}, acc_queue)
            {queue_, distances_, prevs_}
          end
        end)

      traverse_inner(g, queue, distances, prevs, visited)
    end
  end
end
