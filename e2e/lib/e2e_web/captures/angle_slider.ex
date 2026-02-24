defmodule CorexWeb.AngleSlider do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.AngleSlider

  capture variants: [
            basic: %{
              class: "angle-slider",
              label: [%{inner_block: "Angle"}]
            },
            with_markers: %{
              class: "angle-slider",
              marker_values: [0, 90, 180, 270],
              label: [%{inner_block: "Angle"}]
            },
            with_value: %{
              class: "angle-slider",
              value: 90,
              label: [%{inner_block: "Angle"}]
            },
            disabled: %{
              class: "angle-slider",
              value: 45,
              disabled: true,
              label: [%{inner_block: "Angle"}]
            },
            read_only: %{
              class: "angle-slider",
              value: 180,
              read_only: true,
              label: [%{inner_block: "Angle"}]
            },
            invalid: %{
              class: "angle-slider",
              value: 270,
              invalid: true,
              label: [%{inner_block: "Angle"}]
            },
            with_step: %{
              class: "angle-slider",
              value: 45,
              step: 15,
              marker_values: [0, 45, 90, 135, 180, 225, 270, 315],
              label: [%{inner_block: "Angle"}]
            }
          ]

  defdelegate angle_slider(assigns), to: AngleSlider
end
