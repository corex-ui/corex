for path <- :code.get_path(),
    Regex.match?(~r/corex_new-[\w\.\-]+\/ebin$/, List.to_string(path)) do
  Code.delete_path(path)
end

defmodule Corex.New.MixProject do
  use Mix.Project

  @version "0.1.0"
  @phoenix_version "1.8.4"
  @scm_url "https://github.com/corex-ui/corex"

  @elixir_requirement "~> 1.17"

  def project do
    [
      app: :corex_new,
      elixirc_paths: elixirc_paths(Mix.env()),
      test_coverage: [summary: [threshold: 90], ignore_modules: [Corex.New.MixHelper]],
      start_permanent: Mix.env() == :prod,
      version: @version,
      phoenix_version: @phoenix_version,
      elixir: @elixir_requirement,
      deps: deps(),
      aliases: aliases(),
      package: [
        maintainers: ["Karim Semmoud"],
        licenses: ["MIT"],
        links: %{"GitHub" => @scm_url},
        files: ~w(lib priv templates mix.exs README.md)
      ],
      source_url: @scm_url,
      docs: docs(),
      homepage_url: "https://corex.gigalixirapp.com/en",
      description: """
      Corex greenfield helper archive.

      Provides `mix corex.new`, which runs `mix phx.new --no-install` with
      forwarded Phoenix flags and renders Corex-owned files from templates
      directly into the generated app. Install the `phx_new` archive first.
      """
    ]
  end

  def cli do
    [preferred_envs: [docs: :docs, lint: :test]]
  end

  def application do
    [
      extra_applications: [:eex, :crypto, :public_key, :ssl, :inets, :telemetry]
    ]
  end

  def deps do
    [
      {:jason, "~> 1.0"},
      {:telemetry, "~> 1.0"},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:oeditus_credo, "~> 0.6.3", only: [:dev, :test], runtime: false},
      {:sobelow, "~> 0.13", only: [:dev, :test], runtime: false},
      {:ex_slop, "~> 0.4.1", only: [:dev, :test], runtime: false}
    ]
  end

  defp docs do
    [
      source_url_pattern: "#{@scm_url}/blob/v#{@version}/installer/%{path}#L%{line}"
    ]
  end

  defp aliases do
    [
      lint: [
        "format --check-formatted",
        "compile --force --warnings-as-errors",
        "compile --force --warnings-as-errors --env test",
        "credo --strict",
        "sobelow --exit"
      ]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
