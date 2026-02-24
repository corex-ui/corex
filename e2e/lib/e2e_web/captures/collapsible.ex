defmodule CorexWeb.Collapsible do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.Collapsible

  capture variants: [
            basic: %{
              class: "collapsible",
              trigger: [%{inner_block: "Toggle Content"}],
              content: [%{inner_block: "This content can be collapsed and expanded."}]
            }
          ]

  defdelegate collapsible(assigns), to: Collapsible
end
