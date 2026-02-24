defmodule CorexWeb.ColorPicker do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.ColorPicker

  capture variants: [
            basic: %{
              class: "color-picker",
              default_value: "#3b82f6",
              label: "Select Color",
              presets: ["#ff0000", "#00ff00", "#0000ff"]
            },
            with_alpha: %{
              class: "color-picker",
              default_value: "rgb(25, 9, 192, 0.9)",
              label: "Select Color (RGBA)",
              format: "rgba",
              presets: ["#ff0000", "#00ff00", "#0000ff", "rgb(25, 9, 192, 0.9)"]
            }
          ]

  defdelegate color_picker(assigns), to: ColorPicker
end
