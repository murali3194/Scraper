defmodule Scraper.Application do # {Scraper.Consumer, []},
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ScraperWeb.Telemetry,
      Scraper.Repo,
      {DNSCluster, query: Application.get_env(:scraper, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Scraper.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Scraper.Finch},
      # Start a worker by calling: Scraper.Worker.start_link(arg)
      # {Scraper.Worker, arg},
      # Start to serve requests, typically the last entry
      ScraperWeb.Endpoint,
      {Scraper.Producer, "Some weird sentence. Maybe you want to reveal that you are The Batman"},
      # {Scraper.ProducerConsumer, ""},

      Supervisor.child_spec({Scraper.Consumer, ""}, id: :c1),
      Supervisor.child_spec({Scraper.Consumer, ""}, id: :c2),
      Supervisor.child_spec({Scraper.Consumer, ""}, id: :c3),
      Supervisor.child_spec({Scraper.Consumer, ""}, id: :c4)
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :rest_for_one, name: Scraper.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ScraperWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
