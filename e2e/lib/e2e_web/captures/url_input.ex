defmodule CorexWeb.UrlInput do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.UrlInput
  alias E2eWeb.CoreComponents

  capture variants: [
    with_icon: %{
      class: "url-input",
      name: "website",
      label: [%{inner_block: "Website"}],
      icon: [%{inner_block: ~s(<.icon name="hero-link" class="icon" />)}]
    },
            basic: %{
              class: "url-input",
              name: "website",
              label: [%{inner_block: "Website"}],
              icon: []
            }
          ]

  defdelegate url_input(assigns), to: UrlInput
  defdelegate icon(assigns), to: CoreComponents
end
