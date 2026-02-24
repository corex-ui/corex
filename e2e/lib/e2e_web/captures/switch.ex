defmodule CorexWeb.Switch do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.Switch

  capture variants: [
            basic: %{
              class: "switch",
              label: [%{inner_block: "Enable notifications"}]
            },
            checked: %{
              class: "switch",
              checked: true,
              label: [%{inner_block: "Enable notifications"}]
            },
            disabled: %{
              class: "switch",
              disabled: true,
              label: [%{inner_block: "Disabled"}]
            }
          ]

  defdelegate switch(assigns), to: Switch
end
