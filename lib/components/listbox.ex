defmodule Corex.Listbox do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Listbox](https://zagjs.com/components/react/listbox).

  Pass `items={Corex.List.new([...])}`. With `redirect`, use per-item `:to` and `:redirect` (`:href` | `:patch` | `:navigate` | `false`); Zag runs single-select when `redirect` is true.

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

  ```heex
  <.listbox class="listbox" items={
    Corex.List.new([
      %{label: "France", value: "fra"},
      %{label: "Belgium", value: "bel"},
      %{label: "Germany", value: "deu"},
      %{label: "Netherlands", value: "nld"},
      %{label: "Switzerland", value: "che"},
      %{label: "Austria", value: "aut"}
    ])
  }>
    <:label>Choose a country</:label>
  </.listbox>
  ```

  ### With indicator

  ```heex
  <.listbox class="listbox" items={
    Corex.List.new([
      %{label: "France", value: "fra"},
      %{label: "Belgium", value: "bel"},
      %{label: "Germany", value: "deu"},
      %{label: "Netherlands", value: "nld"},
      %{label: "Switzerland", value: "che"},
      %{label: "Austria", value: "aut"}
    ])
  }>
    <:label>Choose a country</:label>
    <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
  </.listbox>
  ```

  ### Grouped

  ```heex
  <.listbox class="listbox" items={
    Corex.List.new([
      %{label: "France", value: "fra", group: "Europe"},
      %{label: "Belgium", value: "bel", group: "Europe"},
      %{label: "Germany", value: "deu", group: "Europe"},
      %{label: "Japan", value: "jpn", group: "Asia"},
      %{label: "China", value: "chn", group: "Asia"},
      %{label: "USA", value: "usa", group: "North America"}
    ])
  }>
    <:label>Choose a country</:label>
    <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
  </.listbox>
  ```

  ### Custom item slot

  Requires [Flagpack](https://hex.pm/packages/flagpack). Use `:item` with `:let={%{item: entry}}`.

  ```heex
  <.listbox class="listbox" items={
    Corex.List.new([
      %{label: "France", value: "fra"},
      %{label: "Belgium", value: "bel"},
      %{label: "Germany", value: "deu"},
      %{label: "Netherlands", value: "nld"},
      %{label: "Switzerland", value: "che"},
      %{label: "Austria", value: "aut"}
    ])
  }>
    <:label>Country of residence</:label>
    <:item :let={%{item: entry}}>
      <Flagpack.flag name={String.to_atom(entry.value)} />
      {entry.label}
    </:item>
    <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
  </.listbox>
  ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.listbox>`.

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`set_value/2`](#set_value/2) | Set selection (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_value/3`](#set_value/3) | Set selection (server) | `socket` |
  | [`value/1`](#value/1) | Read selection (client) | `%Phoenix.LiveView.JS{}` |
  | [`value/2`](#value/2) | Read selection (client, opts) | `%Phoenix.LiveView.JS{}` |
  | [`value/3`](#value/3) | Read selection (server) | `socket` |
  | [`value/4`](#value/4) | Read selection (server, opts) | `socket` |

  <!-- tabs-open -->

  ### set_value

  ```heex
  <.action phx-click={Corex.Listbox.set_value("listbox-api-sv-client", ["bel"])} class="button button--sm">
    Belgium
  </.action>
  <.listbox id="listbox-api-sv-client" class="listbox" items={
    Corex.List.new([
      %{label: "France", value: "fra"},
      %{label: "Belgium", value: "bel"},
      %{label: "Germany", value: "deu"}
    ])
  }>
    <:label>Choose a country</:label>
    <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
  </.listbox>
  ```

  ```elixir
  def handle_event("listbox_api_set_value", _params, socket) do
    {:noreply, Corex.Listbox.set_value(socket, "listbox-api-sv-server", ["bel"])}
  end
  ```

  ### value

  ```heex
  <.action phx-click={Corex.Listbox.value("listbox-api-val-client")} class="button button--sm">
    Read selection
  </.action>
  ```

  ```elixir
  def handle_event("listbox_api_value_server", _params, socket) do
    {:noreply, Corex.Listbox.value(socket, "listbox-api-val-server")}
  end
  ```

  <!-- tabs-close -->

  ## Events

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_value_change="listbox_value_changed"` | Selection changes | `%{"id" => id, "value" => values}` — list of selected value strings |

  <!-- tabs-open -->

  ### on_value_change

  ```heex
  <.listbox
    class="listbox"
    items={
      Corex.List.new([
        %{label: "France", value: "fra"},
        %{label: "Belgium", value: "bel"},
        %{label: "Germany", value: "deu"}
      ])
    }
    on_value_change="listbox_value_changed"
  >
    <:label>Choose a country</:label>
    <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
  </.listbox>
  ```

  ```elixir
  def handle_event("listbox_value_changed", %{"id" => id, "value" => value}, socket) do
    {:noreply, assign(socket, :selected, value)}
  end
  ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_value_change_client="listbox-value-changed"` | Selection changes | `id`, `value`, `items` |

  <!-- tabs-open -->

  ### on_value_change_client

  ```heex
  <.listbox
    id="listbox-events-client"
    class="listbox"
    items={
      Corex.List.new([
        %{label: "France", value: "fra"},
        %{label: "Belgium", value: "bel"},
        %{label: "Germany", value: "deu"}
      ])
    }
    on_value_change_client="listbox-value-changed"
  >
    <:label>Choose a country</:label>
    <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
  </.listbox>
  ```

  ```javascript
  document.getElementById("listbox-events-client")?.addEventListener("listbox-value-changed", (event) => {
    console.log(event.detail);
  });
  ```

  <!-- tabs-close -->

  ## Patterns

  <!-- tabs-open -->

  ### Stream

  Use `Phoenix.LiveView.stream/3` to add or remove items at runtime. Keep a list assign in sync with the stream and pass `Corex.List.new(@items_list)` as `items`. Configure `dom_id` to match each item element id (`listbox:stream-listbox:item:#{value}`).

  ```elixir
  defmodule MyAppWeb.ListboxStreamLive do
    use MyAppWeb, :live_view

    def mount(_params, _session, socket) do
      initial = [
        %{value: "1", label: "Apple"},
        %{value: "2", label: "Banana"},
        %{value: "3", label: "Cherry"}
      ]

      {:ok,
       socket
       |> stream_configure(:items, dom_id: &"listbox:stream-listbox:item:#{&1.value}")
       |> stream(:items, initial)
       |> assign(:items_list, initial)
       |> assign(:next_id, 4)}
    end

    def handle_event("add_item", _params, socket) do
      id = to_string(socket.assigns.next_id)
      item = %{value: id, label: "Item " <> id}

      {:noreply,
       socket
       |> stream_insert(:items, item)
       |> assign(:items_list, socket.assigns.items_list ++ [item])
       |> assign(:next_id, socket.assigns.next_id + 1)}
    end

    def render(assigns) do
      ~H"""
      <.listbox id="stream-listbox" class="listbox" items={Corex.List.new(@items_list)}>
        <:label>Choose an item</:label>
        <:empty>No items</:empty>
        <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
      </.listbox>
      """
    end
  end
  ```

  ### Controlled

  ```heex
  <.listbox
    class="listbox"
    controlled
    value={@value}
    on_value_change="listbox_controlled_changed"
    items={
      Corex.List.new([
        %{label: "France", value: "fra"},
        %{label: "Belgium", value: "bel"},
        %{label: "Germany", value: "deu"}
      ])
    }
  >
    <:label>Choose a country</:label>
    <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
  </.listbox>
  ```

  ```elixir
  def handle_event("listbox_controlled_changed", %{"value" => value}, socket) do
    {:noreply, assign(socket, :value, value)}
  end
  ```

  <!-- tabs-close -->
  '''

  @doc type: :component
  use Phoenix.Component

  import Corex.Api.Doc

  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  alias Corex.Listbox.Anatomy.{
    Content,
    Item,
    ItemGroup,
    ItemGroupLabel,
    ItemIndicator,
    ItemText,
    Label,
    Props,
    Root
  }

  alias Corex.Listbox.Connect

  import Corex.Helpers,
    only: [
      validate_value!: 1,
      normalize_items: 1,
      normalize_groups: 1,
      has_groups?: 1,
      entry_value: 1,
      entry_selected?: 2,
      respond_to_fields: 1
    ]

  attr(:id, :string, required: false, doc: "The id of the listbox")

  attr(:items, :list,
    required: true,
    doc:
      "Items from `Corex.List.new/1` (or maps with :label and optional :value, disabled, group)"
  )

  attr(:value, :list, default: [], doc: "Selected value(s)")
  attr(:controlled, :boolean, default: false, doc: "Whether the listbox is controlled")
  attr(:disabled, :boolean, default: false, doc: "Whether the listbox is disabled")
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"], doc: "Text direction")

  attr(:orientation, :string,
    default: "vertical",
    values: ["horizontal", "vertical"],
    doc: "Layout orientation of items"
  )

  attr(:loop_focus, :boolean, default: false, doc: "Whether to loop focus within the listbox")

  attr(:selection_mode, :string,
    default: "single",
    values: ["single", "multiple", "extended"],
    doc: "How items can be selected"
  )

  attr(:select_on_highlight, :boolean,
    default: false,
    doc: "Select item when highlighted via keyboard"
  )

  attr(:deselectable, :boolean, default: false, doc: "Whether selection can be cleared")
  attr(:typeahead, :boolean, default: false, doc: "Enable typeahead search")
  attr(:on_value_change, :string, default: nil, doc: "Server event name on value change")
  attr(:on_value_change_client, :string, default: nil, doc: "Client event name on value change")

  attr(:redirect, :boolean,
    default: false,
    doc: """
    When true, selecting a value triggers redirect-on-select. Each item picks
    the navigation kind via `:redirect` (`:href` (default) | `:patch` | `:navigate` | `false`).
    Items may also set `:to` (overrides the destination) and `:new_tab` (opens in a new tab).
    When true, the client runs single-select in Zag even if `selection_mode` is multiple.
    """
  )

  attr(:aria_label, :string, default: nil, doc: "Accessible name when no label slot is provided")
  attr(:rest, :global)

  slot :label, required: false do
    attr(:class, :string, required: false)
  end

  slot :item, required: false do
    attr(:class, :string, required: false)
  end

  slot :item_indicator, required: false do
    attr(:class, :string, required: false)
  end

  slot :empty, required: false do
    attr(:class, :string, required: false)
  end

  def listbox(assigns) do
    items = normalize_items(assigns.items)
    has_groups = has_groups?(items)
    groups = normalize_groups(items)

    assigns =
      assigns
      |> assign_new(:id, fn -> "listbox-#{System.unique_integer([:positive])}" end)
      |> assign(:value, validate_value!(assigns[:value] || []))
      |> assign(:items, items)
      |> assign(:has_groups, has_groups)
      |> assign(:groups, groups)

    ~H"""
    <div
      id={@id}
      phx-hook="Listbox"
      data-loading
      phx-mounted={Phoenix.LiveView.JS.ignore_attributes(["data-loading"])}
      {@rest}
      {Connect.props(%Props{
        id: @id,
        items: @items,
        value: @value,
        controlled: @controlled,
        disabled: @disabled,
        dir: @dir,
        orientation: @orientation,
        loop_focus: @loop_focus,
        selection_mode: @selection_mode,
        select_on_highlight: @select_on_highlight,
        deselectable: @deselectable,
        typeahead: @typeahead,
        on_value_change: @on_value_change,
        on_value_change_client: @on_value_change_client,
        redirect: @redirect
      })}
    >
      <div phx-mounted={Connect.ignore_root(%Root{id: @id, dir: @dir, orientation: @orientation})} {Connect.root(%Root{id: @id, dir: @dir, orientation: @orientation})}>
         <label phx-mounted={Connect.ignore_label(%Label{id: @id, dir: @dir, orientation: @orientation})} {Connect.label(%Label{id: @id, dir: @dir, orientation: @orientation})}>
          {if @label != [], do: render_slot(@label), else: @aria_label}
        </label>
        <div phx-mounted={Connect.ignore_content(%Content{id: @id, dir: @dir, orientation: @orientation})} {content_attrs(@id, @dir, @orientation, @label != [] || @aria_label != nil)}>
          <div :if={@items == [] && @empty != []} data-scope="listbox" data-part="empty">
            {render_slot(@empty)}
          </div>
          <div :for={group_id <- @groups} phx-mounted={Connect.ignore_item_group(%ItemGroup{id: @id, group_id: group_id, dir: @dir, orientation: @orientation})} {Connect.item_group(%ItemGroup{id: @id, group_id: group_id, dir: @dir, orientation: @orientation})}>
            <div phx-mounted={Connect.ignore_item_group_label(%ItemGroupLabel{id: @id, html_for: group_id, dir: @dir, orientation: @orientation})} {Connect.item_group_label(%ItemGroupLabel{id: @id, html_for: group_id, dir: @dir, orientation: @orientation})}>{group_id}</div>
            <div :for={entry <- Enum.filter(@items, &(&1.group == group_id))} phx-mounted={Connect.ignore_item(%Item{id: @id, item: entry, value: entry_value(entry), dir: @dir, orientation: @orientation})} {item_attrs(@id, entry, @dir, @orientation)}>
              <span phx-mounted={Connect.ignore_item_text(%ItemText{id: @id, item: entry, orientation: @orientation})} {Connect.item_text(%ItemText{id: @id, item: entry, orientation: @orientation})}>
                <%= if @item == [] do %>
                  {entry[:label]}
                <% else %>
                  {render_slot(@item, %{item: entry, value: entry_value(entry), label: entry[:label]})}
                <% end %>
              </span>
              <span
                phx-mounted={Connect.ignore_item_indicator(%ItemIndicator{id: @id, item: entry, dir: @dir, orientation: @orientation})}
                {Connect.item_indicator(%ItemIndicator{id: @id, item: entry, dir: @dir, orientation: @orientation})}
                hidden={!entry_selected?(entry, @value)}
              >
                {if @item_indicator != [], do: render_slot(@item_indicator), else: nil}
              </span>
            </div>
          </div>
          <div :for={entry <- if(@has_groups, do: [], else: @items)} phx-mounted={Connect.ignore_item(%Item{id: @id, item: entry, value: entry_value(entry), dir: @dir, orientation: @orientation})} {item_attrs(@id, entry, @dir, @orientation)}>
            <span :if={@item == []} phx-mounted={Connect.ignore_item_text(%ItemText{id: @id, item: entry, orientation: @orientation})} {Connect.item_text(%ItemText{id: @id, item: entry, orientation: @orientation})}>{entry[:label]}</span>
            {render_slot(@item, %{item: entry, value: entry_value(entry), label: entry[:label]})}
            <span
              phx-mounted={Connect.ignore_item_indicator(%ItemIndicator{id: @id, item: entry, dir: @dir, orientation: @orientation})}
              {Connect.item_indicator(%ItemIndicator{id: @id, item: entry, dir: @dir, orientation: @orientation})}
              hidden={!entry_selected?(entry, @value)}
            >
              {if @item_indicator != [], do: render_slot(@item_indicator), else: nil}
            </span>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp content_attrs(id, dir, orientation, has_label) do
    Connect.content(%Content{id: id, dir: dir, orientation: orientation})
    |> Map.put("data-layout", "list")
    |> then(fn attrs ->
      if has_label, do: Map.put(attrs, "aria-labelledby", "listbox:#{id}:label"), else: attrs
    end)
  end

  defp item_attrs(id, entry, dir, orientation) do
    base =
      Connect.item(%Item{
        id: id,
        item: entry,
        value: entry_value(entry),
        dir: dir,
        orientation: orientation,
        to: Map.get(entry, :to),
        redirect: Map.get(entry, :redirect),
        new_tab: Map.get(entry, :new_tab, false)
      })

    if Map.get(entry, :disabled) do
      base
      |> Map.put("data-disabled", "")
      |> Map.put("aria-disabled", "true")
    else
      base
    end
  end

  api_doc(~S"""
  Set the listbox selection from `phx-click`. Dispatches `corex:listbox:set-value` with `detail.value` (string list, wrapped if a single scalar is passed internally).

  ```heex
  <.action phx-click={Corex.Listbox.set_value("my-listbox", ["fra"])}>Choose France</.action>
  <.listbox id="my-listbox" class="listbox" items={
    Corex.List.new([
      %{label: "France", value: "fra"},
      %{label: "Belgium", value: "bel"}
    ])
  }>
    <:label>Country</:label>
  </.listbox>
  ```

  ```javascript
  document.getElementById("my-listbox")?.dispatchEvent(
    new CustomEvent("corex:listbox:set-value", {
      bubbles: false,
      detail: { value: ["fra"] },
    })
  );
  ```
  """)

  def set_value(listbox_id, value) when is_binary(listbox_id) do
    JS.dispatch("corex:listbox:set-value",
      to: "##{listbox_id}",
      detail: %{value: validate_value!(List.wrap(value))},
      bubbles: false
    )
  end

  api_doc(~S"""
  Set the listbox selection from `handle_event` (`listbox_set_value`).

  ```elixir
  def handle_event("pick_country", %{"code" => c}, socket) do
    {:noreply, Corex.Listbox.set_value(socket, "my-listbox", [c])}
  end
  ```
  """)

  def set_value(socket, listbox_id, value)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(listbox_id) do
    LiveView.push_event(socket, "listbox_set_value", %{
      id: listbox_id,
      value: validate_value!(List.wrap(value))
    })
  end

  api_doc(~S"""
  Read selected values from `phx-click`. Dispatches `corex:listbox:value`. Optional `respond_to:` `:server`, `:client`, or `:both`.

  | | Reply | Payload |
  | - | ----- | ------- |
  | Server | `listbox_value_response` | `%{"id" => id, "value" => selection}` |
  | Client | `listbox-value` on the root | same fields in `detail` |

  ```heex
  <.action phx-click={Corex.Listbox.value("my-listbox")}>Read selection</.action>
  <.listbox id="my-listbox" class="listbox" items={Corex.List.new([%{label: "A", value: "a"}])}>
    <:label>Pick</:label>
  </.listbox>
  ```

  ```elixir
  def handle_event("listbox_value_response", %{"id" => _, "value" => v}, socket) do
    {:noreply, assign(socket, :picked, v)}
  end
  ```
  """)

  def value(listbox_id, opts) when is_binary(listbox_id) and is_list(opts) do
    JS.dispatch("corex:listbox:value",
      to: "##{listbox_id}",
      detail: respond_to_fields(opts),
      bubbles: false
    )
  end

  def value(socket, listbox_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(listbox_id) do
    value(socket, listbox_id, [])
  end

  api_doc_short("Same as [`value/2`](#value/2) with default `respond_to:`.")
  def value(listbox_id) when is_binary(listbox_id), do: value(listbox_id, [])

  api_doc(~S"""
  Read selected values from `handle_event` (`listbox_value`). Same replies as [`value/2`](#value/2).

  | Reply | Payload |
  | ----- | ------- |
  | `listbox_value_response` | `%{"id" => id, "value" => selection}` |

  ```elixir
  def handle_event("read_listbox", _, socket) do
    {:noreply, Corex.Listbox.value(socket, "my-listbox", respond_to: :server)}
  end
  ```
  """)

  def value(socket, listbox_id, opts)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(listbox_id) and is_list(opts) do
    LiveView.push_event(
      socket,
      "listbox_value",
      Map.merge(%{id: listbox_id}, respond_to_fields(opts))
    )
  end
end
