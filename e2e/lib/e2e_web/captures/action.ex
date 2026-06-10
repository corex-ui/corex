defmodule CorexWeb.Action do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.Action
  alias Corex.Heroicon

  capture variants: [
            basic: %{
              class: "button",
              inner_block: [%{inner_block: "Text"}]
            },
            text_and_icon: %{
              class: "button",
              inner_block: [
                %{
                  inner_block:
                    ~S(Text and SVG <span aria-hidden="true"><.heroicon name="hero-arrow-right" /></span>)
                }
              ]
            },
            square_icon_only: %{
              class: "button button--shape-square",
              aria_label: "Button text",
              inner_block: [
                %{
                  inner_block:
                    ~S(<span aria-hidden="true"><.heroicon name="hero-arrow-right" /></span>)
                }
              ]
            },
            square_letter: %{
              class: "button button--shape-square",
              aria_label: "Button text",
              inner_block: [%{inner_block: "B"}]
            },
            color_accent: %{
              class: "button button--semantic-accent",
              inner_block: [%{inner_block: "Text"}]
            },
            color_brand: %{
              class: "button button--semantic-brand",
              inner_block: [%{inner_block: "Text"}]
            },
            color_alert: %{
              class: "button button--semantic-alert",
              inner_block: [%{inner_block: "Text"}]
            },
            color_info: %{
              class: "button button--semantic-info",
              inner_block: [%{inner_block: "Text"}]
            },
            color_success: %{
              class: "button button--semantic-success",
              inner_block: [%{inner_block: "Text"}]
            },
            size_sm: %{
              class: "button button--size-sm",
              inner_block: [%{inner_block: "Button SM"}]
            },
            size_lg: %{
              class: "button button--size-lg",
              inner_block: [%{inner_block: "Button LG"}]
            },
            size_xl: %{
              class: "button button--size-xl",
              inner_block: [%{inner_block: "Button XL"}]
            },
            shape_square_icon: %{
              class: "button button--shape-square",
              aria_label: "Square button",
              inner_block: [
                %{
                  inner_block:
                    ~S(<span aria-hidden="true"><.heroicon name="hero-arrow-right" /></span>)
                }
              ]
            },
            shape_square_letter: %{
              class: "button button--shape-square",
              aria_label: "Square button",
              inner_block: [%{inner_block: "B"}]
            },
            shape_circle_icon: %{
              class: "button button--shape-square button--rounded-full",
              aria_label: "Circle button",
              inner_block: [
                %{
                  inner_block:
                    ~S(<span aria-hidden="true"><.heroicon name="hero-arrow-right" /></span>)
                }
              ]
            },
            shape_circle_letter: %{
              class: "button button--shape-square button--rounded-full",
              aria_label: "Circle button",
              inner_block: [%{inner_block: "B"}]
            },
            disabled: %{
              class: "button",
              disabled: true,
              inner_block: [%{inner_block: "Text"}]
            },
            disabled_accent: %{
              class: "button button--semantic-accent",
              disabled: true,
              inner_block: [%{inner_block: "Text"}]
            }
          ]

  defdelegate action(assigns), to: Action
  defdelegate heroicon(assigns), to: Heroicon
end
