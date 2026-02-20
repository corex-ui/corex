defmodule Corex.Toast do
  @moduledoc """
  Phoenix implementation of [Zag.js Toast](https://zagjs.com/components/react/toast).

  ## Examples

  You can add the toast group to each pages and or your App layout

  ```heex
   <.toast_group/>
  ```
  ## API Control

  ***Client-side***

  ```heex
  <button phx-click={Corex.Toast.create_toast("This is an info toast", "This is an info toast description", :info)} class="button">
   Create Info Toast
  </button>

  <div phx-disconnected={Corex.Toast.create_toast("We can't find the internet", "Attempting to reconnect", :loading, duration: :infinity)}></div>

  ```

  ***Server-side***

  ```elixir
  def handle_event("create_info_toast", _, socket) do
    {:noreply, Corex.Toast.push_toast(socket, "This is an info toast", "This is an info toast description", :info)}
  end
  ```

  ## Flash Messages
  You can use the `flash` attribute to display flash messages as toasts.
  You can use `%Corex.Flash.Info{}' and `%Corex.Flash.Error{}' to configure the flash messages title, type and duration.
  The descritpion will come from the Phoenix flash message

  ```heex
  <.toast_group
  flash={@flash}
  flash_info={%Corex.Flash.Info{title: "Success", type: :success, duration: 5000}}
  flash_error={%Corex.Flash.Error{title: "Error", type: :error, duration: :infinity}}/>
  ```

  ## Styling

  Use data attributes to target elements:

  ```css
  [data-scope="toast"][data-part="group"] {}
  [data-scope="toast"][data-part="root"] {}
  [data-scope="toast"][data-part="title"] {}
  [data-scope="toast"][data-part="description"] {}
  [data-scope="toast"][data-part="close-trigger"] {}
  ```

  If you wish to use the default Corex styling, you can use the class `toast` on the component.
  This requires to install `Mix.Tasks.Corex.Design` first and import the component css file.

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/toast.css";
  ```

  You can then use modifiers

  ```heex
  <.toast_group class="toast toast--accent">
  ```

  Learn more about modifiers and [Corex Design](https://corex-ui.com/components/toast#modifiers)

  """
  @doc type: :component
  use Phoenix.Component

  alias Phoenix.LiveView.JS
  import Corex.Gettext, only: [gettext: 1]

  alias Corex.Flash

  @doc """
  Renders a toast group (toaster) that manages multiple toast notifications.

  This component should be rendered once in your layout.

  ## Examples

  ```heex
   <.toast_group />
  ```

  ## Flash Messages
  You can use the `flash` attribute to display flash messages as toasts.
  You can use `%Corex.Flash.Info{}' and `%Corex.Flash.Error{}' to configure the flash messages title, type and duration.
  The descritpion will come from the Phoenix flash message

  ```heex
  <.toast_group
  flash={@flash}
  flash_info={%Corex.Flash.Info{title: "Success", type: :success, duration: 5000}}
  flash_error={%Corex.Flash.Error{title: "Error", type: :error, duration: :infinity}}/>
  ```

  """
  attr(:id, :string, default: nil)

  attr(:placement, :string,
    default: "bottom-end",
    values: ~w(top-start top top-end bottom-start bottom bottom-end)
  )

  attr(:overlap, :boolean, default: true)
  attr(:max, :integer, default: 5)
  attr(:gap, :integer, default: nil)
  attr(:offset, :string, default: nil)
  attr(:pause_on_page_idle, :boolean, default: false)
  attr(:flash, :map, default: %{}, doc: "the map of flash messages to display as toasts")

  attr(:flash_info, Flash.Info,
    doc: "configuration for info flash messages (Corex.Flash.Info struct)"
  )

  attr(:flash_error, Flash.Error,
    doc: "configuration for error flash messages (Corex.Flash.Error struct)"
  )

  slot(:loading,
    required: true,
    doc: "the loading spinner icon to display when duration is infinity"
  )

  def toast_group(assigns) do
    info_flash = Phoenix.Flash.get(assigns.flash, :info)
    error_flash = Phoenix.Flash.get(assigns.flash, :error)

    flash_info =
      Map.get(assigns, :flash_info) ||
        %Flash.Info{title: gettext("Info"), type: :info, duration: 5000}

    flash_error =
      Map.get(assigns, :flash_error) ||
        %Flash.Error{title: gettext("Error"), type: :error, duration: 5000}

    assigns =
      assigns
      |> assign(:info_flash, info_flash)
      |> assign(:error_flash, error_flash)
      |> assign(:flash_info, flash_info)
      |> assign(:flash_error, flash_error)

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
      data-flash-info={@info_flash}
      data-flash-info-title={@flash_info.title}
      data-flash-error={@error_flash}
      data-flash-error-title={@flash_error.title}
      data-flash-info-duration={@flash_info.duration}
      data-flash-error-duration={@flash_error.duration}
    >
      <div data-scope="toast" data-part="group">

      </div>
      <div id={"#{@id}-loading-icon"} data-loading-icon-template style="display: none;">
        {render_slot(@loading)}
      </div>
      <div
        :if={@info_flash}
        phx-mounted={create_toast(@flash_info.title, @info_flash, @flash_info.type, [duration: @flash_info.duration])}
      >
      </div>
      <div
        :if={@error_flash}
        phx-mounted={create_toast(@flash_error.title, @error_flash, @flash_error.type, [duration: @flash_error.duration])}
      >
      </div>
    </div>

    """
  end

  @doc type: :component
  @doc """
  Renders a div that creates a toast notification when a client error occurs.

  This component should be placed in your layout and will automatically
  create a toast when Phoenix LiveView detects a client-side connection error.

  ## Examples

      <.toast_client_error
        title="We can't find the internet"
        description="Attempting to reconnect"
        type={:loading}
        duration={:infinity}
      />
  """
  attr(:id, :string, default: "client-error-toast")
  attr(:title, :string, required: true)
  attr(:description, :string, default: nil)
  attr(:type, :atom, default: :info, values: [:info, :success, :error])
  attr(:duration, :any, default: :infinity)

  def toast_client_error(assigns) do
    type_str =
      case assigns.type do
        :info -> "info"
        :success -> "success"
        :error -> "error"
        _ -> "info"
      end

    duration_str = if assigns.duration == :infinity, do: "Infinity", else: assigns.duration

    assigns =
      assigns
      |> assign(:type_str, type_str)
      |> assign(:duration_str, duration_str)

    ~H"""
    <div
      id={@id}
      phx-disconnected={
        JS.remove_attribute("hidden", to: "##{@id}")
        |> JS.dispatch("toast:create",
          to: ".phx-client-error .toast-group-js",
          detail: %{
            title: @title,
            description: @description,
            type: @type_str,
            duration: @duration_str
          }
        )
      }
      phx-connected={JS.set_attribute({"hidden", ""}, to: "##{@id}")}
      hidden
    >
    </div>
    """
  end

  @doc type: :component
  @doc """
  Renders a div that creates a toast notification when a server error occurs.

  This component should be placed in your layout and will automatically
  create a toast when Phoenix LiveView detects a server-side connection error.

  ## Examples

      <.toast_server_error
        title="Something went wrong!"
        description="Attempting to reconnect"
        type={:error}
        duration={:infinity}
      />
  """
  attr(:id, :string, default: "server-error-toast")
  attr(:title, :string, required: true)
  attr(:description, :string, default: nil)
  attr(:type, :atom, default: :error, values: [:info, :success, :error])
  attr(:duration, :any, default: :infinity)

  def toast_server_error(assigns) do
    type_str =
      case assigns.type do
        :info -> "info"
        :success -> "success"
        :error -> "error"
        _ -> "error"
      end

    duration_str = if assigns.duration == :infinity, do: "Infinity", else: assigns.duration

    assigns =
      assigns
      |> assign(:type_str, type_str)
      |> assign(:duration_str, duration_str)

    ~H"""
    <div
      id={@id}
      phx-disconnected={
        JS.remove_attribute("hidden", to: "##{@id}")
        |> JS.dispatch("toast:create",
          to: ".phx-server-error .toast-group-js",
          detail: %{
            title: @title,
            description: @description,
            type: @type_str,
            duration: @duration_str
          }
        )
      }
      phx-connected={JS.set_attribute({"hidden", ""}, to: "##{@id}")}
      hidden
    >
    </div>
    """
  end

  @doc type: :component
  @doc """
  Renders a div that creates a toast notification when the connection is restored.

  This component should be placed in your layout and will automatically
  create a toast when Phoenix LiveView detects that the connection has been restored.

  ## Examples

      <.toast_connected
        title="Connection restored"
        description="You're back online"
        type={:success}
      />
  """
  attr(:id, :string, default: "connected-toast")
  attr(:title, :string, required: true)
  attr(:description, :string, default: nil)
  attr(:type, :atom, default: :success, values: [:info, :success, :error])
  attr(:duration, :any, default: 5000)

  def toast_connected(assigns) do
    type_str =
      case assigns.type do
        :info -> "info"
        :success -> "success"
        :error -> "error"
        _ -> "success"
      end

    duration_str = if assigns.duration == :infinity, do: "Infinity", else: assigns.duration

    assigns =
      assigns
      |> assign(:type_str, type_str)
      |> assign(:duration_str, duration_str)

    ~H"""
    <div
      id={@id}
      phx-connected={
        JS.dispatch("toast:create",
          to: ".toast-group-js",
          detail: %{
            title: @title,
            description: @description,
            type: @type_str,
            duration: @duration_str
          }
        )
      }
      hidden
    >
    </div>
    """
  end

  @doc type: :component
  @doc """
  Renders a div that creates a toast notification when the connection is lost.

  This component should be placed in your layout and will automatically
  create a toast when Phoenix LiveView detects that the connection has been lost.

  ## Examples

      <.toast_disconnected
        title="Connection lost"
        description="Attempting to reconnect"
        type={:warning}
        duration={:infinity}
      />
  """
  attr(:id, :string, default: "disconnected-toast")
  attr(:title, :string, required: true)
  attr(:description, :string, default: nil)
  attr(:type, :atom, default: :info, values: [:info, :success, :error])
  attr(:duration, :any, default: :infinity)

  def toast_disconnected(assigns) do
    type_str =
      case assigns.type do
        :info -> "info"
        :success -> "success"
        :error -> "error"
        _ -> "info"
      end

    duration_str = if assigns.duration == :infinity, do: "Infinity", else: assigns.duration

    assigns =
      assigns
      |> assign(:type_str, type_str)
      |> assign(:duration_str, duration_str)

    ~H"""
    <div
      id={@id}
      phx-disconnected={
        JS.dispatch("toast:create",
          to: ".toast-group-js",
          detail: %{
            title: @title,
            description: @description,
            type: @type_str,
            duration: @duration_str
          }
        )
      }
      hidden
    >
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
    duration_str = if duration == :infinity, do: "Infinity", else: duration

    type_str =
      case type do
        :info -> "info"
        :success -> "success"
        :error -> "error"
        _ -> "info"
      end

    Phoenix.LiveView.push_event(socket, "toast-create", %{
      title: title,
      description: description,
      type: type_str,
      duration: duration_str
    })
  end
end
