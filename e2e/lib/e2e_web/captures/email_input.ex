defmodule CorexWeb.EmailInput do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.EmailInput
  alias E2eWeb.CoreComponents

  capture variants: [
            with_icon: %{
              class: "email-input",
              name: "email",
              label: [%{inner_block: "Email"}],
              icon: [%{inner_block: ~s(<.icon name="hero-envelope" class="icon" />)}]
            },
            basic: %{
              class: "email-input",
              name: "email",
              label: [%{inner_block: "Email"}],
              icon: []
            },
            with_placeholder: %{
              class: "email-input",
              name: "email",
              placeholder: "you@example.com",
              label: [%{inner_block: "Email"}],
              icon: []
            }
          ]

  defdelegate email_input(assigns), to: EmailInput
  defdelegate icon(assigns), to: CoreComponents
end
