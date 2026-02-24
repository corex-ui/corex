defmodule CorexWeb.Menu do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.Menu
  alias Corex.Tree.Item
  alias E2eWeb.CoreComponents

  @items [
    %Item{id: "edit", label: "Edit"},
    %Item{id: "duplicate", label: "Duplicate"},
    %Item{id: "delete", label: "Delete"}
  ]

  capture variants: [
            basic: %{
              class: "menu",
              items: @items,
              trigger: [%{inner_block: "Actions"}],
              indicator: [%{inner_block: ~s(<.icon name="hero-chevron-down" />)}]
            },
            nested: %{
              class: "menu",
              items: [
                %Item{id: "new-tab", label: "New tab"},
                %Item{
                  id: "share",
                  label: "Share",
                  children: [
                    %Item{id: "messages", label: "Messages"},
                    %Item{id: "airdrop", label: "Airdrop"},
                    %Item{id: "whatsapp", label: "WhatsApp"}
                  ]
                },
                %Item{id: "print", label: "Print..."}
              ],
              trigger: [%{inner_block: "Click me"}]
            }
          ]

  defdelegate menu(assigns), to: Menu
  defdelegate icon(assigns), to: CoreComponents
end
