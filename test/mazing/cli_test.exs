defmodule CliTest do
  use ExUnit.Case

  import Mazing.Cli, only: [ parse_args: 1 ]

  test ":help returned by default" do
    assert :help == parse_args(["sadf --asdf"])
  end

end
