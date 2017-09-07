defmodule Mazing.Agent do
  @moduledoc """
  Behaviour for all the agents to implement
  """

  @callback agent_info :: String.t
  @callback agent_description :: String.t
end
