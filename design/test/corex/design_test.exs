defmodule Corex.DesignTest do
  use ExUnit.Case, async: false

  alias Corex.Design.Compiler
  alias Corex.Design.Recipe
  alias Corex.Design.RecipePresets
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
      assert row_css =~ "@utility row--gap-*"
      assert row_css =~ ".row.row--gap-none {"
    end

    test "icon layout recipe sizes children with ui_icon" do
      css = Recipe.to_css(Layout.get(:icon))

      assert css =~ ".icon {"
      assert css =~ "@utility icon--text-*"
      assert css =~ ".icon [data-icon]"
      assert css =~ ".icon img"
      assert css =~ "object-fit: contain"
    end

    test "component recipes emit bem selectors by default" do
      css = Recipe.to_css(Button.recipe())

      assert css =~ ".button {"
      assert css =~ "@utility button--semantic-*"
      refute css =~ "[data-button][data-button-semantic=\"accent\"]"
    end

    test "button export emits prefixed utilities and bem rules" do
      css = Recipe.to_css(Button.recipe())

      refute css =~ "@utility button--*"
      assert css =~ "@utility button--rounded-*"
      assert css =~ ".button {"
      assert css =~ "@utility button--variant-solid"
      assert css =~ "@apply visual-solid;"
      assert css =~ "@utility button--semantic-*"
    end

    test "button base merges default host paint vars and layout" do
      css = Recipe.to_css(Button.recipe())

      assert Regex.match?(
               ~r/\.button \{[^}]+\}/s,
               css
             )

      assert css =~ "--paint-bg: var(--color-base)"

      assert Regex.match?(
               ~r/\.button \{[^}]*padding-inline:/s,
               css
             )
    end

    test "layout box base merges default padding none" do
      css = Recipe.to_css(Layout.get(:box))

      assert css =~ ".box {"
      assert Regex.match?(~r/\.box \{[^}]*padding: 0;/s, css)
      assert css =~ ".box.box--padding-md {"
    end

    test "accordion export keeps slot semantic colors in components layer" do
      css = Recipe.to_css(Accordion.recipe())

      assert css =~ "@utility accordion--semantic-*"
      assert css =~ "@utility accordion--variant-solid"
      assert css =~ "@apply visual-solid"
      refute css =~ "[data-part=\"item-trigger\"][data-state=\"open\"]"
    end

    test "clipboard and marquee avoid nested host selectors" do
      clipboard_css = Recipe.to_css(Clipboard.recipe())
      marquee_css = Recipe.to_css(Marquee.recipe())

      refute clipboard_css =~ ".clipboard .clipboard"
      refute marquee_css =~ ".marquee .marquee"
      refute marquee_css =~ ",\\n"
      assert marquee_css =~ ~S(&[data-side="start"], &[data-side="end"])
      assert marquee_css =~ "animation-name: marqueeX"
    end

    test "tooltip, tabs, and tree view recipes emit key selectors" do
      tooltip_css = Recipe.to_css(Tooltip.recipe())
      tabs_css = Recipe.to_css(Tabs.recipe())
      tree_view_css = Recipe.to_css(TreeNavigation.recipe())

      assert tooltip_css =~ ".tooltip [data-scope=\"tooltip\"][data-part=\"content\"]"
      assert tooltip_css =~ "@utility tooltip--semantic-*"

      assert tabs_css =~ ".tabs [data-scope=\"tabs\"][data-part=\"item-indicator\"]"

      assert tree_view_css =~ ".tree-navigation"
    end

    test "button compound variants emit combined selectors" do
      css = Recipe.to_css(Button.recipe())

      assert css =~ ~S(.button.button--variant-ghost.button--size-sm)
    end

    test "link skip rule keeps the host modifier class" do
      css = Recipe.to_css(Link.recipe())

      assert css =~ ".link.link--skip"
      refute css =~ ".link.link--skip.link--skip"
    end

    test "link skip rule is kept in export" do
      css = Recipe.to_css(Link.recipe())

      assert css =~ ".link.link--skip"
      assert css =~ "inset-block-start: -9999px"
    end

    test "host sizing presets cover container scale" do
      steps = Scales.container() |> Keyword.keys() |> Enum.map(&to_string/1)

      for {step, _} <- RecipePresets.max_width_blocks() do
        assert to_string(step) in ["none", "full" | steps]
      end
    end
  end

  describe "Compiler tailwind bundle" do
    test "base css includes reset and typography" do
      css = Compiler.tailwind_base_css()

      assert css =~ "@layer reset, base;"
      assert css =~ ".typo h1"
      refute css =~ "body h1"
      assert css =~ "box-sizing: border-box"
    end

    test "base css includes global scrollbar styling" do
      css = Compiler.tailwind_base_css()

      assert css =~ "::-webkit-scrollbar"
      assert css =~ "::-webkit-scrollbar-track"
      assert css =~ "::-webkit-scrollbar-thumb"
      assert css =~ "var(--color-surface-control)"
      assert css =~ "var(--color-border)"
    end

    test "emitted css does not couple icon sizing to hero- utility classes" do
      base_css = Compiler.tailwind_base_css()
      recipe_css = Compiler.tailwind_recipes_css()

      combined = base_css <> recipe_css

      refute combined =~ ~S(class^="hero-")
      refute combined =~ ~S(class^='hero-')
      assert combined =~ "[data-icon]"

      priv_design = Application.app_dir(:corex, "priv/design")

      hero_selector? =
        priv_design
        |> Path.join("**/*")
        |> Path.wildcard()
        |> Enum.filter(&String.ends_with?(&1, ".css"))
        |> Enum.any?(&(&1 |> File.read!() =~ ~S(class^="hero-")))

      refute hero_selector?
    end

    test "toggle recipe sizes icons with data-icon and part-icon" do
      css =
        Recipes.components()
        |> Enum.find(&(&1.id == :toggle))
        |> Recipe.to_css()

      assert css =~ ".toggle [data-icon]"
      assert css =~ "part-icon"
    end

    test "badge recipe sizes icons with data-icon at 1em" do
      css =
        Recipes.components()
        |> Enum.find(&(&1.id == :badge))
        |> Recipe.to_css()

      assert css =~ ".badge [data-icon]"
      assert css =~ ".badge.badge--size-sm [data-icon]"
      assert css =~ ".badge.badge--size-sm"
      assert css =~ "1em !important"
      refute css =~ ".badge .icon"
      refute css =~ ".badge svg"
    end

    test "recipes css emits prefixed utilities and bem modifiers" do
      css =
        Recipes.components()
        |> Enum.find(&(&1.id == :button))
        |> Recipe.to_css()

      refute css =~ "@utility button--*"
      assert css =~ "@utility button--rounded-*"
      assert css =~ "@utility button--semantic-*"
      assert css =~ "@utility button--variant-solid"
      assert css =~ "@utility button--text-*"
      assert css =~ ".button.button--size-md {"
    end

    test "export uses max-w utility for container host sizing" do
      css =
        Recipes.components()
        |> Enum.find(&(&1.id == :accordion))
        |> Recipe.to_css()

      assert css =~ "@utility accordion--max-w-*"
      assert css =~ "max-width: --value(--container-*"
      refute css =~ ".accordion.accordion--max-w-md {"
      assert css =~ ".accordion.accordion--max-w-none {"
      assert css =~ ".accordion.accordion--w-fit {"
    end

    test "semantic colors live in components layer" do
      css =
        Recipes.components()
        |> Enum.find(&(&1.id == :button))
        |> Recipe.to_css()

      assert css =~ "@utility button--semantic-*"
      assert css =~ "@utility button--variant-solid"
      assert css =~ "--paint-bg: --value(--color-*, [color])"
    end

    test "modular export writes layered folders" do
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
        assert aggregate =~ ~S(@import "../layers/utilities.css";)
        assert aggregate =~ ~S(@import "../recipes/button.css";)

        utilities = File.read!(Path.join(tmp, "layers/utilities.css"))
        assert utilities =~ "@utility part-trigger"
        assert utilities =~ "@utility visual-solid"
        refute utilities =~ "@utility part-trigger--square"
        refute utilities =~ "@utility part-trigger--circle"
        refute utilities =~ "@utility part-trigger--ghost"

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
      assert css =~ "@utility h1--text-*"
      assert css =~ "@utility h1--semantic-*"
    end

    test "form recipe defaults to full width and md max width" do
      css = Recipe.to_css(Typo.recipe(:form))

      assert css =~ ".form {"
      assert css =~ "@utility form--max-w-*"
      assert css =~ "max-width: --value(--container-*"
      assert css =~ ".form.form--w-full"
      assert css =~ ".form.form--w-fit"
    end

    test "list recipe styles list items" do
      css = Recipe.to_css(Typo.recipe(:list))

      assert css =~ ".list {"
      assert css =~ ".list li {"
      assert css =~ ".list li:hover {"
    end

    test "typography recipes are included in recipe export" do
      css =
        Compiler.compile_recipe(Typo.recipe(:h1)) <> Compiler.compile_recipe(Typo.recipe(:form))

      assert css =~ ".h1 {"
      assert css =~ ".form {"
    end

    test "h1 recipe base uses sans stack, bold weight, and 3xl scale" do
      css = Recipe.to_css(Typo.recipe(:h1))
      base = Regex.run(~r/\.h1 \{([^}]+)\}/, css, capture: :all_but_first) |> hd()

      assert base =~ "font-family: var(--font-sans)"
      assert base =~ "font-size: var(--text-3xl)"
      assert base =~ "font-weight: var(--font-weight-bold)"
    end

    test "lead recipe base uses sans stack, normal weight, and lg scale" do
      css = Recipe.to_css(Typo.recipe(:lead))
      base = Regex.run(~r/\.lead \{([^}]+)\}/, css, capture: :all_but_first) |> hd()

      assert base =~ "font-family: var(--font-sans)"
      assert base =~ "font-size: var(--text-lg)"
      assert base =~ "font-weight: var(--font-weight-normal)"
    end

    test "typo prose css reflects harmonized h1 and lead defaults" do
      css = Corex.Design.Emit.Typography.css()
      h1 = Regex.run(~r/\.typo h1 \{([^}]+)\}/, css, capture: :all_but_first) |> hd()
      lead = Regex.run(~r/\.typo p\.display \{([^}]+)\}/, css, capture: :all_but_first) |> hd()

      assert h1 =~ "font-family: var(--font-sans)"
      assert h1 =~ "font-size: var(--text-3xl)"
      assert lead =~ "font-size: var(--text-lg)"
      assert lead =~ "font-weight: var(--font-weight-normal)"
    end
  end

  describe "dialog closed animation selectors" do
    test "export hides js/custom closed backdrop and content without duplicate host selectors" do
      css = Recipe.to_css(DialogModal.recipe())

      assert css =~
               ~S(.dialog-modal[data-animation='js'] [data-scope="dialog"][data-part="backdrop"][data-state='closed'])

      refute css =~ ~S(.dialog-modal[data-animation='js'] .dialog-modal [data-scope="dialog"])
    end
  end

  describe "accordion closed animation selectors" do
    test "export collapses js/custom closed item content without duplicate host selectors" do
      css = Recipe.to_css(Accordion.recipe())

      assert css =~
               ~S(.accordion[data-animation="js"] [data-scope="accordion"][data-part="item-content"][data-state="closed"])

      refute css =~ ~S(.accordion[data-animation="js"] .accordion [data-scope="accordion"])
    end
  end

  describe "accordion sizing" do
    test "w-fit shrink-wraps inner parts including item-trigger" do
      css = Recipe.to_css(Accordion.recipe())

      assert css =~
               ".accordion.accordion--w-fit [data-scope=\"accordion\"][data-part=\"item-trigger\"]"

      assert css =~ ".accordion.accordion--w-fit [data-scope=\"accordion\"][data-part=\"root\"]"
      assert css =~ ".accordion.accordion--w-fit"
      assert css =~ "max-width: none"
    end

    test "w-auto keeps block sizing without shrink-wrap overrides" do
      css = Recipe.to_css(Accordion.recipe())

      assert css =~ ".accordion.accordion--w-auto"
      assert css =~ "max-width: none"

      refute css =~
               ".accordion.accordion--w-auto [data-scope=\"accordion\"][data-part=\"item-trigger\"]"

      refute css =~ ".accordion.accordion--w-auto [data-scope=\"accordion\"][data-part=\"root\"]"
    end

    test "max-h variant targets item-content not host" do
      css = Recipe.to_css(Accordion.recipe())

      assert css =~ "@utility accordion--max-h-*"
      assert css =~ "max-height: --value(--container-*"

      assert css =~
               "[data-scope=\"accordion\"][data-part=\"item-content\"] {\n    max-height: --value(--container-*"

      refute css =~ ".accordion.accordion--max-h-md {\n    max-height:"
    end

    test "max-h open content box scrolls inside cap" do
      css = Recipe.to_css(Accordion.recipe())

      scroll =
        ".accordion[class*=\"--max-h-\"]:not(.accordion.accordion--max-h-none) [data-scope=\"accordion\"][data-part=\"item-content\"][data-state=\"open\"] > p"

      assert css =~ scroll
      assert css =~ "overflow-y: auto"
      assert css =~ "min-height: 0"
      assert css =~ "flex: 1 1 auto"
      assert css =~ "box-sizing: border-box"
      assert css =~ "&::-webkit-scrollbar"
      assert css =~ "background: var(--color-surface-page)"

      refute css =~
               ".accordion.accordion--max-h-md [data-scope=\"accordion\"][data-part=\"item-content\"][data-state=\"open\"] {\n    overflow-y: auto"
    end
  end

  describe "accordion horizontal layout" do
    test "size md sets horizontal column min width from container scale" do
      css = Recipe.to_css(Accordion.recipe())

      assert css =~
               ".accordion.accordion--size-md [data-scope=\"accordion\"][data-part=\"root\"][data-orientation=\"horizontal\"]"

      assert css =~ "grid-auto-columns: minmax(var(--container-3xs), 1fr)"
    end

    test "horizontal trigger allows wrapped labels" do
      css = Recipe.to_css(Accordion.recipe())

      assert css =~
               "[data-scope=\"accordion\"][data-part=\"item-trigger\"][data-orientation=\"horizontal\"]"

      assert css =~ "box-sizing: border-box"
      assert css =~ "height: 100%"

      assert css =~
               "[data-scope=\"accordion\"][data-part=\"item-trigger\"][data-orientation=\"horizontal\"] [data-scope=\"accordion\"][data-part=\"item-text\"]"

      assert css =~ "align-items: center"
      assert css =~ "text-align: center"
      assert css =~ "white-space: normal"
      assert css =~ "overflow-wrap: anywhere"
    end

    test "horizontal item-content participates in grid shrink chain" do
      css = Recipe.to_css(Accordion.recipe())

      assert css =~
               "[data-scope=\"accordion\"][data-part=\"item-content\"][data-orientation=\"horizontal\"]"

      assert css =~ "grid-row: 2"
      assert css =~ "display: flex"
      assert css =~ "min-height: 0"
      assert css =~ "min-width: 0"
      assert css =~ "width: 100%"
    end
  end

  describe "tree view closed animation selectors" do
    test "export collapses js/custom closed branch content without duplicate host selectors" do
      css = Recipe.to_css(TreeView.recipe())

      assert css =~
               ~S(.tree-view[data-animation='js'] [data-scope="tree-view"][data-part="branch-content"][data-state='closed'])

      refute css =~ ~S(.tree-view[data-animation='js'] .tree-view [data-scope="tree-view"])
    end
  end

  describe "code typography export" do
    test "pre block does not hardcode text-sm line-height" do
      css = Recipe.to_css(Code.recipe())

      refute css =~ "pre.code {\n  font-size:"
      assert css =~ "pre.code {"
      assert css =~ "@utility code--text-*"
      assert css =~ ".code.code--text-xs:is(pre)"
      assert css =~ "font-size: inherit"
    end

    test "highlight spans inherit code typography" do
      css = Recipe.to_css(Code.recipe())

      assert css =~ "pre.code code[data-part=\"content\"] span {"
      assert css =~ "font-size: inherit"
    end
  end

  describe "slot utility export" do
    test "slot recipes emit prefixed utilities and bem modifiers" do
      css =
        Select.recipe()
        |> Recipe.to_css()

      refute css =~ "@utility select--*"
      assert css =~ "@utility select--rounded-*"
      assert css =~ "@utility select--semantic-*"
      assert css =~ "[data-scope=\"select\"][data-part=\"trigger\"]"
    end

    test "slot recipes emit host sizing modifiers outside @utility" do
      css =
        Select.recipe()
        |> Recipe.to_css()

      assert css =~ ".select.select--w-fit {"
      assert css =~ "width: fit-content"
      refute css =~ "@utility select--w-fit"
    end
  end
end
