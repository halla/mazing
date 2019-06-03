defmodule Mazing.Edge do
  @moduledoc """
  Undirected edge -- a passage from one cell to another in the maze --
  is represented as a MapSet, to eliminate duplicates and backward edges.
  """

  defstruct nodes: MapSet.new()

  alias Mazing.Node
  alias Mazing.Edge

  def new(%Node{} = n1, %Node{} = n2) do
    %Edge{nodes: Enum.into([n1, n2], MapSet.new())}
  end
end
