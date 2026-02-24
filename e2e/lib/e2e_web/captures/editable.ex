defmodule CorexWeb.Editable do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.Editable
  alias E2eWeb.CoreComponents

  capture variants: [
            basic: %{
              class: "editable",
              value: "Click to edit",
              label: [%{inner_block: "Name"}],
              edit_trigger: [%{inner_block: ~s(<.icon name="hero-pencil-square" class="icon" />)}],
              submit_trigger: [%{inner_block: ~s(<.icon name="hero-check" class="icon" />)}],
              cancel_trigger: [%{inner_block: ~s(<.icon name="hero-x-mark" class="icon" />)}]
            }
          ]

  defdelegate editable(assigns), to: Editable
  defdelegate icon(assigns), to: CoreComponents
end
