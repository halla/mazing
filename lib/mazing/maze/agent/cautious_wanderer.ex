defmodule Mazing.Agent.CautiousWanderer do
  @moduledoc """
  Cautious wanderer rolls a dice at every corner, avoids other agents and objects.
  TODO
    - not cautious yet...
    - reuse decription in ui
  State:
  - heading
  -
  """

  use GenServer

  alias Mazing.Maze

  @agentname :cautious_wanderer

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: @agentname)
  end

  def init(_args) do
    :timer.send_interval(1_000, :tick)
    Maze.enter(@agentname)
    {:ok, %{heading: :up}}
  end

  defp back(heading) do
    case heading do
      :up -> :down
      :left -> :right
      :down -> :up
      :right -> :left
    end
  end

  def handle_info(:tick, %{heading: heading} = state) do
    paths = Maze.available_paths(@agentname) # TODO change control
      |> Enum.filter(fn x -> x != back(heading) end)

    heading =
      cond do
        Enum.empty?(paths) ->
          back(heading)
        true ->
          Enum.random(paths)
      end

    Maze.move(:maze_server, @agentname, heading) # TODO shouldnt need agentname

    {:noreply, %{heading: heading}}
  end

  def handle_call({:agent_info}, _from, %{heading: heading} = state) do
    {:reply, "Heading: #{heading}", state}
  end

  def handle_call({:agent_description}, _from, state) do
    {:reply, "I wonder around, avoiding encounters.", state}
  end

end
