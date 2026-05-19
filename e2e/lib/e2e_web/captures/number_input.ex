defmodule CorexWeb.NumberInput do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.Heroicon
  alias Corex.NumberInput

  capture variants: [
            basic: %{
              id: "my-number-input",
              class: "number-input",
              label: [%{inner_block: "Quantity"}],
              decrement_trigger: [
                %{inner_block: ~S(<.heroicon name="hero-chevron-down" class="icon" />)}
              ],
              increment_trigger: [
                %{inner_block: ~S(<.heroicon name="hero-chevron-up" class="icon" />)}
              ]
            }
          ]

  defdelegate number_input(assigns), to: NumberInput
  defdelegate heroicon(assigns), to: Heroicon
end
