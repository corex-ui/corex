defmodule CorexWeb.Timer do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.Timer
  alias E2eWeb.CoreComponents

  capture variants: [
            basic: %{
              class: "timer",
              start_ms: 60_000,
              start_trigger: [%{inner_block: ~s(<.icon name="hero-play" class="icon" />)}],
              pause_trigger: [%{inner_block: ~s(<.icon name="hero-pause" class="icon" />)}],
              resume_trigger: [%{inner_block: ~s(<.icon name="hero-play" class="icon" />)}],
              reset_trigger: [%{inner_block: ~s(<.icon name="hero-arrow-path" class="icon" />)}]
            },
            countdown: %{
              class: "timer",
              countdown: true,
              start_ms: 90_000,
              target_ms: 0,
              auto_start: true,
              start_trigger: [%{inner_block: ~s(<.icon name="hero-play" class="icon" />)}],
              pause_trigger: [%{inner_block: ~s(<.icon name="hero-pause" class="icon" />)}],
              resume_trigger: [%{inner_block: ~s(<.icon name="hero-play" class="icon" />)}],
              reset_trigger: [%{inner_block: ~s(<.icon name="hero-arrow-path" class="icon" />)}]
            }
          ]

  defdelegate timer(assigns), to: Timer
  defdelegate icon(assigns), to: CoreComponents
end
