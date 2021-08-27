import Config

config :cloud_flow,
  ecto_repos: [CloudFlow.Repo],
  finch_name: CloudFinch,
  huya_prefix: System.get_env("HUYA_PREFIX", ""),
  douyu_prefix: System.get_env("DOUYU_PREFIX", ""),
  bilibili_prefix: System.get_env("BILIBILI_PREFIX", "")

config :cloud_flow,
  huya_prefix: System.get_env("HUYA", ""),
  douyu_prefix: System.get_env("DOUYU", ""),
  bilibili_prefix: System.get_env("BILIBILI", "")

import_config("#{Mix.env()}.secret.exs")
