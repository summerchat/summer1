defmodule Summer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Summer.Repo,
      # Start the Telemetry supervisor
      SummerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Summer.PubSub},
      # Start the Endpoint (http/https)
      SummerWeb.Endpoint,
      # Start Libcluster
      {Cluster.Supervisor, libcluster_config()},
      # Start Oban
      {Oban, oban_config()}
      # Start a worker by calling: Summer.Worker.start_link(arg)
      # {Summer.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Summer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SummerWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp libcluster_config() do
    topologies = Application.get_env(:libcluster, :topologies) || []
    [topologies, [name: Summer.ClusterSupervisor]]
  end

  defp oban_config do
    Application.fetch_env!(:summer, Oban)
  end
end
