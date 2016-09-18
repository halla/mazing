defmodule Mazing.GraphTest do
  use ExUnit.Case

  alias Mazing.Graph
  import Mazing.Graph
  import Mazing.Node
  alias Mazing.Node

  test "adding nodes adds nodes" do
    g = %Graph{}
     |> add_node(%Node{x: 1, y: 2})

    assert count_nodes(g) == 1
  end
end
