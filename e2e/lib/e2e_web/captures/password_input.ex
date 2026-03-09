defmodule CorexWeb.PasswordInput do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.PasswordInput
  alias Corex.Heroicon

  capture variants: [
            with_visibility_icons: %{
              class: "password-input",
              name: "password",
              label: [%{inner_block: "Password"}],
              visible_indicator: [%{inner_block: ~s(<.heroicon name="hero-eye" class="icon" />)}],
              hidden_indicator: [
                %{inner_block: ~s(<.heroicon name="hero-eye-slash" class="icon" />)}
              ]
            },
            basic: %{
              class: "password-input",
              name: "password",
              label: [%{inner_block: "Password"}],
              visible_indicator: [],
              hidden_indicator: []
            }
          ]

  defdelegate password_input(assigns), to: PasswordInput
  defdelegate heroicon(assigns), to: Heroicon
end
