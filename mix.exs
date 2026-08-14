defmodule Corex.MixProject do
  use Mix.Project

  if Mix.env() != :prod do
    for path <- :code.get_path(),
        Regex.match?(~r/corex_new-[\w\.\-]+\/ebin$/, List.to_string(path)) do
      Code.delete_path(path)
    end
  end

  @version "0.2.1"
  @elixir_requirement "~> 1.17"

  def project do
    [
      app: :corex,
      version: @version,
      elixir: @elixir_requirement,
      elixirc_paths: elixirc_paths_base(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      dialyzer: dialyzer(),
      name: "Corex",
      description:
        "Accessible Phoenix UI components with Zag.js hooks, plus an optional Corex Design Hex package for token-driven CSS and shared ui-* modifiers.",
      package: package(),
      source_url: "https://github.com/corex-ui/corex",
      homepage_url: "https://corex.gigalixirapp.com/en",
      docs: &docs/0,
      test_coverage: [
        tool: ExCoveralls,
        threshold: 90
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def cli do
    [
      preferred_envs: [
        docs: :docs,
        lint: :test,
        ci: :test,
        "release.check": :test,
        "pre.publish": :test
      ]
    ]
  end

  defp elixirc_paths_base(:test), do: ["lib", "test/support", "test/mix"]
  defp elixirc_paths_base(:docs), do: ["lib", "installer/lib"]
  defp elixirc_paths_base(:dev), do: ["lib", "test/mix"]
  defp elixirc_paths_base(_), do: ["lib"]

  defp deps do
    [
      {:phoenix, "~> 1.8.1"},
      {:phoenix_live_view, "~> 1.1 or ~> 1.2"},
      {:gettext, "~> 1.0"},
      {:esbuild, "~> 0.8", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.40", only: [:dev, :docs], runtime: false},
      {:makeup, "~> 1.2", only: [:dev, :test, :docs], optional: true, override: true},
      {:makeup_elixir, "~> 1.0.1 or ~> 1.1", only: [:dev, :test, :docs], optional: true},
      {:makeup_eex, "~> 2.0", only: [:dev, :test, :docs], optional: true},
      {:makeup_syntect, "~> 0.1.0", only: [:dev, :test, :docs], optional: true},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:oeditus_credo, "~> 0.6.3", only: [:dev, :test], runtime: false},
      {:floki, "~> 0.38.0", only: :test},
      {:phoenix_ecto, "~> 4.0", only: :test},
      {:excoveralls, "~> 0.18", only: :test},
      {:bandit, "~> 1.0", only: :dev},
      {:sobelow, "~> 0.13", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:tidewave, "~> 0.5.5", only: :dev},
      {:corex_design, path: "design", runtime: false, only: :test}
    ] ++ maybe_ex_slop() ++ maybe_json_polyfill()
  end

  defp dialyzer do
    [
      plt_local_path: "_build/plts",
      plt_core_path: "_build/plts",
      plt_add_apps: [:mix, :ex_unit, :phoenix, :phoenix_live_view],
      flags: [:error_handling, :extra_return, :missing_return, :unmatched_returns],
      ignore_warnings: ".dialyzer_ignore.exs"
    ]
  end

  # `ex_slop` requires Elixir ~> 1.18; lint/primary legs still get it.
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
      docs: ["docs"],
      "assets.build": [
        "esbuild module",
        "esbuild corex_hooks",
        &clean_priv_static_chunks/1,
        "esbuild hooks",
        "esbuild cdn",
        "esbuild cdn_min",
        "esbuild main",
        &sync_no_design_corex_export/1
      ],
      "assets.watch": "esbuild module --watch",
      "archive.build": &raise_on_archive_build/1,
      "format.all": [
        "format",
        "cmd --cd design mix format",
        "cmd --cd mcp mix format",
        "cmd --cd installer mix format"
      ],
      "format.all.check": [
        "format --check-formatted",
        "cmd --cd design mix format --check-formatted",
        "cmd --cd mcp mix format --check-formatted",
        "cmd --cd installer mix format --check-formatted"
      ],
      lint: [
        "format --check-formatted",
        "compile --force --warnings-as-errors",
        "compile --force --warnings-as-errors --env test",
        "corex.doc_parity --sections anatomy,form",
        "credo --strict",
        "sobelow --exit"
      ],
      ci: [
        "format.all.check",
        "lint",
        "test",
        "cmd --cd design mix lint",
        "cmd --cd design mix dialyzer",
        "cmd --cd design mix test",
        "cmd --cd mcp mix lint",
        "cmd --cd mcp mix dialyzer",
        "cmd --cd mcp mix test",
        "cmd --cd installer mix lint",
        "cmd --cd installer mix dialyzer",
        "cmd --cd installer mix test",
        "cmd npm run check"
      ],
      "release.check": ["hex.audit", "lint", "test", "assets.build"],
      # CVE/outdated Hex+npm PRs: .github/dependabot.yml (weekly)
      "pre.publish": ["release.check"],
      "hex.build": ["hex.build"],
      tidewave:
        "run --no-halt -e 'Agent.start(fn -> Bandit.start_link(plug: Tidewave, port: 4004) end)'"
    ]
  end

  defp clean_priv_static_chunks(_) do
    chunks = Path.join(__DIR__, "priv/static/chunks")

    if File.exists?(chunks) do
      File.rm_rf!(chunks)
    end

    :ok
  end

  # Neo/light full Design tree for `mix corex.new --no-design` (installer archive only).
  defp sync_no_design_corex_export(_) do
    design_root = Path.join(__DIR__, "design")
    config = Path.join(__DIR__, "installer/priv/static/corex_no_design.config.exs")
    installer_out = Path.join(__DIR__, "installer/priv/static/corex")

    unless File.exists?(config) do
      Mix.raise("Missing no-design snapshot config at #{config}")
    end

    Mix.shell().info("Building --no-design Corex CSS snapshot (neo/light)…")

    {_, 0} =
      System.cmd(
        "mix",
        [
          "corex.design.build",
          "--config",
          config,
          "--output",
          installer_out
        ],
        cd: design_root,
        into: IO.stream(:stdio, :line),
        stderr_to_stdout: true
      )

    Mix.shell().info("Synced no-design export → installer/priv/static/corex")
    :ok
  end

  defp raise_on_archive_build(_) do
    Mix.raise("""
    You are trying to install "corex" as an archive, which is not supported. \
    You probably meant to install "corex_new" instead
    """)
  end

  defp package do
    files = ~w(
      lib priv mix.exs package.json README.md CHANGELOG.md LICENSE .formatter.exs
      usage-rules.md usage-rules
    )

    [
      maintainers: ["Karim Semmoud"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/corex-ui/corex",
        "Website" => "https://corex.gigalixirapp.com/en",
        "Sponsor" => "https://github.com/sponsors/corex-ui"
      },
      files: files
    ]
  end

  defp docs do
    [
      main: "installation",
      source_ref: "v#{@version}",
      assets: %{"docs/images" => "images"},
      extras: [
        "guides/installation.md",
        "guides/manual_installation.md",
        "guides/design.md",
        "design/guides/modifiers.md",
        "guides/forms.md",
        "guides/tableau.md",
        "guides/tableau_theming.md",
        "guides/tableau_mode.md",
        "guides/tableau_localize.md",
        "guides/dark_mode.md",
        "guides/theming.md",
        "guides/accessibility.md",
        "guides/localize.md",
        "guides/MCP.md",
        "guides/production.md",
        "guides/configuration.md",
        "guides/update.md",
        "guides/usage_rules.md"
      ],
      formatters: ["html", "epub"],
      groups_for_modules: groups_for_modules(),
      groups_for_docs: [
        Components: &(&1[:type] == :component),
        Compounds: &(&1[:type] == :compound),
        API: &(&1[:type] == :api),
        Helpers: &(&1[:type] == :helpers)
      ],
      groups_for_extras: [
        {:Introduction,
         [
           "guides/installation.md",
           "guides/manual_installation.md",
           "guides/design.md",
           "design/guides/modifiers.md"
         ]},
        {:Guides,
         [
           "guides/forms.md",
           "guides/MCP.md",
           "guides/dark_mode.md",
           "guides/theming.md",
           "guides/accessibility.md",
           "guides/localize.md",
           "guides/production.md",
           "guides/configuration.md",
           "guides/update.md",
           "guides/usage_rules.md"
         ]},
        {"Tableau Guides",
         [
           "guides/tableau.md",
           "guides/tableau_theming.md",
           "guides/tableau_mode.md",
           "guides/tableau_localize.md"
         ]}
      ]
    ]
  end

  defp groups_for_modules do
    [
      Components: [
        Corex.Accordion,
        Corex.Action,
        Corex.AngleSlider,
        Corex.Avatar,
        Corex.Carousel,
        Corex.Checkbox,
        Corex.Clipboard,
        Corex.Code,
        Corex.Collapsible,
        Corex.ColorPicker,
        Corex.Combobox,
        Corex.DataList,
        Corex.DataTable,
        Corex.DatePicker,
        Corex.Dialog,
        Corex.Editable,
        Corex.FileUpload,
        Corex.FileUploadLive,
        Corex.FloatingPanel,
        Corex.Heroicon,
        Corex.HiddenInput,
        Corex.Layout.Heading,
        Corex.Listbox,
        Corex.Marquee,
        Corex.Menu,
        Corex.NativeInput,
        Corex.Navigate,
        Corex.NumberInput,
        Corex.Pagination,
        Corex.PasswordInput,
        Corex.PinInput,
        Corex.RadioGroup,
        Corex.Select,
        Corex.SignaturePad,
        Corex.Switch,
        Corex.Tabs,
        Corex.Timer,
        Corex.Toast,
        Corex.Toggle,
        Corex.TagsInput,
        Corex.ToggleGroup,
        Corex.Tooltip,
        Corex.TreeView
      ],
      Form: [
        Corex.FormField,
        Corex.Dataset
      ],
      Content: [
        Corex.Content,
        Corex.Content.Item,
        Corex.Image
      ],
      DataList: [
        Corex.DataList
      ],
      List: [
        Corex.List,
        Corex.List.Item
      ],
      Tree: [
        Corex.Tree,
        Corex.Tree.Item
      ],
      Flash: [
        Corex.Flash,
        Corex.Flash.Info,
        Corex.Flash.Error
      ],
      Positioning: [
        Corex.Positioning,
        Corex.Offset,
        Corex.Point
      ],
      Animation: [
        Corex.Animation,
        Corex.Animation.Scale,
        Corex.Animation.Height
      ],
      Anatomy: [
        Corex.Marquee.Anatomy.Content
      ],
      DataTable: [
        Corex.DataTable.Sort,
        Corex.DataTable.Selection
      ],
      Translations: [
        Corex.Combobox.Translation,
        Corex.ColorPicker.Translation,
        Corex.DataTable.Translation,
        Corex.DatePicker.Translation,
        Corex.Dialog.Translation,
        Corex.Editable.Translation,
        Corex.FileUpload.Translation,
        Corex.FloatingPanel.Translation,
        Corex.NumberInput.Translation,
        Corex.Pagination.Translation,
        Corex.PasswordInput.Translation,
        Corex.PinInput.Translation,
        Corex.Select.Translation,
        Corex.TagsInput.Translation,
        Corex.Timer.Translation,
        Corex.Toast.Translation
      ]
    ]
  end
end
