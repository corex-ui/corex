defmodule Corex.Design.ThemeTest do
  use ExUnit.Case, async: false

  alias Corex.Design.Emit
  alias Corex.Design.Palette
  alias Corex.Design.Theme
  alias Corex.Design.Theme.Presets
  alias Corex.Design.Tokens.Colors

  setup do
    original = CorexDesign.TestConfig.snapshot()
    semantics = Application.get_env(:corex, :semantics)

    on_exit(fn ->
      CorexDesign.TestConfig.restore(original)
      restore_semantics(semantics)
    end)

    :ok
  end

  defp restore_semantics(nil), do: Application.delete_env(:corex, :semantics)
  defp restore_semantics(value), do: Application.put_env(:corex, :semantics, value)

  test "defaults use presets when themes config is absent" do
    CorexDesign.TestConfig.put([])
    assert Theme.theme_ids() == [:duo, :leo, :neo, :uno]
  end

  test "dark mode ink-brand is lighter than brand fill for ghost contrast" do
    colors = Colors.generate()
    brand = colors[{:neo, :dark}]["brand"]
    ink_brand = colors[{:neo, :dark}]["ui-ink-brand"]

    {:ok, fill} = Color.new(brand)
    {:ok, ink} = Color.new(ink_brand)
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

    CorexDesign.TestConfig.put(themes: themes)

    duo_md = Theme.radius(:duo) |> Keyword.fetch!(:md)
    assert duo_md == "0.675rem"
  end

  test "rejects semantic role not in config semantics" do
    Application.put_env(:corex, :semantics, ~W(accent brand)a)

    CorexDesign.TestConfig.put(
      themes: %{
        bad: %{
          seeds: %{"accent" => "#111111", "base" => "#FFFFFF", "info" => "#0000FF"},
          colors: %{
            light: %{
              semantic: %{info: %{bg: "info", stop: 700, ink: %{color: "base", ratio: 7}}}
            },
            dark: %{semantic: %{}, surface: %{}, ink: %{}, utility: %{}}
          },
          dimensions: %{}
        }
      }
    )

    assert_raise ArgumentError, ~r/not in config :corex semantics/, fn ->
      Theme.resolved_themes()
    end
  end

  test "custom semantics list drives palette variants" do
    Application.put_env(:corex, :semantics, ~W(accent marketing)a)

    CorexDesign.TestConfig.put(
      themes: %{
        slim: %{
          seeds: %{"accent" => "#111111", "base" => "#FFFFFF", "marketing" => "#7C3AED"},
          colors: %{
            light: %{
              semantic: %{
                accent: %{
                  bg: "accent",
                  stop: 700,
                  states: %{muted: 600, default: 700, hover: 700, active: 800},
                  ink: %{color: "base", ratio: 7}
                },
                marketing: %{
                  bg: "marketing",
                  stop: 700,
                  states: %{muted: 600, default: 700, hover: 700, active: 800},
                  ink: %{color: "base", ratio: 7}
                }
              },
              surface: %{
                root: %{color: "base", stop: 50},
                ui: %{color: "base", stop: 100}
              },
              ink: %{default: %{color: "base", ratio: 8}},
              utility: %{border: %{color: "base", ratio: 1.3}}
            },
            dark: %{
              semantic: %{
                accent: %{
                  bg: "accent",
                  stop: 600,
                  states: %{muted: 500, default: 600, hover: 600, active: 700},
                  ink: %{color: "base", ratio: 7}
                },
                marketing: %{
                  bg: "marketing",
                  stop: 600,
                  states: %{muted: 500, default: 600, hover: 600, active: 700},
                  ink: %{color: "base", ratio: 7}
                }
              },
              surface: %{
                root: %{color: "base", stop: 950},
                ui: %{color: "base", stop: 900}
              },
              ink: %{default: %{color: "base", ratio: 12}},
              utility: %{border: %{color: "base", ratio: 1.4}}
            }
          },
          dimensions: %{}
        }
      }
    )

    assert :marketing in Palette.color_atoms()
    assert Theme.theme_ids() == [:slim]
  end

  test "merge_specs merges color overrides onto parent preset" do
    acme =
      Theme.merge_specs(Presets.neo(), %{
        seeds: %{"brand" => "#FF0000"},
        colors: %{
          light: %{semantic: %{brand: %{stop: 500}}},
          dark: Presets.neo().colors.dark
        },
        dimensions: %{radius_scale: 1.25}
      })

    CorexDesign.TestConfig.put(
      themes: %{
        neo: Presets.neo(),
        acme: acme
      }
    )

    assert :acme in Theme.theme_ids()
    colors = Colors.generate()
    assert colors[{:acme, :light}]["brand"] != colors[{:neo, :light}]["brand"]
  end

  test "emitted CSS includes distinct per-theme font stacks" do
    CorexDesign.TestConfig.put([])
    css = Emit.Tokens.css()

    root = root_block(css)
    uno_block = theme_block(css, "uno")
    duo_block = theme_block(css, "duo")

    assert root =~ "--font-sans:"
    assert root =~ "ui-sans-serif"
    assert uno_block =~ "Inter"
    assert duo_block =~ "Source Sans 3"
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
