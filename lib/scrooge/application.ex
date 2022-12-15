defmodule Scrooge.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    topologies = Application.get_env(:libcluster, :topologies) || []

    children = [
      # Start the Telemetry supervisor
      Scrooge.Telemetry,
      # Start the libcluster supervisor
      {Cluster.Supervisor, [topologies, [name: Scrooge.ClusterSupervisor]]},
      # Start our Prometheus endpoint,
      Scrooge.PromEx,
      # Start the Ecto repository
      Scrooge.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Scrooge.PubSub},
      # Start the Endpoint (http/https)
      ScroogeWeb.Endpoint,
      # Start a worker by calling: Scrooge.Worker.start_link(arg)
      # {Scrooge.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Scrooge.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ScroogeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
