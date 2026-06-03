defmodule Corex.MixProject do
  use Mix.Project

  if Mix.env() != :prod do
    for path <- :code.get_path(),
        Regex.match?(~r/corex_new-[\w\.\-]+\/ebin$/, List.to_string(path)) do
      Code.delete_path(path)
    end
  end

  @version "0.1.0"
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
        "Accessible and unstyled UI components library written in Elixir and TypeScript that integrates Zag.js state machines into the Phoenix Framework.",
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
  defp elixirc_paths_base(:docs), do: ["lib", "installer/lib"]
  defp elixirc_paths_base(:dev), do: ["lib", "test/mix"]
  defp elixirc_paths_base(_), do: ["lib"]

  defp deps do
    [
      {:jason, "~> 1.0"},
      {:phoenix, "~> 1.8.1"},
      {:phoenix_live_view, "~> 1.1.0"},
      {:gettext, "~> 1.0", only: :test},
      {:esbuild, "~> 0.8", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.40", only: [:dev, :docs], runtime: false},
      {:makeup, "~> 1.2", only: [:dev, :test, :docs], optional: true, override: true},
      {:makeup_elixir, "~> 1.0.1 or ~> 1.1", only: [:dev, :test, :docs], optional: true},
      {:makeup_eex, "~> 2.0", only: [:dev, :test, :docs], optional: true},
      {:makeup_syntect, "~> 0.1.0", only: [:dev, :test, :docs], optional: true},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:oeditus_credo, "~> 0.6.3", only: [:dev, :test], runtime: false},
      {:floki, "~> 0.38.0", only: :test},
      {:corex_new, path: "installer", only: [:docs, :test], runtime: false},
      {:phoenix_ecto, "~> 4.0", only: :test},
      {:excoveralls, "~> 0.18", only: :test},
      {:bandit, "~> 1.0", only: :dev},
      {:sobelow, "~> 0.13", only: [:dev, :test], runtime: false},
      {:ex_slop, "~> 0.4.1", only: [:dev, :test], runtime: false},
      {:tidewave, "~> 0.5", only: :dev}
    ]
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
        "corex.doc_parity --sections anatomy --components checkbox,switch,select,combobox,accordion,tabs,dialog,action,navigate",
        "credo --strict",
        "sobelow --exit"
      ],
      "release.check": ["hex.audit", "lint", "test", "assets.build"],
      "pre.publish": ["release.check"],
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
        "guides/unstyled.md",
        "guides/styled.md",
        "guides/design-config.md",
        "guides/forms.md",
        "guides/tableau.md",
        "guides/tableau_theming.md",
        "guides/tableau_mode.md",
        "guides/tableau_localize.md",
        "guides/dark_mode.md",
        "guides/theming.md",
        "guides/localize.md",
        "guides/MCP.md",
        "guides/usage_rules.md",
        "guides/production.md",
        "guides/update.md"
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
           "guides/manual_installation.md"
         ]},
        {"Design Guides",
         [
           "guides/design.md",
           "guides/unstyled.md",
           "guides/styled.md",
           "guides/design-config.md",
           "guides/theming.md",
           "guides/dark_mode.md"
         ]},
        {:Guides,
         [
           "guides/forms.md",
           "guides/MCP.md",
           "guides/usage_rules.md",
           "guides/localize.md",
           "guides/production.md",
           "guides/update.md"
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
      Layout: [
        Corex.Layout.Box,
        Corex.Layout.Container,
        Corex.Layout.Divider,
        Corex.Layout.Grid,
        Corex.Layout.Heading,
        Corex.Layout.Row,
        Corex.Layout.Spacer,
        Corex.Layout.Stack
      ],
      Typography: [
        Corex.Typography.Blockquote,
        Corex.Typography.Form,
        Corex.Typography.H1,
        Corex.Typography.H2,
        Corex.Typography.H3,
        Corex.Typography.H4,
        Corex.Typography.Kbd,
        Corex.Typography.Lead,
        Corex.Typography.ListBox,
        Corex.Typography.P,
        Corex.Typography.Small
      ],
      Form: [
        Corex.FormField
      ],
      Content: [
        Corex.Content,
        Corex.Content.Item,
        Corex.Image
      ],
      DataList: [
        Corex.Content.Item
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
