defmodule Corex.Design.PaletteGenTest do
  use ExUnit.Case, async: true

  alias Corex.Design.Tokens.PaletteGen

  test "tonal scale stays in gamut for neo accent seed" do
    assert PaletteGen.in_gamut?("#4B4B4B")
  end

  test "contrast_fg returns a hex color" do
    {hex, ratio} = PaletteGen.contrast_fg("#4B4B4B", "#F0F0F0", 7.0)
    assert String.match?(hex, ~r/^#[0-9A-Fa-f]{6}$/)
    assert ratio >= 6.99
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
    refute File.read!(neo_light) =~ "--theme-color-ui:"
    refute File.read!(neo_light) =~ "--theme-color-accent:"
    refute File.exists?(Path.join(output, "tokens/semantic/color-scope.css"))
    assert File.read!(Path.join(output, "tokens/semantic/color.css")) =~ "@theme inline"
    refute File.read!(Path.join(output, "tokens.css")) =~ "color-scope"
    assert File.read!(neo_dim) =~ "--theme-spacing-space-md:"

    neo_entry = Path.join(output, "theme/neo.css")

    assert File.read!(neo_entry) =~ ~s(@import "../tokens/themes/neo/color/light.css";)
    assert File.read!(neo_entry) =~ ~s(@import "../tokens/themes/neo/color/dark.css";)
  end
end

defmodule Corex.Design.TokenLayerTest do
  use ExUnit.Case, async: true

  test "priv ships generated theme color files with runtime --color-* tokens" do
    root =
      :corex_design
      |> :code.priv_dir()
      |> List.to_string()
      |> Path.join("css")

    neo_light = Path.join(root, "tokens/themes/neo/color/light.css")
    color_bridge = Path.join(root, "tokens/semantic/color.css")
    color_scope = Path.join(root, "tokens/semantic/color-scope.css")

    assert File.exists?(neo_light)
    assert File.read!(neo_light) =~ "--color-ink:"
    refute File.read!(neo_light) =~ "--theme-color-accent:"
    refute File.exists?(color_scope)
    assert File.read!(color_bridge) =~ "@theme inline"
    refute File.read!(Path.join(root, "tokens.css")) =~ "color-scope"
  end
end

defmodule Corex.Design.ColorTokenNamesTest do
  use ExUnit.Case, async: true

  test "generated color tokens use public naming only" do
    tokens = Map.fetch!(Corex.Design.Tokens.Colors.generate(), {:uno, :light})

    assert Map.has_key?(tokens, "ui")
    assert Map.has_key?(tokens, "ink")
    assert Map.has_key?(tokens, "root")
    assert Map.has_key?(tokens, "layer")
    assert Map.has_key?(tokens, "accent-contrast")
    assert Map.has_key?(tokens, "accent-text")

    refute Map.has_key?(tokens, "selected")

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
      |> Enum.reject(&String.ends_with?(&1, "layout.css"))

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
end

defmodule Corex.Design.ScalesTest do
  use ExUnit.Case, async: true

  alias Corex.Design.Scales
  alias Corex.Design.Tokens.Scales, as: TokenScales

  test "rem_value trims trailing zeros" do
    assert TokenScales.rem_value(1.0) == "1rem"
    assert TokenScales.rem_value(0.875) == "0.875rem"
  end

  test "export lists trimmed dimension axes without visual or shape" do
    export = Scales.export()

    assert export[:semantic] != []
    assert Map.keys(export[:dimensions]) |> Enum.sort() == [:density, :radius, :size, :text, :weight]
    refute Map.has_key?(export, :visual)
    assert export[:container][:steps] != []
    assert export[:sizing][:steps] != []
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
    assert File.read!(border) =~ "--theme-radius-md: 0.625rem;"
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
    assert css =~ "--radius-md: var(--theme-radius-md);"
    assert css =~ "--radius-none: 0px;"
  end
end

defmodule Corex.Design.ComponentLayoutTest do
  use ExUnit.Case, async: true

  alias Corex.Design.ComponentLayout

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
      |> Enum.reject(&(&1 in ~w(keyframes layout)))
      |> Enum.sort()

    registry_ids = ComponentLayout.ids()

    for id <- css_ids do
      assert id in registry_ids, "missing ComponentLayout entry for #{id}"
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
      css = File.read!(ComponentLayout.css_path(id))
      selector = ComponentLayout.host_selector(id)

      assert ComponentLayout.parse_host_width(css, selector) == expected_width
      assert ComponentLayout.parse_host_max(css, selector) == expected_max
      assert ComponentLayout.host_width(id) == expected_width
      assert ComponentLayout.default_max(id) == expected_max
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

    assert css =~ "--container-9xs: var(--theme-container-9xs);"
    assert css =~ "--container-9xl: var(--theme-container-9xl);"
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
      assert bridge =~ "--container-#{step}: var(--theme-container-#{step});",
             "missing bridge for --container-#{step} referenced in component css"
    end
  end
end

defmodule Corex.Design.BundleFilterTest do
  use ExUnit.Case, async: false

  alias Corex.Design.ComponentLayout

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

    assert ids == ComponentLayout.ids() |> Enum.sort()
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
        [semantics: ~w(base accent), components: ~w(button)],
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
    assert entry =~ ~s(@import "./utilities.css";)
    assert entry =~ ~s(@import "./components.css";)
  end
end
