defmodule Corex.Design.StyleTest do
  use ExUnit.Case, async: true

  alias Corex.Design.Style

  test "to_css/2 emits declarations and nested conditions" do
    css =
      Style.to_css(".host", %{
        display: :flex,
        gap: :md,
        hover: %{opacity: 0.5}
      })

    assert css =~ ".host {"
    assert css =~ "display: flex;"
    assert css =~ "gap: var(--spacing-md);"
    assert css =~ "&:hover {"
    assert css =~ "opacity: 0.5;"
  end

  test "merge/2 deep-merges nested condition maps" do
    merged =
      Style.merge(%{hover: %{opacity: 0.25}, gap: :sm}, %{
        hover: %{opacity: 0.5},
        gap: :md
      })

    assert merged.gap == :md
    assert merged.hover.opacity == 0.5
  end
end
