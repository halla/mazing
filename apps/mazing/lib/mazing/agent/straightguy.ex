defmodule Mazing.Agent.Straightguy do
  @moduledoc"""
  Straightguy moves in straight lines, keeping the heading if possible.
  """
  use GenServer

  alias Mazing.Maze

  @agentname :straightguy

  # Client API
  def agent_info() do
    GenServer.call(@agentname, {:agent_info})
  end

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: :straightguy) # singleton for now
  end


  def init(_args) do
    :timer.send_interval(900, :tick)
    Maze.enter(:straightguy)
    {:ok, %{}}
  end


  def handle_info(:tick, heading) do
    #newstate = movegenerate_maze_impl(7)
    paths = Maze.available_paths(:straightguy)    
    heading = if not Enum.member?(paths, heading) do      
      heading = Enum.random(paths)
    else 
      heading
    end
    
    Maze.move(:maze_server, :straightguy, heading)
    {:noreply, heading}
  end

  def handle_call({:agent_info}, _from, state) do
    {:reply, "Heading: #{state}", state}
  end

  def handle_call({:agent_description}, _from, _state) do
    {:reply, "I move in straight lines.", _state}
  end
end
