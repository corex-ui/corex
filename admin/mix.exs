defmodule CorexAdmin.MixProject do
  use Mix.Project

  @version "0.1.0"
  @scm_url "https://github.com/corex-ui/corex"

  def project do
    [
      app: :corex_admin,
      version: @version,
      elixir: "~> 1.17",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      dialyzer: dialyzer(),
      name: "Corex Admin",
      description: description(),
      package: package(),
      docs: docs(),
      source_url: @scm_url,
      homepage_url: "https://corex.gigalixirapp.com/en",
      test_coverage: [tool: ExCoveralls]
    ]
  end

  def cli do
    [preferred_envs: [docs: :docs, lint: :test]]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(:docs), do: ["lib"]
  defp elixirc_paths(_), do: ["lib"]

  defp description do
    "Context-first, deny-by-default LiveView admin for Phoenix+Ecto apps, built on Corex."
  end

  defp deps do
    [
      {:phoenix, "~> 1.8.1"},
      {:phoenix_live_view, "~> 1.1 or ~> 1.2"},
      {:phoenix_html, "~> 4.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:ecto, "~> 3.11"},
      {:nimble_options, "~> 1.1"},
      {:corex, path: ".."},
      {:plug, "~> 1.14"},
      {:jason, "~> 1.2"},
      {:bandit, "~> 1.0", only: :test},
      {:floki, "~> 0.38.0", only: :test},
      {:lazy_html, ">= 0.1.0", only: :test},
      {:ex_doc, "~> 0.40", only: :docs, runtime: false},
      {:excoveralls, "~> 0.18", only: :test},
      {:castore, "~> 1.0", only: :test},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:oeditus_credo, "~> 0.11.0", only: [:dev, :test], runtime: false},
      {:sobelow, "~> 0.13", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false}
    ] ++ maybe_ex_slop() ++ maybe_json_polyfill()
  end

  defp dialyzer do
    [
      plt_local_path: "_build/plts",
      plt_core_path: "_build/plts",
      plt_add_apps: [:mix, :ex_unit, :phoenix, :phoenix_live_view, :ecto],
      flags: [:error_handling, :extra_return, :missing_return, :unmatched_returns]
    ]
  end

  defp maybe_ex_slop do
    if Version.match?(System.version(), "~> 1.18") do
      [{:ex_slop, "~> 0.4.1", only: [:dev, :test], runtime: false}]
    else
      []
    end
  end

  defp maybe_json_polyfill do
    case Integer.parse(System.otp_release()) do
      {otp, _} when otp >= 27 -> []
      _ -> [{:json_polyfill, "~> 0.2 or ~> 1.0"}]
    end
  end

  defp aliases do
    [
      test: ["test"],
      lint: [
        "format --check-formatted",
        "compile --force --warnings-as-errors",
        "compile --force --warnings-as-errors --env test",
        "credo --strict",
        "sobelow --exit"
      ]
    ]
  end

  defp package do
    [
      maintainers: ["Karim Semmoud"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @scm_url,
        "Website" => "https://corex.gigalixirapp.com/en",
        "Sponsor" => "https://github.com/sponsors/corex-ui"
      },
      files: ~w(lib priv mix.exs README.md CHANGELOG.md LICENSE .formatter.exs guides)
    ]
  end

  defp docs do
    [
      main: "readme",
      source_url: @scm_url,
      source_ref: "v#{@version}",
      extras: [
        "README.md",
        "CHANGELOG.md",
        "guides/installation.md",
        "guides/security.md",
        "guides/resources.md",
        "guides/customization.md"
      ],
      filter_modules: &docs_filter_modules/2,
      groups_for_extras: [
        Guides: [
          "guides/installation.md",
          "guides/security.md",
          "guides/resources.md",
          "guides/customization.md"
        ]
      ]
    ]
  end

  defp docs_filter_modules(mod, _metadata) do
    allowed =
      MapSet.new([
        CorexAdmin,
        CorexAdmin.Policy,
        CorexAdmin.Resource,
        CorexAdmin.ListOpts,
        CorexAdmin.Page,
        CorexAdmin.Query,
        CorexAdmin.Router,
        Mix.Tasks.Corex.Admin.Install,
        Mix.Tasks.Corex.Admin.Gen.Resource
      ])

    if MapSet.member?(allowed, mod) do
      true
    else
      raise "you forgot to add \"@moduledoc false\" or allowlist #{inspect(mod)} in admin/mix.exs docs"
    end
  end
end
