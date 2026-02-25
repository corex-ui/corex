defmodule CorexWeb.Toast do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.Toast
  alias Corex.Action
  alias E2eWeb.CoreComponents

  capture variants: [
            basic: %{
              demo_type: :buttons,
              toast_group_id: "layout-toast"
            }
          ]

  attr :demo_type, :atom
  attr :toast_group_id, :string, default: "layout-toast"
  attr :id, :string
  attr :class, :string
  attr :flash, :map, default: %{}
  attr :loading, :list, default: []

  def toast_group(assigns) do
    case assigns[:demo_type] do
      :buttons ->
        render_buttons(assigns)

      _ ->
        apply(Toast, :toast_group, [assigns])
    end
  end

  defp render_buttons(assigns) do
    ~H"""
    <div class="layout__row gap-ui-gap">
      <.action
        phx-click={
          Toast.create_toast(
            @toast_group_id,
            "This is an info toast",
            "This is an info toast description",
            :info,
            []
          )
        }
        class="button"
      >
        Create Info Toast
      </.action>
      <.action
        phx-click={
          Toast.create_toast(
            @toast_group_id,
            "This is a success toast",
            "This is a success toast description",
            :success,
            []
          )
        }
        class="button"
      >
        Success Toast
      </.action>
      <.action
        phx-click={
          Toast.create_toast(
            @toast_group_id,
            "This is an error toast",
            "This is an error toast description",
            :error,
            []
          )
        }
        class="button"
      >
        Error Toast
      </.action>
      <.action
        phx-click={
          Toast.create_toast(
            @toast_group_id,
            "This is a loading toast",
            "This is a loading toast description",
            :loading, duration: :infinity)
        }
        class="button"
      >
        Create Loading
      </.action>
    </div>
    """
  end

  defdelegate icon(assigns), to: CoreComponents
  defdelegate action(assigns), to: Action
end
