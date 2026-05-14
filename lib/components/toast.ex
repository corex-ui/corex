defmodule Corex.Toast do
  @moduledoc """
  Phoenix implementation of [Zag.js Toast](https://zagjs.com/components/react/toast).

  Compatible with Phoenix Flash messages

  ## Examples

  Toast components is meant to be a replacement for the Core Components and Layout flash group and flash components.

  In your Layout App, you can replace the flash group `<.flash_group flash={@flash} />` components by the toast group

  ```heex
    <.toast_group id="layout-toast" flash={@flash} class="toast">
      <:loading>
        <.heroicon name="hero-arrow-path" />
      </:loading>
    </.toast_group>
  ```

  ## API Control

  ***Client-side***

  ```heex
  <button phx-click={Corex.Toast.create("layout-toast", "This is an info toast", "This is an info toast description", :info, [])} class="button">
   Create Info Toast
  </button>

  <div phx-disconnected={Corex.Toast.create("layout-toast", "We can't find the internet", "Attempting to reconnect", :info, [duration: :infinity, loading: true])}></div>

  ```

  ***Server-side***

  ```elixir
  def handle_event("create_info_toast", _, socket) do
    {:noreply, Corex.Toast.create(socket, "layout-toast", "This is an info toast", "This is an info toast description", :info, duration: 5000)}
  end
  ```

  ## Flash Messages
  You can use the `flash` attribute to display flash messages as toasts.
  Optional `flash_info` and `flash_error` accept maps with atom keys `title`, `type`, and `duration` for defaults when rendering info and error flashes.
  The description comes from the Phoenix flash message.

  ```heex

  <.toast_group
  id="layout-toast"
  class="toast"
  flash={@flash}
  flash_info={%{title: "Success", type: :success, duration: 5000}}
  flash_error={%{title: "Error", type: :error, duration: :infinity}}/>
  ```

  ## Styling

  Use data attributes to target elements:

  ```css
  [data-scope="toast"][data-part="group"] {}
  [data-scope="toast"][data-part="root"] {}
  [data-scope="toast"][data-part="title"] {}
  [data-scope="toast"][data-part="description"] {}
  [data-scope="toast"][data-part="close-trigger"] {}
  [data-scope="toast"][data-part="action-trigger"] {}
  ```

  If you wish to use the default Corex styling, use the class `toast` on the component after installing `Mix.Tasks.Corex.Design` and importing:

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/toast.css";
  ```

  ## Toast options (`create` / `create` server / `update`)

  Common opts: `duration`, `loading: true`, `id: "stable-id"`, `priority:` integer `1` (highest) through `8` (lowest), optional (Zag defaults by type and action when omitted), `action:`.

  Action map: `%{label:, js: %Phoenix.LiveView.JS{}, class: optional}` or `%Corex.Toast.Action{label:, js:, class:}` (same fields; struct is optional sugar).

  - `label` is trusted HTML for the action button: a plain binary, `Phoenix.HTML.raw/1`, or HEEx (for example `~H{...}` with `<.heroicon />`). HEEx and `{:safe, _}` become HTML through `Phoenix.HTML.Safe` (plain binaries are not escaped).
  - `js` is a non-empty `Phoenix.LiveView.JS` struct (use `JS.push`, `JS.patch`, `JS.navigate`, and `|>` to compose).
  - `class` is optional: a binary string of CSS classes for the action button (leading and trailing whitespace stripped; empty means omit).

  ```elixir
  action: %{
    label: ~H{
      <.heroicon name="hero-arrow-uturn-left" />
      Undo
    },
    class: "button button--accent button--sm",
    js: JS.push("toast_undo", value: %{id: 1}) |> JS.patch(~p"/items")
  }
  ```
  """

  defmodule Translation do
    @moduledoc """
    Translation struct for Toast component strings (default titles for flash messages).

    Without gettext: `translation={%Toast.Translation{ info: "Info", error: "Error" }}`

    With gettext: `translation={%Toast.Translation{ info: Corex.Gettext.gettext("Info"), error: Corex.Gettext.gettext("Error") }}`
    """
    defstruct [:info, :error]
  end

  @doc type: :component
  use Phoenix.Component

  alias Corex.Flash
  alias Corex.Toast.Payload, as: ToastPayload
  alias Phoenix.LiveView.JS

  defp toast_duration_dispatch_string(:infinity), do: "Infinity"
  defp toast_duration_dispatch_string(v), do: v

  defp toast_dispatch_type_string(:info), do: "info"
  defp toast_dispatch_type_string(:success), do: "success"
  defp toast_dispatch_type_string(:error), do: "error"
  defp toast_dispatch_type_string(_), do: nil

  defp toast_dispatch_type_str(type, fallback) do
    case toast_dispatch_type_string(type) do
      nil -> fallback
      s -> s
    end
  end

  defp assign_toast_dispatch_strings(assigns, type_fallback) do
    assigns
    |> assign(:type_str, toast_dispatch_type_str(assigns.type, type_fallback))
    |> assign(:duration_str, toast_duration_dispatch_string(assigns.duration))
  end

  @doc """
  Renders a toast group (toaster) that manages multiple toast notifications.

  This component should be rendered once in your layout.

  ## Examples

  ```heex
   <.toast_group id="layout-toast" class="toast" flash={@flash}>
    <:loading>
      <.heroicon name="hero-arrow-path" />
    </:loading>
  </.toast_group>
  ```

  ## Flash Messages
  You can use the `flash` attribute to display flash messages as toasts.
  Optional `flash_info` and `flash_error` accept maps with atom keys `title`, `type`, and `duration` for defaults when rendering info and error flashes.
  The description comes from the Phoenix flash message.

  ```heex
  <.toast_group
  id="layout-toast"
  class="toast"
  flash={@flash}
  flash_info={%{title: "Success", type: :success, duration: 5000}}
  flash_error={%{title: "Error", type: :error, duration: :infinity}}/>
  ```

  """
  attr(:id, :string, required: true, doc: "The id of the toast group")

  attr(:placement, :string,
    default: "bottom-end",
    values: ~w(top-start top top-end bottom-start bottom bottom-end),
    doc: "Where toasts appear on screen"
  )

  attr(:overlap, :boolean, default: true, doc: "Whether toasts can overlap")
  attr(:max, :integer, default: 5, doc: "Maximum number of visible toasts")
  attr(:gap, :integer, default: nil, doc: "Gap between toasts in pixels")
  attr(:offset, :string, default: nil, doc: "Offset from viewport edge")
  attr(:pause_on_page_idle, :boolean, default: false, doc: "Pause duration when page is idle")
  attr(:flash, :map, default: %{}, doc: "The map of flash messages to display as toasts")

  attr(:flash_info, :any,
    default: nil,
    doc: "Defaults for info flashes: map or struct with title, type, and duration keys"
  )

  attr(:flash_error, :any,
    default: nil,
    doc: "Defaults for error flashes: map or struct with title, type, and duration keys"
  )

  attr(:translation, Corex.Toast.Translation,
    default: nil,
    doc: "Override default titles for info/error flash messages"
  )

  slot :loading,
    doc: "the loading spinner icon to display when duration is infinity" do
    attr(:class, :string, required: false)
  end

  slot(:close,
    doc: "content placed in each toast close button (hidden template, cloned in the client)"
  )

  attr(:rest, :global)

  def toast_group(assigns) do
    info_flash = Phoenix.Flash.get(assigns.flash, :info)
    error_flash = Phoenix.Flash.get(assigns.flash, :error)

    default_translation = %Translation{
      info: Corex.Gettext.gettext("Info"),
      error: Corex.Gettext.gettext("Error")
    }

    translation = merge_translation(assigns[:translation], default_translation)

    flash_info =
      Map.get(assigns, :flash_info) ||
        %Flash.Info{title: translation.info, type: :info, duration: 5000}

    flash_error =
      Map.get(assigns, :flash_error) ||
        %Flash.Error{title: translation.error, type: :error, duration: 5000}

    assigns =
      assigns
      |> assign_new(:loading, fn -> [] end)
      |> assign_new(:close, fn -> [] end)
      |> assign(:info_flash, info_flash)
      |> assign(:error_flash, error_flash)
      |> assign(:flash_info, flash_info)
      |> assign(:flash_error, flash_error)

    ~H"""
    <div
      id={@id}
      phx-hook="Toast"
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
      {@rest}
    >
      <div data-scope="toast" data-part="group">

      </div>
      <div :if={@loading != []} id={"#{@id}-loading-icon"} data-loading-icon-template style="display: none;">
        {render_slot(@loading)}
      </div>
      <div :if={@close != []} id={"#{@id}-close-icon"} data-close-icon-template style="display: none;">
        {render_slot(@close)}
      </div>
      <div
        :if={@info_flash}
        phx-mounted={create(@id, @flash_info.title, @info_flash, @flash_info.type, [duration: @flash_info.duration])}
      >
      </div>
      <div
        :if={@error_flash}
        phx-mounted={create(@id, @flash_error.title, @error_flash, @flash_error.type, [duration: @flash_error.duration])}
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
        toast_group_id="layout-toast"
        title="We can't find the internet"
        description="Attempting to reconnect"
        type={:loading}
        duration={:infinity}
      />
  """
  attr(:id, :string, default: "client-error-toast")
  attr(:toast_group_id, :string, required: true)
  attr(:title, :string, required: true)
  attr(:description, :string, default: nil)
  attr(:type, :atom, default: :info, values: [:info, :success, :error])
  attr(:duration, :any, default: :infinity)

  def toast_client_error(assigns) do
    assigns = assign_toast_dispatch_strings(assigns, "info")

    ~H"""
    <div
      id={@id}
      phx-disconnected={
        JS.remove_attribute("hidden", to: "##{@id}")
        |> JS.dispatch("toast:create",
          to: "##{@toast_group_id}",
          detail: %{
            title: @title,
            description: @description,
            type: @type_str,
            duration: @duration_str,
            loading: true
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
        toast_group_id="layout-toast"
        title="Something went wrong!"
        description="Attempting to reconnect"
        type={:error}
        duration={:infinity}
      />
  """
  attr(:id, :string, default: "server-error-toast")
  attr(:toast_group_id, :string, required: true)
  attr(:title, :string, required: true)
  attr(:description, :string, default: nil)
  attr(:type, :atom, default: :error, values: [:info, :success, :error])
  attr(:duration, :any, default: :infinity)

  def toast_server_error(assigns) do
    assigns = assign_toast_dispatch_strings(assigns, "error")

    ~H"""
    <div
      id={@id}
      phx-disconnected={
        JS.remove_attribute("hidden", to: "##{@id}")
        |> JS.dispatch("toast:create",
          to: "##{@toast_group_id}",
          detail: %{
            title: @title,
            description: @description,
            type: @type_str,
            duration: @duration_str,
            loading: true
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
        toast_group_id="layout-toast"
        title="Connection restored"
        description="You're back online"
        type={:success}
      />
  """
  attr(:id, :string, default: "connected-toast")
  attr(:toast_group_id, :string, required: true)
  attr(:title, :string, required: true)
  attr(:description, :string, default: nil)
  attr(:type, :atom, default: :success, values: [:info, :success, :error])
  attr(:duration, :any, default: 5000)

  def toast_connected(assigns) do
    assigns = assign_toast_dispatch_strings(assigns, "success")

    ~H"""
    <div
      id={@id}
      phx-connected={
        JS.dispatch("toast:create",
          to: "##{@toast_group_id}",
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
        toast_group_id="layout-toast"
        title="Connection lost"
        description="Attempting to reconnect"
        type={:warning}
        duration={:infinity}
      />
  """
  attr(:id, :string, default: "disconnected-toast")
  attr(:toast_group_id, :string, required: true)
  attr(:title, :string, required: true)
  attr(:description, :string, default: nil)
  attr(:type, :atom, default: :info, values: [:info, :success, :error])
  attr(:duration, :any, default: :infinity)

  def toast_disconnected(assigns) do
    assigns = assign_toast_dispatch_strings(assigns, "info")

    ~H"""
    <div
      id={@id}
      phx-disconnected={
        JS.dispatch("toast:create",
          to: "##{@toast_group_id}",
          detail: %{
            title: @title,
            description: @description,
            type: @type_str,
            duration: @duration_str,
            loading: true
          }
        )
      }
      hidden
    >
    </div>
    """
  end

  defp merge_translation(nil, default), do: default

  defp merge_translation(partial, default) do
    %Translation{
      info: partial.info || default.info,
      error: partial.error || default.error
    }
  end

  @doc type: :api
  @doc """
  Creates a toast from the client. Returns `Phoenix.LiveView.JS` that dispatches `toast:create` on the group.

  Options: `duration` (default `5000`, or `:infinity`), `loading: true`, `id:`, `priority:` (`1`..`8`, optional; otherwise Zag derives priority from type and whether an action is present), `action:` (see module docs: `%{label:, js: %JS{}, class?:}`).
  """
  def create(toast_group_id, title, description, type, opts)
      when is_binary(toast_group_id) and is_list(opts) do
    detail = ToastPayload.create_detail(title, description, type, opts)
    JS.dispatch("toast:create", to: "##{toast_group_id}", detail: detail)
  end

  @doc type: :api
  @doc """
  Same as `create/5` but pushes `toast-create` from the server.
  """
  def create(socket, toast_group_id, title, description, type, opts \\ [])
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(toast_group_id) and
             is_list(opts) do
    data = ToastPayload.create_server_data(toast_group_id, title, description, type, opts)
    Phoenix.LiveView.push_event(socket, "toast-create", data)
  end

  @doc type: :api
  @doc """
  Updates an existing toast from the client. `attrs` may include `:title`, `:description`, `:type`, `:duration`, `:loading`, `:action`, `:priority`.
  """
  def update(toast_group_id, toast_id, attrs)
      when is_binary(toast_group_id) and is_binary(toast_id) and (is_map(attrs) or is_list(attrs)) do
    detail = ToastPayload.update_detail(toast_id, attrs)
    JS.dispatch("toast:update", to: "##{toast_group_id}", detail: detail)
  end

  @doc type: :api
  def update(socket, toast_group_id, toast_id, attrs)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(toast_group_id) and
             is_binary(toast_id) and
             (is_map(attrs) or is_list(attrs)) do
    data = ToastPayload.update_server_data(toast_group_id, toast_id, attrs)
    Phoenix.LiveView.push_event(socket, "toast-update", data)
  end

  @doc type: :api
  @doc """
  Removes a toast immediately (Zag `remove`).
  """
  def remove(toast_group_id, toast_id) when is_binary(toast_group_id) and is_binary(toast_id) do
    JS.dispatch("toast:remove", to: "##{toast_group_id}", detail: %{id: toast_id})
  end

  @doc type: :api
  def remove(socket, toast_group_id, toast_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(toast_group_id) and
             is_binary(toast_id) do
    Phoenix.LiveView.push_event(socket, "toast-remove", %{groupId: toast_group_id, id: toast_id})
  end

  @doc type: :api
  @doc """
  Dismisses a toast with the normal dismiss lifecycle (Zag `dismiss`).
  """
  def dismiss(toast_group_id, toast_id) when is_binary(toast_group_id) and is_binary(toast_id) do
    JS.dispatch("toast:dismiss", to: "##{toast_group_id}", detail: %{id: toast_id})
  end

  @doc type: :api
  def dismiss(socket, toast_group_id, toast_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(toast_group_id) and
             is_binary(toast_id) do
    Phoenix.LiveView.push_event(socket, "toast-dismiss", %{groupId: toast_group_id, id: toast_id})
  end
end
