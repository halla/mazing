defmodule MazingUi.PageControllerTest do
  use MazingUi.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Mazes with Elixir"
  end
end
