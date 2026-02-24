defmodule CorexWeb.PinInput do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.PinInput

  capture variants: [
            basic: %{
              class: "pin-input",
              name: "pin",
              count: 4,
              label: [%{inner_block: "Enter PIN"}]
            },
            otp: %{
              class: "pin-input",
              name: "otp",
              count: 6,
              type: "alphanumeric",
              label: [%{inner_block: "Enter code"}]
            }
          ]

  defdelegate pin_input(assigns), to: PinInput
end
