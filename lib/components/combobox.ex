defmodule Corex.Combobox do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Combobox](https://zagjs.com/components/react/combobox).

  <!-- tabs-open -->

  ### Minimal

  This example assumes the import of `.icon` from `Core Components`, you are free to replace it

  ```heex
  <.combobox
        class="combobox"
        placeholder="Select a country"
        collection={[
          %{label: "France", id: "fra", disabled: true},
          %{label: "Belgium", id: "bel"},
          %{label: "Germany", id: "deu"},
          %{label: "Netherlands", id: "nld"},
          %{label: "Switzerland", id: "che"},
          %{label: "Austria", id: "aut"}
        ]}
      >
        <:empty>No results</:empty>
        <:trigger>
          <.icon name="hero-chevron-down" />
        </:trigger>
      </.combobox>
  ```

  ### Grouped

  ```heex
  <.combobox
        class="combobox"
        placeholder="Select a country"
        collection={[
          %{label: "France", id: "fra", group: "Europe"},
          %{label: "Belgium", id: "bel", group: "Europe"},
          %{label: "Germany", id: "deu", group: "Europe"},
          %{label: "Netherlands", id: "nld", group: "Europe"},
          %{label: "Switzerland", id: "che", group: "Europe"},
          %{label: "Austria", id: "aut", group: "Europe"},
          %{label: "Japan", id: "jpn", group: "Asia"},
          %{label: "China", id: "chn", group: "Asia"},
          %{label: "South Korea", id: "kor", group: "Asia"},
          %{label: "Thailand", id: "tha", group: "Asia"},
          %{label: "USA", id: "usa", group: "North America"},
          %{label: "Canada", id: "can", group: "North America"},
          %{label: "Mexico", id: "mex", group: "North America"}
        ]}
      >
        <:empty>No results</:empty>
        <:trigger>
          <.icon name="hero-chevron-down" />
        </:trigger>
      </.combobox>
  ```

  ### Extended

  This example requires the installation of [Flagpack](https://hex.pm/packages/flagpack) to display the use of custom item rendering.

  This example assumes the import of `.icon` from `Core Components`, you are free to replace it

  ```heex
    <.combobox
        class="combobox"
        placeholder="Select a country"
        collection={[
          %{label: "France", id: "fra"},
          %{label: "Belgium", id: "bel"},
          %{label: "Germany", id: "deu"},
          %{label: "Netherlands", id: "nld"},
          %{label: "Switzerland", id: "che"},
          %{label: "Austria", id: "aut"}
        ]}
      >
        <:empty>No results</:empty>
        <:item :let={item}>
          <Flagpack.flag name={String.to_atom(item.id)} />
          {item.label}
        </:item>
        <:trigger>
          <.icon name="hero-chevron-down" />
        </:trigger>
        <:clear_trigger>
          <.icon name="hero-backspace" />
        </:clear_trigger>
        <:item_indicator>
          <.icon name="hero-check" />
        </:item_indicator>
      </.combobox>
  ```

  ### Extended Grouped

  This example requires the installation of [Flagpack](https://hex.pm/packages/flagpack) to display the use of custom item rendering.

  This example assumes the import of `.icon` from `Core Components`, you are free to replace it

  ```heex
  <.combobox
        class="combobox"
        placeholder="Select a country"
        collection={[
          %{label: "France", id: "fra", group: "Europe"},
          %{label: "Belgium", id: "bel", group: "Europe"},
          %{label: "Germany", id: "deu", group: "Europe"},
          %{label: "Japan", id: "jpn", group: "Asia"},
          %{label: "China", id: "chn", group: "Asia"},
          %{label: "South Korea", id: "kor", group: "Asia"}
        ]}
      >
        <:empty>No results</:empty>
        <:item :let={item}>
          <Flagpack.flag name={String.to_atom(item.id)} />
          {item.label}
        </:item>
        <:trigger>
          <.icon name="hero-chevron-down" />
        </:trigger>
        <:clear_trigger>
          <.icon name="hero-backspace" />
        </:clear_trigger>
        <:item_indicator>
          <.icon name="hero-check" />
        </:item_indicator>
      </.combobox>
  ```

  ### Server-side Filtering

  Use `on_input_value_change` to filter on the server. This example uses a local list; replace with a database query for real apps.

  ```heex
  defmodule MyAppWeb.CountryCombobox do
    use MyAppWeb, :live_view

    @items [
      %{id: "fra", label: "France"},
      %{id: "bel", label: "Belgium"},
      %{id: "deu", label: "Germany"},
      %{id: "usa", label: "USA"},
      %{id: "jpn", label: "Japan"}
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
        id="country-combobox"
        collection={@items}
        on_input_value_change="search"
      >
        <:empty>No results</:empty>
        <:trigger><.icon name="hero-chevron-down" /></:trigger>
      </.combobox>
      """
    end
  end
  ```

  <!-- tabs-close -->

  ## Styling

  Use data attributes to target elements:

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
  This requires to install `Mix.Tasks.Corex.Design` first and import the component css file.

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/combobox.css";
  ```

  You can then use modifiers

  ```heex
  <.combobox class="combobox combobox--accent combobox--lg" collection={[]}>
    <:empty>No results</:empty>
    <:trigger>
      <.icon name="hero-chevron-down" />
    </:trigger>
  </.combobox>
  ```

  Learn more about modifiers and [Corex Design](https://corex-ui.com/components/combobox#modifiers)
  '''

  @doc type: :component
  use Phoenix.Component
  alias Corex.Combobox.Connect
  alias Corex.Combobox.Anatomy.{Props, Root, Label, Control, Input, Positioner, Content}

  @doc """
  Renders a combobox component.
  """

  attr(:id, :string,
    required: false,
    doc: "The id of the combobox, useful for API to identify the combobox"
  )

  attr(:collection, :list,
    default: [],
    doc: "The collection of items to display in the combobox"
  )

  attr(:controlled, :boolean, default: false, doc: "Whether the combobox is controlled")

  attr(:on_open_change, :string,
    default: nil,
    doc: "The server event name to trigger on open change"
  )

  attr(:on_open_change_client, :string,
    default: nil,
    doc: "The client event name to trigger on open change"
  )

  attr(:bubble, :boolean, default: false, doc: "Whether the client events are bubbled")
  attr(:disabled, :boolean, default: false, doc: "Whether the combobox is disabled")
  attr(:open, :boolean, default: false, doc: "Whether the combobox is open")
  attr(:value, :list, default: [], doc: "The value of the combobox")

  attr(:placeholder, :string, default: nil, doc: "The placeholder of the combobox")

  attr(:always_submit_on_enter, :boolean,
    default: false,
    doc: "Whether to always submit on enter"
  )

  attr(:auto_focus, :boolean, default: false, doc: "Whether to auto focus the combobox")
  attr(:close_on_select, :boolean, default: true, doc: "Whether to close the combobox on select")

  attr(:dir, :string,
    default: nil,
    doc:
      "The direction of the combobox. When nil, derived from document (html lang + config :rtl_locales)"
  )

  attr(:input_behavior, :string,
    default: "autohighlight",
    doc: "The input behavior of the combobox"
  )

  attr(:loop_focus, :boolean, default: false, doc: "Whether to loop focus the combobox")
  attr(:multiple, :boolean, default: false, doc: "Whether to allow multiple selection")
  attr(:invalid, :boolean, default: false, doc: "Whether the combobox is invalid")
  attr(:name, :string, doc: "The name of the combobox")
  attr(:form, :string, doc: "The id of the form of the combobox")

  attr(:read_only, :boolean, default: false, doc: "Whether the combobox is read only")
  attr(:required, :boolean, default: false, doc: "Whether the combobox is required")

  attr(:filter, :boolean,
    default: true,
    doc:
      "When true, filter options client-side by input value. Set to false when using on_input_value_change for server-side filtering"
  )

  attr(:on_input_value_change, :string,
    default: nil,
    doc: "The server event name to trigger on input value change"
  )

  attr(:on_value_change, :string,
    default: nil,
    doc: "The server event name to trigger on value change"
  )

  attr(:positioning, :map, default: %Corex.Positioning{}, doc: "The positioning of the combobox")

  attr(:rest, :global)

  slot(:label, required: false, doc: "The label content")
  slot(:empty, required: true, doc: "Content to display when there are no results")
  slot(:trigger, required: true, doc: "The trigger button content")
  slot(:clear_trigger, required: false, doc: "The clear button content")
  slot(:item_indicator, required: false, doc: "Optional indicator for selected items")

  slot :error, required: false do
    attr(:class, :string, required: false)
  end

  slot(:item,
    required: false,
    doc: "Custom content for each item. Receives the item as :let binding"
  )

  attr(:field, Phoenix.HTML.FormField,
    doc:
      "A form field struct retrieved from the form, for example: @form[:country]. Automatically sets id, name, value, and errors from the form field"
  )

  attr(:errors, :list,
    default: [],
    doc: "List of error messages to display"
  )

  def combobox(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []
    raw_value = get_value(field.value)
    value = normalize_value_to_ids(assigns.collection, raw_value)
    selected_label = get_selected_label(assigns.collection, value)

    assigns
    |> assign(field: nil)
    |> assign(:errors, Enum.map(errors, &Corex.Gettext.translate_error(&1)))
    |> assign_new(:id, fn -> field.id end)
    |> assign_new(:form, fn -> field.form.id end)
    |> assign_new(:name, fn -> field.name end)
    |> assign(:value, value)
    |> assign(:selected_label, selected_label)
    |> combobox()
  end

  def combobox(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "combobox-#{System.unique_integer([:positive])}" end)
      |> assign_new(:name, fn -> "name-#{System.unique_integer([:positive])}" end)
      |> assign_new(:form, fn -> nil end)

    value = Map.get(assigns, :value, [])
    value_list = get_value(value)
    value_list = normalize_value_to_ids(assigns.collection, value_list)

    grouped_items = Enum.group_by(assigns.collection, &Map.get(&1, :group))

    has_groups =
      grouped_items
      |> Map.keys()
      |> Enum.any?(& &1)

    selected_label = get_selected_label(assigns.collection, value_list)

    assigns =
      assigns
      |> assign(:grouped_items, grouped_items)
      |> assign(:has_groups, has_groups)
      |> assign(:value, value_list)
      |> assign(:selected_label, selected_label)
      |> assign(:value_for_hidden_input, value_for_hidden_input(value_list, assigns.multiple))

    ~H"""
    <div id={@id} phx-hook="Combobox" {@rest} {Connect.props(%Props{
      id: @id, collection: @collection, controlled: @controlled, placeholder: @placeholder, value: @value, form: @form,
      always_submit_on_enter: @always_submit_on_enter, auto_focus: @auto_focus, close_on_select: @close_on_select,
      dir: @dir, input_behavior: @input_behavior, loop_focus: @loop_focus, multiple: @multiple, invalid: @invalid,
     name: @name, read_only: @read_only, required: @required,
      on_open_change: @on_open_change, on_open_change_client: @on_open_change_client, on_input_value_change: @on_input_value_change, on_value_change: @on_value_change,
      open: @open, positioning: @positioning,
      bubble: @bubble, disabled: @disabled, filter: @filter
    })}>
      <div phx-update="ignore" {Connect.root(%Root{id: @id, invalid: @invalid, read_only: @read_only})}>

        <div phx-update="ignore" :if={!Enum.empty?(@label)} {Connect.label(%Label{id: @id, invalid: @invalid, read_only: @read_only, required: @required, disabled: @disabled, dir: @dir})}>
          {render_slot(@label)}
        </div>
        <div phx-update="ignore" {Connect.control(%Control{id: @id, invalid: @invalid, open: @open, dir: @dir, disabled: @disabled})}>
          <input {Connect.input(%Input{id: @id, value: @value, selected_label: @selected_label, form: nil, invalid: @invalid, open: @open, dir: @dir, disabled: @disabled, required: @required, placeholder: @placeholder, name: nil, auto_focus: @auto_focus})} />
          <button :if={!Enum.empty?(@clear_trigger)} data-scope="combobox" data-part="clear-trigger">
            {render_slot(@clear_trigger)}
          </button>
          <button data-scope="combobox" data-part="trigger">
            {render_slot(@trigger)}
          </button>
        </div>

        <div phx-update="ignore" {Connect.positioner(%Positioner{id: @id, dir: @dir})}>
          <ul phx-update="ignore" {Connect.content(%Content{id: @id, dir: @dir, open: @open})}>
          </ul>
        </div>
      </div>
      <div :if={!Enum.empty?(@errors)} :for={msg <- @errors} data-scope="combobox" data-part="error">
        {render_slot(@error, msg)}
      </div>
      <div style="display: none;" data-templates="combobox">
        <li data-scope="combobox" data-part="empty" data-template="true">
          {render_slot(@empty)}
        </li>
        <div :if={@has_groups} :for={{group, items} <- @grouped_items} data-scope="combobox" data-part="item-group" data-id={group || "default"} data-template="true">
          <div :if={group} data-scope="combobox" data-part="item-group-label" data-id={group}>
            {group}
          </div>
          <div data-scope="combobox" data-part="item-group-content">
            <li :for={item <- items} data-scope="combobox" data-part="item" data-value={item.id} data-template="true">
              <span :if={!Enum.empty?(@item)} data-scope="combobox" data-part="item-text">
                {render_slot(@item, item)}
              </span>
              <span :if={Enum.empty?(@item)} data-scope="combobox" data-part="item-text">
                {item.label}
              </span>
              <span :if={!Enum.empty?(@item_indicator)} data-scope="combobox" data-part="item-indicator">
                {render_slot(@item_indicator)}
              </span>
            </li>
          </div>
        </div>

        <li :if={!@has_groups} :for={item <- @collection} data-scope="combobox" data-part="item" data-value={item.id} data-template="true">
          <span :if={!Enum.empty?(@item)} data-scope="combobox" data-part="item-text">
            {render_slot(@item, item)}
          </span>
          <span :if={Enum.empty?(@item)} data-scope="combobox" data-part="item-text">
            {item.label}
          </span>
          <span :if={!Enum.empty?(@item_indicator)} data-scope="combobox" data-part="item-indicator">
            {render_slot(@item_indicator)}
          </span>
        </li>
      </div>
    </div>
    """
  end

  defp get_value(field_value) do
    case field_value do
      nil -> []
      [] -> []
      value when is_list(value) -> Enum.map(value, &to_string/1)
      value -> [to_string(value)]
    end
  end

  defp normalize_value_to_ids(collection, value_list) do
    Enum.map(value_list, &resolve_value_id(collection, &1))
  end

  defp resolve_value_id(collection, val) do
    by_id = Enum.find(collection, &(&1.id == val))
    by_label = Enum.find(collection, &(&1.label == val))

    cond do
      by_id != nil -> val
      by_label != nil -> by_label.id
      true -> val
    end
  end

  defp get_selected_label(collection, value) do
    case value do
      [] ->
        nil

      _ ->
        value
        |> Enum.map(fn val ->
          collection
          |> Enum.find(&(&1.id == val))
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
  defp value_for_hidden_input(value_list, false), do: List.first(value_list)
  defp value_for_hidden_input(value_list, true), do: Enum.join(value_list, ",")
end
