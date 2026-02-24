defmodule CorexWeb.RadioGroup do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.RadioGroup

  @items [
    %{label: "Option A", value: "a"},
    %{label: "Option B", value: "b"},
    %{label: "Option C", value: "c"}
  ]

  capture variants: [
            basic: %{
              class: "radio-group",
              name: "choice",
              items: @items,
              label: [%{inner_block: "Select option"}]
            },
            with_value: %{
              class: "radio-group",
              name: "choice",
              items: @items,
              value: "b",
              label: [%{inner_block: "Select option"}]
            }
          ]

  defdelegate radio_group(assigns), to: RadioGroup
end
