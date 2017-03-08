defmodule MazingUi.MazeChannelTest do
  use MazingUi.ChannelCase

  setup do
    {:ok, socket} = connect(MazingUi.UserSocket, %{})

    {:ok, socket: socket}
  end

  test "socket set assigns doesnt break", %{socket: socket} do
    {:ok, _, socket } = subscribe_and_join(socket, "maze:1", %{})
    ref = push socket, "set-start-cell", "10"
    assert_reply ref, :ok, %{}
  end

  test "maze-me sends a broadcast", %{socket: socket} do
    {:ok, _, socket } = subscribe_and_join(socket, "maze:1", %{})
    ref = push socket, "maze-me", %{generator: "sidewinder"}
    assert_reply ref, :ok, %{}
    assert_broadcast "new_maze", %{}
  end
end
