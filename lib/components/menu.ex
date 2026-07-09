defmodule Corex.Menu do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Menu](https://zagjs.com/components/react/menu).

  ## Anatomy

  <!-- tabs-open -->

  ### List

  You must use `Corex.Tree.Item` struct for items.

  The value for each item is optional in maps passed to `Corex.Tree.new/1` (auto-generated when omitted).

  You can specify disabled for each item and nested children.

  ```heex
  <.menu
    class="menu"
    items={[
      %Corex.Tree.Item{
        value: "edit",
        label: "Edit"
      },
      %Corex.Tree.Item{
        value: "duplicate",
        label: "Duplicate"
      },
      %Corex.Tree.Item{
        value: "delete",
        label: "Delete"
      }
    ]}
  >
    <:trigger>Actions</:trigger>
    <:indicator>
      <.heroicon name="hero-chevron-down" />
    </:indicator>
  </.menu>
  ```

  ### Nested Menu

  Use `children` in `Corex.Tree.Item` to create nested menus.

  ```heex
  <.menu
    class="menu"
    items={[
      %Corex.Tree.Item{
        value: "new-tab",
        label: "New tab"
      },
      %Corex.Tree.Item{
        value: "share",
        label: "Share",
        children: [
          %Corex.Tree.Item{
            value: "messages",
            label: "Messages"
          },
          %Corex.Tree.Item{
            value: "airdrop",
            label: "Airdrop"
          },
          %Corex.Tree.Item{
            value: "whatsapp",
            label: "WhatsApp"
          }
        ]
      },
      %Corex.Tree.Item{
        value: "print",
        label: "Print"
      }
    ]}
  >
    <:trigger>Click me</:trigger>
  </.menu>
  ```

  ### Nested Menu with Custom Indicator

  Use the `:nested_indicator` slot to customize the indicator shown on items with nested menus (defaults to arrow right →).

  ```heex
  <.menu
    class="menu"
    items={[
      %Corex.Tree.Item{
        value: "share",
        label: "Share",
        children: [
          %Corex.Tree.Item{value: "messages", label: "Messages"}
        ]
      }
    ]}
  >
    <:trigger>Click me</:trigger>
    <:nested_indicator>
      <.heroicon name="hero-arrow-right" />
    </:nested_indicator>
  </.menu>
  ```

  ### Grouped Items

  Use `group` in `Corex.Tree.Item` to group related items. The group value is used as the section label (same as select).

  ```heex
  <.menu
    class="menu"
    items={[
      %Corex.Tree.Item{
        value: "edit",
        label: "Edit",
        group: "Actions"
      },
      %Corex.Tree.Item{
        value: "duplicate",
        label: "Duplicate",
        group: "Actions"
      },
      %Corex.Tree.Item{
        value: "account-1",
        label: "Account 1",
        group: "Accounts"
      },
      %Corex.Tree.Item{
        value: "account-2",
        label: "Account 2",
        group: "Accounts"
      }
    ]}
  >
    <:trigger>Actions</:trigger>
    <:indicator>
      <.heroicon name="hero-chevron-down" />
    </:indicator>
  </.menu>
  ```

  <!-- tabs-close -->

  ## Patterns

  <!-- tabs-open -->

  ### Navigation

  Set `redirect` on the component so selecting an item navigates to the item's value (e.g. path).
  Per item, choose the navigation kind explicitly via the item's `:redirect` field:

    * `:href` (default) - full page redirect via `window.location` (safe everywhere)
    * `:patch` - LiveView `js().patch(url)` (caller asserts: same LV mount + matching live route)
    * `:navigate` - LiveView `js().navigate(url)` (caller asserts: another LV in the same `live_session`)
    * `false` - disable redirect for this item (e.g. let your `on_select` server handler decide)

  Set `new_tab: true` on an item to open its destination in a new tab via `window.open`.

  > #### Breaking change {: .warning}
  >
  > Earlier versions were no-ops when LiveView was connected (the server
  > handler was expected to call `redirect/2`). The hook now performs a hard
  > `:href` redirect by default. Opt back into the old behavior by setting
  > the per-item `redirect: false`, or opt into LV-aware navigation with
  > `redirect: :patch` / `redirect: :navigate`.

  ### Controller

  When not connected to LiveView, the hook always performs a full page redirect via `window.location`.

  ```heex
  <.menu
    class="menu"
    redirect
    items={[
      %Corex.Tree.Item{value: "/", label: "Home"},
      %Corex.Tree.Item{value: "/docs", label: "Docs"},
      %Corex.Tree.Item{value: "https://example.com", label: "External", new_tab: true}
    ]}
  >
    <:trigger>Navigate</:trigger>
    <:indicator>
      <.heroicon name="hero-chevron-down" />
    </:indicator>
  </.menu>
  ```

  ### LiveView

  When connected to LiveView, use `on_select` and redirect in the callback. The payload includes `value` (the item value).

  ```elixir
  defmodule MyAppWeb.NavMenuLive do
    use MyAppWeb, :live_view

    def handle_event("handle_select", %{"value" => value}, socket) do
      {:noreply, push_navigate(socket, to: value)}
    end

    def render(assigns) do
      ~H"""
      <.menu
        class="menu"
        redirect
        on_select="handle_select"
        items={[
          %Corex.Tree.Item{value: "/", label: "Home"},
          %Corex.Tree.Item{value: "/docs", label: "Docs"}
        ]}
      >
        <:trigger>Navigate</:trigger>
        <:indicator>
          <.heroicon name="hero-chevron-down" />
        </:indicator>
      </.menu>
      """
    end
  end
  ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.menu>`.

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`set_open/2`](#set_open/2) | Set open state (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_open/3`](#set_open/3) | Set open state (server) | `socket` |

  <!-- tabs-open -->

  ### set_open

  ```heex
  <.action phx-click={Corex.Menu.set_open("menu-api", true)} class="button button--sm">
    Open Menu
  </.action>
  ```

  ```elixir
  def handle_event("open_menu", _, socket) do
    {:noreply, Corex.Menu.set_open(socket, "menu-api", true)}
  end
  ```

  <!-- tabs-close -->

  ## Events

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_select="menu_selected"` | Item selected | `%{"id" => id, "value" => value}` |
  | `on_open_change="menu_open_changed"` | Open state changes | `%{"id" => id, "open" => open}` |

  <!-- tabs-open -->

  ### on_select

  ```heex
  <.menu
    class="menu"
    on_select="menu_selected"
    items={[
      %Corex.Tree.Item{value: "menu", label: "Menu"},
      %Corex.Tree.Item{value: "combobox", label: "Combobox"},
      %Corex.Tree.Item{value: "select", label: "Select"}
    ]}
  >
    <:trigger>Actions</:trigger>
    <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
  </.menu>
  ```

  ```elixir
  def handle_event("menu_selected", %{"value" => value}, socket) do
    {:noreply, socket}
  end
  ```

  ### on_open_change

  ```heex
  <.menu
    class="menu"
    on_open_change="menu_open_changed"
    items={[
      %Corex.Tree.Item{value: "menu", label: "Menu"},
      %Corex.Tree.Item{value: "combobox", label: "Combobox"},
      %Corex.Tree.Item{value: "select", label: "Select"}
    ]}
  >
    <:trigger>Actions</:trigger>
    <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
  </.menu>
  ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_select_client="menu-selected"` | Item selected | `id`, `value` |
  | `on_open_change_client="menu-open-changed"` | Open state changes | `id`, `open` |

  ## Style

  Import `menu.css` and stack modifiers on the host (`class` on `<.menu>`).

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components.css";
  ```

  Axes: **Semantic** (`--accent`, `--brand`, `--alert`, `--info`, `--success`), **Variant** (`--variant-solid`, `--variant-subtle`, `--variant-ghost`, `--variant-outline`), **Size** (`--sm`, `--md`, `--lg`, `--xl`, also scales text), **Radius** (`--rounded-*`). See the [modifier guide](modifiers.html).

  Semantic modifiers set palette variables on triggers and selected items. Variant modifiers control trigger and content panel surface treatment. Default is subtle; add `menu--variant-solid` for a filled trigger or panel.

  <!-- tabs-open -->

  ### Semantic

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `menu` |
  | Accent | `menu menu--accent` |
  | Brand | `menu menu--brand` |
  | Alert | `menu menu--alert` |
  | Info | `menu menu--info` |
  | Success | `menu menu--success` |

  ### Variant

  Visual treatment of the trigger and content panel. Combine with a semantic modifier for palette-driven ink and fill.

  | Modifier | Classes |
  | -------- | ------- |
  | Subtle (default) | `menu` or `menu menu--accent` |
  | Solid | `menu menu--accent menu--variant-solid` |
  | Ghost | `menu menu--variant-ghost` |
  | Outline | `menu menu--accent menu--variant-outline` |

  ### Size

  | Modifier | Classes |
  | -------- | ------- |
  | SM | `menu menu--sm` |
  | MD | `menu menu--md` |
  | LG | `menu menu--lg` |
  | XL | `menu menu--xl` |

  <!-- tabs-close -->

  '''

  @doc type: :component
  use Phoenix.Component

  import Corex.Api.Doc

  alias Corex.Menu.Anatomy.{
    Content,
    Group,
    GroupLabel,
    Indicator,
    Item,
    Positioner,
    Props,
    Root,
    Trigger
  }

  alias Corex.Api.RespondTo
  alias Corex.Menu.Connect
  alias Corex.Positioning
  alias Phoenix.LiveView.JS

  @doc """
  Renders a menu component.

  You can use either:
  - The `:items` attribute for programmatic item generation from a list of `%Corex.Tree.Item{}` structs
  - Manual item definition with full control using slots

  When using `:items`, each item MUST be a `%Corex.Tree.Item{}` struct with:
  - `:value` - Unique value for the item (used by the client and for `value` / selection APIs)
  - `:label` (required) - label text for the item
  - `:children` (optional) - list of nested `%Corex.Tree.Item{}` structs for nested menus
  - `:disabled` (optional, default: false) - whether the item is disabled
  - `:group` (optional) - group identifier for grouping items
  - `:meta` (optional) - map containing additional metadata
  """

  attr(:id, :string,
    required: false,
    doc: "The id of the menu, useful for API to identify the menu"
  )

  attr(:items, :list,
    default: nil,
    doc: "The items of the menu, must be a list of %Corex.Tree.Item{} structs"
  )

  attr(:positioning, Positioning,
    default: %Positioning{slide: false},
    doc: "Floating UI positioning (placement, gutter, flip, etc.)"
  )

  attr(:close_on_select, :boolean,
    default: true,
    doc: "Whether to close the menu when an item is selected"
  )

  attr(:loop_focus, :boolean,
    default: false,
    doc: "Whether to loop focus when navigating with keyboard"
  )

  attr(:typeahead, :boolean,
    default: true,
    doc: "Whether to enable typeahead navigation"
  )

  attr(:composite, :boolean,
    default: false,
    doc: "Whether the menu is composed with other composite widgets"
  )

  attr(:value, :string,
    default: nil,
    doc: "The value of the item to highlight when the menu opens"
  )

  attr(:disabled, :boolean,
    default: false,
    doc: "Whether the menu trigger is disabled"
  )

  attr(:dir, :string,
    default: nil,
    values: [nil, "ltr", "rtl"],
    doc:
      "The direction of the menu. When nil, derived from document (html lang + config :rtl_locales)"
  )

  attr(:orientation, :string,
    default: "vertical",
    values: ["horizontal", "vertical"],
    doc: "Layout orientation for CSS and ignored attribute lists."
  )

  attr(:aria_label, :string,
    default: nil,
    doc: "The aria-label for the menu"
  )

  attr(:on_select, :string,
    default: nil,
    doc: "The server event name when an item is selected"
  )

  attr(:on_select_client, :string,
    default: nil,
    doc: "The client event name when an item is selected"
  )

  attr(:redirect, :boolean,
    default: false,
    doc: """
    When true, selecting an item triggers redirect-on-select using the item's value (or `:to`)
    as the destination. Each item picks the navigation kind via its `:redirect` field
    (`:href` (default) | `:patch` | `:navigate` | `false`); set `:new_tab` to open in a new tab.
    """
  )

  attr(:on_open_change, :string,
    default: nil,
    doc: "The server event name when the menu opens or closes"
  )

  attr(:on_open_change_client, :string,
    default: nil,
    doc: "The client event name when the menu opens or closes"
  )

  attr(:rest, :global)

  slot :trigger, required: true, doc: "The trigger button content" do
    attr(:class, :string, required: false)
  end

  slot :indicator, required: false, doc: "Optional indicator content (e.g., icon or arrow)" do
    attr(:class, :string, required: false)
  end

  slot :nested_indicator,
    required: false,
    doc: "Optional indicator content for nested menu triggers (defaults to arrow right)" do
    attr(:class, :string, required: false)
  end

  slot :item,
    required: false,
    doc:
      "Optional. Custom content for each menu item. Use :let={item} to receive the item (Corex.Tree.Item)." do
    attr(:class, :string, required: false)
  end

  def menu(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "#{System.unique_integer([:positive])}" end)
      |> Corex.Tree.validate_items_assigns!(component: "menu")
      |> assign_menu_entries()

    group_entries = Enum.filter(assigns.menu_entries, &match?({:group, _, _, _}, &1))
    item_entries = Enum.filter(assigns.menu_entries, &match?({:item, _}, &1))

    assigns =
      assigns
      |> assign(:menu_group_entries, group_entries)
      |> assign(:menu_item_entries, item_entries)

    ~H"""
    <div
      id={"menu:#{@id}"}
      phx-hook="Menu"
      phx-mounted={Connect.ignore_hook(@id)}
      data-loading
      {@rest}
      {Connect.props(%Props{
        id: @id,
        close_on_select: @close_on_select,
        loop_focus: @loop_focus,
        typeahead: @typeahead,
        composite: @composite,
        value: @value,
        dir: @dir,
        orientation: @orientation,
        aria_label: @aria_label,
        on_select: @on_select,
        on_select_client: @on_select_client,
        redirect: @redirect,
        on_open_change: @on_open_change,
        on_open_change_client: @on_open_change_client,
        positioning: @positioning
      })}
    >
      <div phx-mounted={Connect.ignore_root(%Root{id: @id, dir: @dir, orientation: @orientation})} {Connect.root(%Root{id: @id, dir: @dir, orientation: @orientation})}>
        <button phx-mounted={Connect.ignore_trigger(%Trigger{id: @id, disabled: @disabled, dir: @dir, orientation: @orientation})} {Connect.trigger(%Trigger{
          id: @id,
          disabled: @disabled,
          dir: @dir,
          orientation: @orientation
        })}>
          <span data-scope="menu" data-part="item-text">
            {render_slot(@trigger)}
          </span>
          <span
            :if={@indicator != []}
            phx-mounted={Connect.ignore_indicator(%Indicator{id: @id, dir: @dir, orientation: @orientation})}
            {Connect.indicator(%Indicator{id: @id, dir: @dir, orientation: @orientation})}
          >
            {render_slot(@indicator)}
          </span>
        </button>

        <div phx-mounted={Connect.ignore_positioner(%Positioner{id: @id, dir: @dir, orientation: @orientation})} {Connect.positioner(%Positioner{id: @id, dir: @dir, orientation: @orientation})}>
          <div phx-mounted={Connect.ignore_content(%Content{id: @id, dir: @dir, orientation: @orientation})} {Connect.content(%Content{id: @id, dir: @dir, orientation: @orientation})}>
            <div
              :for={{:group, group_id, group_label, group_items} <- @menu_group_entries}
              phx-mounted={Connect.ignore_item_group(%Group{id: @id, group_id: group_id, dir: @dir, orientation: @orientation})}
              {Connect.item_group(%Group{id: @id, group_id: group_id, dir: @dir, orientation: @orientation})}
            >
              <div
                phx-mounted={Connect.ignore_item_group_label(%GroupLabel{id: @id, group_id: group_id, dir: @dir, orientation: @orientation})}
                {Connect.item_group_label(%GroupLabel{id: @id, group_id: group_id, dir: @dir, orientation: @orientation})}
              >
                {group_label}
              </div>
              <div
                :for={item <- group_items}
                phx-mounted={Connect.ignore_item(menu_item_struct(@id, @dir, @orientation, item))}
                {Connect.item(menu_item_struct(@id, @dir, @orientation, item))}
              >
                <div :if={@item != []} data-scope="menu" data-part="item-text">
                  {render_slot(@item, item)}
                </div>
                <span :if={@item == []} data-scope="menu" data-part="item-text">
                  {item.label}
                </span>
                <span
                  :if={item.children != [] && item.children != nil && @nested_indicator != []}
                  data-scope="menu"
                  data-part="item-indicator"
                  dir={@dir}
                >
                  {render_slot(@nested_indicator)}
                </span>
                <div :if={item.children != [] && item.children != nil}>
                  <.menu_nested_items
                    menu_id={@id}
                    item={item}
                    dir={@dir}
                    orientation={@orientation}
                    nested_indicator={@nested_indicator}
                    item_slot={@item}
                    close_on_select={@close_on_select}
                    loop_focus={@loop_focus}
                    typeahead={@typeahead}
                    composite={@composite}
                    redirect={@redirect}
                    on_select={@on_select}
                    on_select_client={@on_select_client}
                    on_open_change={@on_open_change}
                    on_open_change_client={@on_open_change_client}
                    positioning={@positioning}
                  />
                </div>
              </div>
            </div>

            <div
              :for={{:item, item} <- @menu_item_entries}
              phx-mounted={Connect.ignore_item(menu_item_struct(@id, @dir, @orientation, item))}
              {Connect.item(menu_item_struct(@id, @dir, @orientation, item))}
            >
              <div :if={@item != []} data-scope="menu" data-part="item-text">
                {render_slot(@item, item)}
              </div>
              <span :if={@item == []} data-scope="menu" data-part="item-text">
                {item.label}
              </span>
              <span
                :if={item.children != [] && item.children != nil && @nested_indicator != []}
                data-scope="menu"
                data-part="item-indicator"
                dir={@dir}
              >
                {render_slot(@nested_indicator)}
              </span>
              <div :if={item.children != [] && item.children != nil}>
                <.menu_nested_items
                  menu_id={@id}
                  item={item}
                  dir={@dir}
                  orientation={@orientation}
                  nested_indicator={@nested_indicator}
                  item_slot={@item}
                  close_on_select={@close_on_select}
                  loop_focus={@loop_focus}
                  typeahead={@typeahead}
                  composite={@composite}
                  redirect={@redirect}
                  on_select={@on_select}
                  on_select_client={@on_select_client}
                  on_open_change={@on_open_change}
                  on_open_change_client={@on_open_change_client}
                  positioning={@positioning}
                />
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  attr(:menu_id, :string, required: true)
  attr(:item, Corex.Tree.Item, required: true)
  attr(:dir, :string, required: true)
  attr(:orientation, :string, required: true)
  attr(:nested_indicator, :list, required: true)
  attr(:item_slot, :list, required: true)
  attr(:close_on_select, :boolean, required: true)
  attr(:loop_focus, :boolean, required: true)
  attr(:typeahead, :boolean, required: true)
  attr(:composite, :boolean, required: true)
  attr(:redirect, :boolean, required: true)
  attr(:on_select, :string, default: nil)
  attr(:on_select_client, :string, default: nil)
  attr(:on_open_change, :string, default: nil)
  attr(:on_open_change_client, :string, default: nil)
  attr(:positioning, Positioning, required: true)

  defp menu_nested_items(assigns) do
    base_id = String.replace_prefix(assigns.menu_id, "menu:", "")
    nested_id = "#{base_id}:#{assigns.item.value}"
    children = List.wrap(assigns.item.children)
    entries = build_menu_entries(children)
    group_entries = Enum.filter(entries, &match?({:group, _, _, _}, &1))
    item_entries = Enum.filter(entries, &match?({:item, _}, &1))

    assigns =
      assigns
      |> assign(:nested_id, nested_id)
      |> assign(:nested_group_entries, group_entries)
      |> assign(:nested_item_entries, item_entries)

    ~H"""
    <div
      phx-hook="Menu"
      phx-mounted={Connect.ignore_hook(@nested_id)}
      data-loading
      {Connect.nested_menu(%Root{id: @nested_id, dir: @dir, orientation: @orientation})}
      {Connect.props(%Props{
        id: @nested_id,
        close_on_select: @close_on_select,
        loop_focus: @loop_focus,
        typeahead: @typeahead,
        composite: @composite,
        value: nil,
        dir: @dir,
        orientation: @orientation,
        aria_label: nil,
        on_select: @on_select,
        on_select_client: @on_select_client,
        redirect: @redirect,
        on_open_change: @on_open_change,
        on_open_change_client: @on_open_change_client,
        positioning: @positioning
      })}
    >
      <div phx-mounted={Connect.ignore_root(%Root{id: @nested_id, dir: @dir, orientation: @orientation})} {Connect.root(%Root{id: @nested_id, dir: @dir, orientation: @orientation})}>
        <div phx-mounted={Connect.ignore_positioner(%Positioner{id: @nested_id, dir: @dir, orientation: @orientation})} {Connect.positioner(%Positioner{id: @nested_id, dir: @dir, orientation: @orientation})}>
          <div phx-mounted={Connect.ignore_content(%Content{id: @nested_id, dir: @dir, orientation: @orientation})} {Connect.content(%Content{id: @nested_id, dir: @dir, orientation: @orientation})}>
            <div
              :for={{:group, group_id, group_label, group_items} <- @nested_group_entries}
              phx-mounted={Connect.ignore_item_group(%Group{id: @nested_id, group_id: group_id, dir: @dir, orientation: @orientation})}
              {Connect.item_group(%Group{id: @nested_id, group_id: group_id, dir: @dir, orientation: @orientation})}
            >
              <div
                phx-mounted={Connect.ignore_item_group_label(%GroupLabel{id: @nested_id, group_id: group_id, dir: @dir, orientation: @orientation})}
                {Connect.item_group_label(%GroupLabel{id: @nested_id, group_id: group_id, dir: @dir, orientation: @orientation})}
              >
                {group_label}
              </div>
              <div
                :for={nitem <- group_items}
                phx-mounted={Connect.ignore_item(menu_item_struct(@nested_id, @dir, @orientation, nitem))}
                {Connect.item(menu_item_struct(@nested_id, @dir, @orientation, nitem))}
              >
                <div :if={@item_slot != []} data-scope="menu" data-part="item-text">
                  {render_slot(@item_slot, nitem)}
                </div>
                <span :if={@item_slot == []} data-scope="menu" data-part="item-text">
                  {nitem.label}
                </span>
                <span
                  :if={nitem.children != [] && nitem.children != nil && @nested_indicator != []}
                  data-scope="menu"
                  data-part="item-indicator"
                  dir={@dir}
                >
                  {render_slot(@nested_indicator)}
                </span>
                <div :if={nitem.children != [] && nitem.children != nil}>
                  <.menu_nested_items
                    menu_id={@nested_id}
                    item={nitem}
                    dir={@dir}
                    orientation={@orientation}
                    nested_indicator={@nested_indicator}
                    item_slot={@item_slot}
                    close_on_select={@close_on_select}
                    loop_focus={@loop_focus}
                    typeahead={@typeahead}
                    composite={@composite}
                    redirect={@redirect}
                    on_select={@on_select}
                    on_select_client={@on_select_client}
                    on_open_change={@on_open_change}
                    on_open_change_client={@on_open_change_client}
                    positioning={@positioning}
                  />
                </div>
              </div>
            </div>

            <div
              :for={{:item, nitem} <- @nested_item_entries}
              phx-mounted={Connect.ignore_item(menu_item_struct(@nested_id, @dir, @orientation, nitem))}
              {Connect.item(menu_item_struct(@nested_id, @dir, @orientation, nitem))}
            >
              <div :if={@item_slot != []} data-scope="menu" data-part="item-text">
                {render_slot(@item_slot, nitem)}
              </div>
              <span :if={@item_slot == []} data-scope="menu" data-part="item-text">
                {nitem.label}
              </span>
              <span
                :if={nitem.children != [] && nitem.children != nil && @nested_indicator != []}
                data-scope="menu"
                data-part="item-indicator"
                dir={@dir}
              >
                {render_slot(@nested_indicator)}
              </span>
              <div :if={nitem.children != [] && nitem.children != nil}>
                <.menu_nested_items
                  menu_id={@nested_id}
                  item={nitem}
                  dir={@dir}
                  orientation={@orientation}
                  nested_indicator={@nested_indicator}
                  item_slot={@item_slot}
                  close_on_select={@close_on_select}
                  loop_focus={@loop_focus}
                  typeahead={@typeahead}
                  composite={@composite}
                  redirect={@redirect}
                  on_select={@on_select}
                  on_select_client={@on_select_client}
                  on_open_change={@on_open_change}
                  on_open_change_client={@on_open_change_client}
                  positioning={@positioning}
                />
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp menu_item_struct(menu_id, dir, orientation, item) do
    %Item{
      id: menu_id,
      value: item.value,
      disabled: item.disabled,
      dir: dir,
      orientation: orientation,
      has_nested: item.children != [] && item.children != nil,
      nested_menu_id:
        if(item.children != [] && item.children != nil,
          do: "#{String.replace_prefix(menu_id, "menu:", "")}:#{item.value}",
          else: nil
        ),
      redirect: Map.get(item, :redirect),
      new_tab: Map.get(item, :new_tab, false)
    }
  end

  defp assign_menu_entries(%{items: nil} = assigns) do
    assign(assigns, :menu_entries, [])
  end

  defp assign_menu_entries(%{items: items} = assigns) when is_list(items) do
    assign(assigns, :menu_entries, build_menu_entries(items))
  end

  defp build_menu_entries(items) when is_list(items) do
    items_by_group = Enum.group_by(items, fn item -> item.group end)

    entries =
      items_by_group
      |> Enum.reject(fn {group, _} -> group == nil end)
      |> Enum.sort_by(fn {group, _} -> group end)
      |> Enum.flat_map(fn {group, group_items} ->
        [{:group, group, group, group_items}]
      end)

    ungrouped = Map.get(items_by_group, nil, []) |> Enum.map(&{:item, &1})
    entries ++ ungrouped
  end

  api_doc(~S"""
  Set menu open state from a control (`phx-click`). Targets the root with id `menu:<id>`.

  ```heex
  <.action phx-click={Corex.Menu.set_open("my-menu", true)}>Open</.action>
  <.menu id="my-menu" class="menu" items={[%Corex.Tree.Item{label: "Edit", value: "edit"}]}>
    <:trigger>Actions</:trigger>
  </.menu>
  ```

  ```javascript
  document.querySelector('[id="menu:my-menu"]')?.dispatchEvent(
    new CustomEvent("corex:menu:set-open", {
      bubbles: false,
      detail: { open: true },
    })
  );
  ```
  """)

  def set_open(menu_id, open) when is_binary(menu_id) do
    JS.dispatch("corex:menu:set-open",
      to: "[id=\"menu:#{menu_id}\"]",
      detail: %{open: open},
      bubbles: false
    )
  end

  api_doc(~S"""
  Set open state from `handle_event`. Pushes `menu_set_open`.

  ```heex
  <.action phx-click="open_menu">Open</.action>
  <.menu id="my-menu" class="menu" items={[%Corex.Tree.Item{label: "Edit", value: "edit"}]}>
    <:trigger>Actions</:trigger>
  </.menu>
  ```

  ```elixir
  def handle_event("open_menu", _, socket) do
    {:noreply, Corex.Menu.set_open(socket, "my-menu", true)}
  end
  ```
  """)

  def set_open(socket, menu_id, open)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(menu_id) do
    RespondTo.push_set_open(socket, "menu_set_open", menu_id, open)
  end
end
