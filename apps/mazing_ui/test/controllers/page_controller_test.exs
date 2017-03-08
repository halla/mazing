defmodule MazingUi.PageControllerTest do
  use MazingUi.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Maze algorithm"
  end
end
