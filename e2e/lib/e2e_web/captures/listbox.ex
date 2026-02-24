defmodule CorexWeb.Listbox do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.Listbox
  alias E2eWeb.CoreComponents

  @collection [
    %{label: "France", id: "fra", disabled: true},
    %{label: "Belgium", id: "bel"},
    %{label: "Germany", id: "deu"},
    %{label: "Netherlands", id: "nld"},
    %{label: "Switzerland", id: "che"},
    %{label: "Austria", id: "aut"}
  ]

  @grouped_collection [
    %{label: "France", id: "fra", group: "Europe"},
    %{label: "Belgium", id: "bel", group: "Europe"},
    %{label: "Germany", id: "deu", group: "Europe"},
    %{label: "Netherlands", id: "nld", group: "Europe"},
    %{label: "Switzerland", id: "che", group: "Europe"},
    %{label: "Austria", id: "aut", group: "Europe"},
    %{label: "Japan", id: "jpn", group: "Asia"},
    %{label: "China", id: "chn", group: "Asia"},
    %{label: "South Korea", id: "kor", group: "Asia"},
    %{label: "USA", id: "usa", group: "North America"},
    %{label: "Canada", id: "can", group: "North America"},
    %{label: "Mexico", id: "mex", group: "North America"}
  ]

  capture variants: [
            basic: %{
              class: "listbox",
              collection: @collection,
              label: [%{inner_block: "Choose a country"}],
              item_indicator: [%{inner_block: "<.icon name=\"hero-check\" />"}]
            },
            grouped: %{
              class: "listbox",
              collection: @grouped_collection,
              label: [%{inner_block: "Choose a country"}],
              item_indicator: [%{inner_block: "<.icon name=\"hero-check\" />"}]
            },
            multiple: %{
              class: "listbox",
              collection: @collection,
              value: ["bel", "deu"],
              selection_mode: "multiple",
              label: [%{inner_block: "Choose countries"}],
              item_indicator: [%{inner_block: "<.icon name=\"hero-check\" />"}]
            }
          ]

  defdelegate listbox(assigns), to: Listbox
  defdelegate icon(assigns), to: CoreComponents
end
