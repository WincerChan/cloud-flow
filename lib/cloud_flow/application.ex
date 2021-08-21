defmodule CloudFlow.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: CloudFlow.Worker.start_link(arg)
      # {CloudFlow.Worker, arg}
      {CloudFlow.Repo, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CloudFlow.Supervisor]
    Supervisor.start_link(children, opts)
  end
end