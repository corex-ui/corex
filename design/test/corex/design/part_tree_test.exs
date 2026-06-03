defmodule Corex.Design.PartTreeTest do
  use ExUnit.Case, async: true

  alias Corex.Design.PartTree
  alias Corex.Design.Token

  import Corex.Design.Token

  setup do
    on_exit(fn ->
      Application.delete_env(:corex_design, :styles)
    end)

    :ok
  end

  test "merge and unset remove overridden properties" do
    base = %{item: %{trigger: %{open: [background_color: color(:brand), color: color(:brand_ink)]}}}

    override = %{
      item: %{
        trigger: %{
          open: [color: color(:accent_ink), unset: [:background_color]]
        }
      }
    }

    merged = base |> PartTree.merge(override) |> PartTree.apply_unset()

    assert merged == %{
             item: %{
               trigger: %{
                 open: [color: color(:accent_ink)]
               }
             }
           }
  end

  test "compile accordion open trigger override css" do
    tree = %{
      item: %{
        trigger: %{
          open: [color: color(:brand_ink)]
        },
        indicator: %{
          open: [rotate: 180]
        }
      }
    }

    css =
      :accordion
      |> PartTree.compile_rules(tree)
      |> Corex.Design.Emit.Css.rules_css()

    assert css =~ "data-part=\"item-trigger\""
    assert css =~ "data-state=\"open\""
    assert css =~ "color: var(--color-brand-ink)"
    assert css =~ "transform: rotate(180deg)"
  end

  test "global styles config appends rules to accordion recipe" do
    Application.put_env(:corex_design, :styles, %{
      accordion: %{
        item: %{
          indicator: %{open: [rotate: 180]}
        }
      }
    })

    css =
      Corex.Design.Recipes.Accordion.recipe()
      |> Corex.Design.Styles.apply_recipe()
      |> Corex.Design.Recipe.to_css()

    assert css =~ "rotate(180deg)"
  end

  test "scoped css uses host id" do
    css =
      PartTree.scoped_css(:accordion, "faq", %{
        item: %{trigger: %{open: [color: color(:brand_ink)]}}
      })

    assert css =~ "#faq"
    refute css =~ "[data-accordion]"
  end

  test "per-id styles config scopes rules to host id" do
    Application.put_env(:corex_design, :styles, %{
      accordion: %{
        all: %{item: %{indicator: %{open: [rotate: 180]}}},
        instances: %{
          "faq" => %{item: %{trigger: %{open: [color: color(:brand_ink)]}}}
        }
      }
    })

    css =
      Corex.Design.Recipes.Accordion.recipe()
      |> Corex.Design.Styles.apply_recipe()
      |> Corex.Design.Recipe.to_css()

    assert css =~ "rotate(180deg)"
    assert css =~ "#faq"
    assert css =~ "data-part=\"item-trigger\""
  end

  test "host style vars from part tree" do
    vars =
      Corex.Design.PartTree.Vars.to_host_style(:accordion, %{
        item: %{
          trigger: %{
            open: [color: color(:brand_ink), unset: [:background_color]],
            focus: [text_decoration: :underline]
          }
        }
      })

    assert {"--corex-accordion-item-trigger-open-color", "var(--color-brand-ink)"} in vars
    assert {"--corex-accordion-item-trigger-open-background-color", "initial"} in vars
    assert {"--corex-accordion-item-trigger-focus-text-decoration", "underline"} in vars
  end
end
