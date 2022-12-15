defmodule Scrooge.PromEx do
  @moduledoc """
  This module sets up `PromEx` plugins and default grafana dashboards. This
  exports Prometheus metrics at `localhost:4080/metrics` for scraping.
  It also allows us to generate Grafana dashboard JSON for easier metrics.
  """

  use PromEx, otp_app: :scrooge

  @impl true
  def plugins do
    [
      PromEx.Plugins.Application,
      PromEx.Plugins.Beam,
      {PromEx.Plugins.Phoenix, router: ScroogeWeb.Router, endpoint: ScroogeWeb.Endpoint},
      {PromEx.Plugins.Ecto, repos: [Scrooge.Repo]},
      PromEx.Plugins.PhoenixLiveView
    ]
  end

  @impl true
  def dashboards do
    [
      {:prom_ex, "application.json"},
      {:prom_ex, "beam.json"},
      {:prom_ex, "phoenix.json"},
      {:prom_ex, "ecto.json"},
      {:prom_ex, "phoenix_live_view.json"}
    ]
  end
end
