defmodule Corex.Toast do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Toast](https://zagjs.com/components/react/toast).

  Replace layout flash groups with `<.toast_group>` and drive toasts from LiveView or the client API.

  ## Anatomy

  ### Layout flash

  ```heex
  <.toast_group id="layout-toast" flash={@flash} class="toast">
    <:loading>
      <.heroicon name="hero-arrow-path" />
    </:loading>
  </.toast_group>
  ```

  ### Flash defaults

  ```heex
  <.toast_group
    id="layout-toast"
    class="toast"
    flash={@flash}
    flash_info={%{title: "Success", type: :success, duration: 5000}}
    flash_error={%{title: "Error", type: :error, duration: :infinity}}
  />
  ```

  ## API

  Target a toast group by its DOM `id` on `<.toast_group>`.

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`create/5`](#create/5) | Create toast (client) | `%Phoenix.LiveView.JS{}` |
  | [`create/6`](#create/6) | Create toast (server) | `socket` |
  | [`update/3`](#update/3) | Update toast (client) | `%Phoenix.LiveView.JS{}` |
  | [`update/4`](#update/4) | Update toast (server) | `socket` |
  | [`remove/2`](#remove/2) | Remove toast immediately (client) | `%Phoenix.LiveView.JS{}` |
  | [`remove/3`](#remove/3) | Remove toast immediately (server) | `socket` |
  | [`dismiss/2`](#dismiss/2) | Dismiss with lifecycle (client) | `%Phoenix.LiveView.JS{}` |
  | [`dismiss/3`](#dismiss/3) | Dismiss with lifecycle (server) | `socket` |

  <!-- tabs-open -->

  ### create (client)

  ```heex
  <.action
    phx-click={Corex.Toast.create("layout-toast", "Info", "Info description", :info, [])}
    class="button button--sm"
  >
    Info
  </.action>
  ```

  ### create (server)

  ```elixir
  def handle_event("create_info_toast", _, socket) do
    {:noreply,
     Corex.Toast.create(
       socket,
       "layout-toast",
       "Info",
       "Info description",
       :info,
       duration: 5000
     )}
  end
  ```

  <!-- tabs-close -->

  `create` opts: `duration`, `loading: true`, `id: "stable-id"`, `priority:` `1`–`8`, `action:` map with `label`, `js`, optional `class`.

  ## Style

  Target parts with `data-scope` and `data-part`, or use Corex Design: import tokens and `toast.css`, then set `class="toast"` on `<.toast_group>`.

  ```css
  [data-scope="toast"][data-part="group"] {}
  [data-scope="toast"][data-part="root"] {}
  [data-scope="toast"][data-part="title"] {}
  [data-scope="toast"][data-part="description"] {}
  [data-scope="toast"][data-part="close-trigger"] {}
  [data-scope="toast"][data-part="action-trigger"] {}
  ```

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/toast.css";
  ```

  Stack modifiers on the group host (`class` on `<.toast_group>`).

  <!-- tabs-open -->

  ### Color

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `toast` |
  | Accent | `toast toast--accent` |
  | Brand | `toast toast--brand` |
  | Alert | `toast toast--alert` |
  | Info | `toast toast--info` |
  | Success | `toast toast--success` |

  <!-- tabs-close -->

  '''

  @doc type: :component
  use Phoenix.Component

  import Corex.Api.Doc

  alias Corex.Flash
  alias Corex.Toast.Payload, as: ToastPayload
  alias Corex.Toast.Translation
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

  @doc type: :component
  @doc """
  Renders a toast group (toaster) that manages multiple toast notifications.

  This component should be rendered once in your layout.

  ## Anatomy

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
    values: ~W(top-start top top-end bottom-start bottom bottom-end),
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
    doc:
      "Defaults for `:info` flashes: [`Corex.Flash.Info`](Corex.Flash.Info.html), map, or omit for translation defaults"
  )

  attr(:flash_error, :any,
    default: nil,
    doc:
      "Defaults for `:error` flashes: [`Corex.Flash.Error`](Corex.Flash.Error.html), map, or omit for translation defaults"
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

    translation = Translation.resolve(assigns[:translation])

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

  ## Anatomy

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

  ## Anatomy

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

  ## Anatomy

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

  ## Anatomy

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

  api_doc(~S"""
  Append a toast from `phx-click`. Dispatches `toast:create` on the toast group host (`id`). Optional keyword `opts`: `:id`, `:duration`, `:loading`, `:priority`, `:action`.

  ```heex
  <.action phx-click={Corex.Toast.create("toast-group-id", "Saved", "Draft stored.", :info, duration: 4_000)}>Notify</.action>
  <.toast_group id="toast-group-id" placement="bottom-end" />
  ```

  ```javascript
  document.getElementById("toast-group-id")?.dispatchEvent(
    new CustomEvent("toast:create", {
      bubbles: true,
      detail: { title: "Saved", description: "OK.", type: "info", duration: 4000 },
    })
  );
  ```
  """)

  def create(toast_group_id, title, description, type, opts)
      when is_binary(toast_group_id) and is_list(opts) do
    detail = ToastPayload.create_detail(title, description, type, opts)
    JS.dispatch("toast:create", to: "##{toast_group_id}", detail: detail)
  end

  api_doc(~S"""
  Append a toast from `handle_event` (`toast-create`). Payload includes `groupId` plus Zag fields assembled from the same arguments.

  ```elixir
  def handle_event("notify", _, socket) do
    {:noreply, Corex.Toast.create(socket, "toast-group-id", "Done", "Completed.", :success, duration: 3_000)}
  end
  ```
  """)

  def create(socket, toast_group_id, title, description, type, opts \\ [])
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(toast_group_id) and
             is_list(opts) do
    data = ToastPayload.create_server_data(toast_group_id, title, description, type, opts)
    Phoenix.LiveView.push_event(socket, "toast-create", data)
  end

  api_doc(~S"""
  Patch an existing toast from `phx-click`. Dispatches `toast:update` with `detail.id` and optional fields from `attrs` (map or keyword list).

  ```heex
  <.action phx-click={Corex.Toast.update("toast-group-id", @toast_id, title: "Uploading…", loading: true)}>Update</.action>
  <.toast_group id="toast-group-id" />
  ```
  """)

  def update(toast_group_id, toast_id, attrs)
      when is_binary(toast_group_id) and is_binary(toast_id) and (is_map(attrs) or is_list(attrs)) do
    detail = ToastPayload.update_detail(toast_id, attrs)
    JS.dispatch("toast:update", to: "##{toast_group_id}", detail: detail)
  end

  api_doc(~S"""
  Patch an existing toast from `handle_event` (`toast-update`).

  ```elixir
  def handle_event("patch_toast", %{"id" => id}, socket) do
    {:noreply, Corex.Toast.update(socket, "toast-group-id", id, %{title: "Finished", loading: false})}
  end
  ```
  """)

  def update(socket, toast_group_id, toast_id, attrs)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(toast_group_id) and
             is_binary(toast_id) and
             (is_map(attrs) or is_list(attrs)) do
    data = ToastPayload.update_server_data(toast_group_id, toast_id, attrs)
    Phoenix.LiveView.push_event(socket, "toast-update", data)
  end

  api_doc(~S"""
  Remove a toast immediately from `phx-click`. Dispatches `toast:remove` with `detail.id`.

  ```heex
  <.action phx-click={Corex.Toast.remove("toast-group-id", @toast_id)}>Remove</.action>
  <.toast_group id="toast-group-id" />
  ```
  """)

  def remove(toast_group_id, toast_id) when is_binary(toast_group_id) and is_binary(toast_id) do
    JS.dispatch("toast:remove", to: "##{toast_group_id}", detail: %{id: toast_id})
  end

  api_doc(~S"""
  Remove a toast immediately from `handle_event` (`toast-remove`).

  ```elixir
  def handle_event("drop_toast", %{"id" => id}, socket) do
    {:noreply, Corex.Toast.remove(socket, "toast-group-id", id)}
  end
  ```
  """)

  def remove(socket, toast_group_id, toast_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(toast_group_id) and
             is_binary(toast_id) do
    Phoenix.LiveView.push_event(socket, "toast-remove", %{groupId: toast_group_id, id: toast_id})
  end

  api_doc(~S"""
  Begin dismiss animation from `phx-click`. Dispatches `toast:dismiss` with `detail.id`.

  ```heex
  <.action phx-click={Corex.Toast.dismiss("toast-group-id", @toast_id)}>Dismiss</.action>
  <.toast_group id="toast-group-id" />
  ```
  """)

  def dismiss(toast_group_id, toast_id) when is_binary(toast_group_id) and is_binary(toast_id) do
    JS.dispatch("toast:dismiss", to: "##{toast_group_id}", detail: %{id: toast_id})
  end

  api_doc(~S"""
  Begin dismiss animation from `handle_event` (`toast-dismiss`).

  ```elixir
  def handle_event("fade_out", %{"id" => id}, socket) do
    {:noreply, Corex.Toast.dismiss(socket, "toast-group-id", id)}
  end
  ```
  """)

  def dismiss(socket, toast_group_id, toast_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(toast_group_id) and
             is_binary(toast_id) do
    Phoenix.LiveView.push_event(socket, "toast-dismiss", %{groupId: toast_group_id, id: toast_id})
  end
end
