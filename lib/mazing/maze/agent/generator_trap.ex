defmodule Mazing.Agent.GeneratorTrap do

  use GenServer

  @name :generator_trap

  alias Mazing.Maze

  def agent_info() do
    GenServer.call(@name, {:agent_info})
  end

  def init(_args) do
    IO.puts("Enter #{@name}")
    :timer.send_interval(2000, :tick)
      Maze.enter(@name)
      {:ok, true}
  end

  def handle_info(:tick, _active?) do
    {:noreply, true}
  end

  def trap() do
    GenServer.cast(@name, {:trap})
  end

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: @name)
  end

  def handle_cast({:trap},  active?) do
    IO.puts("trap")
    if active? do
      Maze.generate_maze(:maze_server, %{ generator: :binary_tree, size: 9})
      Maze.enter(@name) # overwrites old
    end
    {:noreply, false}
  end

  def handle_call({:agent_info}, _from, state) do
    {:reply, "Waiting for someone to enter the same cell, I'll trigger a maze regeneration.", state}
  end

end
