defmodule CloudFlow.MixProject do
  use Mix.Project

  def project do
    [
      app: :cloud_flow,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {CloudFlow.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:jason, "~> 1.2"},
      {:httpoison, "~> 1.8"},
      {:floki, "~> 0.31.0"}
    ]
  end
end
