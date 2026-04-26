defmodule E2e.DesignPaletteTest do
  use ExUnit.Case, async: true

  defp config_path do
    Path.expand("../../assets/corex/design/palette_config.json", __DIR__)
  end

  defp load! do
    E2e.DesignPalette.load_config!(config_path())
  end

  test "palette_config loads and defines eight theme modes" do
    c = load!()
    assert map_size(c["themes"]) == 8
    assert Map.has_key?(c["themes"], "neo-light")
    assert Map.has_key?(c["themes"], "neo-dark")
  end

  test "neo-light theme color JSON shape, hex values, and contrast descriptions" do
    c = load!()

    {sd, names} =
      E2e.DesignPalette.build_style_dictionary(c, "neo-light", c["themes"]["neo-light"])

    colors = sd["theme"]["color"]

    assert length(names) == 45
    assert map_size(colors) == 45

    hex? = fn v -> String.match?(v, ~r/^#[0-9a-fA-F]{6}$/i) end

    for {_k, row} <- colors do
      assert row["type"] == "color"
      assert hex?.(row["value"])
      if row["description"], do: assert(is_binary(row["description"]))
    end

    ink = colors["ink"]
    assert ink["description"] =~ ~r/\d+\.?\d*:1 contrast against ui \(#[0-9a-fA-F]{6}\)/i

    border = colors["border"]
    assert border["description"] =~ ~r/\d+\.?\d*:1 contrast against ui \(#[0-9a-fA-F]{6}\)/i

    assert colors["root"]["description"] =~ ~r/Surface root at 98% lightness/
    assert colors["ui"]["description"] =~ ~r/Surface ui default stop/
  end

  test "semantic color.json aliases reference theme.color paths" do
    c = load!()

    all =
      Enum.reduce(c["themes"], MapSet.new(), fn {_id, theme}, acc ->
        {_sd, names} = E2e.DesignPalette.build_style_dictionary(c, "x", theme)
        MapSet.union(acc, MapSet.new(names))
      end)

    sem = E2e.DesignPalette.semantic_aliases(all)
    assert map_size(sem["color"]) == MapSet.size(all)

    for name <- MapSet.to_list(all) do
      row = sem["color"][name]
      assert row["type"] == "color"
      assert row["value"] == "{theme.color.#{name}}"
    end
  end

  test "run writes theme files and semantic color under design tokens" do
    root = Path.expand("../..", __DIR__)
    design = Path.join(root, "assets/corex/design")

    assert :ok == E2e.DesignPalette.run(design_dir: design)

    neo =
      Path.join(design, "tokens/themes/neo/color/light.json") |> File.read!() |> Jason.decode!()

    assert neo["theme"]["color"]["ink"]["type"] == "color"

    sem = Path.join(design, "tokens/semantic/color.json") |> File.read!() |> Jason.decode!()
    assert sem["color"]["ink"]["value"] == "{theme.color.ink}"
  end
end
