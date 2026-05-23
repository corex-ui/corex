defmodule E2e.MixProject do
  use Mix.Project

  def project do
    [
      app: :corex_web,
      version: "0.1.0",
      elixir: "~> 1.17",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      usage_rules: usage_rules(),
      compilers: [:phoenix_live_view] ++ Mix.compilers(),
      listeners: [Phoenix.CodeReloader]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {E2e.Application, []},
      extra_applications: [:logger, :runtime_tools, :ecto, :ecto_sql]
    ]
  end

  def cli do
    [
      preferred_envs: [precommit: :test]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.8.3"},
      {:phoenix_ecto, "~> 4.5"},
      {:ecto_sql, "~> 3.13"},
      {:db_connection, "~> 2.10"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 4.1"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_dashboard, "~> 0.8.3"},
      {:phoenix_live_view, "~> 1.1.0"},
      {:live_capture, "~> 0.2"},
      {:lazy_html, ">= 0.1.0", only: :test},
      {:esbuild, "~> 0.10", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.3", runtime: Mix.env() == :dev},
      {:heroicons,
       github: "tailwindlabs/heroicons",
       tag: "v2.2.0",
       sparse: "optimized",
       app: false,
       compile: false,
       depth: 1},
      {:swoosh, "~> 1.16"},
      {:req, "~> 0.5"},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 1.0"},
      {:gettext_sigils, "~> 0.5.1"},
      {:localize_web, "~> 0.5"},
      {:jason, "~> 1.2"},
      {:color, "~> 0.11"},
      {:dns_cluster, "~> 0.2.0"},
      {:bandit, "~> 1.5"},
      {:corex, path: "../../corex"},
      {:makeup, "~> 1.2"},
      {:makeup_elixir, "~> 1.0.1 or ~> 1.1"},
      {:makeup_html, "~> 0.2"},
      {:makeup_eex, "~> 2.0"},
      {:makeup_css, "~> 0.2"},
      {:makeup_js, "~> 0.1.0"},
      {:makeup_syntect, "~> 0.1"},
      {:mdex, "~> 0.11"},
      {:floki, "~> 0.38"},
      {:yaml_elixir, "~> 2.9"},
      {:html_entities, "~> 0.5"},
      {:wallaby, "~> 0.30", only: :test},
      {:a11y_audit, "~> 0.3.1", only: :test},
      {:flagpack, "~> 0.6.0"},
      {:tidewave, "~> 0.5.5", only: :dev},
      {:designex, "~> 1.0"},
      {:igniter, "~> 0.6", only: [:dev, :test]},
      {:usage_rules, "~> 1.1", only: :dev},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:oeditus_credo, "~> 0.6.3", only: [:dev, :test], runtime: false},
      {:ex_slop, "~> 0.4.1", only: [:dev, :test], runtime: false}
    ] ++ maybe_json_polyfill()
  end

  defp maybe_json_polyfill do
    if Code.ensure_loaded?(:json) do
      []
    else
      [{:json_polyfill, "~> 0.2 or ~> 1.0"}]
    end
  end

  defp usage_rules do
    [
      skills: [
        location: ".cursor/skills",
        package_skills: [:corex]
      ]
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      compile: ["compile"],
      setup: ["deps.get", "ecto.setup", "assets.setup", "assets.build"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: [
        "patch_wallaby_session_store",
        "localize.download_locales",
        "ecto.drop --quiet",
        "ecto.create --quiet",
        "ecto.migrate",
        "run priv/repo/seeds/user_admin_seed.exs",
        "tailwind e2e --minify",
        "esbuild e2e  --minify",
        "test"
      ],
      "assets.setup": [
        "localize.download_locales",
        "tailwind.install --if-missing",
        "esbuild.install --if-missing"
      ],
      "assets.digest.clean": ["phx.digest.clean", "--no-compile"],
      "assets.digest.clean.all": ["phx.digest.clean", "--all", "--no-compile"],
      "assets.build": [
        "e2e.palette",
        "designex corex",
        "tailwind e2e",
        "esbuild e2e"
      ],
      "assets.deploy": [
        "compile",
        "designex corex",
        "tailwind e2e --minify",
        "esbuild e2e --minify",
        "phx.digest"
      ],
      lint: [
        "format --check-formatted",
        "compile --force --warnings-as-errors",
        "compile --force --warnings-as-errors --env test",
        "credo --strict"
      ],
      precommit: [
        "compile --warnings-as-errors",
        "deps.unlock --unused",
        "format",
        "lint",
        "test"
      ]
    ]
  end
end
