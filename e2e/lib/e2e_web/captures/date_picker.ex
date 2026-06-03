defmodule CorexWeb.DatePicker do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.DatePicker
  alias Corex.Heroicon

  capture variants: [
            basic: %{
              class: "date-picker",
              label: [%{inner_block: "Select a date"}],
              trigger: [%{inner_block: ~S(<.heroicon name="hero-calendar" />)}],
              prev_trigger: [
                %{inner_block: ~S(<.heroicon name="hero-chevron-left" />)}
              ],
              next_trigger: [
                %{inner_block: ~S(<.heroicon name="hero-chevron-right" />)}
              ]
            }
          ]

  defdelegate date_picker(assigns), to: DatePicker
  defdelegate heroicon(assigns), to: Heroicon
end
