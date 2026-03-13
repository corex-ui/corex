defmodule Corex.MixProject do
  use Mix.Project

  @version "0.1.0-alpha.30"
  @elixir_requirement "~> 1.15"

  def project do
    [
      app: :corex,
      version: @version,
      elixir: @elixir_requirement,
      elixirc_paths: elixirc_paths(Mix.env()),
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
        threshold: 85,
        ignore_modules: [
          Mix.Tasks.Corex.Gen.Html,
          Mix.Tasks.Corex.Gen.Live,
          Corex.Flash,
          Corex.Positioning,
          Corex.Flash.Info,
          Corex.Flash.Error,
          Corex.Gettext,
          Corex.Combobox.Translation,
          Corex.ColorPicker.Translation,
          Corex.DataTable.Translation,
          Corex.Dialog.Translation,
          Corex.Editable.Translation,
          Corex.FloatingPanel.Translation,
          Corex.NumberInput.Translation,
          Corex.PasswordInput.Translation,
          Corex.PinInput.Translation,
          Corex.Select.Translation,
          Corex.Toast.Translation
        ]
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

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(:docs), do: ["lib", "installer/lib"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:jason, "~> 1.0"},
      {:phoenix, "~> 1.8.1"},
      {:phoenix_live_view, "~> 1.1.0"},
      {:gettext, "~> 1.0"},
      {:ecto, "~> 3.10"},
      {:esbuild, "~> 0.8", only: :dev},
      {:ex_doc, "~> 0.40", only: :docs},
      {:makeup, "~> 1.2", only: [:dev, :test, :docs], optional: true, override: true},
      {:makeup_elixir, "~> 1.0.1 or ~> 1.1", only: [:dev, :test, :docs], optional: true},
      {:makeup_eex, "~> 2.0", only: [:dev, :test, :docs], optional: true},
      {:makeup_syntect, "~> 0.1.0", only: [:dev, :test, :docs], optional: true},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:floki, "~> 0.38.0", only: :test},
      {:phoenix_ecto, "~> 4.0", only: :test},
      {:excoveralls, "~> 0.18", only: :test},
      {:tidewave, "~> 0.5.5", only: :dev},
      {:ex_cldr, "~> 2.47", only: :dev},
      {:ex_cldr_languages, "~> 0.3", only: :dev},
      {:bandit, "~> 1.0", only: :dev},
      {:sobelow, "~> 0.13", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases do
    [
      docs: ["docs"],
      "assets.build": [
        &copy_design_to_installer/1,
        "esbuild module",
        "esbuild cdn",
        "esbuild cdn_min",
        "esbuild main",
        "esbuild hooks"
      ],
      "assets.watch": "esbuild module --watch",
      "archive.build": &raise_on_archive_build/1,
      "pre.publish": [
        "format --check-formatted",
        "credo --strict",
        "sobelow --exit"
      ],
      tidewave:
        "run --no-halt -e 'Agent.start(fn -> Bandit.start_link(plug: Tidewave, port: 4004) end)'"
    ]
  end

  defp copy_design_to_installer(_) do
    source = Path.join([__DIR__, "priv", "design"])
    destination = Path.join([__DIR__, "installer", "templates", "corex_design"])

    if File.exists?(source) and File.dir?(source) do
      File.mkdir_p!(Path.dirname(destination))
      File.cp_r!(source, destination, force: true)
    end
  end

  defp raise_on_archive_build(_) do
    Mix.raise("""
    You are trying to install "corex" as an archive, which is not supported. \
    You probably meant to install "corex_new" instead
    """)
  end

  defp package do
    [
      maintainers: ["Karim Semmoud"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/corex-ui/corex",
        "Website" => "https://corex-ui.com"
      },
      files: ~w(
        lib priv mix.exs package.json README.md .formatter.exs
        )
    ]
  end

  defp docs do
    [
      main: "Corex",
      extras: [
        "guides/installation.md",
        "guides/manual_installation.md",
        "guides/dark_mode.md",
        "guides/theming.md",
        "guides/locale.md",
        "guides/rtl.md",
        "guides/production.md",
        "guides/troubleshooting.md"
      ],
      main: "installation",
      formatters: ["html", "epub"],
      groups_for_modules: groups_for_modules(),
      groups_for_docs: [
        Components: &(&1[:type] == :component),
        API: &(&1[:type] == :api),
        Helpers: &(&1[:type] == :helpers)
      ]
    ]
  end

  defp groups_for_modules do
    [
      Components: [
        Corex.Accordion,
        Corex.Action,
        Corex.Avatar,
        Corex.Carousel,
        Corex.Clipboard,
        Corex.Code,
        Corex.Collapsible,
        Corex.DataList,
        Corex.DataTable,
        Corex.Dialog,
        Corex.FloatingPanel,
        Corex.Heroicon,
        Corex.Listbox,
        Corex.Marquee,
        Corex.Menu,
        Corex.Navigate,
        Corex.Tabs,
        Corex.Timer,
        Corex.Toast,
        Corex.ToggleGroup,
        Corex.TreeView
      ],
      Form: [
        Corex.AngleSlider,
        Corex.Checkbox,
        Corex.ColorPicker,
        Corex.Combobox,
        Corex.DatePicker,
        Corex.Editable,
        Corex.Form,
        Corex.NativeInput,
        Corex.HiddenInput,
        Corex.NumberInput,
        Corex.PasswordInput,
        Corex.PinInput,
        Corex.RadioGroup,
        Corex.Select,
        Corex.SignaturePad,
        Corex.Switch
      ],
      Layout: [
        Corex.Layout.Heading
      ],
      Content: [
        Corex.Content,
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
        Corex.Flash.Info,
        Corex.Flash.Error
      ],
      Positioning: [
        Corex.Positioning
      ],
      DataTable: [
        Corex.DataTable.Sort,
        Corex.DataTable.Selection
      ],
      Translations: [
        Corex.Combobox.Translation,
        Corex.ColorPicker.Translation,
        Corex.DataTable.Translation,
        Corex.Dialog.Translation,
        Corex.Editable.Translation,
        Corex.FloatingPanel.Translation,
        Corex.NumberInput.Translation,
        Corex.PasswordInput.Translation,
        Corex.PinInput.Translation,
        Corex.Select.Translation,
        Corex.Toast.Translation
      ]
    ]
  end
end
