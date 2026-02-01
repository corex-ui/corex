defmodule Corex.Toast do
  @moduledoc """
  Phoenix implementation of [Zag.js Toast](https://zagjs.com/components/react/toast).

  ## Examples

  ```heex
   <.toast_group />
   <div phx-disconnected={Corex.Toast.create("We can't find the internet", "Attempting to reconnect", :loading, duration: :infinity)}></div>
  ```
  ## API Control

  ***Client-side***

  ```heex
  <button phx-click={Corex.Toast.create_toast("This is an info toast", "This is an info toast description", :info)} class="button">
   Create Info Toast
  </button>

  ```

  ***Server-side***

  ```elixir
  def handle_event("create_info_toast", _, socket) do
    {:noreply, Corex.Toast.push_toast(socket, "This is an info toast", "This is an info toast description", :info)}
  end
  ```

  """
  @doc type: :component
  use Phoenix.Component

  @doc """
  Renders a toast group (toaster) that manages multiple toast notifications.

  This component should be rendered once in your layout.

  ## Examples

  ```heex
   <.toast_group />
   <div phx-disconnected={Corex.Toast.create_toast("We can't find the internet", "Attempting to reconnect", :loading, duration: :infinity)}></div>
  ```
  ## API Control

  ***Client-side***

  ```heex
  <button phx-click={Corex.Toast.create_toast("This is an info toast", "This is an info toast description", :info)} class="button">
   Create Info Toast
  </button>

  ```

  ***Server-side***

  ```elixir
  def handle_event("create_info_toast", _, socket) do
    {:noreply, Corex.Toast.push_toast(socket, "This is an info toast", "This is an info toast description", :info)}
  end
  ```


  """
  attr(:id, :string, default: nil)

  attr(:placement, :string,
    default: "bottom-end",
    values: ~w(top-start top top-end bottom-start bottom bottom-end)
  )

  attr(:overlap, :boolean, default: false)
  attr(:max, :integer, default: 5)
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

  @doc type: :api
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
  def create_toast(title, description \\ nil, type \\ :info, opts \\ []) do
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

  @doc type: :api
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
