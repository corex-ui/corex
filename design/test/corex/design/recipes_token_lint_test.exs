defmodule Corex.Design.RecipesTokenLintTest do
  use ExUnit.Case, async: true

  @recipes_path Path.join([__DIR__, "../../../lib/corex/design/recipes.ex"])
  @emit_path Path.join([__DIR__, "../../../lib/corex/design/emit.ex"])

  test "recipes do not reference --ui-* host alias tokens" do
    content = File.read!(@recipes_path)

    refute String.contains?(content, "--ui-"),
           "host alias tokens in recipes (use --color-* scale tokens)"

    refute String.contains?(content, "{:palette,"),
           "legacy {:palette, _} tokens in recipes"
  end

  test "recipes and emit utilities do not reference legacy -ink color tokens" do
    recipes = File.read!(@recipes_path)
    emit = File.read!(@emit_path)

    refute Regex.match?(~r/(?<!\-\-paint)\-ink\)/, recipes),
           "legacy -ink var() strings in recipes (use --color-on-* or --paint-ink)"

    refute Regex.match?(~r/\{:color,\s*:[a-z_]+_ink\}/, recipes),
           "legacy {:color, :*_ink} atoms in recipes (use :on_* via Palette.ink_color_atom/1)"

    refute String.contains?(emit, "--color-*-ink"),
           "legacy --color-*-ink wildcards in emit utilities (use --color-* for role ink)"
  end
end
