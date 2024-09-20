defmodule ScheduleDeliver.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ScheduleDeliverWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:schedule_deliver, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ScheduleDeliver.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ScheduleDeliver.Finch},
      # Start a worker by calling: ScheduleDeliver.Worker.start_link(arg)
      # {ScheduleDeliver.Worker, arg},
      # Start to serve requests, typically the last entry
      ScheduleDeliverWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ScheduleDeliver.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ScheduleDeliverWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
