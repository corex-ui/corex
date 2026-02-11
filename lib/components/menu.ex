defmodule Corex.Menu do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Menu](https://zagjs.com/components/react/menu).

  ## Examples

  <!-- tabs-open -->

  ### List

  You must use `Corex.Tree.Item` struct for items.

  The value for each item is optional, useful for controlled mode and API to identify the item.

  You can specify disabled for each item and nested children.

  ```heex
  <.menu
    class="menu"
    items={[
      %Corex.Tree.Item{
        id: "edit",
        label: "Edit"
      },
      %Corex.Tree.Item{
        id: "duplicate",
        label: "Duplicate"
      },
      %Corex.Tree.Item{
        id: "delete",
        label: "Delete"
      }
    ]}
  >
    <:trigger>Actions</:trigger>
    <:indicator>
      <.icon name="hero-chevron-down" />
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
        id: "new-tab",
        label: "New tab"
      },
      %Corex.Tree.Item{
        id: "share",
        label: "Share",
        children: [
          %Corex.Tree.Item{
            id: "messages",
            label: "Messages"
          },
          %Corex.Tree.Item{
            id: "airdrop",
            label: "Airdrop"
          },
          %Corex.Tree.Item{
            id: "whatsapp",
            label: "WhatsApp"
          }
        ]
      },
      %Corex.Tree.Item{
        id: "print",
        label: "Print..."
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
        id: "share",
        label: "Share",
        children: [
          %Corex.Tree.Item{id: "messages", label: "Messages"}
        ]
      }
    ]}
  >
    <:trigger>Click me</:trigger>
    <:nested_indicator>
      <.icon name="hero-arrow-right" />
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
        id: "edit",
        label: "Edit",
        group: "Actions"
      },
      %Corex.Tree.Item{
        id: "duplicate",
        label: "Duplicate",
        group: "Actions"
      },
      %Corex.Tree.Item{
        id: "account-1",
        label: "Account 1",
        group: "Accounts"
      },
      %Corex.Tree.Item{
        id: "account-2",
        label: "Account 2",
        group: "Accounts"
      }
    ]}
  >
    <:trigger>Actions</:trigger>
    <:indicator>
      <.icon name="hero-chevron-down" />
    </:indicator>
  </.menu>
  ```

  ### Controlled

  Render a menu controlled by the server.

  You must use the `on_select` event to handle selection on the server.

  ```elixir
  defmodule MyAppWeb.MenuLive do
  use MyAppWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :open, false)}
  end

  def handle_event("on_select", %{"value" => value}, socket) do
    IO.inspect("Selected: #{value}")
    {:noreply, socket}
  end

  def handle_event("on_open_change", %{"open" => open}, socket) do
    {:noreply, assign(socket, :open, open)}
  end

  def render(assigns) do
    ~H"""
    <.menu
      id="my-menu"
      controlled
      open={@open}
      on_select="on_select"
      on_open_change="on_open_change"
      class="menu"
      items={[
        %Corex.Tree.Item{id: "edit", label: "Edit"},
        %Corex.Tree.Item{id: "duplicate", label: "Duplicate"},
        %Corex.Tree.Item{id: "delete", label: "Delete"}
      ]}
    >
      <:trigger>Actions</:trigger>
          <:indicator>
      <.icon name="hero-chevron-down" />
    </:indicator>
    </.menu>
    """
  end
  end
  ```

  <!-- tabs-close -->

  ## API Control

  In order to use the API, you must use an id on the component

  ***Client-side***

  ```heex
  <button phx-click={Corex.Menu.set_open("my-menu", true)}>
    Open Menu
  </button>
  ```

  ***Server-side***

  ```elixir
  def handle_event("open_menu", _, socket) do
    {:noreply, Corex.Menu.set_open(socket, "my-menu", true)}
  end
  ```

  ## Styling

  Use data attributes to target elements:

  ```css
  [data-scope="menu"][data-part="root"] {}
  [data-scope="menu"][data-part="trigger"] {}
  [data-scope="menu"][data-part="positioner"] {}
  [data-scope="menu"][data-part="content"] {}
  [data-scope="menu"][data-part="item"] {}
  [data-scope="menu"][data-part="separator"] {}
  [data-scope="menu"][data-part="item-group"] {}
  [data-scope="menu"][data-part="item-group-label"] {}
  ```

  If you wish to use the default Corex styling, you can use the class `menu` on the component.
  This requires to install mix corex.design first and import the component css file.

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/menu.css";
  ```

  Learn more about modifiers and [Corex Design](https://corex-ui.com/components/menu#modifiers)
  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.Menu.Anatomy.{Props, Root, Trigger, Item, Group}
  alias Corex.Menu.Connect

  @doc """
  Renders a menu component.

  You can use either:
  - The `:items` attribute for programmatic item generation from a list of `%Corex.Tree.Item{}` structs
  - Manual item definition with full control using slots

  When using `:items`, each item MUST be a `%Corex.Tree.Item{}` struct with:
  - `:id` (required) - unique identifier for the item
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

  attr(:open, :boolean,
    default: false,
    doc: "The initial open state or the controlled open state of the menu"
  )

  attr(:controlled, :boolean,
    default: false,
    doc:
      "Whether the menu is controlled. Only in LiveView, the on_select and on_open_change events are required"
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
    doc:
      "When true, selecting an item redirects to the item's id (e.g. path). When not connected to LiveView the hook sets window.location; when connected use on_select and redirect(socket, to: value) in your handler. Per item: set redirect: false on a Tree.Item to disable redirect for that item; set new_tab: true to open that item's URL in a new tab."
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

  slot(:trigger, required: true, doc: "The trigger button content")
  slot(:indicator, required: false, doc: "Optional indicator content (e.g., icon or arrow)")

  slot(:nested_indicator,
    required: false,
    doc: "Optional indicator content for nested menu triggers (defaults to arrow right)"
  )

  slot(:item,
    required: false,
    doc:
      "Optional. Custom content for each menu item. Use :let={item} to receive the item (Corex.Tree.Item)."
  )

  def menu(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "#{System.unique_integer([:positive])}" end)
      |> validate_items()
      |> assign_menu_entries()

    ~H"""
    <div id={"menu:#{@id}"} phx-hook="Menu" {@rest} {Connect.props(%Props{
      id: @id,
      open: @open,
      controlled: @controlled,
      close_on_select: @close_on_select,
      loop_focus: @loop_focus,
      typeahead: @typeahead,
      composite: @composite,
      dir: @dir,
      aria_label: @aria_label,
      on_select: @on_select,
      on_select_client: @on_select_client,
      redirect: @redirect,
      on_open_change: @on_open_change,
      on_open_change_client: @on_open_change_client
    })}>
      <div {Connect.root(%Root{id: @id, dir: @dir, changed: if(@__changed__, do: true, else: false)})}>
        <button {Connect.trigger(%Trigger{
          id: @id,
          disabled: @disabled,
          dir: @dir,
          changed: if(@__changed__, do: true, else: false)
        })}>
          {render_slot(@trigger)}
          <span :if={@indicator != []} {Connect.indicator(%Root{id: @id, dir: @dir, changed: if(@__changed__, do: true, else: false)})}>
            {render_slot(@indicator)}
          </span>
        </button>

        <div {Connect.positioner(%Root{id: @id, dir: @dir, open: @open, changed: if(@__changed__, do: true, else: false)})}>
          <div {Connect.content(%Root{id: @id, dir: @dir, open: @open, changed: if(@__changed__, do: true, else: false)})}>
            <%= for entry <- @menu_entries do %>
              <%= case entry do %>
                <% {:group, group_id, group_label, group_items} -> %>
                  <div {Connect.item_group(%Group{id: @id, group_id: group_id, dir: @dir, changed: if(@__changed__, do: true, else: false)})}>
                    <div {Connect.item_group_label(%Group{id: @id, group_id: group_id, dir: @dir, changed: if(@__changed__, do: true, else: false)})}>
                      {group_label}
                    </div>
                    <li :for={item <- group_items} {Connect.item(%Item{
                      id: @id,
                      value: item.id,
                      disabled: item.disabled,
                      dir: @dir,
                      changed: if(@__changed__, do: true, else: false),
                      has_nested: item.children != [] && item.children != nil,
                      nested_menu_id: if(item.children != [] && item.children != nil, do: "#{String.replace_prefix(@id, "menu:", "")}:#{item.id}", else: nil),
                      redirect: Map.get(item, :redirect),
                      new_tab: Map.get(item, :new_tab, false)
                    })}>
                      <div :if={@item != []} data-scope="menu" data-part="item-text">
                        {render_slot(@item, item)}
                      </div>
                      <span :if={@item == []} data-scope="menu" data-part="item-text">
                        {item.label}
                      </span>
                      <span :if={item.children != [] && item.children != nil && @nested_indicator != []} data-scope="menu" data-part="item-indicator">
                        {render_slot(@nested_indicator)}
                      </span>
                      <div :if={item.children != [] && item.children != nil}>
                        <.menu_nested_items menu_id={@id} item={item} dir={@dir} changed={if(@__changed__, do: true, else: false)} nested_indicator={@nested_indicator} item_slot={@item} />
                      </div>
                    </li>
                  </div>
                <% {:item, item} -> %>
                  <li {entry_li_attrs(entry, @id, @dir, if(@__changed__, do: true, else: false))}>
                    <div :if={@item != []} data-scope="menu" data-part="item-text">
                      {render_slot(@item, item)}
                    </div>
                    <span :if={@item == []} data-scope="menu" data-part="item-text">
                      {item.label}
                    </span>
                    <span :if={item.children != [] && item.children != nil && @nested_indicator != []} data-scope="menu" data-part="item-indicator">
                      {render_slot(@nested_indicator)}
                    </span>
                    <div :if={item.children != [] && item.children != nil}>
                      <.menu_nested_items menu_id={@id} item={item} dir={@dir} changed={if(@__changed__, do: true, else: false)} nested_indicator={@nested_indicator} item_slot={@item} />
                    </div>
                  </li>
              <% end %>
            <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  attr(:menu_id, :string, required: true)
  attr(:item, Corex.Tree.Item, required: true)
  attr(:dir, :string, required: true)
  attr(:changed, :boolean, required: true)
  attr(:nested_indicator, :list, required: true)
  attr(:item_slot, :list, required: true)

  defp menu_nested_items(assigns) do
    base_id = String.replace_prefix(assigns.menu_id, "menu:", "")
    nested_id = "#{base_id}:#{assigns.item.id}"
    assigns = assign(assigns, :nested_id, nested_id)

    ~H"""
    <div phx-hook="Menu" {Connect.nested_menu(%Root{id: @nested_id, dir: @dir, changed: @changed})} {Connect.props(%Props{
      id: @nested_id,
      open: false,
      controlled: false,
      close_on_select: true,
      loop_focus: false,
      typeahead: true,
      composite: false,
      dir: @dir,
      aria_label: nil,
      on_select: nil,
      on_select_client: nil,
      on_open_change: nil,
      on_open_change_client: nil
    })}>
      <div {Connect.root(%Root{id: @nested_id, dir: @dir, changed: @changed})}>
        <div {Connect.positioner(%Root{id: @nested_id, dir: @dir, open: false, changed: @changed})}>
          <ul {Connect.content(%Root{id: @nested_id, dir: @dir, open: false, changed: @changed})}>
            <li :for={child <- @item.children} {Connect.item(%Item{
              id: @nested_id,
              value: child.id,
              disabled: child.disabled,
              dir: @dir,
              changed: @changed,
              has_nested: false,
              nested_menu_id: nil,
              redirect: Map.get(child, :redirect),
              new_tab: Map.get(child, :new_tab, false)
            })}>
              <div :if={@item_slot != []} data-scope="menu" data-part="item-text">
                {render_slot(@item_slot, child)}
              </div>
              <span :if={@item_slot == []} data-scope="menu" data-part="item-text">
                {child.label}
              </span>
            </li>
          </ul>
        </div>
      </div>
    </div>
    """
  end

  defp entry_li_attrs({:item, item}, menu_id, dir, changed) do
    Connect.item(%Item{
      id: menu_id,
      value: item.id,
      disabled: item.disabled,
      dir: dir,
      changed: changed,
      has_nested: item.children != [] && item.children != nil,
      nested_menu_id:
        if(item.children != [] && item.children != nil,
          do: "#{String.replace_prefix(menu_id, "menu:", "")}:#{item.id}",
          else: nil
        ),
      redirect: Map.get(item, :redirect),
      new_tab: Map.get(item, :new_tab, false)
    })
  end

  defp validate_items(%{items: nil} = assigns), do: assigns

  defp validate_items(%{items: items} = assigns) when is_list(items) do
    Enum.each(items, fn item ->
      unless is_struct(item, Corex.Tree.Item) do
        raise ArgumentError, """
        Invalid item in :items attribute. Expected %Corex.Tree.Item{} struct, got: #{inspect(item)}

        Please use the Corex.Tree.Item struct:

        %Corex.Tree.Item{
          id: "unique-id",
          label: "Label text",
          children: [],
          disabled: false,
          group: nil,
          meta: %{}
        }
        """
      end
    end)

    assigns
  end

  defp validate_items(assigns), do: assigns

  defp assign_menu_entries(%{items: nil} = assigns) do
    assign(assigns, :menu_entries, [])
  end

  defp assign_menu_entries(%{items: items} = assigns) when is_list(items) do
    items_by_group = Enum.group_by(items, fn item -> item.group end)

    entries =
      items_by_group
      |> Enum.reject(fn {group, _} -> group == nil end)
      |> Enum.sort_by(fn {group, _} -> group end)
      |> Enum.flat_map(fn {group, group_items} ->
        # Use group value as label, same as select
        [{:group, group, group, group_items}]
      end)

    ungrouped = Map.get(items_by_group, nil, []) |> Enum.map(&{:item, &1})
    entries = entries ++ ungrouped

    assign(assigns, :menu_entries, entries)
  end

  @doc type: :api
  @doc """
  Sets the menu open state from client-side. Returns a `Phoenix.LiveView.JS` command.

  ## Examples

      <button phx-click={Corex.Menu.set_open("my-menu", true)}>
        Open Menu
      </button>
  """
  def set_open(menu_id, open) when is_binary(menu_id) do
    Phoenix.LiveView.JS.dispatch("phx:menu:set-open",
      to: "##{menu_id}",
      detail: %{open: open},
      bubbles: false
    )
  end

  @doc type: :api
  @doc """
  Sets the menu open state from server-side. Pushes a LiveView event.

  ## Examples

      def handle_event("open_menu", _params, socket) do
        socket = Corex.Menu.set_open(socket, "my-menu", true)
        {:noreply, socket}
      end
  """
  def set_open(socket, menu_id, open)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(menu_id) do
    Phoenix.LiveView.push_event(socket, "menu_set_open", %{
      menu_id: menu_id,
      open: open
    })
  end
end
