defmodule CorexWeb.SignaturePad do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.SignaturePad
  alias Corex.Heroicon

  capture variants: [
            basic: %{
              class: "signature-pad",
              label: [%{inner_block: "Sign here"}],
              clear_trigger: [%{inner_block: ~s(<.heroicon name="hero-x-mark" />)}]
            }
          ]

  defdelegate signature_pad(assigns), to: SignaturePad
  defdelegate heroicon(assigns), to: Heroicon
end
