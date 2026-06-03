defmodule CorexWeb.FloatingPanel do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.FloatingPanel
  alias Corex.Heroicon

  capture variants: [
            basic: %{
              class: "floating-panel",
              trigger: [
                %{
                  inner_block:
                    ~S(<span data-closed>Open panel</span><span data-open>Close panel</span>)
                }
              ],
              minimize_trigger: [
                %{inner_block: ~S(<.heroicon name="hero-arrow-down-left" />)}
              ],
              maximize_trigger: [
                %{inner_block: ~S(<.heroicon name="hero-arrows-pointing-out" />)}
              ],
              default_trigger: [
                %{inner_block: ~S(<.heroicon name="hero-rectangle-stack" />)}
              ],
              close_trigger: [%{inner_block: ~S(<.heroicon name="hero-x-mark" />)}],
              content: [%{inner_block: "Panel content goes here."}]
            }
          ]

  defdelegate floating_panel(assigns), to: FloatingPanel
  defdelegate heroicon(assigns), to: Heroicon
end
