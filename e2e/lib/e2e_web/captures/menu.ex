defmodule CorexWeb.Menu do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.Heroicon
  alias Corex.Menu
  alias Corex.Tree.Item

  @items_minimal [
    %Item{value: "menu", label: "Menu"},
    %Item{value: "combobox", label: "Combobox"},
    %Item{value: "select", label: "Select"}
  ]

  @items_grouped [
    %Item{value: "combobox", label: "Combobox", group: "Pickers"},
    %Item{value: "listbox", label: "Listbox", group: "Pickers"},
    %Item{value: "menu", label: "Menu", group: "Overlays"},
    %Item{value: "dialog", label: "Dialog", group: "Overlays"}
  ]

  @items_nested [
    %Item{value: "listbox", label: "Listbox"},
    %Item{
      value: "corex",
      label: "Corex",
      children: [
        %Item{value: "combobox", label: "Combobox"},
        %Item{value: "date-picker", label: "Date picker"},
        %Item{value: "menu", label: "Menu"},
        %Item{value: "dialog", label: "Dialog"}
      ]
    },
    %Item{value: "tabs", label: "Tabs"}
  ]

  @items_nested_grouped [
    %Item{value: "tabs", label: "Tabs"},
    %Item{
      value: "corex",
      label: "Corex",
      children: [
        %Item{value: "combobox", label: "Combobox", group: "Pickers"},
        %Item{value: "date-picker", label: "Date picker", group: "Pickers"},
        %Item{value: "menu", label: "Menu", group: "Overlays"},
        %Item{value: "dialog", label: "Dialog", group: "Overlays"}
      ]
    }
  ]

  @pattern_redirect_items [
    %Item{value: E2eWeb.Path.join_locale_path("en", "/menu/anatomy"), label: "Anatomy"},
    %Item{value: E2eWeb.Path.join_locale_path("en", "/menu/api"), label: "API"}
  ]

  @pattern_redirect_types_items [
    %Item{
      value: E2eWeb.Path.join_locale_path("en", "/menu/playground"),
      label: "href (default)",
      redirect: :href
    },
    %Item{
      value: E2eWeb.Path.join_locale_path("en", "/menu/events"),
      label: "LiveView navigate",
      redirect: :navigate
    }
  ]

  capture variants: [
            minimal: %{
              id: "menu-anatomy-minimal",
              class: "menu",
              items: @items_minimal,
              trigger: [%{inner_block: "Corex"}],
              indicator: [%{inner_block: ~S(<.heroicon name="hero-chevron-down" />)}]
            },
            grouped: %{
              id: "menu-anatomy-grouped",
              class: "menu",
              items: @items_grouped,
              trigger: [%{inner_block: "Corex"}],
              indicator: [%{inner_block: ~S(<.heroicon name="hero-chevron-down" />)}]
            },
            nested: %{
              id: "menu-anatomy-nested",
              class: "menu",
              items: @items_nested,
              trigger: [%{inner_block: "Corex"}],
              indicator: [%{inner_block: ~S(<.heroicon name="hero-chevron-down" />)}],
              nested_indicator: [%{inner_block: ~S(<.heroicon name="hero-chevron-right" />)}]
            },
            nested_grouped: %{
              id: "menu-anatomy-nested-grouped",
              class: "menu",
              items: @items_nested_grouped,
              trigger: [%{inner_block: "Corex"}],
              indicator: [%{inner_block: ~S(<.heroicon name="hero-chevron-down" />)}],
              nested_indicator: [%{inner_block: ~S(<.heroicon name="hero-chevron-right" />)}]
            },
            pattern_redirect: %{
              id: "menu-pattern-redirect",
              class: "menu",
              redirect: true,
              items: @pattern_redirect_items,
              trigger: [%{inner_block: "Navigate"}],
              indicator: [%{inner_block: ~S(<.heroicon name="hero-chevron-down" />)}]
            },
            pattern_redirect_external: %{
              id: "menu-pattern-external",
              class: "menu",
              redirect: true,
              items: [
                %Item{
                  value: "https://zagjs.com/components/react/menu",
                  label: "Zag menu",
                  new_tab: true
                },
                %Item{
                  value: "https://hexdocs.pm/phoenix_live_view/",
                  label: "Phoenix LiveView",
                  new_tab: true
                }
              ],
              trigger: [%{inner_block: "External"}],
              indicator: [%{inner_block: ~S(<.heroicon name="hero-chevron-down" />)}]
            },
            pattern_redirect_types: %{
              id: "menu-pattern-types",
              class: "menu",
              redirect: true,
              items: @pattern_redirect_types_items,
              trigger: [%{inner_block: "Redirect kinds"}],
              indicator: [%{inner_block: ~S(<.heroicon name="hero-chevron-down" />)}]
            }
          ]

  defdelegate menu(assigns), to: Menu
  defdelegate heroicon(assigns), to: Heroicon
end
