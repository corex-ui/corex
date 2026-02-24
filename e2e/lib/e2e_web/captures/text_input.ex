defmodule CorexWeb.TextInput do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.TextInput

  capture variants: [
            basic: %{
              class: "text-input",
              name: "name",
              label: [%{inner_block: "Name"}]
            },
            with_placeholder: %{
              class: "text-input",
              name: "email",
              placeholder: "you@example.com",
              label: [%{inner_block: "Email"}]
            },
            disabled: %{
              class: "text-input",
              name: "name",
              disabled: true,
              label: [%{inner_block: "Disabled"}]
            }
          ]

  defdelegate text_input(assigns), to: TextInput
end
