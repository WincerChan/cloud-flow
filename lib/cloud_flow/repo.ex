defmodule CloudFlow.Repo do
  use Ecto.Repo,
    otp_app: :cloud_flow,
    adapter: Ecto.Adapters.Postgres
end
