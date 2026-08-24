defmodule CorexWeb.Slider do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.Slider

  capture variants: [
            basic: %{
              class: "slider",
              label: [%{inner_block: "Volume"}]
            },
            with_markers: %{
              class: "slider",
              markers: true,
              marker_values: [0, 25, 50, 75, 100],
              label: [%{inner_block: "Volume"}]
            },
            with_value: %{
              class: "slider",
              value: 50,
              label: [%{inner_block: "Volume"}]
            },
            range: %{
              class: "slider",
              value: [20, 80],
              label: [%{inner_block: "Price"}]
            },
            disabled: %{
              class: "slider",
              value: 45,
              disabled: true,
              label: [%{inner_block: "Volume"}]
            },
            read_only: %{
              class: "slider",
              value: 75,
              read_only: true,
              label: [%{inner_block: "Volume"}]
            },
            invalid: %{
              class: "slider",
              value: 90,
              invalid: true,
              label: [%{inner_block: "Volume"}]
            },
            with_step: %{
              class: "slider",
              value: 25,
              step: 5,
              markers: true,
              marker_values: [0, 25, 50, 75, 100],
              label: [%{inner_block: "Volume"}]
            }
          ]

  defdelegate slider(assigns), to: Slider
end
