defmodule CorexWeb.Dialog do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.Dialog
  alias E2eWeb.CoreComponents

  capture variants: [
            basic: %{
              id: "my-dialog",
              class: "dialog",
              trigger: [%{inner_block: "Open Dialog"}],
              title: [%{inner_block: "Dialog Title"}],
              description: [
                %{
                  inner_block:
                    "This is a dialog description that explains what the dialog is about."
                }
              ],
              content: [
                %{
                  inner_block:
                    ~S|<p>Dialog content goes here. You can add any content you want inside the dialog.</p> <.action phx-click={Corex.Dialog.set_open("my-dialog", false)} class="button button--sm">API Close Dialog</.action>|
                }
              ],
              close_trigger: [%{inner_block: ~s(<.icon name="hero-x-mark" class="icon" />)}]
            }
          ]

  defdelegate dialog(assigns), to: Dialog
  defdelegate action(assigns), to: Corex.Action
  defdelegate icon(assigns), to: CoreComponents
end
