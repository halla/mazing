defmodule Mazing.Edge do
  defstruct nodes: MapSet.new

  alias Mazing.Node
  alias Mazing.Edge

  def new(%Node{} = n1, %Node{} = n2) do
    %Edge{ nodes: (Enum.into [n1, n2], MapSet.new) }
  end
end
