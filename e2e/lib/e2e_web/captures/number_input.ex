defmodule CorexWeb.NumberInput do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.NumberInput
  alias E2eWeb.CoreComponents

  capture variants: [
            basic: %{
              id: "my-number-input",
              class: "number-input",
              label: [%{inner_block: "Quantity"}],
              decrement_trigger: [%{inner_block: ~s(<.icon name="hero-chevron-down" class="icon" />)}],
              increment_trigger: [%{inner_block: ~s(<.icon name="hero-chevron-up" class="icon" />)}]
            },
            scrubber: %{
              id: "scrubber-number-input",
              scrubber: true,
              class: "number-input",
              label: [%{inner_block: "Enter Number"}],
              scrubber_trigger: [%{inner_block: ~s(<.icon name="hero-arrows-up-down" class="icon rotate-90" />)}]
            }
          ]

  defdelegate number_input(assigns), to: NumberInput
  defdelegate icon(assigns), to: CoreComponents
end
