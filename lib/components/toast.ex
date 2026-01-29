defmodule Corex.Toast do
  @moduledoc """
  Provides Toast UI components that integrate with Zag.js via Phoenix LiveView hooks.

  Toast is used to give feedback to users after an action has taken place.
  Toasts can be created programmatically and support multiple types (info, success, error, loading).
  """

  use Phoenix.Component

  @doc """
  Renders a toast group (toaster) that manages multiple toast notifications.

  This component should be rendered once in your layout.

  ## Attributes

  - `id`: The ID of the toast group (default: auto-generated)
  - `flash`: Map of flash messages to display as toasts (optional)
  - `placement`: Where toasts appear (default: "bottom-end")
  - `overlap`: Whether toasts overlap (default: true)
  - `max`: Maximum number of visible toasts
  - `gap`: Gap between toasts in pixels
  - `offset`: Offset from viewport edge
  - `pause_on_page_idle`: Pause toasts when page is idle (default: false)

  ## Examples

      <.toast_group />
      <.toast_group flash={@flash} />
      <.toast_group flash={@flash} placement="bottom-end" max={5} />
  """
  attr(:id, :string, default: nil)
  attr(:flash, :map, default: %{}, doc: "the map of flash messages to display as toasts")

  attr(:placement, :string,
    default: "bottom-end",
    values: ~w(top-start top top-end bottom-start bottom bottom-end)
  )

  attr(:overlap, :boolean, default: true)
  attr(:max, :integer, default: nil)
  attr(:gap, :integer, default: nil)
  attr(:offset, :string, default: nil)
  attr(:pause_on_page_idle, :boolean, default: false)

  def toast_group(assigns) do
    ~H"""
    <div
      id={@id}
      phx-hook="Toast"
      class="toast toast-group-js"
      data-placement={@placement}
      data-max={@max}
      data-gap={@gap}
      data-offset={@offset}
      data-overlap={@overlap}


    >
      <div data-scope="toast" data-part="group">

      </div>


    </div>

    """
  end

  @doc """
  Creates a toast notification programmatically (client-side).

  This function returns a JS command that can be used in event handlers.

  ## Examples

      def handle_event("save", _params, socket) do
        # ... save logic ...
        {:noreply, push_event(socket, "toast-create", %{
          title: "Saved!",
          description: "Your changes have been saved.",
          type: "success"
        })}
      end

  Or use the JS command version:

      <button phx-click={Corex.Toast.create("Saved!", "Your changes have been saved.", :success)}>
        Save
      </button>

      <button phx-click={Corex.Toast.create("Loading...", nil, :loading, duration: :infinity)}>
        Show Loading
      </button>
  """
  def create(title, description \\ nil, type \\ :info, opts \\ []) do
    duration = Keyword.get(opts, :duration, 5000)
    duration_str = if duration == :infinity, do: "Infinity", else: duration

    type_str =
      case type do
        :info -> "info"
        :success -> "success"
        :error -> "error"
        :warning -> "warning"
        :loading -> "loading"
        _ -> "info"
      end

    Phoenix.LiveView.JS.dispatch("toast:create",
      to: ".toast-group-js",
      detail: %{
        title: title,
        description: description,
        type: type_str,
        duration: duration_str
      }
    )
  end

  @doc """
  Server-side function to push a toast event to the client.

  Use this in your LiveView event handlers.

  ## Examples

      def handle_event("save", _params, socket) do
        # ... save logic ...
        {:noreply, push_toast(socket, "Saved!", "Your changes have been saved.", :success)}
      end
  """
  def push_toast(socket, title, description \\ nil, type \\ :info, duration \\ 5000) do
    type_str =
      case type do
        :info -> "info"
        :success -> "success"
        :error -> "error"
        :warning -> "warning"
        :loading -> "loading"
        _ -> "info"
      end

    Phoenix.LiveView.push_event(socket, "toast-create", %{
      title: title,
      description: description,
      type: type_str,
      duration: duration
    })
  end
end
