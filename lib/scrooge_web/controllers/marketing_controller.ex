defmodule ScroogeWeb.MarketingController do
  use ScroogeWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, "home.html", layout: false)
  end
end
