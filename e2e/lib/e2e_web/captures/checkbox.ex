defmodule CorexWeb.Checkbox do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.Checkbox

  capture variants: [
            basic: %{
              class: "checkbox",
              name: "terms",
              label: [%{inner_block: "Accept terms"}]
            },
            checked: %{
              class: "checkbox",
              name: "terms",
              checked: true,
              label: [%{inner_block: "Accept terms"}]
            },
            disabled: %{
              class: "checkbox",
              name: "terms",
              disabled: true,
              label: [%{inner_block: "Disabled"}]
            }
          ]

  defdelegate checkbox(assigns), to: Checkbox
end
