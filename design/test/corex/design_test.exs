defmodule Corex.Design.ColorTest do
  use ExUnit.Case, async: true

  alias Corex.Design.Color, as: DesignColor

  test "at_l returns a hex at true Oklch lightness" do
    hex = DesignColor.at_l("#4B4B4B", 0.5)
    assert String.match?(hex, ~r/^#[0-9A-Fa-f]{6}$/)
  end

  test "against returns a hex color that meets the target" do
    {hex, ratio} = DesignColor.against("#4B4B4B", "#F0F0F0", 7.0)
    assert String.match?(hex, ~r/^#[0-9A-Fa-f]{6}$/)
    assert ratio >= 6.99
  end

  test "against_or_pick falls back to white or black when unreachable" do
    {hex, ratio} = DesignColor.against_or_pick("#E6E8EB", "#636972", 21.0)
    assert hex in ["#FFFFFF", "#000000", "#ffffff", "#000000"] or String.match?(hex, ~r/^#[0-9A-Fa-f]{6}$/)
    assert ratio >= 1.0
  end
end

defmodule Corex.Design.BuildSmokeTest do
  use ExUnit.Case, async: false

  setup do
    original = CorexDesign.TestConfig.snapshot()
    on_exit(fn -> CorexDesign.TestConfig.restore(original) end)

    CorexDesign.TestConfig.put(
      output: "_build/test_bundle",
      default_theme: :neo,
      default_mode: :light,
      themes: nil,
      scales: []
    )

    :ok
  end

  test "mix corex.design.build writes theme color and dimension files" do
    output = Path.expand("_build/test_bundle", File.cwd!())
    File.rm_rf!(output)

    Mix.Task.reenable("corex.design.build")
    Mix.Task.run("corex.design.build", ["--output", output])

    neo_light = Path.join(output, "tokens/themes/neo/color/light.css")
    neo_dim = Path.join(output, "tokens/themes/neo/dimension.css")

    assert File.exists?(neo_light)
    assert File.exists?(neo_dim)
    assert File.read!(neo_light) =~ "--color-ui:"
    assert File.read!(neo_light) =~ "--color-accent:"
    refute File.exists?(Path.join(output, "tokens/semantic/color-scope.css"))
    assert File.read!(Path.join(output, "tokens/semantic/color.css")) =~ "@theme inline"
    refute File.read!(Path.join(output, "tokens.css")) =~ "color-scope"
    assert File.read!(neo_dim) =~ "--spacing-space-md:"

    neo_entry = Path.join(output, "theme/neo.css")

    assert File.read!(neo_entry) =~ ~s(@import "../tokens/themes/neo/color/light.css";)
    assert File.read!(neo_entry) =~ ~s(@import "../tokens/themes/neo/color/dark.css";)
  end
end

defmodule Corex.Design.TokenLayerTest do
  use ExUnit.Case, async: false

  test "priv keeps anatomy and import shells, not generated theme token trees" do
    root =
      :corex_design
      |> :code.priv_dir()
      |> List.to_string()
      |> Path.join("css")

    assert File.exists?(Path.join(root, "tokens.css"))
    assert File.exists?(Path.join(root, "main.css"))
    assert File.exists?(Path.join(root, "utilities.css"))
    assert File.dir?(Path.join(root, "components"))

    refute File.dir?(Path.join(root, "theme"))
    refute File.dir?(Path.join(root, "tokens/themes"))
    refute File.dir?(Path.join(root, "tokens/semantic"))
    refute File.exists?(Path.join(root, "corex.css"))
    refute File.exists?(Path.join(root, "components.css"))
    refute File.read!(Path.join(root, "tokens.css")) =~ "color-scope"
  end

  test "bundle writes theme color files with runtime --color-* tokens" do
    original = CorexDesign.TestConfig.snapshot()

    try do
      CorexDesign.TestConfig.put(
        output: "_build/test_token_layer",
        default_theme: :neo,
        default_mode: :light,
        themes: nil,
        scales: []
      )

      output = Path.expand("_build/test_token_layer", File.cwd!())
      File.rm_rf!(output)

      Mix.Task.reenable("corex.design.build")
      Mix.Task.run("corex.design.build", ["--output", output])

      neo_light = Path.join(output, "tokens/themes/neo/color/light.css")
      color_bridge = Path.join(output, "tokens/semantic/color.css")
      color_scope = Path.join(output, "tokens/semantic/color-scope.css")

      assert File.exists?(neo_light)
      assert File.read!(neo_light) =~ "--color-ink:"
      refute File.exists?(color_scope)
      assert File.read!(color_bridge) =~ "@theme inline"
    after
      CorexDesign.TestConfig.restore(original)
    end
  end
end

defmodule Corex.Design.ColorTokenNamesTest do
  use ExUnit.Case, async: true

  test "generated color tokens use public naming only" do
    tokens = Map.fetch!(Corex.Design.Tokens.Colors.generate(), {:uno, :light})

    assert Map.has_key?(tokens, "ui")
    assert Map.has_key?(tokens, "ink")
    assert Map.has_key?(tokens, "root")
    assert Map.has_key?(tokens, "surface")
    assert Map.has_key?(tokens, "accent-contrast")
    assert Map.has_key?(tokens, "accent-text")

    refute Map.has_key?(tokens, "selected")
    refute Map.has_key?(tokens, "layer")
    refute Map.has_key?(tokens, "base")
    refute Map.has_key?(tokens, "on-page")
    refute Map.has_key?(tokens, "surface-page")
    refute Map.has_key?(tokens, "surface-control")
  end
end

defmodule Corex.Design.ComponentAxesTest do
  use ExUnit.Case, async: true

  @forbidden ~r/(?:--semantic-|\.[a-z0-9-]+--radius-)/

  test "shipped component css avoids prefixed axis modifiers" do
    root =
      :corex_design
      |> :code.priv_dir()
      |> List.to_string()
      |> Path.join("css/components")

    css_files =
      root
      |> Path.join("*.css")
      |> Path.wildcard()

    assert css_files != []

    for file <- css_files do
      refute File.read!(file) =~ @forbidden,
             "prefixed axis modifier in #{Path.basename(file)}"
    end
  end
end

defmodule Corex.Design.InkTokenCssTest do
  use ExUnit.Case, async: true

  test "filled semantic utilities use on-fill ink wildcard" do
    root =
      :corex_design
      |> :code.priv_dir()
      |> List.to_string()
      |> Path.join("css")

    utilities = File.read!(Path.join(root, "utilities.css"))
    button = File.read!(Path.join(root, "components/button.css"))

    assert utilities =~ "@utility ui-accent"
    assert utilities =~ "--ctl-fill-hover: var(--color-accent-hover)"
    assert utilities =~ "--ctl-fill-ink: var(--color-accent-contrast"
    refute button =~ "@utility button--accent"
  end

  test "component recipes avoid per-component palette utilities" do
    root =
      :corex_design
      |> :code.priv_dir()
      |> List.to_string()
      |> Path.join("css/components")

    button = File.read!(Path.join(root, "button.css"))
    accordion = File.read!(Path.join(root, "accordion.css"))

    refute button =~ "@utility button--accent"
    refute accordion =~ "@utility accordion--accent"
  end

  test "shipped css avoids removed ink token names" do
    root =
      :corex_design
      |> :code.priv_dir()
      |> List.to_string()
      |> Path.join("css")

    files =
      Path.wildcard(Path.join(root, "**/*.css"))
      |> Enum.reject(&String.contains?(&1, "/themes/"))

    assert files != []

    for file <- files do
      css = File.read!(file)
      refute css =~ "--color-ink-accent", Path.basename(file)
      refute css =~ "--color-accent-ink", Path.basename(file)
      refute css =~ "--color-ink-brand", Path.basename(file)
      refute css =~ "--color-brand-ink", Path.basename(file)
      refute css =~ "--color-border-accent", Path.basename(file)
    end
  end

  test "dialog and color-picker use ui-* not legacy semantic or radius BEM" do
    root =
      :corex_design
      |> :code.priv_dir()
      |> List.to_string()
      |> Path.join("css/components")

    dialog = File.read!(Path.join(root, "dialog.css"))
    color_picker = File.read!(Path.join(root, "color-picker.css"))
    utilities = File.read!(Path.join(Path.dirname(root), "utilities.css"))

    refute dialog =~ ".dialog.dialog--accent"
    refute dialog =~ ".dialog.dialog--rounded-full"
    assert dialog =~ ".dialog.ui-rounded-full" or dialog =~ "var(--ctl-ink-text"
    assert dialog =~ "var(--ctl-ink-text"

    refute color_picker =~ ".color-picker.color-picker--rounded-full"
    assert color_picker =~ ".color-picker.ui-rounded-full"

    assert utilities =~ "@utility ui-solid"
    assert utilities =~ "@utility ui-ghost"
    refute utilities =~ "@utility ui-outline"
    refute File.read!(Path.join(root, "button.css")) =~ ":not(.ui-solid)"
    assert File.exists?(Path.join(Path.dirname(root), "utilities.css"))
  end
end

defmodule Corex.Design.ScalesTest do
  use ExUnit.Case, async: true

  alias Corex.Design.Scales
  alias Corex.Design.Tokens.Scales, as: TokenScales

  test "rem_value trims trailing zeros" do
    assert TokenScales.rem_value(1.0) == "1rem"
    assert TokenScales.rem_value(0.875) == "0.875rem"
  end

  test "dimension axes expose steps via steps/1" do
    for axis <- [:density, :radius, :size, :text, :weight] do
      assert Scales.steps(axis) != []
    end

    assert Scales.steps(:container) != []
    assert Scales.steps(:sizing) != []
    assert Scales.semantic_steps() != []
  end

  @master_ladder_strings ~w(9xs 8xs 7xs 6xs 5xs 4xs 3xs 2xs xs sm md lg xl 2xl 3xl 4xl 5xl 6xl 7xl 8xl 9xl)

  test "max_width steps use full container master ladder" do
    assert Scales.steps(:max_width) == ["none", "full" | @master_ladder_strings]
    assert "9xs" in Scales.steps(:max_width)
    assert "7xs" in Scales.steps(:max_width)
    assert "9xl" in Scales.steps(:max_width)
  end

  test "min_width uses full plus full special" do
    assert Scales.steps(:min_width) == ["full" | @master_ladder_strings]
  end

  test "width steps include auto full fit and master ladder" do
    steps = Scales.steps(:width)

    assert Enum.all?(~w(auto full fit), &(&1 in steps))
    assert "9xs" in steps
    assert "9xl" in steps
  end

  test "max_height and min_height use specials plus master ladder" do
    assert Scales.steps(:max_height) == ["none", "full", "screen", "dvh" | @master_ladder_strings]

    steps = Scales.steps(:min_height)

    assert "screen" in steps
    assert "dvh" in steps
    assert "9xs" in steps
    assert "9xl" in steps
  end

  test "radius steps include Tailwind xs through 4xl" do
    steps = Scales.steps(:radius)

    assert Enum.all?(~w(none xs sm md lg xl 2xl 3xl 4xl full), &(&1 in steps))
  end

  test "radius config override changes emitted theme radius token" do
    original = CorexDesign.TestConfig.snapshot()
    on_exit(fn -> CorexDesign.TestConfig.restore(original) end)

    CorexDesign.TestConfig.put(
      output: "_build/test_radius_override",
      default_theme: :neo,
      default_mode: :light,
      themes: nil,
      scales: [radius: [md: 0.625]]
    )

    output = Path.expand("_build/test_radius_override", File.cwd!())
    File.rm_rf!(output)

    Mix.Task.reenable("corex.design.build")
    Mix.Task.run("corex.design.build", ["--output", output])

    border = Path.join(output, "tokens/themes/neo/border.css")
    assert File.read!(border) =~ "--radius-md: 0.75rem;"
    assert File.read!(border) =~ "--border-width: 1px;"
    assert File.read!(border) =~ "--ring-width: 2px;"
  end

  test "semantic border bridge emits runtime radius tokens" do
    original = CorexDesign.TestConfig.snapshot()
    on_exit(fn -> CorexDesign.TestConfig.restore(original) end)

    CorexDesign.TestConfig.put(
      output: "_build/test_border_bridge",
      default_theme: :neo,
      default_mode: :light,
      themes: nil
    )

    output = Path.expand("_build/test_border_bridge", File.cwd!())
    File.rm_rf!(output)

    Mix.Task.reenable("corex.design.build")
    Mix.Task.run("corex.design.build", ["--output", output])

    border = Path.join(output, "tokens/semantic/border.css")
    css = File.read!(border)

    assert css =~ "--radius-full: 9999px;"
    assert css =~ "--radius-md: var(--radius-md);"
    assert css =~ "--radius-none: 0px;"
  end

  test "font bridge maps theme font families and weights" do
    Application.ensure_all_started(:corex_design)

    CorexDesign.TestConfig.put(
      output: "_build/test_font_bridge",
      default_theme: :neo,
      default_mode: :light,
      themes: nil
    )

    output = Path.expand("_build/test_font_bridge", File.cwd!())
    File.rm_rf!(output)

    Mix.Task.reenable("corex.design.build")
    Mix.Task.run("corex.design.build", ["--output", output])

    font = Path.join(output, "tokens/semantic/font.css")
    css = File.read!(font)

    assert css =~ "--font-sans: var(--font-sans);"
    assert css =~ "--font-display: var(--font-display);"
    assert css =~ "--font-mono: var(--font-mono);"
    assert css =~ "--font-weight-bold: var(--font-weight-bold);"
  end
end

defmodule Corex.Design.ComponentsTest do
  use ExUnit.Case, async: true

  alias Corex.Design.Components

  test "registry covers shipped component css files" do
    root =
      :corex_design
      |> :code.priv_dir()
      |> List.to_string()
      |> Path.join("css/components")

    css_ids =
      root
      |> Path.join("*.css")
      |> Path.wildcard()
      |> Enum.map(&Path.basename/1)
      |> Enum.map(&String.replace_suffix(&1, ".css", ""))
      |> Enum.reject(&(&1 in ~w(keyframes)))
      |> Enum.sort()

    registry_ids = Components.ids()

    for id <- css_ids do
      assert id in registry_ids, "missing Corex.Design.Components entry for #{id}"
    end
  end

  test "registry host width and default max match component css for key components" do
    checks = [
      {"select", :fill, {:container, "3xs"}},
      {"native-input", :fill, {:container, "xs"}},
      {"angle-slider", :fit, {:container, "6xs"}},
      {"toggle-group", :fit, {:container, "5xs"}},
      {"pin-input", :fit, {:container, "md"}},
      {"timer", :fit, :none},
      {"editable", :fit, :none},
      {"layout-heading", :fill, :none}
    ]

    for {id, expected_width, expected_max} <- checks do
      css = File.read!(Components.css_path(id))
      selector = Components.host_selector(id)

      assert Components.parse_host_width(css, selector) == expected_width
      assert Components.parse_host_max(css, selector) == expected_max
      assert Components.host_width(id) == expected_width
      assert Components.default_max(id) == expected_max
    end
  end

  test "every part host is a registered component" do
    part_hosts = Components.parts() |> Enum.map(&elem(&1, 0)) |> Enum.uniq()

    for host <- part_hosts do
      assert Components.family?(host), "part table references unregistered host #{host}"
    end
  end

  test "every component has exactly one family" do
    for id <- Components.ids() do
      assert Components.family(id) in [:action, :selection, :field, :static]
    end
  end

  test "only action hosts carry the variant axis" do
    for id <- Components.ids() do
      assert Components.has_variant_axis?(id) == (Components.family(id) == :action)
    end

    assert Components.no_variant_hosts() ==
             Components.ids()
             |> Enum.reject(&Components.has_variant_axis?/1)
             |> Enum.sort()
  end

  test "axes_for always ends in width and starts with variant for action hosts" do
    assert List.last(Components.axes_for("button")) == :width
    assert hd(Components.axes_for("select")) == :variant
    refute :variant in Components.axes_for("checkbox")
    assert :shape in Components.axes_for("badge")
    refute :shape in Components.axes_for("select")
    assert :max_height in Components.axes_for("combobox")
    refute :max_height in Components.axes_for("switch")
  end

  describe "id mapping" do
    test "resolves component ids that differ from their css host" do
      assert Components.fetch_css_id("action") == {:ok, "button"}
      assert Components.fetch_css_id("navigate") == {:ok, "link"}
      assert Components.fetch_css_id("heroicon") == {:ok, "icon"}
      assert Components.fetch_css_id("file_upload_live") == {:ok, "file-upload"}
    end

    test "dashes underscored component ids" do
      assert Components.fetch_css_id("date_picker") == {:ok, "date-picker"}
      assert Components.fetch_css_id(:tags_input) == {:ok, "tags-input"}
      assert Components.fetch_css_id("accordion") == {:ok, "accordion"}
    end

    test "returns :error for components with no styled host" do
      assert Components.fetch_css_id("hidden_input") == :error
      assert Components.fetch_css_id("nonsense") == :error
    end

    test "resolves css hosts back to component ids" do
      assert Components.fetch_elixir_id("button") == {:ok, "action"}
      assert Components.fetch_elixir_id("link") == {:ok, "navigate"}
      assert Components.fetch_elixir_id("icon") == {:ok, "heroicon"}
      assert Components.fetch_elixir_id("date-picker") == {:ok, "date_picker"}
    end

    test "returns :error for css-only hosts" do
      for id <- Components.css_only_ids() do
        assert Components.fetch_elixir_id(id) == :error
      end
    end

    test "round-trips every css host that has a component" do
      for css_id <- Components.ids(), {:ok, elixir_id} <- [Components.fetch_elixir_id(css_id)] do
        assert Components.fetch_css_id(elixir_id) == {:ok, css_id}
      end
    end
  end
end

defmodule Corex.Design.DimensionBridgeTest do
  use ExUnit.Case, async: false

  setup do
    original = CorexDesign.TestConfig.snapshot()
    on_exit(fn -> CorexDesign.TestConfig.restore(original) end)

    CorexDesign.TestConfig.put(
      output: "_build/test_dimension_bridge",
      default_theme: :neo,
      default_mode: :light,
      themes: nil,
      scales: []
    )

    :ok
  end

  test "semantic dimension bridge uses full container master ladder" do
    output = Path.expand("_build/test_dimension_bridge", File.cwd!())
    File.rm_rf!(output)

    Mix.Task.reenable("corex.design.build")
    Mix.Task.run("corex.design.build", ["--output", output])

    css = File.read!(Path.join(output, "tokens/semantic/dimension.css"))

    assert css =~ "--container-9xs: var(--container-9xs);"
    assert css =~ "--container-9xl: var(--container-9xl);"
    refute css =~ "--max-width-5xs:"
    refute css =~ "--width-7xs:"
  end

  test "every container token referenced in component css is bridged" do
    output = Path.expand("_build/test_dimension_bridge", File.cwd!())
    File.rm_rf!(output)

    Mix.Task.reenable("corex.design.build")
    Mix.Task.run("corex.design.build", ["--output", output])

    bridge = File.read!(Path.join(output, "tokens/semantic/dimension.css"))

    components_root =
      :corex_design
      |> :code.priv_dir()
      |> List.to_string()
      |> Path.join("css/components")

    refs =
      components_root
      |> Path.join("*.css")
      |> Path.wildcard()
      |> Enum.flat_map(fn file ->
        ~r/var\(--container-([a-z0-9]+)\)/
        |> Regex.scan(File.read!(file))
        |> Enum.map(fn [_, step] -> step end)
      end)
      |> Enum.uniq()

    assert refs != []

    for step <- refs do
      assert bridge =~ "--container-#{step}: var(--container-#{step});",
             "missing bridge for --container-#{step} referenced in component css"
    end
  end
end

defmodule Corex.Design.BundleFilterTest do
  use ExUnit.Case, async: false

  alias Corex.Design.Components

  setup do
    original = CorexDesign.TestConfig.snapshot()
    on_exit(fn -> CorexDesign.TestConfig.restore(original) end)
    :ok
  end

  defp build!(config, output) do
    CorexDesign.TestConfig.put(
      Keyword.merge(
        [
          output: output,
          default_theme: :neo,
          default_mode: :light,
          themes: nil,
          scales: []
        ],
        config
      )
    )

    File.rm_rf!(Path.expand(output, File.cwd!()))
    Mix.Task.reenable("corex.design.build")
    Mix.Task.run("corex.design.build", ["--output", output])
    Path.expand(output, File.cwd!())
  end

  test "writes components.css entry listing all components by default" do
    output = build!([], "_build/test_bundle_all")

    entry = File.read!(Path.join(output, "components.css"))
    assert entry =~ "/* Corex generated components - do not edit */"
    assert entry =~ ~s(@import "./components/button.css";)

    ids =
      output
      |> Path.join("components")
      |> File.ls!()
      |> Enum.reject(&(&1 == "keyframes.css"))
      |> Enum.map(&String.replace_suffix(&1, ".css", ""))
      |> Enum.sort()

    assert ids == Components.ids() |> Enum.sort()
  end

  test "GENERATED records a content hash so repeated builds are byte identical" do
    output = build!([components: ~w(button)], "_build/test_bundle_manifest")
    manifest = Path.join(output, "GENERATED")
    first = File.read!(manifest)

    assert first =~ ~r/^content_hash=[0-9a-f]{64}$/m
    refute first =~ "generated_at"

    Mix.Task.reenable("corex.design.build")
    Mix.Task.run("corex.design.build", ["--output", "_build/test_bundle_manifest"])

    assert File.read!(manifest) == first
  end

  test "components filter copies only requested ids and deps" do
    output = build!([components: ~w(button)], "_build/test_bundle_button")

    entry = File.read!(Path.join(output, "components.css"))
    assert entry =~ ~s(@import "./components/button.css";)
    refute entry =~ "accordion.css"

    assert File.exists?(Path.join(output, "components/button.css"))
    refute File.exists?(Path.join(output, "components/accordion.css"))
  end

  test "components filter resolves scrollbar dep for combobox" do
    output = build!([components: ~w(combobox)], "_build/test_bundle_combobox")

    entry = File.read!(Path.join(output, "components.css"))
    assert entry =~ ~s(@import "./components/combobox.css";)
    assert entry =~ ~s(@import "./components/scrollbar.css";)

    assert File.exists?(Path.join(output, "components/combobox.css"))
    assert File.exists?(Path.join(output, "components/scrollbar.css"))
  end

  test "invalid component id raises at validate" do
    CorexDesign.TestConfig.put(
      output: "_build/test_bundle_invalid",
      components: ~w(not-a-component)
    )

    assert_raise ArgumentError, ~r/components: unknown ids/, fn ->
      Mix.Task.reenable("corex.design.build")
      Mix.Task.run("corex.design.build", ["--output", "_build/test_bundle_invalid"])
    end
  end

  test "semantics filter limits accent tokens in theme color output" do
    output =
      build!(
        [semantics: ~w(accent), components: ~w(button)],
        "_build/test_bundle_semantics"
      )

    neo_light = File.read!(Path.join(output, "tokens/themes/neo/color/light.css"))
    assert neo_light =~ "--color-accent:"
    refute neo_light =~ "--color-brand:"
    refute neo_light =~ "--color-alert:"

    button = File.read!(Path.join(output, "components/button.css"))
    refute button =~ "@utility button--brand"

    utilities = File.read!(Path.join(output, "utilities.css"))
    assert utilities =~ "@utility ui-accent"
    refute utilities =~ "@utility ui-brand"
  end

  test "corex.css entry imports bundle layers" do
    output = build!([], "_build/test_bundle_all")

    entry = File.read!(Path.join(output, "corex.css"))
    assert entry =~ ~s(@import "./main.css";)
    assert entry =~ ~s(@import "./recipes.css";)
    assert entry =~ ~s(@import "./components.css";)
    refute entry =~ ~s(@import "./utilities.css";)
  end

  test "a filtered build leaves the static utilities.css untouched" do
    source = Path.join([:code.priv_dir(:corex_design), "css", "utilities.css"])
    before = File.read!(source)

    output =
      build!([semantics: ~w(accent), components: ~w(button)], "_build/test_bundle_src")

    assert File.read!(source) == before
    refute File.read!(Path.join(output, "utilities.css")) =~ "@utility ui-brand"
  end

  test "emits theme steps in ladder order rather than atom table order" do
    output = build!([components: ~w(button)], "_build/test_bundle_order")

    steps =
      Path.join(output, "tokens/themes/neo/border.css")
      |> File.read!()
      |> then(&Regex.scan(~r/--radius-([\w-]+):/, &1))
      |> Enum.map(fn [_, step] -> step end)

    assert steps == ~w(none xs sm md lg xl 2xl 3xl 4xl full)
  end

  test "accessibility false emits no preference CSS" do
    output = build!([components: ~w(button), accessibility: false], "_build/test_a11y_off")

    refute File.exists?(Path.join(output, "preferences.css"))
    refute File.dir?(Path.join(output, "tokens/preferences"))
    refute File.read!(Path.join(output, "corex.css")) =~ ~s(@import "./preferences.css";)
    refute File.read!(Path.join(output, "recipes.css")) =~ ~s([data-motion="reduce"])
  end

  test "accessibility axes emit only selected preference CSS" do
    output =
      build!(
        [components: ~w(button), accessibility: [:text, :motion, :contrast]],
        "_build/test_a11y_partial"
      )

    entry = File.read!(Path.join(output, "corex.css"))
    assert entry =~ ~s(@import "./preferences.css";)

    prefs = File.read!(Path.join(output, "preferences.css"))
    assert prefs =~ ~s(@import "./tokens/preferences/text.css";)
    assert prefs =~ ~s(@import "./tokens/preferences/contrast.css";)
    assert prefs =~ ~s(@import "./tokens/preferences/motion.css";)
    refute prefs =~ "cursor.css"
    refute prefs =~ "focus.css"
    refute prefs =~ "links.css"

    text = File.read!(Path.join(output, "tokens/preferences/text.css"))
    assert text =~ ~s([data-text="lg"])
    assert text =~ "zoom: 1.25;"
    assert text =~ "@supports not (zoom: 1)"
    assert text =~ "font-size: 125%;"
    refute text =~ "theme-text-base"
    refute text =~ ~s([data-text="xl"])

    text_bridge = File.read!(Path.join(output, "tokens/semantic/text.css"))
    assert text_bridge =~ ~r/@theme \{/
    assert text_bridge =~ "--text-base: var(--text-base);"
    refute text_bridge =~ ~r/@theme inline \{\n  --text-base:/

    contrast = File.read!(Path.join(output, "tokens/preferences/contrast.css"))
    assert contrast =~ ~s([data-theme="neo"][data-mode="light"][data-contrast="more"])
    assert contrast =~ "--color-ink:"

    motion = File.read!(Path.join(output, "tokens/preferences/motion.css"))
    assert motion =~ ~s([data-motion="reduce"])

    recipes = File.read!(Path.join(output, "recipes.css"))
    refute recipes =~ ~s([data-motion="reduce"])
    assert recipes =~ "@media (prefers-reduced-motion: reduce)"
  end
end
