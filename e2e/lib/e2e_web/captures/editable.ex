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
                %{inner_block: ~s(<.heroicon name="hero-pencil-square" class="icon" />)}
              ],
              submit_trigger: [%{inner_block: ~s(<.heroicon name="hero-check" class="icon" />)}],
              cancel_trigger: [%{inner_block: ~s(<.heroicon name="hero-x-mark" class="icon" />)}]
            }
          ]

  defdelegate editable(assigns), to: Editable
  defdelegate heroicon(assigns), to: Heroicon
end
