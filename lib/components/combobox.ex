defmodule Corex.Combobox do
  @moduledoc ~S'''
  Searchable combobox for Phoenix LiveView forms. Behavior follows [Zag.js Combobox](https://zagjs.com/components/react/combobox).
  Pass options with `Corex.List.new/1`. With `redirect`, use per-item `:to`, `:redirect` (`:href` | `:patch` | `:navigate` | `false`), and `:new_tab`; Zag runs single-select when `redirect` is true.

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

  ```heex
  <.combobox
        class="combobox"
        translation={%Corex.Combobox.Translation{placeholder: "Select a country", empty: "No results"}}
        items={Corex.List.new([
          %{label: "France", value: "fra"},
          %{label: "Belgium", value: "bel"},
          %{label: "Germany", value: "deu"},
          %{label: "Netherlands", value: "nld"},
          %{label: "Switzerland", value: "che"},
          %{label: "Austria", value: "aut"}
        ])}
      >
        <:trigger>
          <.heroicon name="hero-chevron-down" />
        </:trigger>
      </.combobox>
  ```

  ### Grouped

  ```heex
  <.combobox
        class="combobox"
        translation={%Corex.Combobox.Translation{placeholder: "Select a country", empty: "No results"}}
        items={Corex.List.new([
          %{label: "France", value: "fra", group: "Europe"},
          %{label: "Belgium", value: "bel", group: "Europe"},
          %{label: "Germany", value: "deu", group: "Europe"},
          %{label: "Netherlands", value: "nld", group: "Europe"},
          %{label: "Switzerland", value: "che", group: "Europe"},
          %{label: "Austria", value: "aut", group: "Europe"},
          %{label: "Japan", value: "jpn", group: "Asia"},
          %{label: "China", value: "chn", group: "Asia"},
          %{label: "South Korea", value: "kor", group: "Asia"},
          %{label: "Thailand", value: "tha", group: "Asia"},
          %{label: "USA", value: "usa", group: "North America"},
          %{label: "Canada", value: "can", group: "North America"},
          %{label: "Mexico", value: "mex", group: "North America"}
        ])}
      >
        <:trigger>
          <.heroicon name="hero-chevron-down" />
        </:trigger>
      </.combobox>
  ```

  ### Extended

  This example requires the installation of [Flagpack](https://hex.pm/packages/flagpack) to display the use of custom item rendering.

  ```heex
    <.combobox
        class="combobox"
        translation={%Corex.Combobox.Translation{placeholder: "Select a country", empty: "No results"}}
        items={Corex.List.new([
          %{label: "France", value: "fra"},
          %{label: "Belgium", value: "bel"},
          %{label: "Germany", value: "deu"},
          %{label: "Netherlands", value: "nld"},
          %{label: "Switzerland", value: "che"},
          %{label: "Austria", value: "aut"}
        ])}
      >
        <:item :let={item}>
          <Flagpack.flag name={String.to_existing_atom(to_string(item.value))} />
          {item.label}
        </:item>
        <:trigger>
          <.heroicon name="hero-chevron-down" />
        </:trigger>
        <:clear_trigger>
          <.heroicon name="hero-backspace" />
        </:clear_trigger>
        <:item_indicator>
          <.heroicon name="hero-check" />
        </:item_indicator>
      </.combobox>
  ```

  ### Extended Grouped

  This example requires the installation of [Flagpack](https://hex.pm/packages/flagpack) to display the use of custom item rendering.

  ```heex
  <.combobox
        class="combobox"
        translation={%Corex.Combobox.Translation{placeholder: "Select a country", empty: "No results"}}
        items={Corex.List.new([
          %{label: "France", value: "fra", group: "Europe"},
          %{label: "Belgium", value: "bel", group: "Europe"},
          %{label: "Germany", value: "deu", group: "Europe"},
          %{label: "Japan", value: "jpn", group: "Asia"},
          %{label: "China", value: "chn", group: "Asia"},
          %{label: "South Korea", value: "kor", group: "Asia"}
        ])}
      >
        <:item :let={item}>
          <Flagpack.flag name={String.to_existing_atom(to_string(item.value))} />
          {item.label}
        </:item>
        <:trigger>
          <.heroicon name="hero-chevron-down" />
        </:trigger>
        <:clear_trigger>
          <.heroicon name="hero-backspace" />
        </:clear_trigger>
        <:item_indicator>
          <.heroicon name="hero-check" />
        </:item_indicator>
      </.combobox>
  ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.combobox>`.

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`set_value/2`](#set_value/2) | Set selection (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_value/3`](#set_value/3) | Set selection (server) | `socket` |
  | [`set_open/2`](#set_open/2) | Open or close menu (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_open/3`](#set_open/3) | Open or close menu (server) | `socket` |

  ```heex
  <.action phx-click={Corex.Combobox.set_value("combobox-api", ["fra"])} class="button ui-size-sm">France</.action>
  ```

  ## Events

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_value_change="combobox_value_changed"` | Selection changes | `%{"id" => id, "value" => values, "items" => items}` |
  | `on_open_change="combobox_open_changed"` | Menu open state changes | `%{"id" => id, "open" => open, "reason" => reason, "value" => values}` |
  | `on_input_value_change="combobox_search"` | Input text changes (server filter) | `%{"id" => id, "value" => string, "reason" => reason}` |
  | `on_highlight_change="combobox_highlight_changed"` | Highlighted option changes | `%{"id" => id, "highlightedValue" => value}` |
  | `on_select="combobox_selected"` | Item picked | `%{"id" => id, "value" => values, "itemValue" => item}` |

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_value_change_client="combobox-value-changed"` | Selection changes | `id`, `value`, `items` |
  | `on_open_change_client="combobox-open-changed"` | Menu open state changes | `id`, `open`, `reason`, `value` |
  | `on_input_value_change_client="combobox-input-changed"` | Input text changes | `id`, `value`, `reason` |
  | `on_highlight_change_client="combobox-highlight-changed"` | Highlighted option changes | `id`, `highlightedValue` |
  | `on_select_client="combobox-selected"` | Item picked | `id`, `value`, `itemValue` |

  ## Patterns

  ### Server-side filtering

  Disable client filtering with `filter={false}` and use `on_input_value_change` to filter on the server. This example uses a local list; replace with a database query for real apps.

  ```heex
  defmodule MyAppWeb.CountryCombobox do
    use MyAppWeb, :live_view

    @items [
      %{value: "fra", label: "France"},
      %{value: "bel", label: "Belgium"},
      %{value: "deu", label: "Germany"},
      %{value: "usa", label: "USA"},
      %{value: "jpn", label: "Japan"}
    ]

    def mount(_params, _session, socket) do
      {:ok, assign(socket, items: [])}
    end

    def handle_event("search", %{"value" => value, "reason" => "input-change"}, socket) do
      filtered =
        if byte_size(value) < 1 do
          []
        else
          term = String.downcase(value)
          Enum.filter(@items, fn item ->
            String.contains?(String.downcase(item.label), term)
          end)
        end

      {:noreply, assign(socket, items: filtered)}
    end

    def render(assigns) do
      ~H"""
      <.combobox
        items={@items}
        filter={false}
        on_input_value_change="search"
      >
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      </.combobox>
      """
    end
  end
  ```

  ## Style

  Target parts with `data-scope` and `data-part`:

  ```css
  [data-scope="combobox"][data-part="root"] {}
  [data-scope="combobox"][data-part="control"] {}
  [data-scope="combobox"][data-part="input"] {}
  [data-scope="combobox"][data-part="trigger"] {}
  [data-scope="combobox"][data-part="clear-trigger"] {}
  [data-scope="combobox"][data-part="content"] {}
  [data-scope="combobox"][data-part="empty"] {}
  [data-scope="combobox"][data-part="item-group"] {}
  [data-scope="combobox"][data-part="item-group-label"] {}
  [data-scope="combobox"][data-part="item"] {}
  [data-scope="combobox"][data-part="item-text"] {}
  [data-scope="combobox"][data-part="item-indicator"] {}
  ```

  If you wish to use the default Corex styling, you can use the class `combobox` on the component.
  This requires the `corex_design` dependency and `mix corex.design.build`; import the component css file.

  ```css
  @import "../corex/corex.css";
  ```

  You can then use modifiers

  ```heex
  <.combobox class="combobox ui-accent ui-size-lg" items={Corex.List.new([])}>
    <:empty>No results</:empty>
    <:trigger>
      <.heroicon name="hero-chevron-down" />
    </:trigger>
  </.combobox>
  ```

  Axes: **Semantic** (`ui-accent`, `ui-brand`, `ui-alert`, `ui-info`, `ui-success`), **Variant** (`ui-solid`), **Size** (`ui-size-sm` … `ui-size-xl`), **Radius** (`ui-rounded-*`), **Max height** (`ui-max-height-*` on the host; clamps content). See the [modifier guide](modifiers.html).

  Semantic modifiers set palette variables on the input and triggers. Variant modifiers control field surface treatment. Default is subtle; add `combobox ui-solid` for a filled control.

  <!-- tabs-open -->

  ### Semantic

  Palette variables for combobox ink and fill. Does not change surface treatment by itself.

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `combobox` |
  | Accent | `combobox ui-accent` |
  | Brand | `combobox ui-brand` |
  | Alert | `combobox ui-alert` |
  | Info | `combobox ui-info` |
  | Success | `combobox ui-success` |

  ### Variant

  Visual treatment of the input and trigger surfaces. Combine with a semantic modifier for palette-driven ink and fill.

  | Modifier | Classes |
  | -------- | ------- |
  | Subtle (default) | `combobox` or `combobox ui-accent` |
  | Solid | `combobox ui-accent ui-solid` |

  ### Size

  | Modifier | Classes |
  | -------- | ------- |
  | SM | `combobox ui-size-sm` |
  | MD | `combobox ui-size-md` |
  | LG | `combobox ui-size-lg` |
  | XL | `combobox ui-size-xl` |

  ### Max height

  Overrides the default content max-height. Example: `combobox ui-max-height-sm`.

  <!-- tabs-close -->

  ## Form

  Use `field={f[:key]}` with a form built from an Ecto changeset. Set the form `id` in `to_form/2` and use `<.form for={@form}>`. See [Select](`Corex.Select`) **Form** for full controller and LiveView examples.

  For cross-cutting invalid styling and error presentation, see the [Forms](forms.html) guide. With `field={@form[:…]}`, pass `auto_invalid` for alert borders from visible errors, or `invalid={true}` to force the alert state.

  ### Localization

  Pass `translation={%Corex.Combobox.Translation{}}` for partial overrides. See [`Corex.Combobox.Translation`](`Corex.Combobox.Translation`) for defaults.

  '''

  alias Corex.Combobox.Translation

  @doc type: :component
  use Phoenix.Component

  import Corex.Api.Doc

  import Corex.Helpers,
    only: [normalize_items: 1, has_groups?: 1, normalize_groups: 1, entry_value: 1]

  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  alias Corex.Combobox.Anatomy.{
    ClearTrigger,
    Content,
    Control,
    Empty,
    Input,
    Item,
    ItemGroup,
    ItemGroupLabel,
    ItemIndicator,
    ItemText,
    Label,
    List,
    Positioner,
    Props,
    Root,
    Trigger
  }

  alias Corex.Combobox.Connect
  alias Corex.Selectors

  @doc """
  Renders a combobox component.
  """

  attr(:id, :string,
    required: false,
    doc: "The id of the combobox, useful for API to identify the combobox"
  )

  attr(:items, :list,
    default: [],
    doc: "Items from `Corex.List.new/1` (or maps with :label and optional :value)"
  )

  attr(:value, :any,
    default: nil,
    doc:
      "Initial selected item values (list of strings or a single string); not updated by LiveView after mount"
  )

  attr(:on_open_change, :string,
    default: nil,
    doc: "The server event name to trigger on open change"
  )

  attr(:on_open_change_client, :string,
    default: nil,
    doc: "The client event name to trigger on open change"
  )

  attr(:disabled, :boolean, default: false, doc: "Whether the combobox is disabled")

  attr(:translation, Corex.Combobox.Translation,
    default: nil,
    doc: "Override translatable strings"
  )

  attr(:always_submit_on_enter, :boolean,
    default: false,
    doc: "Whether to always submit on enter"
  )

  attr(:auto_focus, :boolean, default: false, doc: "Whether to auto focus the combobox")
  attr(:close_on_select, :boolean, default: true, doc: "Whether to close the combobox on select")

  attr(:dir, :string,
    default: nil,
    values: [nil, "ltr", "rtl"],
    doc:
      "The direction of the combobox. When nil, derived from document (html lang + config :rtl_locales)"
  )

  attr(:orientation, :string,
    default: "vertical",
    values: ["horizontal", "vertical"],
    doc: "Layout orientation for the combobox"
  )

  attr(:input_behavior, :string,
    default: "autohighlight",
    doc: "The input behavior of the combobox"
  )

  attr(:loop_focus, :boolean, default: false, doc: "Whether to loop focus the combobox")
  attr(:multiple, :boolean, default: false, doc: "Whether to allow multiple selection")
  attr(:invalid, :boolean, default: nil, doc: "Whether the combobox is invalid")

  attr(:auto_invalid, :boolean,
    default: false,
    doc: "When true with `field`, set invalid from visible changeset errors"
  )

  attr(:name, :string, doc: "The name of the combobox")
  attr(:form, :string, doc: "The id of the form of the combobox")

  attr(:read_only, :boolean, default: false, doc: "Whether the combobox is read only")
  attr(:required, :boolean, default: false, doc: "Whether the combobox is required")

  attr(:filter, :boolean,
    default: true,
    doc:
      "When true, filter options client-side by input value. Set to false when using on_input_value_change for server-side filtering"
  )

  attr(:allow_custom_value, :boolean,
    default: false,
    doc: "Whether the combobox accepts values not in the collection"
  )

  attr(:selection_behavior, :string,
    default: "replace",
    values: ["clear", "replace", "preserve"],
    doc: "How selection behaves when picking items"
  )

  attr(:clear_on_empty, :boolean,
    default: false,
    doc: "When true, clearing the input text clears the current selection"
  )

  attr(:open_on_click, :boolean,
    default: nil,
    doc: "Whether clicking the input opens the menu. Omit to use the Zag default (false)"
  )

  attr(:open_on_change, :boolean,
    default: nil,
    doc: "Whether typing opens the menu. Omit to use the Zag default (true)"
  )

  attr(:open_on_key_press, :boolean,
    default: nil,
    doc: "Whether key presses open the menu. Omit to use the Zag default (true)"
  )

  attr(:composite, :boolean,
    default: nil,
    doc: "Whether the combobox is composite. Omit to use the Zag default (true)"
  )

  attr(:disable_layer, :boolean,
    default: nil,
    doc: "Whether to disable the popover layer. Omit to use the Zag default (false)"
  )

  attr(:on_input_value_change, :string,
    default: nil,
    doc: "The server event name to trigger on input value change"
  )

  attr(:on_input_value_change_client, :string,
    default: nil,
    doc: "The client event name to trigger on input value change"
  )

  attr(:on_value_change, :string,
    default: nil,
    doc: "The server event name to trigger on value change"
  )

  attr(:on_value_change_client, :string,
    default: nil,
    doc: "The client event name to trigger on value change"
  )

  attr(:on_highlight_change, :string,
    default: nil,
    doc: "The server event name to trigger on highlight change"
  )

  attr(:on_highlight_change_client, :string,
    default: nil,
    doc: "The client event name to trigger on highlight change"
  )

  attr(:on_select, :string,
    default: nil,
    doc: "The server event name to trigger when an item is selected"
  )

  attr(:on_select_client, :string,
    default: nil,
    doc: "The client event name to trigger when an item is selected"
  )

  attr(:redirect, :boolean,
    default: false,
    doc: """
    When true, selecting a value triggers redirect-on-select. Each item picks
    the navigation kind via `:redirect` (`:href` (default) | `:patch` | `:navigate` | `false`).
    Items may also set `:to` (overrides the destination) and `:new_tab` (opens in a new tab).
    When true, the client runs single-select in Zag even if `multiple` is set on this component.
    """
  )

  attr(:positioning, :map,
    default: %Corex.Positioning{same_width: true},
    doc: "The positioning of the combobox"
  )

  attr(:rest, :global)

  slot :label, required: false, doc: "The label content" do
    attr(:class, :string, required: false)
  end

  slot :empty,
    required: false,
    doc: "Content when there are no results. When omitted, translation.empty is used" do
    attr(:class, :string, required: false)
  end

  slot :trigger, required: true, doc: "The trigger button content" do
    attr(:class, :string, required: false)
  end

  slot :clear_trigger, required: false, doc: "The clear button content" do
    attr(:class, :string, required: false)
  end

  slot :item_indicator, required: false, doc: "Optional indicator for selected items" do
    attr(:class, :string, required: false)
  end

  slot :error, required: false do
    attr(:class, :string, required: false)
  end

  slot :item,
    required: false,
    doc: "Custom content for each item. Receives the item as :let binding" do
    attr(:class, :string, required: false)
  end

  attr(:field, Phoenix.HTML.FormField,
    doc:
      "A form field struct retrieved from the form, for example: @form[:country]. Automatically sets id, name, value, and errors from the form field"
  )

  attr(:form_field, :boolean, default: false, doc: false)

  attr(:errors, :list,
    default: [],
    doc: "List of error messages to display"
  )

  def combobox(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    items = normalize_items(assigns.items)
    raw_value = get_value(field.value)
    value = normalize_value_to_ids(items, raw_value)
    selected_label = get_selected_label(items, value)

    assigns
    |> assign(:items, items)
    |> Corex.FormField.assign_form_field(field)
    |> assign(:value, value)
    |> assign(:selected_label, selected_label)
    |> combobox_render(Phoenix.Component.used_input?(field))
  end

  def combobox(assigns), do: combobox_render(assigns, false)

  defp combobox_render(assigns, field_used) do
    translation = Translation.resolve(assigns[:translation])
    placeholder = translation.placeholder
    empty_text = translation.empty

    assigns =
      assigns
      |> Corex.FormField.require_id!("Corex component (combobox)")
      |> assign_new(:name, fn -> nil end)
      |> assign_new(:form, fn -> nil end)
      |> assign_new(:form_field, fn -> false end)
      |> assign_new(:dir, fn -> "ltr" end)
      |> assign(:translation, translation)
      |> assign(:placeholder, placeholder)
      |> assign(:empty_text, empty_text)
      |> assign(:field_used, field_used)

    items = normalize_items(assigns.items)

    raw_initial = Map.get(assigns, :value)
    value_list = normalize_value_to_ids(items, get_value(raw_initial))

    has_groups = has_groups?(items)
    groups = normalize_groups(items)

    selected_label = get_selected_label(items, value_list)

    array_form_submit = assigns.multiple && is_binary(assigns[:name])

    assigns =
      assigns
      |> assign(:items, items)
      |> assign(:items_json, Corex.Dataset.encode_json(items))
      |> assign(:has_groups, has_groups)
      |> assign(:groups, groups)
      |> assign(:value, value_list)
      |> assign(:selected_label, selected_label)
      |> assign(:value_for_hidden_input, value_for_hidden_input(value_list, assigns.multiple))
      |> then(fn a ->
        if array_form_submit do
          Corex.FormField.assign_list_submit(a)
        else
          assign(a, :submit_name, nil)
        end
      end)
      |> then(fn a ->
        assign(a, :empty_array_name, if(field_used, do: a.submit_name))
      end)

    assigns = assign(assigns, :hook_attrs, combobox_connect_props(assigns))

    ~H"""
    <div id={@id} 
    phx-hook="Combobox" 
    data-loading
    phx-mounted={Phoenix.LiveView.JS.ignore_attributes(["data-loading"])}
    {@rest}
    {@hook_attrs}>
      <div phx-mounted={Connect.ignore_root(%Root{id: @id, invalid: @invalid, read_only: @read_only, orientation: @orientation, dir: @dir})} {Connect.root(%Root{id: @id, invalid: @invalid, read_only: @read_only, orientation: @orientation, dir: @dir})}>
        <div
          :if={@submit_name}
          data-scope="combobox"
          data-part="array-inputs"
          id={"combobox:#{@id}:array-inputs"}
        >
          <input
            :for={{v, index} <- Enum.with_index(@value)}
            type="hidden"
            id={"combobox:#{@id}:array-input-#{index}"}
            data-scope="combobox"
            data-part="array-input"
            name={@submit_name}
            value={v}
            phx-mounted={
              JS.ignore_attributes(["value", "name"],
                to: Selectors.css_id("combobox:#{@id}:array-input-#{index}")
              )
            }
          />
          <input
            :if={@value == []}
            type="hidden"
            id={"combobox:#{@id}:array-input-empty"}
            data-scope="combobox"
            data-part="array-input"
            data-empty
            name={@empty_array_name}
            value=""
            phx-mounted={
              JS.ignore_attributes(["value", "name"],
                to: Selectors.css_id("combobox:#{@id}:array-input-empty")
              )
            }
          />
        </div>
      <input
        type="text"
        hidden
        aria-hidden="true"
        autocomplete="off"
        tabindex="-1"
        id={"#{@id}-hidden-value"}
        name={if(@submit_name, do: nil, else: @name)}
        data-scope="combobox"
        data-part="hidden-input"
        value={@value_for_hidden_input}
        phx-mounted={JS.ignore_attributes(["value"], to: Selectors.css_id("#{@id}-hidden-value"))}
      />

        <div :if={!Enum.empty?(@label)} phx-mounted={Connect.ignore_label(%Label{id: @id, invalid: @invalid, read_only: @read_only, required: @required, disabled: @disabled, dir: @dir, orientation: @orientation})} {Connect.label(%Label{id: @id, invalid: @invalid, read_only: @read_only, required: @required, disabled: @disabled, dir: @dir, orientation: @orientation})}>
          {render_slot(@label)}
        </div>
        <div phx-mounted={Connect.ignore_control(%Control{id: @id, invalid: @invalid, dir: @dir, disabled: @disabled, orientation: @orientation})} {Connect.control(%Control{id: @id, invalid: @invalid, dir: @dir, disabled: @disabled, orientation: @orientation})}>
          <input value={@selected_label || ""} phx-mounted={Connect.ignore_input(%Input{id: @id, value: @value, selected_label: @selected_label, form: nil, invalid: @invalid, dir: @dir, disabled: @disabled, required: @required, placeholder: @placeholder, name: nil, auto_focus: @auto_focus, orientation: @orientation})} {Connect.input(%Input{id: @id, value: @value, selected_label: @selected_label, form: nil, invalid: @invalid, dir: @dir, disabled: @disabled, required: @required, placeholder: @placeholder, name: nil, auto_focus: @auto_focus, orientation: @orientation})} />
          <button :if={!Enum.empty?(@clear_trigger)} hidden={Enum.empty?(@value)} phx-mounted={Connect.ignore_clear_trigger(%ClearTrigger{id: @id, dir: @dir, disabled: @disabled, invalid: @invalid, orientation: @orientation})} {Connect.clear_trigger(%ClearTrigger{id: @id, dir: @dir, disabled: @disabled, invalid: @invalid, orientation: @orientation})} aria-label={@translation.clear_selection}>
            {render_slot(@clear_trigger)}
          </button>
          <button phx-mounted={Connect.ignore_trigger(%Trigger{id: @id, dir: @dir, disabled: @disabled, invalid: @invalid, orientation: @orientation})} {Connect.trigger(%Trigger{id: @id, dir: @dir, disabled: @disabled, invalid: @invalid, orientation: @orientation})} aria-label={@translation.trigger}>
            {render_slot(@trigger)}
          </button>
        </div>

        <div phx-mounted={Connect.ignore_positioner(%Positioner{id: @id, dir: @dir, orientation: @orientation})} {Connect.positioner(%Positioner{id: @id, dir: @dir, orientation: @orientation})}>
          <div phx-mounted={Connect.ignore_content(%Content{id: @id, dir: @dir, orientation: @orientation})} {Connect.content(%Content{id: @id, dir: @dir, orientation: @orientation})}>
            <ul phx-mounted={Connect.ignore_list(%List{id: @id, dir: @dir, orientation: @orientation})} {Connect.list(%List{id: @id, dir: @dir, orientation: @orientation})}>
              <li :if={@items == []} phx-mounted={Connect.ignore_empty(%Empty{id: @id, dir: @dir, orientation: @orientation})} {Connect.empty(%Empty{id: @id, dir: @dir, orientation: @orientation})}>
                {if Enum.empty?(@empty), do: @empty_text, else: render_slot(@empty)}
              </li>

              <li :if={@has_groups} :for={group_id <- @groups} phx-mounted={Connect.ignore_item_group(%ItemGroup{id: @id, group_id: group_id, dir: @dir, orientation: @orientation})} {Connect.item_group(%ItemGroup{id: @id, group_id: group_id, dir: @dir, orientation: @orientation})}>
                <div phx-mounted={Connect.ignore_item_group_label(%ItemGroupLabel{id: @id, html_for: group_id, dir: @dir, orientation: @orientation})} {Connect.item_group_label(%ItemGroupLabel{id: @id, html_for: group_id, dir: @dir, orientation: @orientation})}>
                  {group_id}
                </div>
                <ul>
                  <li :for={entry <- Enum.filter(@items, &(&1.group == group_id))} phx-mounted={Connect.ignore_item(%Item{id: @id, item: entry, value: entry_value(entry), dir: @dir, orientation: @orientation})} {item_attrs(@id, entry, @dir, @orientation)}>
                    <span :if={Enum.empty?(@item)} phx-mounted={Connect.ignore_item_text(%ItemText{id: @id, item: entry, dir: @dir, orientation: @orientation})} {Connect.item_text(%ItemText{id: @id, item: entry, dir: @dir, orientation: @orientation})}>
                      {entry.label}
                    </span>
                    <span :if={!Enum.empty?(@item)} phx-mounted={Connect.ignore_item_text(%ItemText{id: @id, item: entry, dir: @dir, orientation: @orientation})} {Connect.item_text(%ItemText{id: @id, item: entry, dir: @dir, orientation: @orientation})}>
                      {render_slot(@item, entry)}
                    </span>
                    <span :if={!Enum.empty?(@item_indicator)} phx-mounted={Connect.ignore_item_indicator(%ItemIndicator{id: @id, item: entry, dir: @dir, orientation: @orientation})} {Connect.item_indicator(%ItemIndicator{id: @id, item: entry, dir: @dir, orientation: @orientation})}>
                      {render_slot(@item_indicator)}
                    </span>
                  </li>
                </ul>
              </li>

              <li :for={entry <- if(@has_groups, do: [], else: @items)} phx-mounted={Connect.ignore_item(%Item{id: @id, item: entry, value: entry_value(entry), dir: @dir, orientation: @orientation})} {item_attrs(@id, entry, @dir, @orientation)}>
                <span :if={Enum.empty?(@item)} phx-mounted={Connect.ignore_item_text(%ItemText{id: @id, item: entry, dir: @dir, orientation: @orientation})} {Connect.item_text(%ItemText{id: @id, item: entry, dir: @dir, orientation: @orientation})}>
                  {entry.label}
                </span>
                <span :if={!Enum.empty?(@item)} phx-mounted={Connect.ignore_item_text(%ItemText{id: @id, item: entry, dir: @dir, orientation: @orientation})} {Connect.item_text(%ItemText{id: @id, item: entry, dir: @dir, orientation: @orientation})}>
                  {render_slot(@item, entry)}
                </span>
                <span :if={!Enum.empty?(@item_indicator)} phx-mounted={Connect.ignore_item_indicator(%ItemIndicator{id: @id, item: entry, dir: @dir, orientation: @orientation})} {Connect.item_indicator(%ItemIndicator{id: @id, item: entry, dir: @dir, orientation: @orientation})}>
                  {render_slot(@item_indicator)}
                </span>
              </li>
            </ul>
          </div>
        </div>
      </div>
      <div
        :if={@error != [] and !Enum.empty?(@errors)}
        :for={msg <- @errors}
        class={Map.get(Enum.at(@error, 0), :class, nil)}
        data-scope="combobox"
        data-part="error"
      >
        {render_slot(@error, msg)}
      </div>
      <div style="display: none;" data-templates="combobox">
        <li data-scope="combobox" data-part="empty" data-template="true">
          {if Enum.empty?(@empty), do: @empty_text, else: render_slot(@empty)}
        </li>

        <li :if={@has_groups} :for={group_id <- @groups} {Connect.item_group_template(%ItemGroup{id: @id, group_id: group_id, dir: @dir, orientation: @orientation})} data-template="true">
          <div {Connect.item_group_label_template(%ItemGroupLabel{id: @id, html_for: group_id, dir: @dir, orientation: @orientation})}>
            {group_id}
          </div>
          <ul>
            <li :for={entry <- Enum.filter(@items, &(&1.group == group_id))} {item_attrs_template(@id, entry, @dir, @orientation)} data-template="true">
              <span :if={Enum.empty?(@item)} {Connect.item_text_template(%ItemText{id: @id, item: entry, dir: @dir, orientation: @orientation})}>
                {entry.label}
              </span>
              <span :if={!Enum.empty?(@item)} {Connect.item_text_template(%ItemText{id: @id, item: entry, dir: @dir, orientation: @orientation})}>
                {render_slot(@item, entry)}
              </span>
              <span :if={!Enum.empty?(@item_indicator)} {Connect.item_indicator_template(%ItemIndicator{id: @id, item: entry, dir: @dir, orientation: @orientation})}>
                {render_slot(@item_indicator)}
              </span>
            </li>
          </ul>
        </li>

        <li :for={entry <- if(@has_groups, do: [], else: @items)} {item_attrs_template(@id, entry, @dir, @orientation)} data-template="true">
          <span :if={Enum.empty?(@item)} {Connect.item_text_template(%ItemText{id: @id, item: entry, dir: @dir, orientation: @orientation})}>
            {entry.label}
          </span>
          <span :if={!Enum.empty?(@item)} {Connect.item_text_template(%ItemText{id: @id, item: entry, dir: @dir, orientation: @orientation})}>
            {render_slot(@item, entry)}
          </span>
          <span :if={!Enum.empty?(@item_indicator)} {Connect.item_indicator_template(%ItemIndicator{id: @id, item: entry, dir: @dir, orientation: @orientation})}>
            {render_slot(@item_indicator)}
          </span>
        </li>
      </div>
    </div>
    """
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

  defp item_attrs_template(id, entry, dir, orientation) do
    base =
      Connect.item_template(%Item{
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

  defp get_value(field_value) do
    cond do
      empty_field_value?(field_value) ->
        []

      is_list(field_value) ->
        normalize_field_value_list(field_value)

      true ->
        s = to_string(field_value)
        if empty_field_value?(s), do: [], else: [s]
    end
  end

  defp empty_field_value?(value) when value in [nil, "", "[]", []], do: true
  defp empty_field_value?(_), do: false

  defp normalize_field_value_list(value) do
    value
    |> Enum.map(&to_string/1)
    |> Enum.reject(&empty_field_value?/1)
  end

  defp normalize_value_to_ids(items, value_list) do
    Enum.map(value_list, &resolve_value_id(items, &1))
  end

  defp resolve_value_id(items, val) do
    by_value = Enum.find(items, &(to_string(&1.value) == val))
    by_label = Enum.find(items, &(&1.label == val))

    cond do
      by_value != nil -> val
      by_label != nil -> to_string(by_label.value)
      true -> val
    end
  end

  defp get_selected_label(items, value) do
    case value do
      [] ->
        nil

      _ ->
        value
        |> Enum.map(fn val ->
          items
          |> Enum.find(&(to_string(&1.value) == val))
        end)
        |> Enum.filter(& &1)
        |> Enum.map(& &1.label)
        |> case do
          [] -> nil
          labels -> Enum.join(labels, ", ")
        end
    end
  end

  defp value_for_hidden_input(value_list, _multiple) when value_list == [], do: ""
  defp value_for_hidden_input(value_list, false), do: Elixir.List.first(value_list)
  defp value_for_hidden_input(value_list, true), do: Enum.join(value_list, ",")

  api_doc(~S"""
  Set selected value(s) from a control (`phx-click`). Pass a list, comma-separated string, or single value (normalized like the component).

  ```heex
  <.action phx-click={Corex.Combobox.set_value("my-combobox", "bel")}>Belgium</.action>
  <.combobox
    id="my-combobox"
    class="combobox"
    translation={%Corex.Combobox.Translation{placeholder: "Country", empty: "None"}}
    items={Corex.List.new([
      %{label: "Belgium", value: "bel"},
      %{label: "Germany", value: "deu"}
    ])}
  >
    <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
  </.combobox>
  ```

  ```javascript
  document.getElementById("my-combobox")?.dispatchEvent(
    new CustomEvent("corex:combobox:set-value", {
      bubbles: false,
      detail: { value: ["bel"] },
    })
  );
  ```
  """)

  def set_value(combobox_id, value) when is_binary(combobox_id) do
    JS.dispatch("corex:combobox:set-value",
      to: "##{combobox_id}",
      detail: %{value: Corex.Helpers.normalize_string_list_value!(value)},
      bubbles: false
    )
  end

  api_doc(~S"""
  Set selection from `handle_event`. Pushes `combobox_set_value`.

  ```heex
  <.action phx-click="pick_bel" phx-value-value="bel">Belgium</.action>
  <.combobox
    id="my-combobox"
    class="combobox"
    translation={%Corex.Combobox.Translation{placeholder: "Country", empty: "None"}}
    items={Corex.List.new([
      %{label: "Belgium", value: "bel"},
      %{label: "Germany", value: "deu"}
    ])}
  >
    <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
  </.combobox>
  ```

  ```elixir
  def handle_event("pick_bel", %{"value" => v}, socket) do
    {:noreply, Corex.Combobox.set_value(socket, "my-combobox", v)}
  end
  ```
  """)

  def set_value(socket, combobox_id, value)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(combobox_id) do
    LiveView.push_event(socket, "combobox_set_value", %{
      id: combobox_id,
      value: Corex.Helpers.normalize_string_list_value!(value)
    })
  end

  api_doc(~S"""
  Open or close the menu from a control (`phx-click`).

  ```heex
  <.action phx-click={Corex.Combobox.set_open("my-combobox", true)}>Open</.action>
  ```

  ```javascript
  document.getElementById("my-combobox")?.dispatchEvent(
    new CustomEvent("corex:combobox:set-open", {
      bubbles: false,
      detail: { open: true },
    })
  );
  ```
  """)

  def set_open(combobox_id, open) when is_binary(combobox_id) and is_boolean(open) do
    JS.dispatch("corex:combobox:set-open",
      to: "##{combobox_id}",
      detail: %{open: open},
      bubbles: false
    )
  end

  api_doc(~S"""
  Open or close the menu from `handle_event`. Pushes `combobox_set_open`.

  ```elixir
  def handle_event("open_combobox", _, socket) do
    {:noreply, Corex.Combobox.set_open(socket, "my-combobox", true)}
  end
  ```
  """)

  def set_open(socket, combobox_id, open)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(combobox_id) and
             is_boolean(open) do
    LiveView.push_event(socket, "combobox_set_open", %{id: combobox_id, open: open})
  end

  defp combobox_connect_props(assigns) do
    props = %Props{
      id: assigns.id,
      items: assigns.items,
      items_json: Map.get(assigns, :items_json),
      form_field: assigns[:form_field] == true,
      controlled: false,
      placeholder: assigns.placeholder,
      value: assigns.value,
      name: assigns.name,
      form: assigns.form,
      translation: assigns.translation,
      always_submit_on_enter: assigns.always_submit_on_enter,
      auto_focus: assigns.auto_focus,
      close_on_select: assigns.close_on_select,
      dir: assigns.dir,
      orientation: assigns.orientation,
      input_behavior: assigns.input_behavior,
      loop_focus: assigns.loop_focus,
      multiple: assigns.multiple,
      invalid: assigns.invalid,
      read_only: assigns.read_only,
      required: assigns.required,
      on_open_change: assigns.on_open_change,
      on_open_change_client: assigns.on_open_change_client,
      on_input_value_change: assigns.on_input_value_change,
      on_input_value_change_client: assigns.on_input_value_change_client,
      on_value_change: assigns.on_value_change,
      on_value_change_client: assigns.on_value_change_client,
      on_highlight_change: assigns.on_highlight_change,
      on_highlight_change_client: assigns.on_highlight_change_client,
      on_select: assigns.on_select,
      on_select_client: assigns.on_select_client,
      positioning: assigns.positioning,
      redirect: assigns.redirect,
      disabled: assigns.disabled,
      filter: assigns.filter,
      allow_custom_value: Map.get(assigns, :allow_custom_value, false),
      selection_behavior: Map.get(assigns, :selection_behavior, "replace"),
      clear_on_empty: Map.get(assigns, :clear_on_empty, false),
      open_on_click: Map.get(assigns, :open_on_click),
      open_on_change: Map.get(assigns, :open_on_change),
      open_on_key_press: Map.get(assigns, :open_on_key_press),
      composite: Map.get(assigns, :composite),
      disable_layer: Map.get(assigns, :disable_layer),
      submit_name: Map.get(assigns, :submit_name)
    }

    props
    |> Connect.props()
    |> Corex.FormField.put_form_field_attrs(assigns)
  end
end
