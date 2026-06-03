defmodule CorexWeb.Editable do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.Editable
  alias Corex.Heroicon

  capture variants: [
            basic: %{
              class: "editable",
              value: "Click to edit",
              label: [%{inner_block: "Name"}],
              edit_trigger: [
                %{inner_block: ~S(<.heroicon name="hero-pencil-square" />)}
              ],
              submit_trigger: [%{inner_block: ~S(<.heroicon name="hero-check" />)}],
              cancel_trigger: [%{inner_block: ~S(<.heroicon name="hero-x-mark" />)}]
            }
          ]

  defdelegate editable(assigns), to: Editable
  defdelegate heroicon(assigns), to: Heroicon
end
