defmodule CorexWeb.Menu do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.Menu
  alias Corex.Tree.Item
  alias Corex.Heroicon

  @items_minimal [
    %Item{id: "menu", label: "Menu"},
    %Item{id: "combobox", label: "Combobox"},
    %Item{id: "select", label: "Select"}
  ]

  @items_grouped [
    %Item{id: "combobox", label: "Combobox", group: "Pickers"},
    %Item{id: "listbox", label: "Listbox", group: "Pickers"},
    %Item{id: "menu", label: "Menu", group: "Overlays"},
    %Item{id: "dialog", label: "Dialog", group: "Overlays"}
  ]

  @items_nested [
    %Item{id: "listbox", label: "Listbox"},
    %Item{
      id: "corex",
      label: "Corex",
      children: [
        %Item{id: "combobox", label: "Combobox"},
        %Item{id: "date-picker", label: "Date picker"},
        %Item{id: "menu", label: "Menu"},
        %Item{id: "dialog", label: "Dialog"}
      ]
    },
    %Item{id: "tabs", label: "Tabs"}
  ]

  @items_nested_grouped [
    %Item{id: "tabs", label: "Tabs"},
    %Item{
      id: "corex",
      label: "Corex",
      children: [
        %Item{id: "combobox", label: "Combobox", group: "Pickers"},
        %Item{id: "date-picker", label: "Date picker", group: "Pickers"},
        %Item{id: "menu", label: "Menu", group: "Overlays"},
        %Item{id: "dialog", label: "Dialog", group: "Overlays"}
      ]
    }
  ]

  capture variants: [
            minimal: %{
              id: "menu-anatomy-minimal",
              class: "menu",
              items: @items_minimal,
              trigger: [%{inner_block: "Corex"}],
              indicator: [%{inner_block: ~s(<.heroicon name="hero-chevron-down" />)}]
            },
            grouped: %{
              id: "menu-anatomy-grouped",
              class: "menu",
              items: @items_grouped,
              trigger: [%{inner_block: "Corex"}],
              indicator: [%{inner_block: ~s(<.heroicon name="hero-chevron-down" />)}]
            },
            nested: %{
              id: "menu-anatomy-nested",
              class: "menu",
              items: @items_nested,
              trigger: [%{inner_block: "Corex"}],
              indicator: [%{inner_block: ~s(<.heroicon name="hero-chevron-down" />)}],
              nested_indicator: [%{inner_block: ~s(<.heroicon name="hero-chevron-right" />)}]
            },
            nested_grouped: %{
              id: "menu-anatomy-nested-grouped",
              class: "menu",
              items: @items_nested_grouped,
              trigger: [%{inner_block: "Corex"}],
              indicator: [%{inner_block: ~s(<.heroicon name="hero-chevron-down" />)}],
              nested_indicator: [%{inner_block: ~s(<.heroicon name="hero-chevron-right" />)}]
            },
            pattern_redirect: %{
              id: "menu-pattern-redirect",
              class: "menu",
              redirect: true,
              items: [
                %Item{id: "/en/menu/anatomy", label: "Anatomy"},
                %Item{id: "/en/menu/api", label: "API"}
              ],
              trigger: [%{inner_block: "Navigate"}],
              indicator: [%{inner_block: ~s(<.heroicon name="hero-chevron-down" />)}]
            },
            pattern_redirect_external: %{
              id: "menu-pattern-external",
              class: "menu",
              redirect: true,
              items: [
                %Item{
                  id: "https://zagjs.com/components/react/menu",
                  label: "Zag menu",
                  new_tab: true
                },
                %Item{
                  id: "https://hexdocs.pm/phoenix_live_view/",
                  label: "Phoenix LiveView",
                  new_tab: true
                }
              ],
              trigger: [%{inner_block: "External"}],
              indicator: [%{inner_block: ~s(<.heroicon name="hero-chevron-down" />)}]
            },
            pattern_redirect_types: %{
              id: "menu-pattern-types",
              class: "menu",
              redirect: true,
              items: [
                %Item{id: "/en/menu/playground", label: "href (default)", redirect: :href},
                %Item{id: "/en/menu/events", label: "LiveView navigate", redirect: :navigate}
              ],
              trigger: [%{inner_block: "Redirect kinds"}],
              indicator: [%{inner_block: ~s(<.heroicon name="hero-chevron-down" />)}]
            }
          ]

  defdelegate menu(assigns), to: Menu
  defdelegate heroicon(assigns), to: Heroicon
end
