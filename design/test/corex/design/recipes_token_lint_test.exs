defmodule Corex.Design.RecipesTokenLintTest do
  use ExUnit.Case, async: true

  @recipes_path Path.join([__DIR__, "../../../lib/corex/design/recipes.ex"])

  test "recipes do not reference --ui-* host alias tokens" do
    content = File.read!(@recipes_path)

    refute String.contains?(content, "--ui-"),
           "host alias tokens in recipes (use --color-* scale tokens)"

    refute String.contains?(content, "{:palette,"),
           "legacy {:palette, _} tokens in recipes"
  end
end
