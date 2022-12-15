defmodule ScroogeWeb.MarketingController do
  @moduledoc """
  Controller for static HTML pages like the homepage,
  legal details, etc.
  """

  use ScroogeWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, "home.html", layout: false)
  end
end
