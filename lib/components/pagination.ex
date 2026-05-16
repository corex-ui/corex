defmodule Corex.Pagination do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Pagination](https://zagjs.com/components/react/pagination).

  Pagination `page` is **1-based** (first page is `1`). [Carousel](`Corex.Carousel`) `page` is **0-based** — do not mix the two.

  Page numbers and ellipses are rendered on the server (same markup as the client) so the control is complete before the hook runs.

  ## Examples

  ### Minimal

  ```heex
  <.pagination id="p1" class="pagination" count={120} page_size={10}>
    <:prev><.heroicon name="hero-chevron-left" /></:prev>
    <:next><.heroicon name="hero-chevron-right" /></:next>
    <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
  </.pagination>
  ```

  ### Controlled page (LiveView)

  ```elixir
  def handle_event("page_changed", %{"page" => page}, socket) do
    {:noreply, assign(socket, :page, page)}
  end
  ```

  ```heex
  <.pagination
    id="results"
    class="pagination"
    count={500}
    page={@page}
    page_size={20}
    controlled
    on_page_change="page_changed"
  >
    <:prev><.heroicon name="hero-chevron-left" /></:prev>
    <:next><.heroicon name="hero-chevron-right" /></:next>
    <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
  </.pagination>
  ```

  Slice data on the server (Zag `api.slice` is client-only):

  ```elixir
  offset = (@page - 1) * @page_size
  Enum.slice(items, offset, @page_size)
  ```

  ### Controlled page size

  Use `controlled_page_size` with `on_page_size_change` independently of `controlled` / `page`.

  ### Link mode

  Set `type={:link}`, `to`, and optional `page_param` / `page_size_param`. The hook builds `href` on each page, previous, and next control (SSR and client).

  | `redirect` | Behavior |
  | --- | --- |
  | `:href` (default) | Normal anchor navigation (full page load) |
  | `:patch` | Phoenix live link: `data-phx-link="patch"` on anchors (same as `<.navigate type="patch">`) |
  | `:navigate` | Phoenix live link: `data-phx-link="redirect"` on anchors (same as `<.navigate type="navigate">`) |

  Caller must assert the LiveView route accepts patch or navigate for the generated URLs.

  For state held in assigns (not the URL), prefer `type={:button}`, `controlled`, and `push_patch/2` inside `on_page_change` instead of link mode.

  ### Translation

  ```heex
  <.pagination
    translation={%Corex.Pagination.Translation{
      prev_trigger_label: Corex.Gettext.gettext("Previous page"),
      next_trigger_label: Corex.Gettext.gettext("Next page"),
      item_label: Corex.Gettext.gettext("Page %{page} of %{total_pages}")
    }}
    ...
  />
  ```

  ## Styling

  ```css
  @import "../corex/components/pagination.css";
  ```

  ```heex
  <.pagination class="pagination pagination--accent pagination--lg" ...>
  ```

  Target parts:

  ```css
  [data-scope="pagination"][data-part="root"] {}
  [data-scope="pagination"][data-part="item"] {}
  [data-scope="pagination"][data-part="ellipsis"] {}
  [data-scope="pagination"][data-part="prev-trigger"][data-disabled] {}
  [data-scope="pagination"][data-part="next-trigger"][data-disabled] {}
  ```
  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.Gettext
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

  attr(:controlled, :boolean,
    default: false,
    doc: "When true, `page` is server-driven; use with `on_page_change` in LiveView"
  )

  attr(:controlled_page_size, :boolean,
    default: false,
    doc: "When true, `page_size` is server-driven; use with `on_page_size_change`"
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
    default_translation = default_translation()
    page_size = max(assigns.page_size, 1)
    count = max(assigns.count, 0)
    total_pages = total_pages_for(count, page_size)
    {type_str, redirect_str} = type_and_redirect(assigns)
    page = assigns.page

    {prev_disabled, next_disabled, prev_href, next_href, link?} =
      link_navigation(assigns, type_str, page, total_pages, page_size)

    page_entries =
      Utils.pages(page, total_pages, assigns.sibling_count, assigns.boundary_count)

    translation = merge_translation(assigns.translation, default_translation)

    assigns
    |> assign_new(:id, fn -> "pagination-#{System.unique_integer([:positive])}" end)
    |> assign_new(:dir, fn -> "ltr" end)
    |> assign_new(:translation, fn -> default_translation end)
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

  defp default_translation do
    %Translation{
      root_label: Gettext.gettext("Pagination"),
      prev_trigger_label: Gettext.gettext("Previous page"),
      next_trigger_label: Gettext.gettext("Next page"),
      item_label: "Page %{page} of %{total_pages}"
    }
  end

  defp total_pages_for(0, _page_size), do: 0
  defp total_pages_for(count, page_size), do: div(count + page_size - 1, page_size)

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

  defp merge_translation(nil, default), do: default

  defp merge_translation(%Translation{} = partial, %Translation{} = default) do
    %Translation{
      root_label: partial.root_label || default.root_label,
      prev_trigger_label: partial.prev_trigger_label || default.prev_trigger_label,
      next_trigger_label: partial.next_trigger_label || default.next_trigger_label,
      item_label: partial.item_label || default.item_label
    }
  end

  @doc type: :api
  def set_page(pagination_id, page) when is_binary(pagination_id) and is_integer(page) do
    JS.dispatch("corex:pagination:set-page",
      to: "##{pagination_id}",
      detail: %{page: page}
    )
  end

  @doc type: :api
  def set_page(socket, pagination_id, page)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(pagination_id) and
             is_integer(page) do
    LiveView.push_event(socket, "pagination_set_page", %{id: pagination_id, page: page})
  end

  @doc type: :api
  def set_page_size(pagination_id, page_size)
      when is_binary(pagination_id) and is_integer(page_size) do
    JS.dispatch("corex:pagination:set-page-size",
      to: "##{pagination_id}",
      detail: %{page_size: page_size}
    )
  end

  @doc type: :api
  def set_page_size(socket, pagination_id, page_size)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(pagination_id) and
             is_integer(page_size) do
    LiveView.push_event(socket, "pagination_set_page_size", %{
      id: pagination_id,
      page_size: page_size
    })
  end

  @doc type: :api
  def go_to_next_page(pagination_id) when is_binary(pagination_id) do
    JS.dispatch("corex:pagination:go-to-next-page", to: "##{pagination_id}", detail: %{})
  end

  @doc type: :api
  def go_to_next_page(socket, pagination_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(pagination_id) do
    LiveView.push_event(socket, "pagination_go_to_next_page", %{id: pagination_id})
  end

  @doc type: :api
  def go_to_prev_page(pagination_id) when is_binary(pagination_id) do
    JS.dispatch("corex:pagination:go-to-prev-page", to: "##{pagination_id}", detail: %{})
  end

  @doc type: :api
  def go_to_prev_page(socket, pagination_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(pagination_id) do
    LiveView.push_event(socket, "pagination_go_to_prev_page", %{id: pagination_id})
  end

  @doc type: :api
  def go_to_first_page(pagination_id) when is_binary(pagination_id) do
    JS.dispatch("corex:pagination:go-to-first-page", to: "##{pagination_id}", detail: %{})
  end

  @doc type: :api
  def go_to_first_page(socket, pagination_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(pagination_id) do
    LiveView.push_event(socket, "pagination_go_to_first_page", %{id: pagination_id})
  end

  @doc type: :api
  def go_to_last_page(pagination_id) when is_binary(pagination_id) do
    JS.dispatch("corex:pagination:go-to-last-page", to: "##{pagination_id}", detail: %{})
  end

  @doc type: :api
  def go_to_last_page(socket, pagination_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(pagination_id) do
    LiveView.push_event(socket, "pagination_go_to_last_page", %{id: pagination_id})
  end
end
