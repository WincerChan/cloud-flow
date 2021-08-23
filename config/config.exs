import Config

config :cloud_flow,
  ecto_repos: [CloudFlow.Repo],
  finch_name: CloudFinch

config :postgrex, json_library: :jiffy

import_config("#{Mix.env()}.secret.exs")
