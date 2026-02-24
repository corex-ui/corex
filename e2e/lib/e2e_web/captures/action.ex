defmodule CorexWeb.Action do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.Action

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
                    ~s(Text and SVG <span aria-hidden="true"><.icon name="hero-arrow-right" class="icon" /></span>)
                }
              ]
            },
            square_icon_only: %{
              class: "button button--square",
              aria_label: "Button text",
              inner_block: [
                %{
                  inner_block: ~s(<span aria-hidden="true"><.icon name="hero-arrow-right" class="icon" /></span>)
                }
              ]
            },
            square_letter: %{
              class: "button button--square",
              aria_label: "Button text",
              inner_block: [%{inner_block: "B"}]
            },
            color_accent: %{
              class: "button button--accent",
              inner_block: [%{inner_block: "Text"}]
            },
            color_brand: %{
              class: "button button--brand",
              inner_block: [%{inner_block: "Text"}]
            },
            color_alert: %{
              class: "button button--alert",
              inner_block: [%{inner_block: "Text"}]
            },
            color_info: %{
              class: "button button--info",
              inner_block: [%{inner_block: "Text"}]
            },
            color_success: %{
              class: "button button--success",
              inner_block: [%{inner_block: "Text"}]
            },
            size_sm: %{
              class: "button button--sm",
              inner_block: [%{inner_block: "Button SM"}]
            },
            size_lg: %{
              class: "button button--lg",
              inner_block: [%{inner_block: "Button LG"}]
            },
            size_xl: %{
              class: "button button--xl",
              inner_block: [%{inner_block: "Button XL"}]
            },
            shape_square_icon: %{
              class: "button button--square",
              aria_label: "Square button",
              inner_block: [
                %{
                  inner_block:
                    ~s(<span aria-hidden="true"><.icon name="hero-arrow-right" class="icon" /></span>)
                }
              ]
            },
            shape_square_letter: %{
              class: "button button--square",
              aria_label: "Square button",
              inner_block: [%{inner_block: "B"}]
            },
            shape_circle_icon: %{
              class: "button button--circle",
              aria_label: "Circle button",
              inner_block: [
                %{
                  inner_block:
                    ~s(<span aria-hidden="true"><.icon name="hero-arrow-right" class="icon" /></span>)
                }
              ]
            },
            shape_circle_letter: %{
              class: "button button--circle",
              aria_label: "Circle button",
              inner_block: [%{inner_block: "B"}]
            },
            disabled: %{
              class: "button",
              disabled: true,
              inner_block: [%{inner_block: "Text"}]
            },
            disabled_accent: %{
              class: "button button--accent",
              disabled: true,
              inner_block: [%{inner_block: "Text"}]
            }
          ]

  defdelegate action(assigns), to: Action
  defdelegate icon(assigns), to: E2eWeb.CoreComponents
end
