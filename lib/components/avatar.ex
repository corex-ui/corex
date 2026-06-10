defmodule Corex.Avatar do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Avatar](https://zagjs.com/components/react/avatar).

  ## Anatomy

  <!-- tabs-open -->

  ### Fallback

  ```heex
  <.avatar src="">
    <:fallback>
      <span class="font-semibold">AB</span>
    </:fallback>
  </.avatar>
  ```

  ### Value slot

  Override fallback body and receive the current `src` as `value`. When `:value` is omitted, `<:fallback>` is used.

  ```heex
  <.avatar src="https://corex-ui.com/images/avatar.png" alt="">
    <:value :let={src}>
      {if src, do: "IMG", else: " - "}
    </:value>
  </.avatar>
  ```

  ### Pending

  With `pending={true}`, the hook and `<img>` are not mounted until `pending={false}`. Use `:loading` or `avatar_skeleton/1`.

  ```heex
  <.avatar pending>
    <:loading><span class="text-sm">Loading</span></:loading>
  </.avatar>
  ```

  <!-- tabs-close -->

  ## Styling

  Style attrs and BEM classes are equivalent. See [Unstyled](unstyled.html). Axes: `size`, `radius`.

  <!-- tabs-open -->

  ### With attributes

  ```heex
  <.avatar size="md" class="avatar" src="">
    <:fallback>AB</:fallback>
  </.avatar>
  ```

  ### With classes

  ```heex
  <.avatar class="avatar avatar--size-md" src="">
    <:fallback>AB</:fallback>
  </.avatar>
  ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.avatar>`.

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`set_src/2`](#set_src/2) | Set image URL (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_src/3`](#set_src/3) | Set image URL (server) | `socket` |
  | [`loaded/1`](#loaded/1) | Read loaded state (client) | `%Phoenix.LiveView.JS{}` |
  | [`loaded/2`](#loaded/2) | Read loaded state with `respond_to` (client) | `%Phoenix.LiveView.JS{}` |
  | [`loaded/3`](#loaded/3) | Read loaded state (server) | `socket` |

  For `loaded`, use `respond_to: :server | :client | :both`. LiveView receives `avatar_loaded_response`; the DOM receives `avatar-loaded`.

  ## Events

  Pick an event name and pass it to `on_*` on `<.avatar>`.

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_status_change="avatar_status_changed"` | Image load status changes | `%{"id" => id, "status" => "loaded" \| "error"}` |

  <!-- tabs-open -->

  ### on_status_change

  ```heex
  <.avatar
    src="https://corex-ui.com/images/avatar.png"
    alt="Avatar"
    on_status_change="avatar_status_changed"
  >
    <:fallback>JD</:fallback>
  </.avatar>
  ```

  ```elixir
  def handle_event("avatar_status_changed", %{"id" => _id, "status" => status}, socket) do
    {:noreply, assign(socket, :avatar_status, status)}
  end
  ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_status_change_client="avatar-status-changed"` | Image load status changes | `id`, `status` |

  <!-- tabs-open -->

  ### on_status_change_client

  ```heex
  <.avatar
    id="avatar-events-client"
    src="https://corex-ui.com/images/avatar.png"
    on_status_change_client="avatar-status-changed"
  >
    <:fallback>JD</:fallback>
  </.avatar>
  ```

  ```javascript
  const el = document.getElementById("avatar-events-client");
  el?.addEventListener("avatar-status-changed", (e) => console.log(e.detail));
  ```

  <!-- tabs-close -->

  ## Style

  Target parts with `data-scope` and `data-part`, or use [Corex Design](styled.html): `@import "./corex.tailwind.css"` in `app.css`.

  ```css
  [data-scope="avatar"][data-part="root"] {}
  [data-scope="avatar"][data-part="image"] {}
  [data-scope="avatar"][data-part="fallback"] {}
  [data-scope="avatar"][data-part="skeleton"] {}
  ```

  Stack modifiers on the host (`class` on `<.avatar>`).

  <!-- tabs-open -->

  ### Color

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `avatar` |
  | Accent | `avatar avatar--semantic-accent` |
  | Brand | `avatar avatar--semantic-brand` |
  | Alert | `avatar avatar--semantic-alert` |
  | Info | `avatar avatar--semantic-info` |
  | Success | `avatar avatar--semantic-success` |

  ### Size

  | Modifier | Classes |
  | -------- | ------- |
  | SM | `avatar avatar--size-sm` |
  | MD | `avatar avatar--size-md` |
  | LG | `avatar avatar--size-lg` |
  | XL | `avatar avatar--size-xl` |

  <!-- tabs-close -->

  '''

  @doc type: :component
  use Phoenix.Component

  use Corex.Variants,
    base: "avatar",
    axes: [
      width: :width,
      max_width: :max_width,
      height: :height,
      max_height: :max_height,
      size: :size,
      radius: :radius
    ],
    defaults: [
      width: "auto",
      max_width: "none",
      height: "auto",
      max_height: "none",
      size: "md"
    ]

  import Corex.Api.Doc

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
      "Optional replacement for `:fallback` inner content. Use `:let={value}`  -  `value` is the image `src` (or `nil`)." do
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
      <.avatar_skeleton :if={@loading == []} id={@id} {@rest} />
    </div>

    <div
      :if={not @pending}
      id={@id}
      phx-hook="Avatar"
      class={corex_style_class(assigns)}
     
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

  api_doc(~S"""
  Set the image `src` from a control (`phx-click`).

  ```heex
  <.action phx-click={Corex.Avatar.set_src("my-avatar", "https://example.com/a.png")}>A</.action>
  <.avatar id="my-avatar" class="avatar" src={nil} />
  ```

  ```javascript
  document.getElementById("my-avatar")?.dispatchEvent(
    new CustomEvent("corex:avatar:set-src", {
      bubbles: false,
      detail: { src: "https://example.com/a.png" },
    })
  );
  ```
  """)

  def set_src(avatar_id, src) when is_binary(avatar_id) and is_binary(src) do
    JS.dispatch("corex:avatar:set-src",
      to: "##{avatar_id}",
      detail: %{src: src},
      bubbles: false
    )
  end

  api_doc(~S"""
  Set `src` from `handle_event`.

  ```heex
  <.action phx-click="avatar_a" phx-value-src="https://example.com/a.png">A</.action>
  <.avatar id="my-avatar" class="avatar" src={nil} />
  ```

  ```elixir
  def handle_event("avatar_a", %{"src" => src}, socket) do
    {:noreply, Corex.Avatar.set_src(socket, "my-avatar", src)}
  end
  ```
  """)

  def set_src(socket, avatar_id, src)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(avatar_id) and is_binary(src) do
    LiveView.push_event(socket, "avatar_set_src", %{id: avatar_id, src: src})
  end

  @doc false
  def loaded(avatar_id) when is_binary(avatar_id), do: loaded(avatar_id, [])

  api_doc(~S"""
  Read image load status from `phx-click`. Optional `respond_to:` `:server` (default), `:client`, or `:both`.

  ```heex
  <.action phx-click={Corex.Avatar.loaded("my-avatar", respond_to: :both)}>Status</.action>
  <.avatar id="my-avatar" class="avatar" src="https://example.com/a.png" />
  ```

  ```javascript
  document.getElementById("my-avatar")?.dispatchEvent(
    new CustomEvent("corex:avatar:loaded", {
      bubbles: false,
      detail: { respond_to: "both" },
    })
  );
  ```
  """)

  def loaded(avatar_id, opts) when is_binary(avatar_id) and is_list(opts) do
    JS.dispatch("corex:avatar:loaded",
      to: "##{avatar_id}",
      detail: respond_to_fields(opts),
      bubbles: false
    )
  end

  api_doc(~S"""
  Read load status from `handle_event`. Same `respond_to` behavior as [`loaded/2`](#loaded/2).

  ```heex
  <.action phx-click="avatar_status">Status</.action>
  <.avatar id="my-avatar" class="avatar" src="https://example.com/a.png" />
  ```

  ```elixir
  def handle_event("avatar_status", _, socket) do
    {:noreply, Corex.Avatar.loaded(socket, "my-avatar", respond_to: :server)}
  end
  ```
  """)

  def loaded(socket, avatar_id, opts \\ [])
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(avatar_id) and is_list(opts) do
    attrs =
      opts
      |> respond_to_fields()
      |> Map.new(fn {k, v} -> {to_string(k), v} end)

    LiveView.push_event(socket, "avatar_loaded", Map.merge(%{"id" => avatar_id}, attrs))
  end
end
