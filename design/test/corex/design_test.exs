defmodule Corex.DesignTest do
  use ExUnit.Case, async: false

  alias Corex.Design.Compiler
  alias Corex.Design.Presets
  alias Corex.Design.Recipe
  alias Corex.Design.Recipes
  alias Corex.Design.Recipes.Accordion
  alias Corex.Design.Recipes.Button
  alias Corex.Design.Recipes.Clipboard
  alias Corex.Design.Recipes.Code
  alias Corex.Design.Recipes.DialogModal
  alias Corex.Design.Recipes.Layout
  alias Corex.Design.Recipes.Link
  alias Corex.Design.Recipes.Marquee
  alias Corex.Design.Recipes.Select
  alias Corex.Design.Recipes.Tabs
  alias Corex.Design.Recipes.Tooltip
  alias Corex.Design.Recipes.TreeNavigation
  alias Corex.Design.Recipes.TreeView
  alias Corex.Design.Recipes.Typo
  alias Corex.Design.Tokens.Scales

  setup do
    original = CorexDesign.TestConfig.snapshot()
    on_exit(fn -> restore_env(original) end)
    :ok
  end

  defp restore_env(env), do: CorexDesign.TestConfig.restore(env)

  describe "Recipe.to_css/1" do
    test "layout recipes emit bem selectors by default" do
      row_css = Recipe.to_css(Layout.get(:row))

      assert row_css =~ ".row {"
      assert row_css =~ ".row.row--gap-lg {"
    end

    test "icon layout recipe sizes children with ui_icon" do
      css = Recipe.to_css(Layout.get(:icon))

      assert css =~ ".icon {"
      assert css =~ ".icon.icon--text-xs {"
      assert css =~ ".icon [data-icon]"
      assert css =~ ".icon img"
      assert css =~ "object-fit: contain"
    end

    test "component recipes emit bem selectors by default" do
      css = Recipe.to_css(Button.recipe())

      assert css =~ ".button {"
      assert css =~ ".button.button--semantic-accent {"
      refute css =~ "[data-button][data-button-semantic=\"accent\"]"
    end

    test "tailwind target emits prefixed utilities and bem rules" do
      css = Recipe.to_css(Button.recipe(), target: :tailwind)

      refute css =~ "@utility button--*"
      assert css =~ "@utility button--rounded-*"
      assert css =~ ".button {"
      assert css =~ ".button.button--variant-solid"
      assert css =~ ".button.button--semantic-accent"
    end

    test "tailwind target keeps slot semantic colors in components layer" do
      css = Recipe.to_css(Accordion.recipe(), target: :tailwind)

      assert css =~ ".accordion.accordion--semantic-accent"
      assert css =~ ".accordion.accordion--variant-solid.accordion--semantic-accent [data-scope=\"accordion\"][data-part=\"item-trigger\"]"
      assert css =~ "background-color: var(--color-accent)"
      assert css =~ "color: var(--color-accent-ink)"

      refute css =~ "[data-part=\"item-trigger\"][data-state=\"open\"]"
    end

    test "clipboard and marquee avoid nested host selectors" do
      clipboard_css = Recipe.to_css(Clipboard.recipe())
      marquee_css = Recipe.to_css(Marquee.recipe())

      refute clipboard_css =~ ".clipboard .clipboard"
      refute marquee_css =~ ".marquee .marquee"
    end

    test "tooltip, tabs, and tree view recipes emit key selectors" do
      tooltip_css = Recipe.to_css(Tooltip.recipe())
      tabs_css = Recipe.to_css(Tabs.recipe())
      tree_view_css = Recipe.to_css(TreeNavigation.recipe())

      assert tooltip_css =~ ".tooltip [data-scope=\"tooltip\"][data-part=\"content\"]"
      assert tooltip_css =~ ".tooltip.tooltip--semantic-accent"

      assert tabs_css =~ ".tabs [data-scope=\"tabs\"][data-part=\"item-indicator\"]"

      assert tree_view_css =~ ".tree-navigation"
    end

    test "button compound variants emit combined selectors" do
      css = Recipe.to_css(Button.recipe())

      assert css =~ ~s(.button.button--variant-ghost.button--size-sm)
    end

    test "link skip rule keeps the host modifier class" do
      css = Recipe.to_css(Link.recipe())

      assert css =~ ".link.link--skip"
      refute css =~ ".link.link--skip.link--skip"
    end

    test "link skip rule is kept in tailwind export" do
    css = Recipe.to_css(Link.recipe(), target: :tailwind)

    assert css =~ ".link.link--skip"
    assert css =~ "inset-block-start: -9999px"
  end

    test "host sizing presets cover container scale" do
      steps = Scales.container() |> Keyword.keys() |> Enum.map(&to_string/1)

      for {step, _} <- Presets.max_width_blocks() do
        assert to_string(step) in ["none", "full" | steps]
      end
    end
  end

  describe "Compiler.compile/0" do
    test "declares cascade layers and includes token + recipe layers with bem selectors by default" do
      css = Compiler.compile()

      assert css =~ "@layer reset, base, tokens;"
      assert css =~ "@layer tokens {"
      assert css =~ "--color-accent: #484848;"
      assert css =~ ".button {"
      assert css =~ ".button.button--semantic-accent"
      assert css =~ ".select {"
      refute css =~ "[data-button][data-button-semantic=\"accent\"]"
    end

    test "base layer includes config-driven typography element rules" do
      css = Compiler.compile()

      assert css =~ ".typo h1"
      refute css =~ "body h1"
      assert css =~ "font-family: var(--font-display)"
      assert css =~ "font-size: var(--text-2xl)"
      refute css =~ "body form, .typo form"
    end

    test "tailwind base css includes reset and typography" do
      css = Compiler.tailwind_base_css()

      assert css =~ "@layer reset, base;"
      assert css =~ ".typo h1"
      refute css =~ "body h1"
      assert css =~ "box-sizing: border-box"
    end

    test "tailwind base css includes global scrollbar styling" do
      css = Compiler.tailwind_base_css()

      assert css =~ "::-webkit-scrollbar"
      assert css =~ "::-webkit-scrollbar-track"
      assert css =~ "::-webkit-scrollbar-thumb"
      assert css =~ "var(--color-ui)"
      assert css =~ "var(--color-border)"
    end

    test "emitted css does not couple icon sizing to hero- utility classes" do
      base_css = Compiler.tailwind_base_css()
      recipe_css = Compiler.tailwind_recipes_css()

      combined = base_css <> recipe_css

      refute combined =~ ~s(class^="hero-")
      refute combined =~ ~s(class^='hero-')
      assert combined =~ "[data-icon]"

      priv_design = Path.expand("../../../priv/design", __DIR__)

      hero_selector? =
        priv_design
        |> Path.join("**/*")
        |> Path.wildcard()
        |> Enum.filter(&String.ends_with?(&1, ".css"))
        |> Enum.any?(&(&1 |> File.read!() =~ ~s(class^="hero-")))

      refute hero_selector?
    end

    test "toggle recipe sizes icons with data-icon and ui-icon" do
      css =
        Recipes.components()
        |> Enum.find(&(&1.id == :toggle))
        |> Recipe.to_css(target: :tailwind)

      assert css =~ ".toggle [data-icon]"
      assert css =~ "ui-icon"
    end

    test "badge recipe sizes icons with data-icon at 1em" do
      css =
        Recipes.components()
        |> Enum.find(&(&1.id == :badge))
        |> Recipe.to_css(target: :tailwind)

      assert css =~ ".badge [data-icon]"
      refute css =~ ".badge.badge--size-sm [data-icon]"
      assert css =~ "@utility badge--size-*"
      assert css =~ "1em !important"
      refute css =~ ".badge .icon"
      refute css =~ ".badge svg"
    end

    test "tailwind recipes css emits prefixed utilities and bem modifiers" do
      css =
        Recipes.components()
        |> Enum.find(&(&1.id == :button))
        |> Recipe.to_css(target: :tailwind)

      refute css =~ "@utility button--*"
      assert css =~ "@utility button--rounded-*"
      assert css =~ ".button.button--semantic-accent {"
      assert css =~ "@utility button--size-*"
      refute css =~ ".button.button--size-md {"
      assert css =~ ".button.button--variant-solid {"
    end

    test "tailwind export uses max-w utility for container host sizing" do
      css =
        Recipes.components()
        |> Enum.find(&(&1.id == :accordion))
        |> Recipe.to_css(target: :tailwind)

      assert css =~ "@utility accordion--max-w-*"
      assert css =~ "max-width: --value(--container-*"
      refute css =~ ".accordion.accordion--max-w-md {"
      assert css =~ ".accordion.accordion--max-w-none {"
      assert css =~ ".accordion.accordion--w-fit {"
    end

    test "tailwind semantic colors live in components layer" do
      css =
        Recipes.components()
        |> Enum.find(&(&1.id == :button))
        |> Recipe.to_css(target: :tailwind)

      assert css =~ ".button.button--semantic-accent"
      assert css =~ ".button.button--variant-solid.button--semantic-accent"
    end

    test "modular export writes base and per-recipe files" do
      tmp = Path.join(System.tmp_dir!(), "corex-design-#{System.unique_integer()}")

      try do
        Compiler.write_modular!(tmp)

        assert File.exists?(Path.join(tmp, "layers/base.css"))
        assert File.exists?(Path.join(tmp, "components/button.css"))

        button_css = File.read!(Path.join(tmp, "components/button.css"))
        assert button_css =~ ".button.button--semantic-accent"
      after
        File.rm_rf!(tmp)
      end
    end

    test "tailwind modular export writes layered folders" do
      tmp = Path.join(System.tmp_dir!(), "corex-tailwind-#{System.unique_integer()}")

      try do
        Compiler.write_tailwind_modular!(tmp)

        assert File.exists?(Path.join(tmp, "layers/theme.css"))
        assert File.exists?(Path.join(tmp, "layers/utilities.css"))
        assert File.exists?(Path.join(tmp, "recipes/button.css"))
        assert File.exists?(Path.join(tmp, "recipes/row.css"))
        assert File.exists?(Path.join(tmp, "aggregates/recipes.css"))
        assert File.exists?(Path.join(tmp, "corex.tailwind.css"))
        refute File.exists?(Path.join(tmp, "recipes/class"))
        refute File.exists?(Path.join(tmp, "recipes/data"))

        aggregate = File.read!(Path.join(tmp, "aggregates/recipes.css"))
        assert aggregate =~ ~s(@import "../layers/utilities.css";)
        assert aggregate =~ ~s(@import "../recipes/button.css";)

        utilities = File.read!(Path.join(tmp, "layers/utilities.css"))
        assert utilities =~ "@utility ui-trigger"
        refute utilities =~ "@utility ui-trigger--square"
        refute utilities =~ "@utility ui-trigger--circle"
        refute utilities =~ "@utility ui-trigger--ghost"

        row = File.read!(Path.join(tmp, "recipes/row.css"))
        assert row =~ ".row"
      after
        File.rm_rf!(tmp)
      end
    end
  end

  describe "typography recipes" do
    test "h1 recipe emits host and text axis selectors" do
      css = Recipe.to_css(Typo.recipe(:h1))

      assert css =~ ".h1 {"
      assert css =~ ".h1.h1--text-lg"
      assert css =~ ".h1.h1--semantic-accent"
    end

    test "form recipe defaults to full width and md max width" do
      css = Recipe.to_css(Typo.recipe(:form))

      assert css =~ ".form {"
      assert css =~ "max-width: var(--container-md)"
      assert css =~ ".form.form--max-w-lg"
      assert css =~ ".form.form--w-fit"
    end

    test "list recipe styles list items" do
      css = Recipe.to_css(Typo.recipe(:list))

      assert css =~ ".list {"
      assert css =~ ".list li {"
      assert css =~ ".list li:hover {"
    end

    test "typography recipes are included in compiler output" do
      css = Compiler.compile()

      assert css =~ ".h1 {"
      assert css =~ ".form {"
    end
  end

  describe "CSS export token parity" do
    test "compile uses canonical runtime tokens without bridge or namespace prefixes" do
      css = Compiler.compile()

      refute css =~ "--cx-"
      refute css =~ "--spacing-space-"
      refute css =~ "var(--spacing-space-"
      assert css =~ "gap: var(--space-sm)"
      assert css =~ "font-family: var(--font-mono)"
      assert css =~ "min-height: var(--size)"
    end
  end

  describe "dialog closed animation selectors" do
    test "plain export hides js/custom closed backdrop and content without duplicate host selectors" do
      css = Compiler.compile_recipe(DialogModal.recipe())

      assert css =~
               ~s(.dialog-modal[data-animation='js'] [data-scope="dialog"][data-part="backdrop"][data-state='closed'])

      refute css =~ ~s(.dialog-modal[data-animation='js'] .dialog-modal [data-scope="dialog"])
    end

    test "tailwind export hides js/custom closed backdrop and content without duplicate host selectors" do
      css =
        DialogModal.recipe()
        |> Recipe.to_css(target: :tailwind)

      assert css =~
               ~s(.dialog-modal[data-animation='js'] [data-scope="dialog"][data-part="backdrop"][data-state='closed'])

      refute css =~ ~s(.dialog-modal[data-animation='js'] .dialog-modal [data-scope="dialog"])
    end
  end

  describe "accordion closed animation selectors" do
    test "plain export collapses js/custom closed item content without duplicate host selectors" do
      css = Compiler.compile_recipe(Accordion.recipe())

      assert css =~
               ~s(.accordion[data-animation="js"] [data-scope="accordion"][data-part="item-content"][data-state="closed"])

      refute css =~ ~s(.accordion[data-animation="js"] .accordion [data-scope="accordion"])
    end

    test "tailwind export collapses js/custom closed item content without duplicate host selectors" do
      css =
        Accordion.recipe()
        |> Recipe.to_css(target: :tailwind)

      assert css =~
               ~s(.accordion[data-animation="js"] [data-scope="accordion"][data-part="item-content"][data-state="closed"])

      refute css =~ ~s(.accordion[data-animation="js"] .accordion [data-scope="accordion"])
    end
  end

  describe "accordion sizing" do
    test "w-fit shrink-wraps inner parts including item-trigger" do
      css = Recipe.to_css(Accordion.recipe())

      assert css =~
               ~s(.accordion.accordion--w-fit [data-scope="accordion"][data-part="item-trigger"] {\n  width: auto;)

      assert css =~
               ~s(.accordion.accordion--w-fit [data-scope="accordion"][data-part="root"] {\n  width: auto;)

      assert css =~
               ~s(.accordion.accordion--w-fit {\n  max-width: none;)
    end

    test "w-auto keeps block sizing without shrink-wrap overrides" do
      css = Recipe.to_css(Accordion.recipe())

      assert css =~ ~s(.accordion.accordion--w-auto {\n  max-width: none;)

      refute css =~
               ~s(.accordion.accordion--w-auto [data-scope="accordion"][data-part="item-trigger"] {\n  width: auto;)

      refute css =~
               ~s(.accordion.accordion--w-auto [data-scope="accordion"][data-part="root"] {\n  width: auto;)
    end

    test "max-h variant targets item-content not host" do
      css = Recipe.to_css(Accordion.recipe())

      assert css =~
               ~s(.accordion.accordion--max-h-md [data-scope="accordion"][data-part="item-content"])

      assert css =~ "max-height: var(--container-md)"

      refute css =~ ~s(.accordion.accordion--max-h-md {\n  max-height:)
    end

    test "max-h open content box scrolls inside cap" do
      css = Recipe.to_css(Accordion.recipe())

      assert css =~
               ~s(.accordion.accordion--max-h-md [data-scope="accordion"][data-part="item-content"][data-state="open"] > p {\n  overflow-y: auto;\n  min-height: 0;\n  flex: 1 1 auto;\n  box-sizing: border-box;\n  &::-webkit-scrollbar)

      assert css =~ "background: var(--color-root)"

      refute css =~
               ~s(.accordion.accordion--max-h-md [data-scope="accordion"][data-part="item-content"][data-state="open"] {\n  overflow-y: auto)
    end

    test "plain export keeps closed animation selectors after sizing changes" do
      css = Compiler.compile_recipe(Accordion.recipe())

      assert css =~
               ~s(.accordion[data-animation="js"] [data-scope="accordion"][data-part="item-content"][data-state="closed"])

      refute css =~ ~s(.accordion[data-animation="js"] .accordion [data-scope="accordion"])
    end
  end

  describe "accordion horizontal layout" do
    test "size md sets horizontal column min width from container scale" do
      css = Recipe.to_css(Accordion.recipe())

      assert css =~
               ~s(.accordion.accordion--size-md [data-scope="accordion"][data-part="root"][data-orientation="horizontal"])

      assert css =~ "grid-auto-columns: minmax(var(--container-3xs), 1fr)"
    end

    test "horizontal trigger allows wrapped labels" do
      css = Recipe.to_css(Accordion.recipe())

      assert css =~
               ~s([data-scope="accordion"][data-part="item-trigger"][data-orientation="horizontal"] {\n  box-sizing: border-box;\n  height: 100%;)

      assert css =~
               ~s([data-scope="accordion"][data-part="item-trigger"][data-orientation="horizontal"] [data-scope="accordion"][data-part="item-text"])

      assert css =~ "align-items: center"
      assert css =~ "text-align: center"
      assert css =~ "white-space: normal"
      assert css =~ "overflow-wrap: anywhere"
    end

    test "horizontal item-content participates in grid shrink chain" do
      css = Recipe.to_css(Accordion.recipe())

      assert css =~
               ~s([data-scope="accordion"][data-part="item-content"][data-orientation="horizontal"] {\n  grid-row: 2;\n  display: flex;\n  min-height: 0;\n  min-width: 0;\n  width: 100%;)
    end
  end

  describe "tree view closed animation selectors" do
    test "plain export collapses js/custom closed branch content without duplicate host selectors" do
      css = Compiler.compile_recipe(TreeView.recipe())

      assert css =~
               ~s(.tree-view[data-animation='js'] [data-scope="tree-view"][data-part="branch-content"][data-state='closed'])

      refute css =~ ~s(.tree-view[data-animation='js'] .tree-view [data-scope="tree-view"])
    end

    test "tailwind export collapses js/custom closed branch content without duplicate host selectors" do
      css =
        TreeView.recipe()
        |> Recipe.to_css(target: :tailwind)

      assert css =~
               ~s(.tree-view[data-animation='js'] [data-scope="tree-view"][data-part="branch-content"][data-state='closed'])

      refute css =~ ~s(.tree-view[data-animation='js'] .tree-view [data-scope="tree-view"])
    end
  end

  describe "code typography export parity" do
    test "pre block typography comes from host text variants only" do
      css = Compiler.compile_recipe(Code.recipe())

      assert css =~ "pre.code {"
      refute css =~ "pre.code {\n  font-size:"
      assert css =~ ".code.code--text-xs:is(pre)"
      assert css =~ "font-size: var(--text-xs)"
      assert css =~ "line-height: var(--leading-xs)"
    end

    test "tailwind pre block does not hardcode text-sm line-height" do
      css =
        Code.recipe()
        |> Recipe.to_css(target: :tailwind)

      refute css =~ "pre.code {\n  font-size:"
      assert css =~ "pre.code {"
      assert css =~ "@utility code--text-*"
      assert css =~ ".code.code--text-xs:is(pre)"
      assert css =~ "font-size: inherit"
    end

    test "highlight spans inherit code typography in both exports" do
      plain = Compiler.compile_recipe(Code.recipe())

      tailwind =
        Code.recipe()
        |> Recipe.to_css(target: :tailwind)

      assert plain =~ "pre.code code[data-part=\"content\"] span {"
      assert plain =~ "font-size: inherit"
      assert tailwind =~ "pre.code code[data-part=\"content\"] span {"
    end
  end

  describe "tailwind slot utility parity" do
    test "slot recipes emit prefixed utilities and bem modifiers" do
      css =
        Select.recipe()
        |> Recipe.to_css(target: :tailwind)

      refute css =~ "@utility select--*"
      assert css =~ "@utility select--rounded-*"
      assert css =~ ".select.select--semantic-accent"
      assert css =~ "[data-scope=\"select\"][data-part=\"trigger\"]"
    end

    test "slot recipes emit host sizing modifiers outside @utility" do
      css =
        Select.recipe()
        |> Recipe.to_css(target: :tailwind)

      assert css =~ ".select.select--w-fit {"
      assert css =~ "width: fit-content"
      refute css =~ "@utility select--w-fit"
    end
  end
end
