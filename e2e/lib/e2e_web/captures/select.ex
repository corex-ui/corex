defmodule E2eWeb.Captures.Select do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.Select
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
              class: "select",
              placeholder_text: "Select a country",
              collection: @collection,
              trigger: [%{inner_block: "<.icon name=\"hero-chevron-down\" />"}]
            },
            grouped: %{
              class: "select",
              placeholder_text: "Select a country",
              collection: @grouped_collection,
              trigger: [%{inner_block: "<.icon name=\"hero-chevron-down\" />"}]
            },
            with_value: %{
              class: "select",
              placeholder_text: "Select a country",
              collection: @collection,
              value: ["bel"],
              trigger: [%{inner_block: "<.icon name=\"hero-chevron-down\" />"}]
            }
          ]

  defdelegate select(assigns), to: Select
  defdelegate icon(assigns), to: CoreComponents
end
