defmodule CorexWeb.Avatar do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.Avatar

  capture variants: [
            basic: %{
              class: "avatar",
              fallback: [%{inner_block: "JD"}]
            },
            with_src: %{
              class: "avatar",
              src: "/images/avatar.png",
              fallback: [%{inner_block: "JD"}]
            }
          ]

  defdelegate avatar(assigns), to: Avatar
end
