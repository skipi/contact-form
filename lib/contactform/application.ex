defmodule Contactform.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      Contactform.Repo,
      # Start the endpoint when the application starts
      ContactformWeb.Endpoint,

      # Contactform.DeleteMsgWorker.start_link(arg)
      # Starts a worker by calling: Contactform.Worker.start_link(arg)
      {Contactform.DeleteMsgWorker, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Contactform.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ContactformWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
