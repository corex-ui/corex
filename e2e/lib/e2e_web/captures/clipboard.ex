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
              copy: [%{inner_block: ~S(<.heroicon name="hero-clipboard" />)}],
              copied: [%{inner_block: ~S(<.heroicon name="hero-check" />)}]
            }
          ]

  defdelegate clipboard(assigns), to: Clipboard
  defdelegate heroicon(assigns), to: Heroicon
end
