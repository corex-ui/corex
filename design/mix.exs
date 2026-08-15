defmodule CorexDesign.MixProject do
  use Mix.Project

  @version "0.2.1"
  @scm_url "https://github.com/corex-ui/corex"

  def project do
    [
      app: :corex_design,
      version: @version,
      elixir: "~> 1.17",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      dialyzer: dialyzer(),
      name: "Corex Design",
      description: description(),
      package: package(),
      docs: docs(),
      source_url: @scm_url,
      homepage_url: "https://corex.gigalixirapp.com/en"
    ]
  end

  def cli do
    [preferred_envs: [docs: :docs, lint: :test]]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp elixirc_paths(:test), do: ["lib", "test"]
  defp elixirc_paths(:docs), do: ["lib"]
  defp elixirc_paths(_), do: ["lib"]

  defp description do
    "Optional config-driven token generation and static component CSS for Corex."
  end

  defp deps do
    [
      {:color, "~> 0.11"},
      {:nimble_options, "~> 1.1"},
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
      plt_add_apps: [:mix, :ex_unit],
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

  # Gate on OTP release, not Code.ensure_loaded?(:json). After json_polyfill
  # compiles it defines :json, so an ensure_loaded? check can drop the dep on
  # Mix reload and raise "Unknown dependency json_polyfill for environment …".
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
      files: ~w(lib priv/css mix.exs README.md CHANGELOG.md LICENSE .formatter.exs guides)
    ]
  end

  defp docs do
    [
      main: "readme",
      source_url: @scm_url,
      source_ref: "v#{@version}",
      assets: %{"../docs/images" => "images"},
      extras: ["README.md", "CHANGELOG.md", "guides/modifiers.md"],
      filter_modules: &docs_filter_modules/2,
      groups_for_modules: [
        Design: [
          Corex.Design,
          Corex.Design.Accessibility,
          Corex.Design.Config,
          Corex.Design.Config.Resolved,
          Corex.Design.Config.Schema,
          Mix.Tasks.Corex.Design.Build,
          Mix.Tasks.Corex.Design.Options,
          Mix.Tasks.Corex.Design.Validate,
          Mix.Tasks.Compile.CorexDesign
        ]
      ]
    ]
  end

  defp docs_filter_modules(mod, _metadata) do
    allowed =
      MapSet.new([
        Corex.Design,
        Corex.Design.Accessibility,
        Corex.Design.Config,
        Corex.Design.Config.Resolved,
        Corex.Design.Config.Schema,
        Mix.Tasks.Corex.Design.Build,
        Mix.Tasks.Corex.Design.Options,
        Mix.Tasks.Corex.Design.Validate,
        Mix.Tasks.Compile.CorexDesign
      ])

    if MapSet.member?(allowed, mod) do
      true
    else
      raise "you forgot to add \"@moduledoc false\" or allowlist #{inspect(mod)} in design/mix.exs docs"
    end
  end
end
