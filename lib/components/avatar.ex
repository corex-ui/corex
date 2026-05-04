defmodule Corex.Avatar do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Avatar](https://zagjs.com/components/react/avatar).

  ## Examples

  ### Basic

  ```heex
  <.avatar id="avatar" src="/me.jpg" class="avatar">
    <:fallback>JD</:fallback>
  </.avatar>
  ```

  ### Custom fallback with `:let` (`:value` slot)

  Same idea as the angle slider `value_text` slot: override the fallback body and receive the current `src` as `value`.

  ```heex
  <.avatar id="avatar" src="/me.jpg" class="avatar">
    <:value :let={value}>{if value, do: "JD", else: "?"}</:value>
  </.avatar>
  ```

  When the `:value` slot is omitted, `<:fallback>` is used.

  ### `pending` vs the hooked avatar

  With `pending={true}`, the component does **not** mount `phx-hook="Avatar"`, does **not** run Zag, and does **not** render an `<img>`.
  Assigns such as `src` have no visible effect until you re-render with `pending={false}`.
  The `:loading` slot is only used in that pending branch (custom markup or `avatar_skeleton/1` when empty); it is **not** a replacement for the hooked avatar’s own loading UI.

  ### Async loading

  ```elixir
  <.async_result :let={profile} assign={@profile}>
    <:loading>
      <.avatar_skeleton class="avatar" />
    </:loading>
    <:failed>Could not load.</:failed>
    <.avatar id="user-avatar" src={profile.avatar_url} class="avatar">
      <:fallback>{profile.initials}</:fallback>
    </.avatar>
  </.async_result>
  ```

  ### Pending without `async_result`

  ```heex
  <.avatar pending class="avatar">
    <:loading><span class="text-sm">Loading…</span></:loading>
  </.avatar>
  ```

  When `pending` is true and the `:loading` slot is empty, `avatar_skeleton/1` is used.

  ## API

  The API targets one avatar via its DOM `id` (the same `id` you pass to `avatar/1`).

  - `set_src/2` and `set_src/3`
  - `loaded/1`, `loaded/2`, and `loaded/3`

  For `loaded`, use `respond_to: :server | :client | :both` to control whether the response is pushed to LiveView, dispatched as a DOM event, or both.

  ```heex
  <.action phx-click={Corex.Avatar.set_src("my-avatar", "https://example.com/a.png")}>Set image</.action>
  <.action phx-click={Corex.Avatar.loaded("my-avatar")}>Read loaded</.action>
  ```

  ## Events

  User interaction and imperative API use different channels. See also `on_status_change` / `on_status_change_client` on `avatar/1`.

  ### User interaction

  When `phx-hook="Avatar"` is active, Zag invokes **`on_status_change`** (server) and **`on_status_change_client`** (client `CustomEvent` type you set). Params / `event.detail` include `%{"id" => dom_id, "status" => "loaded" | "error"}` (string keys from the server; camelCase in JS `detail` as emitted by the hook).

  ### Imperative API (LiveView helpers and client DOM)

  **From LiveView**, use `Corex.Avatar.set_src/3` and `loaded/3`. They use `push_event/3` to the hook; optional `respond_to` controls where the answer goes for `loaded/3`.

  **From the client**, dispatch `CustomEvent`s on the hook root (e.g. `#my-avatar`):

  | Dispatch (type) | `detail` |
  |-----------------|----------|
  | `corex:avatar:set-src` | `src` — image URL string |
  | `corex:avatar:loaded` | optional `respond_to`: `"server"`, `"client"`, or `"both"` |

  **Responses to LiveView** (`push_event` from the hook; handle in `handle_event/3`):

  - `avatar_loaded_response` — `%{"id" => ..., "loaded" => boolean}`

  **Responses to the DOM** (listen on the hook root element):

  - `avatar-loaded` — `detail` with `id` and `loaded`

  ## Styling

  Use data attributes to target elements:

  ```css
  [data-scope="avatar"][data-part="root"] {}
  [data-scope="avatar"][data-part="image"] {}
  [data-scope="avatar"][data-part="fallback"] {}
  [data-scope="avatar"][data-part="skeleton"] {}
  ```

  If you wish to use the default Corex styling, you can use the class `avatar` on the component.
  This requires to install `Mix.Tasks.Corex.Design` first and import the component css file.

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/avatar.css";
  ```

  You can then use modifiers

  ```heex
  <.avatar class="avatar avatar--accent avatar--lg">
    <:fallback>JD</:fallback>
  </.avatar>
  ```

  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.Avatar.Anatomy.{Fallback, Image, Props, Root, Skeleton}
  alias Corex.Avatar.Connect
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  import Corex.Helpers, only: [respond_to_fields: 1]

  attr(:id, :string, required: false, doc: "The id of the avatar")
  attr(:src, :string, default: nil, doc: "Image source URL")
  attr(:alt, :string, default: "", doc: "Alternative text for the image")
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"], doc: "Direction")

  attr(:pending, :boolean,
    default: false,
    doc:
      "When true, renders only the loading UI (`:loading` slot or `avatar_skeleton/1`), without the Avatar hook."
  )

  attr(:on_status_change, :string,
    default: nil,
    doc: "Server event when image load status changes"
  )

  attr(:on_status_change_client, :string,
    default: nil,
    doc: "Client event when image load status changes"
  )

  attr(:rest, :global)

  slot :loading,
    required: false,
    doc: "Custom loading content when `pending` is true. Overrides default `avatar_skeleton/1`." do
    attr(:class, :string, required: false)
  end

  slot :fallback,
    required: false,
    doc: "Content for the fallback part when the image is absent or not yet shown." do
    attr(:class, :string, required: false)
  end

  slot :value,
    required: false,
    doc:
      "Optional replacement for `:fallback` inner content. Use `:let={value}` — `value` is the image `src` (or `nil`)." do
    attr(:class, :string, required: false)
  end

  def avatar(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "avatar-#{System.unique_integer([:positive])}" end)
      |> assign_new(:dir, fn -> nil end)

    ~H"""
    <div :if={@pending} id={@id} {@rest}>
      <div :if={@loading != []}>
        {render_slot(@loading)}
      </div>
      <.avatar_skeleton :if={@loading == []} {@rest} />
    </div>

    <div
      :if={not @pending}
      id={@id}
      phx-hook="Avatar"
      dir={@dir}
      data-src={@src}
      data-loading
      phx-mounted={Phoenix.LiveView.JS.ignore_attributes(["data-loading"])}
      {@rest}
      {Connect.props(%Props{
        id: @id,
        dir: @dir,
        on_status_change: @on_status_change,
        on_status_change_client: @on_status_change_client
      })}
    >
      <div
        phx-mounted={Connect.ignore_root(%Root{id: @id, dir: @dir})}
        {Connect.root(%Root{id: @id, dir: @dir})}
      >
        <span
          phx-mounted={Connect.ignore_fallback(%Fallback{id: @id, dir: @dir})}
          {Connect.fallback(%Fallback{id: @id, dir: @dir})}
        >
          {if @value != [], do: render_slot(@value, @src), else: render_slot(@fallback)}
        </span>
        <img
          :if={@src}
          phx-mounted={Connect.ignore_image(%Image{id: @id, src: @src, dir: @dir})}
          alt={@alt}
          {Connect.image(%Image{id: @id, src: @src, dir: @dir})}
        />
        <span
          :if={@src}
          phx-mounted={Connect.ignore_skeleton(%Skeleton{id: @id})}
          {Connect.skeleton(%Skeleton{id: @id})}
        />
      </div>
    </div>
    """
  end

  @doc type: :component
  @doc """
  Static loading placeholder for use with `<.async_result>` or when `pending` is true without a `:loading` slot.
  """

  attr(:rest, :global)

  def avatar_skeleton(assigns) do
    ~H"""
    <div {@rest}>
      <div data-scope="avatar" data-part="root" data-loading>
        <span data-scope="avatar" data-part="fallback" aria-hidden="true"></span>
        <span data-scope="avatar" data-part="skeleton"></span>
      </div>
    </div>
    """
  end

  @doc type: :api
  @doc """
  Sets the avatar image URL from the client. Returns a `Phoenix.LiveView.JS` command.

  ## Examples

      <.action phx-click={Corex.Avatar.set_src("my-avatar", "https://example.com/x.png")} class="button button--sm">
        Set src
      </.action>
  """
  def set_src(avatar_id, src) when is_binary(avatar_id) and is_binary(src) do
    JS.dispatch("corex:avatar:set-src",
      to: "##{avatar_id}",
      detail: %{src: src},
      bubbles: false
    )
  end

  @doc type: :api
  @doc """
  Sets the avatar image URL from the server. Pushes a LiveView event handled by the hook.

  ## Examples

      def handle_event("set_avatar", %{"url" => url}, socket) do
        {:noreply, Corex.Avatar.set_src(socket, "my-avatar", url)}
      end
  """
  def set_src(socket, avatar_id, src)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(avatar_id) and is_binary(src) do
    LiveView.push_event(socket, "avatar_set_src", %{id: avatar_id, src: src})
  end

  @doc type: :api
  @doc """
  Requests whether the avatar image is loaded from the browser. Returns a `Phoenix.LiveView.JS` command.

  Options: `:respond_to` — `:server` (default, `avatar_loaded_response` only), `:both`, or `:client` (`avatar-loaded` DOM only).

  ## Examples

      <.action phx-click={Corex.Avatar.loaded("my-avatar")} class="button button--sm">Loaded</.action>
      <.action phx-click={Corex.Avatar.loaded("my-avatar", respond_to: :client)} class="button button--sm">
        Loaded (client)
      </.action>
  """
  def loaded(avatar_id) when is_binary(avatar_id), do: loaded(avatar_id, [])

  def loaded(avatar_id, opts) when is_binary(avatar_id) and is_list(opts) do
    JS.dispatch("corex:avatar:loaded",
      to: "##{avatar_id}",
      detail: respond_to_fields(opts),
      bubbles: false
    )
  end

  @doc type: :api
  @doc """
  Requests loaded state from the client. Pushes a LiveView event handled by the hook.

  See `loaded/2` for `:respond_to`.

  ## Examples

      def handle_event("avatar_loaded_response", %{"id" => id, "loaded" => loaded}, socket) do
        {:noreply, assign(socket, :avatar_loaded, {id, loaded})}
      end
  """
  def loaded(socket, avatar_id, opts \\ [])
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(avatar_id) and is_list(opts) do
    attrs =
      opts
      |> respond_to_fields()
      |> Map.new(fn {k, v} -> {to_string(k), v} end)

    LiveView.push_event(socket, "avatar_loaded", Map.merge(%{"id" => avatar_id}, attrs))
  end
end
