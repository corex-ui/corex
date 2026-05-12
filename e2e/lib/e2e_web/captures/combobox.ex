defmodule CorexWeb.Combobox do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.Combobox
  alias Corex.Heroicon

  @items Corex.List.new([
           %{label: "France", value: "fra"},
           %{label: "Belgium", value: "bel"},
           %{label: "Germany", value: "deu"},
           %{label: "Netherlands", value: "nld"},
           %{label: "Switzerland", value: "che"}
         ])

  capture variants: [
            basic: %{
              class: "combobox",
              placeholder: "Select a country",
              items: @items,
              empty: [%{inner_block: "No results"}],
              trigger: [%{inner_block: ~s(<.heroicon name="hero-chevron-down" />)}]
            },
            with_value: %{
              class: "combobox",
              placeholder: "Select a country",
              items: @items,
              value: ["bel"],
              empty: [%{inner_block: "No results"}],
              trigger: [%{inner_block: ~s(<.heroicon name="hero-chevron-down" />)}]
            }
          ]

  defdelegate combobox(assigns), to: Combobox
  defdelegate heroicon(assigns), to: Heroicon
end
