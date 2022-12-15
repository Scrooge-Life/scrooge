defmodule ScroogeBrowser.PageTest do
  use ScroogeBrowser.BrowserCase

  test "can view page", %{session: session} do
    session
    |> visit(~p"/")
    |> assert_text("Peace of mind from prototype to production")
  end
end
