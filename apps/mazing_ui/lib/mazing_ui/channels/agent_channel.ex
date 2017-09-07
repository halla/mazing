defmodule MazingUi.AgentChannel do
  use MazingUi.Web, :channel
  alias Phoenix.View
  alias MazingUi.PageView


  def join("agent:1", _params, socket) do
    :timer.send_interval(1000, :refresh)
    {:ok, socket}
  end


  def handle_info(:refresh, socket) do
    agent = Map.get(socket.assigns, :agent, :avatar)
    info = Mazing.Maze.agent_info(agent)
    description = Mazing.Maze.agent_description(agent)
    html = View.render_to_string(PageView, "agent_view.html", name: agent, info: info, description: description)
    broadcast! socket, "agent_info", %{html: html }
    {:noreply, socket}
  end

  def handle_in("set_active_agent", %{"agent" => agent}, socket) do
    socket = put_in socket.assigns[:agent], String.to_atom(agent)
    {:reply, :ok, socket}
  end

  def handle_in("move", %{"direction" => direction}, socket) do
    Mazing.Agent.Avatar.move(String.to_atom(direction))
    {:reply, :ok, socket}
  end
end
