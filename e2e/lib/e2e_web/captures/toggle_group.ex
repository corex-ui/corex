defmodule CorexWeb.ToggleGroup do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.ToggleGroup

  capture variants: [
            basic: %{
              class: "toggle-group",
              item: [
                %{value: "left", inner_block: "Left"},
                %{value: "center", inner_block: "Center"},
                %{value: "right", inner_block: "Right"}
              ]
            },
            with_value: %{
              class: "toggle-group",
              value: ["center"],
              item: [
                %{value: "left", inner_block: "Left"},
                %{value: "center", inner_block: "Center"},
                %{value: "right", inner_block: "Right"}
              ]
            }
          ]

  defdelegate toggle_group(assigns), to: ToggleGroup
end
