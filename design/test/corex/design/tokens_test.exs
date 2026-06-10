defmodule Corex.Design.TokensTest do
  use ExUnit.Case, async: false

  alias Corex.Design.Emit
  alias Corex.Design.Emit.Tokens, as: Var
  alias Corex.Design.Theme
  alias Corex.Design.Tokens.Scales

  setup do
    original = CorexDesign.TestConfig.snapshot()
    on_exit(fn -> restore_env(original) end)
    :ok
  end

  defp restore_env(env), do: CorexDesign.TestConfig.restore(env)

  defp parse_block(css, selector) do
    [_, body] = String.split(css, selector <> " {\n", parts: 2)
    [body, _] = String.split(body, "\n}", parts: 2)

    ~r/(--[\w-]+):\s*([^;]+);/
    |> Regex.scan(body)
    |> Map.new(fn [_full, name, value] -> {name, String.trim(value)} end)
  end

  describe "Scales formatting" do
    test "rem_value trims trailing zeros and appends rem" do
      assert Scales.rem_value(1.0) == "1rem"
      assert Scales.rem_value(0.875) == "0.875rem"
      assert Scales.rem_value(0.5) == "0.5rem"
    end

    test "font_stack quotes only multi-word members" do
      stack = Scales.font_stack(["ui-sans-serif", "system-ui", "Apple Color Emoji"])
      assert stack == "ui-sans-serif, system-ui, 'Apple Color Emoji'"
    end
  end

  describe "Var" do
    test "name and ref build dashed custom properties" do
      assert Var.name([:space, :sm]) == "--spacing-sm"
      assert Var.name([:size, :md]) == "--spacing-control-md"
      assert Var.name([:leading, :"2xl"]) == "--leading-2xl"
      assert Var.ref([:"font-weight", :normal]) == "var(--font-weight-normal)"
    end

    test "font_stacks_for merges theme overrides onto scale defaults" do
      CorexDesign.TestConfig.put([])

      stacks = Var.font_stacks_for(:neo)

      assert Keyword.has_key?(stacks, :sans)
      assert Keyword.has_key?(stacks, :display)
      assert Keyword.has_key?(stacks, :mono)
      assert Keyword.has_key?(stacks, :code)
    end
  end

  describe "Themes" do
    test "default theme/mode come from config" do
      assert Theme.default_theme() == :neo
      assert Theme.default_mode() == :light

      CorexDesign.TestConfig.put(
        output: "assets/css/corex.tailwind.css",
        default_theme: :uno,
        default_mode: :dark
      )
      assert Theme.default_theme() == :uno
      assert Theme.default_mode() == :dark
    end

    test "dimension scales scale by the per-theme factor" do
      assert Theme.space(:neo) |> Keyword.fetch!(:lg) == "calc(var(--spacing) * 4)"
      assert Theme.size(:neo) |> Keyword.fetch!(:md) == "calc(var(--spacing) * 10)"

      neo_text = Theme.text(:neo) |> Keyword.fetch!(:base)
      uno_text = Theme.text(:uno) |> Keyword.fetch!(:base)
      assert neo_text == "1rem"
      assert uno_text == "0.92rem"
    end

    test "radius keywords resolve to fixed values" do
      radius = Theme.radius(:neo)
      assert Keyword.fetch!(radius, :none) == "0"
      assert Keyword.fetch!(radius, :full) == "9999px"
    end
  end

  describe "Emit.Tokens.css/0" do
    test ":root carries static scale, default dimensions, and default colors" do
      CorexDesign.TestConfig.put([])
      css = Emit.Tokens.css()
      root = parse_block(css, ":root")

      assert root["--leading-base"] == "1.5"
      assert root["--font-weight-normal"] == "400"
      assert root["--spacing"] == "0.25rem"
      assert root["--spacing-lg"] == "calc(var(--spacing) * 4)"
      assert root["--spacing-md"] == "calc(var(--spacing) * 3)"
      assert root["--spacing-control-md"] == "calc(var(--spacing) * 10)"
      assert root["--radius"] == "0.375rem"
      assert root["--radius-md"] == "0.375rem"
      assert root["--radius-full"] == "9999px"
      assert Map.has_key?(root, "--color-on-page")
      assert Map.has_key?(root, "--color-accent")
      assert Map.has_key?(root, "--font-sans")
      assert Map.has_key?(root, "--font-display")
      assert Map.has_key?(root, "--font-mono")
      assert Map.has_key?(root, "--font-code")
    end

    test "non-default themes get dimension blocks; non-default theme/mode pairs get color blocks" do
      CorexDesign.TestConfig.put([])
      css = Emit.Tokens.css()

      dt = Theme.default_theme()
      dm = Theme.default_mode()

      assert css =~ ~S([data-theme="uno"] {)
      refute css =~ ~S([data-theme="neo"] {\n)

      for theme <- Theme.themes(), mode <- Theme.modes(), {theme, mode} != {dt, dm} do
        assert css =~ ~s([data-theme="#{theme}"][data-mode="#{mode}"] {)
      end

      refute css =~ ~s([data-theme="#{dt}"][data-mode="#{dm}"] {)

      refute css =~ "data-accessibility"
    end
  end

  describe "Emit.Theme.css/0" do
    test "includes the Corex runtime token layer" do
      CorexDesign.TestConfig.put([])
      css = Emit.Theme.css()
      root = parse_block(css, ":root")

      assert root["--spacing-lg"] == "calc(var(--spacing) * 4)"
      assert root["--color-on-page"]
    end

    test "@theme inline aliases tailwind namespaces to runtime variables" do
      CorexDesign.TestConfig.put([])
      css = Emit.Theme.css()
      theme = parse_block(css, "@theme inline")

      assert theme["--spacing-lg"] == "var(--spacing-lg)"
      assert theme["--spacing"] == "var(--spacing)"
      assert theme["--spacing-control-md"] == "var(--spacing-control-md)"
      assert theme["--font-weight-bold"] == "var(--font-weight-bold)"
      assert theme["--color-on-page"] == "var(--color-on-page)"
      assert theme["--font-display"] == "var(--font-display)"
      assert theme["--font-mono"] == "var(--font-mono)"
    end
  end
end
