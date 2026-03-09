defmodule CorexWeb.Combobox do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.Combobox
  alias Corex.Heroicon

  @collection [
    %{label: "France", id: "fra"},
    %{label: "Belgium", id: "bel"},
    %{label: "Germany", id: "deu"},
    %{label: "Netherlands", id: "nld"},
    %{label: "Switzerland", id: "che"}
  ]

  capture variants: [
            basic: %{
              class: "combobox",
              placeholder: "Select a country",
              collection: @collection,
              empty: [%{inner_block: "No results"}],
              trigger: [%{inner_block: ~s(<.heroicon name="hero-chevron-down" />)}]
            },
            with_value: %{
              class: "combobox",
              placeholder: "Select a country",
              collection: @collection,
              value: ["bel"],
              empty: [%{inner_block: "No results"}],
              trigger: [%{inner_block: ~s(<.heroicon name="hero-chevron-down" />)}]
            }
          ]

  defdelegate combobox(assigns), to: Combobox
  defdelegate heroicon(assigns), to: Heroicon
end
