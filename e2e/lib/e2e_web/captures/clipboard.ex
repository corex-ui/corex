defmodule CorexWeb.Clipboard do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.Clipboard
  alias Corex.Heroicon

  capture variants: [
            basic: %{
              class: "clipboard",
              value: "Text to copy",
              label: [%{inner_block: "Copy to clipboard"}],
              trigger: [
                %{
                  inner_block:
                    ~s(<.heroicon name="hero-clipboard" class="icon data-copy" /><.heroicon name="hero-check" class="icon data-copied" />)
                }
              ]
            }
          ]

  defdelegate clipboard(assigns), to: Clipboard
  defdelegate heroicon(assigns), to: Heroicon
end
