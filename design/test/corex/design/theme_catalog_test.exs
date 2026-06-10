defmodule Corex.Design.ThemeTest do
  use ExUnit.Case, async: false

  alias Corex.Design.Emit
  alias Corex.Design.Palette
  alias Corex.Design.Theme
  alias Corex.Design.Theme.Presets
  alias Corex.Design.Tokens.Colors
  alias Corex.Design.Vocabulary

  setup do
    original = CorexDesign.TestConfig.snapshot()

    on_exit(fn ->
      CorexDesign.TestConfig.restore(original)
    end)

    :ok
  end

  test "defaults use presets when themes config is absent" do
    CorexDesign.TestConfig.put([])
    assert Theme.theme_ids() == [:duo, :leo, :neo, :uno]
  end

  test "dark mode on-brand is lighter than brand fill for ghost contrast" do
    colors = Colors.generate()
    brand = colors[{:neo, :dark}]["brand"]
    on_brand = colors[{:neo, :dark}]["on-brand"]

    {:ok, fill} = Color.new(brand)
    {:ok, ink} = Color.new(on_brand)
    {:ok, fill_okl} = Color.convert(fill, Color.Oklch)
    {:ok, ink_okl} = Color.convert(ink, Color.Oklch)

    assert ink_okl.l > fill_okl.l
  end

  test "uno accent fill lightness is not inverted (~89%)" do
    colors = Colors.generate()
    accent = colors[{:uno, :light}]["accent"]
    {:ok, c} = Color.new(accent)
    {:ok, okl} = Color.convert(c, Color.Oklch)
    assert okl.l < 0.6
  end

  test "dimension scales differ per preset theme" do
    neo_md = Theme.radius(:neo) |> Keyword.fetch!(:md)
    uno_md = Theme.radius(:uno) |> Keyword.fetch!(:md)
    duo_md = Theme.radius(:duo) |> Keyword.fetch!(:md)
    leo_md = Theme.radius(:leo) |> Keyword.fetch!(:md)

    assert neo_md == "0.375rem"
    assert uno_md == "0.264rem"
    assert duo_md == "0.5175rem"
    assert leo_md == "0.205rem"
    assert duo_md > neo_md
    assert leo_md < neo_md
  end

  test "radius 2xl spread between duo and leo exceeds thirty percent" do
    duo_2xl = Theme.radius(:duo) |> Keyword.fetch!(:"2xl") |> parse_rem()
    leo_2xl = Theme.radius(:leo) |> Keyword.fetch!(:"2xl") |> parse_rem()

    ratio = duo_2xl / leo_2xl
    assert ratio > 1.3
  end

  defp parse_rem("full"), do: 9999.0

  defp parse_rem(str) do
    str
    |> String.trim_trailing("rem")
    |> String.to_float()
  end

  test "host config can override a theme radius scale" do
    themes =
      Presets.all()
      |> Map.update!(:duo, fn spec ->
        put_in(spec, [:dimensions, :radius_scale], 1.5)
      end)

    CorexDesign.TestConfig.put(themes: themes, output: "assets/css/corex.tailwind.css")

    duo_md = Theme.radius(:duo) |> Keyword.fetch!(:md)
    assert duo_md == "0.675rem"
  end

  test "rejects palette ref missing from palette map" do
    CorexDesign.TestConfig.put(
      output: "assets/css/corex.tailwind.css",
      themes: %{
        bad: %{
          palette: %{"accent" => "#111111", "neutral" => "#FFFFFF"},
          colors: %{
            light: %{
              roles: %{info: %{palette: :info, lightness: 40}}
            },
            dark: %{roles: %{}, surface: %{}, on: %{}}
          },
          dimensions: %{}
        }
      }
    )

    assert_raise ArgumentError, ~r/missing from palette/, fn ->
      Theme.resolved_themes()
    end
  end

  test "custom roles drive vocabulary and palette variants" do
    CorexDesign.TestConfig.put(
      output: "assets/css/corex.tailwind.css",
      themes: %{
        slim: %{
          palette: %{
            neutral: "#FFFFFF",
            accent: "#111111",
            marketing: "#7C3AED"
          },
          colors: %{
            light: %{
              roles: %{
                accent: %{
                  palette: :accent,
                  lightness: 40,
                  states: %{muted: 43, default: 40, hover: 36, active: 33},
                  component: true
                },
                marketing: %{
                  palette: :marketing,
                  lightness: 40,
                  states: %{muted: 43, default: 40, hover: 36, active: 33},
                  component: true
                }
              },
              surface: %{
                page: %{palette: :neutral, lightness: 98},
                control: %{palette: :neutral, lightness: 94}
              },
              on: %{page: %{palette: :neutral, against: :page, ratio: 8}},
              border: %{palette: :neutral, against: :control, ratio: 1.12},
              focus: %{palette: :neutral, against: :control, ratio: 2.2},
              shadow: %{palette: :neutral, against: :page, ratio: 1.05}
            },
            dark: %{
              roles: %{
                accent: %{
                  palette: :accent,
                  lightness: 48,
                  states: %{muted: 51, default: 48, hover: 44, active: 41},
                  component: true
                },
                marketing: %{
                  palette: :marketing,
                  lightness: 48,
                  states: %{muted: 51, default: 48, hover: 44, active: 41},
                  component: true
                }
              },
              surface: %{
                page: %{palette: :neutral, lightness: 8},
                control: %{palette: :neutral, lightness: 24}
              },
              on: %{page: %{palette: :neutral, against: :page, ratio: 12}},
              border: %{palette: :neutral, against: :control, ratio: 1.18},
              focus: %{palette: :neutral, against: :control, ratio: 2.4},
              shadow: %{palette: :neutral, against: :page, ratio: 1.2}
            }
          },
          dimensions: %{}
        }
      }
    )

    assert :marketing in Palette.color_atoms()
    assert :marketing in Vocabulary.semantic_roles()
    assert Theme.theme_ids() == [:slim]
  end

  test "merge_specs merges color overrides onto parent preset" do
    custom =
      Theme.merge_specs(Presets.neo(), %{
        palette: %{brand: "#FF0000"},
        colors: %{
          light: %{roles: %{brand: %{lightness: 50}}},
          dark: Presets.neo().colors.dark
        },
        dimensions: %{radius_scale: 1.25}
      })

    CorexDesign.TestConfig.put(
      output: "assets/css/corex.tailwind.css",
      themes: %{
        neo: Presets.neo(),
        custom: custom
      }
    )

    assert :custom in Theme.theme_ids()
    colors = Colors.generate()
    assert colors[{:custom, :light}]["brand"] != colors[{:neo, :light}]["brand"]
  end

  test "themes list selects preset subset" do
    CorexDesign.TestConfig.put(
      output: "assets/css/corex.tailwind.css",
      themes: ~w(neo leo)a
    )

    assert Theme.theme_ids() == [:leo, :neo]
    assert Theme.picker_ids() == ["leo", "neo"]
  end

  test "emitted CSS uses system font stacks for all themes" do
    CorexDesign.TestConfig.put([])
    css = Emit.Tokens.css()

    root = root_block(css)
    uno_block = theme_block(css, "uno")
    duo_block = theme_block(css, "duo")

    assert root =~ "--font-sans:"
    assert root =~ "ui-sans-serif"
    assert uno_block =~ "--font-sans: ui-sans-serif"
    assert duo_block =~ "--font-sans: ui-sans-serif"
    refute css =~ "Figtree"
    refute css =~ "Inter"
  end

  defp root_block(css) do
    [_, rest] = String.split(css, ":root {\n", parts: 2)
    [block, _] = String.split(rest, "\n}\n\n", parts: 2)
    block
  end

  defp theme_block(css, theme) do
    [_, rest] = String.split(css, ~s([data-theme="#{theme}"] {), parts: 2)
    [block, _] = String.split(rest, ~S([data-theme=), parts: 2)
    block
  end

  test "--radius default matches --radius-md per theme" do
    CorexDesign.TestConfig.put([])
    css = Emit.Tokens.css()

    neo = parse_radius_block(css, ":root")
    uno = parse_radius_block(css, ~S([data-theme="uno"]))

    assert neo["--radius"] == neo["--radius-md"]
    assert uno["--radius"] == uno["--radius-md"]
    assert uno["--radius"] != neo["--radius"]
  end

  defp parse_radius_block(css, selector) do
    [_, body] = String.split(css, selector <> " {\n", parts: 2)
    [body, _] = String.split(body, "\n}", parts: 2)

    ~r/(--radius[^:]*):\s*([^;]+);/
    |> Regex.scan(body)
    |> Map.new(fn [_full, name, value] -> {name, String.trim(value)} end)
  end
end
