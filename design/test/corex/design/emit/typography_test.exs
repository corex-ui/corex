defmodule Corex.Design.Emit.TypographyTest do
  use ExUnit.Case, async: true

  alias Corex.Design.Emit.Typography

  defp generate(typography), do: IO.iodata_to_binary(Typography.generate(:probe, typography))

  describe "generate/2" do
    test "emits only the banner when a theme declares no typography" do
      assert generate(%{}) ==
               "/**\n * Do not edit directly, this file was auto-generated.\n */\n\n"
    end

    test "scopes each selector to the theme and the typo class" do
      css = generate(%{"h1" => %{font_weight: {:weight, :bold}}})

      assert css =~ ~s|[data-theme="probe"] .typo h1:not(:where([data-scope] *)) {|
    end

    test "dasherizes property names" do
      css = generate(%{"h1" => %{letter_spacing: "0.01em", font_style: :italic}})

      assert css =~ "  letter-spacing: 0.01em;"
      assert css =~ "  font-style: italic;"
    end

    test "sorts declarations so output does not depend on map order" do
      props = %{line_height: {:leading, :tight}, font_size: {:text, :lg}, color: "red"}

      css = generate(%{"h1" => props})

      assert [color, font_size, line_height] =
               css |> String.split("\n") |> Enum.filter(&String.starts_with?(&1, "  "))

      assert color =~ "color:"
      assert font_size =~ "font-size:"
      assert line_height =~ "line-height:"
    end

    test "resolves token references to the semantic custom properties" do
      props = %{
        font_family: {:font, :display},
        font_weight: {:weight, :semibold},
        font_size: {:text, :xl},
        line_height: {:text, :xl},
        letter_spacing: {:tracking, :tight}
      }

      css = generate(%{"h1" => props})

      assert css =~ "font-family: var(--font-display);"
      assert css =~ "font-weight: var(--font-weight-semibold);"
      assert css =~ "font-size: var(--text-xl);"
      assert css =~ "line-height: var(--text-xl--line-height);"
      assert css =~ "letter-spacing: var(--tracking-tight);"
    end

    test "spells the md text step as base, matching the emitted token" do
      css = generate(%{"p" => %{font_size: {:text, :md}}})

      assert css =~ "font-size: var(--text-base);"
    end

    test "resolves a leading reference on line-height" do
      css = generate(%{"p" => %{line_height: {:leading, :relaxed}}})

      assert css =~ "line-height: var(--leading-relaxed);"
    end

    test "wraps a breakpoint key in a min-width media query" do
      props = %{"md" => %{font_size: {:text, :xl}}, font_size: {:text, :lg}}

      css = generate(%{"h1" => props})

      assert css =~ "@media (min-width: 48rem) {\n"
      assert css =~ ~s|  [data-theme="probe"] .typo h1:not(:where([data-scope] *)) {\n      font-size: var(--text-xl);\n  }\n|
    end

    test "emits a media query without a base block when only breakpoints are set" do
      css = generate(%{"h1" => %{"lg" => %{font_size: {:text, :xl}}}})

      assert css =~ "@media (min-width: 64rem) {"
      refute css =~ ~s|[data-theme="probe"] .typo h1:not(:where([data-scope] *)) {\n  font-size|
    end

    test "treats a breakpoint-named key with a scalar value as a plain property" do
      css = generate(%{"h1" => %{"md" => "8px"}})

      refute css =~ "@media"
      assert css =~ "  md: 8px;"
    end

    test "accepts atom selectors" do
      assert generate(%{h1: %{color: "red"}}) =~
               ~s|[data-theme="probe"] .typo h1:not(:where([data-scope] *)) {|
    end
  end
end
