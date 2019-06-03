defmodule MazingUi.PageViewTest do
  use MazingUi.ConnCase, async: true
  alias MazingUi.PageView

  test "objectmap" do
    obs = PageView.objects(%{ objects: %{ asdf: 3, qwer: 4}})
    assert obs == %{ 3 => [:asdf], 4 => [:qwer] }
  end
end
