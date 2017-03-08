defmodule MazingUi.UserSocketTest do
  use MazingUi.ChannelCase, async: true

  alias MazingUi.UserSocket

  test "socket non-authentication" do
    assert {:ok, socket} = connect(UserSocket, %{})
    assert socket.assigns ==  %{}
  end
end
