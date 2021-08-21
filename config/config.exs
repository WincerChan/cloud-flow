import Config

config :cloud_flow,
  ecto_repos: [CloudFlow.Repo]

config :cloud_flow, CloudFlow.Repo,
  database: "works",
  username: "postgres",
  password: "5.Eb?z__mEc#M_TECg",
  hostname: "104.168.19.72",
  port: "12878"
