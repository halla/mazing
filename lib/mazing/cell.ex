defmodule Mazing.Cell do
  @moduledoc """
  Cell is a more geometrical mapping of a node in the graph.
  The struct tells whether there is a passage from the (square) cell to an adjacent one.
  """

  defstruct top: true, right: true, bottom: true, left: true
end
