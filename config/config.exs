import Config

config :cloud_flow,
  ecto_repos: [CloudFlow.Repo],
  finch_name: CloudFinch,
  huya_prefix: System.get_env("HUYA_PREFIX", "http://121.51.249.6/tx.hls.huya.com"),
  douyu_prefix: System.get_env("DOUYU_PREFIX", "http://dyscdnali1.douyucdn.cn/live/"),
  bilibili_prefix: System.get_env("BILIBILI_PREFIX", "")

import_config("#{Mix.env()}.secret.exs")
