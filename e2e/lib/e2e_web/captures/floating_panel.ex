defmodule CorexWeb.FloatingPanel do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.FloatingPanel
  alias E2eWeb.CoreComponents

  capture variants: [
            basic: %{
              class: "floating-panel",
              default_open: false,
              open_trigger: [%{inner_block: "Close panel"}],
              closed_trigger: [%{inner_block: "Open panel"}],
              minimize_trigger: [
                %{inner_block: ~s(<.icon name="hero-arrow-down-left" class="icon" />)}
              ],
              maximize_trigger: [
                %{inner_block: ~s(<.icon name="hero-arrows-pointing-out" class="icon" />)}
              ],
              default_trigger: [
                %{inner_block: ~s(<.icon name="hero-rectangle-stack" class="icon" />)}
              ],
              close_trigger: [%{inner_block: ~s(<.icon name="hero-x-mark" class="icon" />)}],
              content: [%{inner_block: "Panel content goes here."}]
            }
          ]

  defdelegate floating_panel(assigns), to: FloatingPanel
  defdelegate icon(assigns), to: CoreComponents
end
