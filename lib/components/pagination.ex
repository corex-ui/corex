defmodule Corex.Pagination do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Pagination](https://zagjs.com/components/react/pagination).

  Pagination and [Carousel](`Corex.Carousel`) both use **1-based** `page` (first page is `1`). Page numbers and ellipses are rendered on the server so the control is complete before the hook runs.

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

  ```heex
  <.pagination class="pagination" count={95} page_size={10}>
    <:prev><.heroicon name="hero-chevron-left" /></:prev>
    <:next><.heroicon name="hero-chevron-right" /></:next>
    <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
  </.pagination>
  ```

  ### Controlled page

  ```heex
  <.pagination
    class="pagination"
    count={18}
    page={@page}
    page_size={4}
    controlled
    on_page_change="pagination_controlled_changed"
  >
    <:prev><.heroicon name="hero-chevron-left" /></:prev>
    <:next><.heroicon name="hero-chevron-right" /></:next>
    <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
  </.pagination>
  ```

  ```elixir
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page, 1)}
  end

  def handle_event("pagination_controlled_changed", %{"page" => page}, socket) do
    {:noreply, assign(socket, :page, page)}
  end
  ```

  ### Link mode

  Set `type={:link}`, `to`, and optional `page_param` / `page_size_param`. The hook builds `href` on each control (SSR and client).

  | `redirect` | Behavior |
  | --- | --- |
  | `:href` (default) | Full page load |
  | `:patch` | `data-phx-link="patch"` (same as `<.navigate type="patch">`) |
  | `:navigate` | `data-phx-link="redirect"` (same as `<.navigate type="navigate">`) |

  For assigns-driven state, prefer `type={:button}`, `controlled`, and `on_page_change` instead of link mode.

  ### Translation

  ```heex
  <.pagination
    class="pagination"
    count={95}
    page_size={10}
    translation={%Corex.Pagination.Translation{
      prev_trigger_label: Corex.Gettext.gettext("Previous page"),
      next_trigger_label: Corex.Gettext.gettext("Next page"),
      item_label:
        Corex.Gettext.gettext("Page %{page} of %{total_pages}",
          page: "%{page}",
          total_pages: "%{total_pages}"
        )
    }}
  >
    <:prev><.heroicon name="hero-chevron-left" /></:prev>
    <:next><.heroicon name="hero-chevron-right" /></:next>
    <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
  </.pagination>
  ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.pagination>`.

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`set_page/2`](#set_page/2) | Set active page (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_page/3`](#set_page/3) | Set active page (server) | `socket` |
  | [`set_page_size/2`](#set_page_size/2) | Set page size (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_page_size/3`](#set_page_size/3) | Set page size (server) | `socket` |
  | [`go_to_next_page/1`](#go_to_next_page/1) | Next page (client) | `%Phoenix.LiveView.JS{}` |
  | [`go_to_next_page/2`](#go_to_next_page/2) | Next page (server) | `socket` |
  | [`go_to_prev_page/1`](#go_to_prev_page/1) | Previous page (client) | `%Phoenix.LiveView.JS{}` |
  | [`go_to_prev_page/2`](#go_to_prev_page/2) | Previous page (server) | `socket` |
  | [`go_to_first_page/1`](#go_to_first_page/1) | First page (client) | `%Phoenix.LiveView.JS{}` |
  | [`go_to_first_page/2`](#go_to_first_page/2) | First page (server) | `socket` |
  | [`go_to_last_page/1`](#go_to_last_page/1) | Last page (client) | `%Phoenix.LiveView.JS{}` |
  | [`go_to_last_page/2`](#go_to_last_page/2) | Last page (server) | `socket` |

  <!-- tabs-open -->

  ### set_page

  ```heex
  <.action phx-click={Corex.Pagination.set_page("pagination-api-bind", 5)} class="button ui-size-sm">5</.action>
  <.pagination id="pagination-api-bind" class="pagination" count={95} page={5} page_size={10}>
    <:prev><.heroicon name="hero-chevron-left" /></:prev>
    <:next><.heroicon name="hero-chevron-right" /></:next>
    <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
  </.pagination>
  ```

  ```elixir
  def handle_event("pagination_api_page_3", _, socket) do
    {:noreply, Corex.Pagination.set_page(socket, "pagination-api-srv", 3)}
  end
  ```

  <!-- tabs-close -->

  ## Events

  Pick an event name and pass it to `on_*` on `<.pagination>`.

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_page_change="pagination_page_changed"` | Active page changes | `%{"id" => id, "page" => page}` |
  | `on_page_size_change="pagination_page_size_changed"` | Page size changes | `%{"id" => id, "page_size" => page_size}` |

  <!-- tabs-open -->

  ### on_page_change

  ```heex
  <.pagination class="pagination" count={95} page_size={10} on_page_change="pagination_page_changed">
    <:prev><.heroicon name="hero-chevron-left" /></:prev>
    <:next><.heroicon name="hero-chevron-right" /></:next>
    <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
  </.pagination>
  ```

  ```elixir
  def handle_event("pagination_page_changed", %{"id" => id, "page" => page}, socket) do
    {:noreply, assign(socket, :page, page)}
  end
  ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_page_change_client="pagination-page-changed"` | Active page changes | `id`, `page`, `page_size` |
  | `on_page_size_change_client="pagination-page-size-changed"` | Page size changes | `id`, `page_size` |

  <!-- tabs-open -->

  ### on_page_change_client

  ```heex
  <.pagination
    id="pagination-events-client"
    class="pagination"
    count={95}
    page_size={10}
    on_page_change_client="pagination-page-changed"
  >
    <:prev><.heroicon name="hero-chevron-left" /></:prev>
    <:next><.heroicon name="hero-chevron-right" /></:next>
    <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
  </.pagination>
  ```

  ```javascript
  document.getElementById("pagination-events-client")?.addEventListener("pagination-page-changed", (e) => {
    console.log(e.detail);
  });
  ```

  <!-- tabs-close -->

  ## Patterns

  <!-- tabs-open -->

  ### Controlled

  Bind `page` (and optionally `page_size`) with `controlled` (`true`, `:all`, `:page`, or `:page_size`) and handle `on_page_change` so assigns stay the source of truth.

  ```heex
  <.pagination
    class="pagination"
    count={18}
    page={@page}
    page_size={4}
    controlled
    on_page_change="pagination_controlled_changed"
  >
    <:prev><.heroicon name="hero-chevron-left" /></:prev>
    <:next><.heroicon name="hero-chevron-right" /></:next>
    <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
  </.pagination>
  ```

  Slice list data on the server (Zag `api.slice` is client-only):

  ```elixir
  offset = (page - 1) * page_size
  Enum.slice(items, offset, page_size)
  ```

  ### Patch (URL)

  Use `type={:link}`, `controlled`, `to`, and `redirect={:patch}` so page and page size sync from query params via `handle_params/3`.

  ```heex
  <.pagination
    class="pagination"
    count={18}
    page={@page}
    page_size={4}
    controlled={:all}
    type={:link}
    to="/posts"
    redirect={:patch}
  >
    <:prev><.heroicon name="hero-chevron-left" /></:prev>
    <:next><.heroicon name="hero-chevron-right" /></:next>
    <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
  </.pagination>
  ```

  <!-- tabs-close -->

  ## Style

  Target parts with `data-scope` and `data-part`, or import `pagination.css` and stack modifiers on the host.

  ```css
  [data-scope="pagination"][data-part="root"] {}
  [data-scope="pagination"][data-part="item"] {}
  [data-scope="pagination"][data-part="ellipsis"] {}
  [data-scope="pagination"][data-part="prev-trigger"][data-disabled] {}
  [data-scope="pagination"][data-part="next-trigger"][data-disabled] {}
  ```

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components.css";
  ```

  Stack modifiers on `<.pagination class="pagination ...">`. Combine axes, for example `pagination pagination ui-accent pagination ui-size-lg` or `pagination pagination ui-info pagination ui-solid`.

  Axes: **Semantic** (`ui-accent`, `ui-brand`, `ui-alert`, `ui-info`, `ui-success`), **Variant** (`ui-solid`), **Size** (`ui-size-sm` … `ui-size-xl`), **Radius** (`ui-rounded-*`). See the [modifier guide](modifiers.html).

  Semantic modifiers set palette variables on item triggers. Variant modifiers control surface treatment. Default is subtle: unselected items use a neutral surface, the active page uses selected with semantic ink text. Add `pagination ui-solid` for filled active and nav triggers.

  <!-- tabs-open -->

  ### Semantic

  Palette variables for pagination ink and fill. Does not change surface treatment by itself.

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `pagination` |
  | Accent | `pagination pagination ui-accent` |
  | Brand | `pagination pagination ui-brand` |
  | Alert | `pagination pagination ui-alert` |
  | Success | `pagination pagination ui-success` |
  | Info | `pagination pagination ui-info` |

  ### Variant

  Visual treatment of prev, next, and page item triggers. Combine with a semantic modifier for palette-driven ink and fill.

  | Modifier | Classes |
  | -------- | ------- |
  | Subtle (default) | `pagination` or `pagination pagination ui-accent` |
  | Solid | `pagination pagination ui-accent pagination ui-solid` |

  ### Size

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `pagination` |
  | SM | `pagination pagination ui-size-sm` |
  | MD | `pagination pagination ui-size-md` |
  | LG | `pagination pagination ui-size-lg` |
  | XL | `pagination pagination ui-size-xl` |

  ### Rounded

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `pagination` |
  | None | `pagination pagination ui-rounded-none` |
  | SM | `pagination pagination ui-rounded-sm` |
  | MD | `pagination pagination ui-rounded-md` |
  | LG | `pagination pagination ui-rounded-lg` |
  | XL | `pagination pagination ui-rounded-xl` |
  | Full | `pagination pagination ui-rounded-full` |

  ### Max width

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `pagination` |
  | SM | `pagination max-w-sm` |
  | MD | `pagination max-w-md` |
  | LG | `pagination max-w-lg` |
  | XL | `pagination max-w-xl` |

  <!-- tabs-close -->
  '''

  @doc type: :component
  use Phoenix.Component

  import Corex.Api.Doc

  alias Corex.Pagination.Anatomy.{NextTrigger, PrevTrigger, Props, Root, SsrEllipsis, SsrPageItem}
  alias Corex.Pagination.Connect
  alias Corex.Pagination.Translation
  alias Corex.Pagination.Utils
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  attr(:id, :string, required: false)
  attr(:count, :integer, required: true, doc: "Total number of data items")
  attr(:page, :integer, default: 1, doc: "Active page (1-based)")
  attr(:page_size, :integer, default: 10, doc: "Items per page")
  attr(:sibling_count, :integer, default: 1, doc: "Pages beside the active page")
  attr(:boundary_count, :integer, default: 1, doc: "Pages at the start and end")

  attr(:controlled, :any,
    default: false,
    doc: """
    false — uncontrolled (default).
    true or :all — server drives both page and page_size.
    :page — server drives page only; use with `on_page_change`.
    :page_size — server drives page_size only; use with `on_page_size_change`.
    """
  )

  attr(:type, :atom,
    default: :button,
    values: [:button, :link],
    doc: "Trigger element type passed to Zag (`:button` or `:link`)"
  )

  attr(:to, :string,
    default: nil,
    doc: "Base path for link mode; hook builds query URLs from `page_param` and `page_size_param`"
  )

  attr(:page_param, :string, default: "page", doc: "Query param name for page in link mode")

  attr(:page_size_param, :string,
    default: "page_size",
    doc: "Query param name for page size in link mode"
  )

  attr(:redirect, :atom,
    default: :href,
    values: [:href, :patch, :navigate],
    doc: "Navigation kind when `type` is `:link` and LiveView is connected"
  )

  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
  attr(:on_page_change, :string, default: nil)
  attr(:on_page_change_client, :string, default: nil)
  attr(:on_page_size_change, :string, default: nil)
  attr(:on_page_size_change_client, :string, default: nil)

  attr(:translation, Translation, default: nil, doc: "Override translatable strings")
  attr(:rest, :global)

  slot :prev, required: true do
    attr(:class, :string)
  end

  slot :next, required: true do
    attr(:class, :string)
  end

  slot :ellipsis, required: true do
    attr(:class, :string)
  end

  def pagination(assigns) do
    validate_slots!(assigns)
    assigns = prepare_pagination_assigns(assigns)

    ~H"""
    <div
      :if={@total_pages > 1}
      id={@id}
      phx-hook="Pagination"
      data-loading
      phx-mounted={Phoenix.LiveView.JS.ignore_attributes(["data-loading"])}
      {@rest}
      {Connect.props(%Props{
        id: @id,
        count: @count,
        page: @page,
        page_size: @page_size,
        controlled: @controlled,
        controlled_page_size: @controlled_page_size,
        sibling_count: @sibling_count,
        boundary_count: @boundary_count,
        type: @type_str,
        to: @to,
        page_param: @page_param,
        page_size_param: @page_size_param,
        redirect: @redirect_str,
        dir: @dir,
        on_page_change: @on_page_change,
        on_page_change_client: @on_page_change_client,
        on_page_size_change: @on_page_size_change,
        on_page_size_change_client: @on_page_size_change_client,
        translation: @translation
      })}
    >
      <nav
        phx-mounted={Connect.ignore_root(%Root{id: @id, dir: @dir, aria_label: @translation.root_label})}
        {Connect.root(%Root{id: @id, dir: @dir, aria_label: @translation.root_label})}
      >
        <ul>
          <li>
            <button
              :if={!@link?}
              type="button"
              phx-mounted={
                Connect.ignore_prev_trigger(%PrevTrigger{
                  id: @id,
                  dir: @dir,
                  disabled: @prev_disabled,
                  aria_label: @translation.prev_trigger_label,
                  tag: "button"
                })
              }
              {Connect.prev_trigger(%PrevTrigger{
                id: @id,
                dir: @dir,
                disabled: @prev_disabled,
                aria_label: @translation.prev_trigger_label,
                tag: "button"
              })}
            >
              {render_slot(@prev)}
            </button>
            <a
              :if={@link?}
              phx-mounted={
                Connect.ignore_prev_trigger(%PrevTrigger{
                  id: @id,
                  dir: @dir,
                  disabled: @prev_disabled,
                  aria_label: @translation.prev_trigger_label,
                  href: @prev_href,
                  redirect: @redirect_str,
                  tag: "link"
                })
              }
              {Connect.prev_trigger(%PrevTrigger{
                id: @id,
                dir: @dir,
                disabled: @prev_disabled,
                aria_label: @translation.prev_trigger_label,
                href: @prev_href,
                redirect: @redirect_str,
                tag: "link"
              })}
            >
              {render_slot(@prev)}
            </a>
          </li>
          <li
            :for={{entry, index} <- Enum.with_index(@page_entries)}
            data-pagination-part="page"
          >
            <button
              :if={entry.type == :page and !@link?}
              type="button"
              phx-mounted={Connect.ignore_ssr_page_item(ssr_page_item_for(@ssr, entry.value, index))}
              {Connect.ssr_page_item(ssr_page_item_for(@ssr, entry.value, index))}
            >
              {entry.value}
            </button>
            <a
              :if={entry.type == :page and @link?}
              phx-mounted={Connect.ignore_ssr_page_item(ssr_page_item_for(@ssr, entry.value, index))}
              {Connect.ssr_page_item(ssr_page_item_for(@ssr, entry.value, index))}
            >
              {entry.value}
            </a>
            <span
              :if={entry.type == :ellipsis}
              phx-mounted={Connect.ignore_ssr_ellipsis(%SsrEllipsis{id: @id, dir: @dir, index: index})}
              {Connect.ssr_ellipsis(%SsrEllipsis{id: @id, dir: @dir, index: index})}
            >
              {render_slot(@ellipsis)}
            </span>
          </li>
          <li data-pagination-part="next">
            <button
              :if={!@link?}
              type="button"
              phx-mounted={
                Connect.ignore_next_trigger(%NextTrigger{
                  id: @id,
                  dir: @dir,
                  disabled: @next_disabled,
                  aria_label: @translation.next_trigger_label,
                  tag: "button"
                })
              }
              {Connect.next_trigger(%NextTrigger{
                id: @id,
                dir: @dir,
                disabled: @next_disabled,
                aria_label: @translation.next_trigger_label,
                tag: "button"
              })}
            >
              {render_slot(@next)}
            </button>
            <a
              :if={@link?}
              phx-mounted={
                Connect.ignore_next_trigger(%NextTrigger{
                  id: @id,
                  dir: @dir,
                  disabled: @next_disabled,
                  aria_label: @translation.next_trigger_label,
                  href: @next_href,
                  redirect: @redirect_str,
                  tag: "link"
                })
              }
              {Connect.next_trigger(%NextTrigger{
                id: @id,
                dir: @dir,
                disabled: @next_disabled,
                aria_label: @translation.next_trigger_label,
                href: @next_href,
                redirect: @redirect_str,
                tag: "link"
              })}
            >
              {render_slot(@next)}
            </a>
          </li>
        </ul>
      </nav>
      <div data-pagination-ellipsis-template hidden aria-hidden="true">
        {render_slot(@ellipsis)}
      </div>
    </div>
    """
  end

  defp prepare_pagination_assigns(assigns) do
    page_size = assigns.page_size |> positive_int(10) |> max(1)
    count = assigns.count |> non_negative_int(0)
    total_pages = total_pages_for(count, page_size)
    {type_str, redirect_str} = type_and_redirect(assigns)
    page = assigns.page

    {prev_disabled, next_disabled, prev_href, next_href, link?} =
      link_navigation(assigns, type_str, page, total_pages, page_size)

    page_entries =
      Utils.pages(page, total_pages, assigns.sibling_count, assigns.boundary_count)

    translation = Translation.resolve(assigns.translation)
    {controlled_page, controlled_page_size} = normalize_pagination_controlled(assigns.controlled)

    assigns
    |> assign(:controlled, controlled_page)
    |> assign(:controlled_page_size, controlled_page_size)
    |> assign_new(:dir, fn -> "ltr" end)
    |> assign_new(:translation, fn -> Translation.resolve(nil) end)
    |> assign(:translation, translation)
    |> assign(:page_size, page_size)
    |> assign(:count, count)
    |> assign(:total_pages, total_pages)
    |> assign(:type_str, type_str)
    |> assign(:redirect_str, redirect_str)
    |> assign(:page_entries, page_entries)
    |> assign(:prev_disabled, prev_disabled)
    |> assign(:next_disabled, next_disabled)
    |> assign(:prev_href, prev_href)
    |> assign(:next_href, next_href)
    |> assign(:link?, link?)
    |> then(fn prepared ->
      assign(prepared, :ssr, %{
        id: prepared.id,
        dir: prepared.dir,
        current_page: page,
        total_pages: total_pages,
        translation: translation,
        type_str: type_str,
        redirect_str: redirect_str,
        to: prepared.to,
        page_param: prepared.page_param,
        page_size_param: prepared.page_size_param,
        page_size: page_size
      })
    end)
  end

  defp total_pages_for(0, _page_size), do: 0
  defp total_pages_for(count, page_size), do: div(count + page_size - 1, page_size)

  defp positive_int(nil, default), do: default
  defp positive_int(n, _default) when is_integer(n) and n > 0, do: n
  defp positive_int(_, default), do: default

  defp non_negative_int(nil, default), do: default
  defp non_negative_int(n, _default) when is_integer(n) and n >= 0, do: n
  defp non_negative_int(_, default), do: default

  defp type_and_redirect(%{type: :link, redirect: redirect}) do
    {"link", Atom.to_string(redirect)}
  end

  defp type_and_redirect(_assigns), do: {"button", nil}

  defp link_navigation(assigns, type_str, page, total_pages, page_size) do
    prev_disabled = page <= 1
    next_disabled = page >= total_pages
    link? = type_str == "link"
    base_to = assigns.to

    prev_href =
      if page > 1, do: page_link_href(link?, base_to, assigns, page - 1, page_size)

    next_href =
      if page < total_pages,
        do: page_link_href(link?, base_to, assigns, page + 1, page_size)

    {prev_disabled, next_disabled, prev_href, next_href, link?}
  end

  defp page_link_href(false, _base_to, _assigns, _page, _page_size), do: nil
  defp page_link_href(true, nil, _assigns, _page, _page_size), do: nil

  defp page_link_href(true, base_to, assigns, page, page_size) do
    Utils.page_href(base_to, assigns.page_param, assigns.page_size_param, page, page_size)
  end

  defp ssr_page_item_for(ssr, page_value, index) do
    ssr_page_item_attrs(Map.merge(ssr, %{page_value: page_value, index: index}))
  end

  defp ssr_page_item_attrs(ctx) do
    link? = ctx.type_str == "link"

    href =
      if link? && ctx.to,
        do:
          Utils.page_href(
            ctx.to,
            ctx.page_param,
            ctx.page_size_param,
            ctx.page_value,
            ctx.page_size
          )

    %SsrPageItem{
      id: ctx.id,
      dir: ctx.dir,
      page: ctx.page_value,
      index: ctx.index,
      selected: ctx.page_value == ctx.current_page,
      aria_label:
        Utils.format_item_label(ctx.translation.item_label, ctx.page_value, ctx.total_pages),
      href: href,
      redirect: ctx.redirect_str,
      tag: ctx.type_str
    }
  end

  defp validate_slots!(assigns) do
    if assigns.prev == [] or assigns.next == [] or assigns.ellipsis == [] do
      raise ArgumentError,
            "Corex.Pagination requires non-empty :prev, :next, and :ellipsis slots"
    end
  end

  api_doc(~S"""
  Set the current **1-based** page from `phx-click`. Dispatches `corex:pagination:set-page` with `detail.page`.

  ```heex
  <.action phx-click={Corex.Pagination.set_page("my-pagination", 2)}>Page 2</.action>
  <.pagination id="my-pagination" class="pagination" count={95} page={1} page_size={10}>
    <:prev><.heroicon name="hero-chevron-left" /></:prev>
    <:next><.heroicon name="hero-chevron-right" /></:next>
    <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
  </.pagination>
  ```

  ```javascript
  document.getElementById("my-pagination")?.dispatchEvent(
    new CustomEvent("corex:pagination:set-page", {
      bubbles: false,
      detail: { page: 2 },
    })
  );
  ```
  """)

  def set_page(pagination_id, page) when is_binary(pagination_id) and is_integer(page) do
    JS.dispatch("corex:pagination:set-page",
      to: "##{pagination_id}",
      detail: %{page: page}
    )
  end

  api_doc(~S"""
  Set the current page from `handle_event` (`pagination_set_page`).

  ```elixir
  def handle_event("set_page", %{"page" => page}, socket) do
    {:noreply, Corex.Pagination.set_page(socket, "my-pagination", String.to_integer(page))}
  end
  ```
  """)

  def set_page(socket, pagination_id, page)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(pagination_id) and
             is_integer(page) do
    LiveView.push_event(socket, "pagination_set_page", %{id: pagination_id, page: page})
  end

  api_doc(~S"""
  Change page size from `phx-click`. Dispatches `corex:pagination:set-page-size` with `detail.page_size`.

  ```heex
  <.action phx-click={Corex.Pagination.set_page_size("my-pagination", 20)}>20 per page</.action>
  <.pagination id="my-pagination" class="pagination" count={95} page={1} page_size={10}>
    <:prev><.heroicon name="hero-chevron-left" /></:prev>
    <:next><.heroicon name="hero-chevron-right" /></:next>
    <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
  </.pagination>
  ```
  """)

  def set_page_size(pagination_id, page_size)
      when is_binary(pagination_id) and is_integer(page_size) do
    JS.dispatch("corex:pagination:set-page-size",
      to: "##{pagination_id}",
      detail: %{page_size: page_size}
    )
  end

  api_doc(~S"""
  Change page size from `handle_event` (`pagination_set_page_size`).

  ```elixir
  def handle_event("set_size", _params, socket) do
    {:noreply, Corex.Pagination.set_page_size(socket, "my-pagination", 25)}
  end
  ```
  """)

  def set_page_size(socket, pagination_id, page_size)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(pagination_id) and
             is_integer(page_size) do
    LiveView.push_event(socket, "pagination_set_page_size", %{
      id: pagination_id,
      page_size: page_size
    })
  end

  api_doc(~S"""
  Go to the next page from `phx-click`. Dispatches `corex:pagination:go-to-next-page`.

  ```heex
  <.action phx-click={Corex.Pagination.go_to_next_page("my-pagination")}>Next</.action>
  <.pagination id="my-pagination" class="pagination" count={95} page={1} page_size={10}>
    <:prev><.heroicon name="hero-chevron-left" /></:prev>
    <:next><.heroicon name="hero-chevron-right" /></:next>
    <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
  </.pagination>
  ```
  """)

  def go_to_next_page(pagination_id) when is_binary(pagination_id) do
    JS.dispatch("corex:pagination:go-to-next-page", to: "##{pagination_id}", detail: %{})
  end

  api_doc(~S"""
  Go to the next page from `handle_event` (`pagination_go_to_next_page`).

  ```elixir
  def handle_event("next", _params, socket) do
    {:noreply, Corex.Pagination.go_to_next_page(socket, "my-pagination")}
  end
  ```
  """)

  def go_to_next_page(socket, pagination_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(pagination_id) do
    LiveView.push_event(socket, "pagination_go_to_next_page", %{id: pagination_id})
  end

  api_doc(~S"""
  Go to the previous page from `phx-click`. Dispatches `corex:pagination:go-to-prev-page`.

  ```heex
  <.action phx-click={Corex.Pagination.go_to_prev_page("my-pagination")}>Previous</.action>
  <.pagination id="my-pagination" class="pagination" count={95} page={1} page_size={10}>
    <:prev><.heroicon name="hero-chevron-left" /></:prev>
    <:next><.heroicon name="hero-chevron-right" /></:next>
    <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
  </.pagination>
  ```
  """)

  def go_to_prev_page(pagination_id) when is_binary(pagination_id) do
    JS.dispatch("corex:pagination:go-to-prev-page", to: "##{pagination_id}", detail: %{})
  end

  api_doc(~S"""
  Go to the previous page from `handle_event` (`pagination_go_to_prev_page`).

  ```elixir
  def handle_event("prev", _params, socket) do
    {:noreply, Corex.Pagination.go_to_prev_page(socket, "my-pagination")}
  end
  ```
  """)

  def go_to_prev_page(socket, pagination_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(pagination_id) do
    LiveView.push_event(socket, "pagination_go_to_prev_page", %{id: pagination_id})
  end

  api_doc(~S"""
  Go to page `1` from `phx-click`. Dispatches `corex:pagination:go-to-first-page`.

  ```heex
  <.action phx-click={Corex.Pagination.go_to_first_page("my-pagination")}>First</.action>
  <.pagination id="my-pagination" class="pagination" count={95} page={1} page_size={10}>
    <:prev><.heroicon name="hero-chevron-left" /></:prev>
    <:next><.heroicon name="hero-chevron-right" /></:next>
    <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
  </.pagination>
  ```
  """)

  def go_to_first_page(pagination_id) when is_binary(pagination_id) do
    JS.dispatch("corex:pagination:go-to-first-page", to: "##{pagination_id}", detail: %{})
  end

  api_doc(~S"""
  Go to first page from `handle_event` (`pagination_go_to_first_page`).

  ```elixir
  def handle_event("first", _params, socket) do
    {:noreply, Corex.Pagination.go_to_first_page(socket, "my-pagination")}
  end
  ```
  """)

  def go_to_first_page(socket, pagination_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(pagination_id) do
    LiveView.push_event(socket, "pagination_go_to_first_page", %{id: pagination_id})
  end

  api_doc(~S"""
  Go to the last page from `phx-click`. Dispatches `corex:pagination:go-to-last-page`.

  ```heex
  <.action phx-click={Corex.Pagination.go_to_last_page("my-pagination")}>Last</.action>
  <.pagination id="my-pagination" class="pagination" count={95} page={1} page_size={10}>
    <:prev><.heroicon name="hero-chevron-left" /></:prev>
    <:next><.heroicon name="hero-chevron-right" /></:next>
    <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
  </.pagination>
  ```
  """)

  def go_to_last_page(pagination_id) when is_binary(pagination_id) do
    JS.dispatch("corex:pagination:go-to-last-page", to: "##{pagination_id}", detail: %{})
  end

  api_doc(~S"""
  Go to last page from `handle_event` (`pagination_go_to_last_page`).

  ```elixir
  def handle_event("last", _params, socket) do
    {:noreply, Corex.Pagination.go_to_last_page(socket, "my-pagination")}
  end
  ```
  """)

  def go_to_last_page(socket, pagination_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(pagination_id) do
    LiveView.push_event(socket, "pagination_go_to_last_page", %{id: pagination_id})
  end

  defp normalize_pagination_controlled(false), do: {false, false}
  defp normalize_pagination_controlled(true), do: {true, true}
  defp normalize_pagination_controlled(:all), do: {true, true}
  defp normalize_pagination_controlled(:page), do: {true, false}
  defp normalize_pagination_controlled(:page_size), do: {false, true}
end
