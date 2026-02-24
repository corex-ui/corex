defmodule CorexWeb.Clipboard do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.Clipboard
  alias E2eWeb.CoreComponents

  capture variants: [
            basic: %{
              class: "clipboard",
              value: "Text to copy",
              label: [%{inner_block: "Copy to clipboard"}],
              trigger: [
                %{
                  inner_block:
                    ~s(<.icon name="hero-clipboard" class="icon data-copy" /><.icon name="hero-check" class="icon data-copied" />)
                }
              ]
            }
          ]

  defdelegate clipboard(assigns), to: Clipboard
  defdelegate icon(assigns), to: CoreComponents
end
