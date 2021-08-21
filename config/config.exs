import Config

config :cloud_flow,
  ecto_repos: [CloudFlow.Repo]

import_config("#{Mix.env()}.secret.exs")
