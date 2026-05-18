defmodule CorexWeb.Listbox do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.Heroicon
  alias Corex.Listbox

  @collection Corex.List.new([
                %{label: "France", value: "fra", disabled: true},
                %{label: "Belgium", value: "bel"},
                %{label: "Germany", value: "deu"},
                %{label: "Netherlands", value: "nld"},
                %{label: "Switzerland", value: "che"},
                %{label: "Austria", value: "aut"}
              ])

  @grouped_collection Corex.List.new([
                        %{label: "France", value: "fra", group: "Europe"},
                        %{label: "Belgium", value: "bel", group: "Europe"},
                        %{label: "Germany", value: "deu", group: "Europe"},
                        %{label: "Netherlands", value: "nld", group: "Europe"},
                        %{label: "Switzerland", value: "che", group: "Europe"},
                        %{label: "Austria", value: "aut", group: "Europe"},
                        %{label: "Japan", value: "jpn", group: "Asia"},
                        %{label: "China", value: "chn", group: "Asia"},
                        %{label: "South Korea", value: "kor", group: "Asia"},
                        %{label: "USA", value: "usa", group: "North America"},
                        %{label: "Canada", value: "can", group: "North America"},
                        %{label: "Mexico", value: "mex", group: "North America"}
                      ])

  capture variants: [
            basic: %{
              class: "listbox",
              items: @collection,
              label: [%{inner_block: "Choose a country"}],
              item_indicator: [%{inner_block: "<.heroicon name=\"hero-check\" />"}]
            },
            grouped: %{
              class: "listbox",
              items: @grouped_collection,
              label: [%{inner_block: "Choose a country"}],
              item_indicator: [%{inner_block: "<.heroicon name=\"hero-check\" />"}]
            },
            multiple: %{
              class: "listbox",
              items: @collection,
              value: ["bel", "deu"],
              selection_mode: "multiple",
              label: [%{inner_block: "Choose countries"}],
              item_indicator: [%{inner_block: "<.heroicon name=\"hero-check\" />"}]
            }
          ]

  defdelegate listbox(assigns), to: Listbox
  defdelegate heroicon(assigns), to: Heroicon
end
