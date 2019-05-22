defmodule MazingUi.AgentChannel do
  use MazingUi.Web, :channel
  alias Phoenix.View
  alias MazingUi.PageView


  def join("agent:1", _params, socket) do 
    {:ok, socket}
  end

  def handle_in("move", %{"direction" => direction}, socket) do
    Mazing.Agent.Avatar.move(String.to_atom(direction))    
    {:reply, :ok, socket}
  end
end
