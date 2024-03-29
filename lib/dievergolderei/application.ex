defmodule Dievergolderei.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Telemetry supervisor
      DievergoldereiWeb.Telemetry,
      # Start the Ecto repository
      Dievergolderei.Repo,
      {DNSCluster, query: Application.get_env(:dievergolderei, :dns_cluster_query) || :ignore},
      # Start the PubSub system
      {Phoenix.PubSub, name: Dievergolderei.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Dievergolderei.Finch},
      # Start the endpoint when the application starts
      DievergoldereiWeb.Endpoint
      # Starts a worker by calling: Dievergolderei.Worker.start_link(arg)
      # {Dievergolderei.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dievergolderei.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    DievergoldereiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
