defmodule Corex.MixProject do
  use Mix.Project

  if Mix.env() != :prod do
    for path <- :code.get_path(),
        Regex.match?(~r/corex_new-[\w\.\-]+\/ebin$/, List.to_string(path)) do
      Code.delete_path(path)
    end
  end

  @version "0.2.0"
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
      name: "Corex",
      description:
        "Accessible Phoenix UI components with Zag.js hooks. Optional Hex companions: corex_design (tokens/CSS) and corex_mcp (dev MCP tools for AI agents).",
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
      preferred_envs: [docs: :docs]
    ]
  end

  defp elixirc_paths_base(:test), do: ["lib", "test/support", "test/mix"]
  defp elixirc_paths_base(:docs), do: ["lib", "installer/lib", "mcp/lib", "design/lib"]
  defp elixirc_paths_base(:dev), do: ["lib", "test/mix"]
  defp elixirc_paths_base(_), do: ["lib"]

  defp deps do
    [
      {:phoenix, "~> 1.8.1"},
      {:phoenix_live_view, "~> 1.1"},
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
      {:corex_design, path: "design", runtime: false, only: :test},
      {:color, "~> 0.11", only: [:dev, :test, :docs], runtime: false},
      {:nimble_options, "~> 1.1", only: [:dev, :test, :docs], runtime: false},
      {:phoenix_ecto, "~> 4.0", only: :test},
      {:excoveralls, "~> 0.18", only: :test},
      {:bandit, "~> 1.0", only: :dev},
      {:sobelow, "~> 0.13", only: [:dev, :test], runtime: false},
      {:ex_slop, "~> 0.4.1", only: [:dev, :test], runtime: false},
      {:tidewave, "~> 0.5.5", only: :dev}
    ] ++ maybe_json_polyfill()
  end

  defp maybe_json_polyfill do
    if Code.ensure_loaded?(:json) do
      []
    else
      [{:json_polyfill, "~> 0.2 or ~> 1.0", only: [:dev, :test]}]
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
        "esbuild main"
      ],
      "assets.watch": "esbuild module --watch",
      "archive.build": &raise_on_archive_build/1,
      lint: [
        "format --check-formatted",
        "compile --force --warnings-as-errors",
        "compile --force --warnings-as-errors --env test",
        "corex.doc_parity --sections anatomy,form",
        "credo --strict",
        "sobelow --exit"
      ],
      "release.check": ["hex.audit", "lint", "test", "assets.build"],
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
        "guides/localize.md",
        "mcp/guides/MCP.md",
        "guides/usage_rules.md",
        "guides/production.md",
        "guides/configuration.md",
        "guides/update.md"
      ],
      formatters: ["html", "epub"],
      filter_modules: &docs_filter_modules/2,
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
           "guides/manual_installation.md"
         ]},
        {:Guides,
         [
           "guides/forms.md",
           "guides/usage_rules.md",
           "guides/localize.md",
           "guides/production.md",
           "guides/configuration.md",
           "guides/update.md"
         ]},
        {"Design Guides",
         [
           "guides/design.md",
           "design/guides/modifiers.md",
           "guides/theming.md",
           "guides/dark_mode.md"
         ]},
        {"MCP Guides", ["mcp/guides/MCP.md"]},
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

  defp docs_filter_modules(mod, _metadata) do
    if MapSet.member?(docs_allowed_modules(), mod) do
      true
    else
      raise "you forgot to add \"@moduledoc false\" or allowlist #{inspect(mod)} in mix.exs docs"
    end
  end

  defp docs_allowed_modules do
    groups_for_modules()
    |> Enum.flat_map(fn {_group, modules} -> modules end)
    |> MapSet.new()
  end

  defp groups_for_modules do
    [
      Overview: [
        Corex
      ],
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
        Corex.FormField
      ],
      Design: [
        Corex.Design,
        Corex.Design.Config,
        Corex.Design.Config.Options,
        Corex.Design.ThemeDefinition,
        Mix.Tasks.Corex.Design.Build,
        Mix.Tasks.Corex.Design.Code,
        Mix.Tasks.Corex.Design.Options,
        Mix.Tasks.Corex.Design.Validate,
        Mix.Tasks.Compile.CorexDesign
      ],
      MCP: [
        Corex.MCP
      ],
      Content: [
        Corex.Content,
        Corex.Content.Item,
        Corex.Image
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
      ],
      Generators: [
        Mix.Tasks.Corex,
        Mix.Tasks.Corex.Gen.Html,
        Mix.Tasks.Corex.Gen.Live,
        Mix.Tasks.Corex.Heroicon
      ],
      Installer: [
        Mix.Tasks.Corex.New,
        Mix.Tasks.Corex.Tableau.New,
        Mix.Tasks.Local.Corex
      ]
    ]
  end
end
