defmodule CorexWeb.TextAreaInput do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.TextAreaInput

  capture variants: [
            basic: %{
              class: "text-area-input",
              name: "message",
              label: [%{inner_block: "Message"}]
            },
            with_placeholder: %{
              class: "text-area-input",
              name: "message",
              placeholder: "Enter your message...",
              label: [%{inner_block: "Message"}]
            }
          ]

  defdelegate text_area_input(assigns), to: TextAreaInput
end
