defmodule CorexWeb.Select do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.Select
  alias Corex.Heroicon

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
              class: "select",
              placeholder: "Select a country",
              items: @collection,
              trigger: [%{inner_block: "<.heroicon name=\"hero-chevron-down\" />"}]
            },
            grouped: %{
              class: "select",
              placeholder: "Select a country",
              items: @grouped_collection,
              trigger: [%{inner_block: "<.heroicon name=\"hero-chevron-down\" />"}]
            },
            with_value: %{
              class: "select",
              placeholder: "Select a country",
              items: @collection,
              value: ["bel"],
              trigger: [%{inner_block: "<.heroicon name=\"hero-chevron-down\" />"}]
            }
          ]

  defdelegate select(assigns), to: Select
  defdelegate heroicon(assigns), to: Heroicon
end
