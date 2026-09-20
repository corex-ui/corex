defmodule PalaverDemo.MixProject do
  use Mix.Project

  def project do
    [
      app: :palaver_demo,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: false,
      deps: deps(),
      aliases: aliases()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  # Everything Palaver deliberately does not own lives here: an HTTP client to
  # reach a provider, an HTTP server to pretend to be one, and the tools.
  defp deps do
    [
      {:palaver, path: ".."},
      {:req, "~> 0.5"},
      {:bandit, "~> 1.0"},
      {:plug, "~> 1.14"}
    ]
  end

  defp aliases do
    [
      lint: [
        "format --check-formatted",
        "compile --force --warnings-as-errors"
      ]
    ]
  end
end
