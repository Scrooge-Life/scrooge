defmodule ScroogeBrowser.BrowserCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require a live browser session.

  Such tests use `Wallaby` and Selenium to run real browsers
  to test against. They import other functionality to make it
  easier to build common data structures and query the data
  layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use ScroogeWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # The default endpoint for testing
      @endpoint ScroogeWeb.Endpoint

      use ScroogeWeb, :verified_routes
      use Wallaby.DSL

      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import ScroogeBrowser.BrowserCase
    end
  end

  setup tags do
    pid = Scrooge.DataCase.setup_sandbox(tags)
    remote_url = Application.get_env(:wallaby, :selenium)[:remote_url]
    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(Scrooge.Repo, pid)

    {:ok, session} = Wallaby.start_session(metadata: metadata, remote_url: remote_url)
    {:ok, session: session}
  end
end
