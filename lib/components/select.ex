defmodule Corex.Select do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Select](https://zagjs.com/components/react/select).

  ## Examples
  <!-- tabs-open -->

  ### Minimal

  This example assumes the import of `.icon` from `Core Components`, you are free to replace it

  ```heex
  <.select
    id="my-select"
    class="select"
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
    <:trigger>
      <.icon name="hero-chevron-down" />
    </:trigger>
  </.select>
  ```

  ### Grouped

  This example assumes the import of `.icon` from `Core Components`, you are free to replace it

  ```heex
  <.select
    class="select"
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
    <:trigger>
      <.icon name="hero-chevron-down" />
    </:trigger>
  </.select>
  ```

    ### Custom

  This example requires the installation of [Flagpack](https://hex.pm/packages/flagpack) to display the use of custom item rendering.
  This example assumes the import of `.icon` from `Core Components`, you are free to replace it

  ```heex
  <.select
    class="select"
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
    <:label>
      Country of residence
    </:label>
    <:item :let={item}>
      <Flagpack.flag name={String.to_atom(item.id)} />
      {item.label}
    </:item>
    <:trigger>
      <.icon name="hero-chevron-down" />
    </:trigger>
    <:item_indicator>
      <.icon name="hero-check" />
    </:item_indicator>
  </.select>
  ```

  ### Custom Grouped

  This example requires the installation of [Flagpack](https://hex.pm/packages/flagpack) to display the use of custom item rendering.
  This example assumes the import of `.icon` from `Core Components`, you are free to replace it

  ```heex
  <.select
    class="select"
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
    <:item :let={item}>
      <Flagpack.flag name={String.to_atom(item.id)} />
      {item.label}
    </:item>
    <:trigger>
      <.icon name="hero-chevron-down" />
    </:trigger>
    <:item_indicator>
      <.icon name="hero-check" />
    </:item_indicator>
  </.select>
  ```

  <!-- tabs-close -->

  ## Phoenix Form Integration

  When using with Phoenix forms, you must add an id to the form using the `Corex.Form.get_form_id/1` function.

  ### Controller

  ```heex
  <.form :let={f} for={@changeset} id={get_form_id(@changeset)}>
     <.select
    class="select"
    field={f[:country]}
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
    <:label>
      Your country of residence
    </:label>
    <:trigger>
      <.icon name="hero-chevron-down" />
    </:trigger>
    <:error :let={msg}>
      <.icon name="hero-exclamation-circle" class="icon" />
      {msg}
    </:error>
  </.select>
    <button type="submit">Submit</button>
  </.form>
  ```


  ### Live View

  When using Phoenix form in a Live view you must also add controlled mode. This allows the Live view to be the source of truth and the component to be in sync accordingly

  ```heex
  <.form for={@form} id={get_form_id(@form)} phx-change="validate" phx-submit="save">
     <.select
          class="select"
          field={@form[:country]}
          controlled
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
          <:label>
            Your country of residence
          </:label>
          <:trigger>
            <.icon name="hero-chevron-down" />
          </:trigger>
          <:error :let={msg}>
            <.icon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
        </.select>
  </.form>
  ```

  The `field` attribute automatically handles:
  - Setting the `id` from the form field
  - Setting the `name` for form submission
  - Mapping the form value to the `select` value
  - Displaying validation errors
  - Integration with Phoenix changesets

  ## API Control

  ```heex
  # Client-side
  <button phx-click={Corex.Select.set_value("my-select", "fra")}>
    Check
  </button>

  <button phx-click={Corex.Select.toggle_value("my-select")}>
    Toggle
  </button>

  # Server-side
  def handle_event("set_value", _, socket) do
    {:noreply, Corex.Select.set_value(socket, "my-select", "fra")}
  end
  ```

  ## Styling

  Use data attributes to target elements:
  - `[data-scope="select"][data-part="root"]` - Label wrapper
  - `[data-scope="select"][data-part="control"]` - Select control
  - `[data-scope="select"][data-part="label"]` - Label text
  - `[data-scope="select"][data-part="input"]` - Hidden input
  - `[data-scope="select"][data-part="error"]` - Error message

  State-specific styling:
  - `[data-state="open"]` - When select is open
  - `[data-state="closed"]` - When select is closed
  - `[data-disabled]` - When select is disabled
  - `[data-readonly]` - When select is read-only
  - `[data-invalid]` - When select has validation errors

  If you wish to use the default Corex styling, you can use the class `select` on the component.
  This requires to install mix corex.design first and import the component css file.

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/select.css";
  ```

  You can then use modifiers

  ```heex
  <.select class="select select--accent select--lg">
  ```

  Learn more about modifiers and [Corex Design](https://corex-ui.com/components/select#modifiers)

  '''

  use Phoenix.Component
  alias Corex.Select.Connect
  alias Corex.Select.Anatomy.{Props, Root, Label, Control, Positioner, Content}

  attr(:id, :string, required: false)
  attr(:collection, :list, default: [])
  attr(:controlled, :boolean, default: false, doc: "Whether the select is controlled")
  attr(:placeholder, :string, default: nil, doc: "The placeholder of the select")
  attr(:value, :list, default: [], doc: "The value of the select")
  attr(:disabled, :boolean, default: false, doc: "Whether the select is disabled")
  attr(:close_on_select, :boolean, default: true, doc: "Whether to close the select on select")
  attr(:dir, :string, default: "ltr", doc: "The direction of the select")
  attr(:loop_focus, :boolean, default: false, doc: "Whether to loop focus the select")
  attr(:multiple, :boolean, default: false, doc: "Whether to allow multiple selection")
  attr(:invalid, :boolean, default: false, doc: "Whether the select is invalid")
  attr(:name, :string, doc: "The name of the select")
  attr(:form, :string, doc: "The id of the form of the select")
  attr(:read_only, :boolean, default: false, doc: "Whether the select is read only")
  attr(:required, :boolean, default: false, doc: "Whether the select is required")
  attr(:prompt, :string, default: nil, doc: "the prompt for select inputs")

  attr(:on_value_change, :string,
    default: nil,
    doc: "The server event name to trigger on value change"
  )

  attr(:on_value_change_client, :string,
    default: nil,
    doc: "The client event name to trigger on value change"
  )

  attr(:bubble, :boolean, default: false, doc: "Whether the client events are bubbled")

  attr(:positioning, Corex.Positioning,
    default: %Corex.Positioning{},
    doc: "Positioning options for the dropdown"
  )

  attr(:rest, :global)

  slot(:label, required: false, doc: "The label content")
  slot(:trigger, required: true, doc: "The trigger button content")
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

  def select(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []
    value = get_value(field.value)
    selected_label = get_selected_label(assigns.collection, value)

    assigns
    |> assign(field: nil)
    |> assign(:errors, Enum.map(errors, &Corex.Gettext.translate_error(&1)))
    |> assign_new(:id, fn -> field.id end)
    |> assign_new(:form, fn -> field.form.id end)
    |> assign_new(:name, fn -> field.name end)
    |> assign(:value, value)
    |> assign(:selected_label, selected_label)
    |> select()
  end

  def select(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "select-#{System.unique_integer([:positive])}" end)
      |> assign_new(:name, fn -> "name-#{System.unique_integer([:positive])}" end)
      |> assign_new(:form, fn -> nil end)

    value = Map.get(assigns, :value, [])

    value_list = get_value(value)
    selected_label = get_selected_label(assigns.collection, value_list)

    assigns = assign(assigns, :selected_label, selected_label)

    options = transform_collection_to_options(assigns.collection)

    grouped_items = Enum.group_by(assigns.collection, &Map.get(&1, :group))

    has_groups =
      grouped_items
      |> Map.keys()
      |> Enum.any?(& &1)

    selected_for_options =
      if assigns.multiple do
        value_list
      else
        if value_list == [], do: "", else: List.first(value_list)
      end

    options_with_prompt = [{"", ""} | options]

    assigns =
      assigns
      |> assign(:grouped_items, grouped_items)
      |> assign(:has_groups, has_groups)
      |> assign(:options, options)
      |> assign(:options_with_prompt, options_with_prompt)
      |> assign(:selected_for_options, selected_for_options)
      |> assign(:disabled_values, get_disabled_values(assigns.collection))
      |> assign(:value_for_hidden_input, value_for_hidden_input(value_list, assigns.multiple))

    ~H"""
    <div id={@id} phx-hook="Select" {@rest} {Connect.props(%Props{
      id: @id, collection: @collection, controlled: @controlled, placeholder: @placeholder, value: @value,
      disabled: @disabled, close_on_select: @close_on_select, dir: @dir, loop_focus: @loop_focus,
      multiple: @multiple, invalid: @invalid, name: @name, form: @form, read_only: @read_only,
      required: @required, on_value_change: @on_value_change, on_value_change_client: @on_value_change_client,
      bubble: @bubble, positioning: @positioning
    })}>
      <div {Connect.root(%Root{id: @id, changed: if(@__changed__, do: true, else: false), invalid: @invalid, read_only: @read_only})}>

      <input type="hidden" name={@name} form={@form} id={"#{@id}-value"} data-scope="select" data-part="value-input" value={@value_for_hidden_input} />

      <select multiple={@multiple} data-scope="select" data-part="hidden-select" aria-hidden="true" tabindex="-1" style="border:0;clip:rect(0 0 0 0);height:1px;margin:-1px;overflow:hidden;padding:0;position:absolute;width:1px;white-space:nowrap;word-wrap:normal;">
        <%= Phoenix.HTML.Form.options_for_select(
          @options_with_prompt,
          @selected_for_options,
          disabled: @disabled_values
        ) %>
      </select>

        <div :if={!Enum.empty?(@label)} {Connect.label(%Label{id: @id, changed: if(@__changed__, do: true, else: false), invalid: @invalid, read_only: @read_only, required: @required, disabled: @disabled, dir: @dir})}>
          {render_slot(@label)}
        </div>
        <div {Connect.control(%Control{id: @id, changed: Map.get(assigns, :__changed__, nil) != nil, invalid: @invalid, dir: @dir, disabled: @disabled})}>
          <button :if={!Enum.empty?(@trigger)} data-scope="select" data-part="trigger">
            <span data-scope="select" data-part="item-text">
              {if @selected_label do @selected_label else @placeholder end}
            </span>
            {render_slot(@trigger)}
          </button>
        </div>
        <div :if={!Enum.empty?(@errors)} :for={msg <- @errors} data-scope="select" data-part="error">
          {render_slot(@error, msg)}
        </div>
        <div {Connect.positioner(%Positioner{id: @id, changed: Map.get(assigns, :__changed__, nil) != nil, dir: @dir})}>
          <ul {Connect.content(%Content{id: @id, changed: Map.get(assigns, :__changed__, nil) != nil, dir: @dir})}>
          </ul>

          <div style="display: none;" data-templates="select">
            <div :if={@has_groups} :for={{group, items} <- @grouped_items} data-scope="select" data-part="item-group" data-id={group || "default"} data-template="true">
              <div :if={group} data-scope="select" data-part="item-group-label" data-id={group}>
                {group}
              </div>
              <li :for={item <- items} data-scope="select" data-part="item" data-value={item.id} data-template="true">
                <span :if={!Enum.empty?(@item)} data-scope="select" data-part="item-text">
                  {render_slot(@item, item)}
                </span>
                <span :if={Enum.empty?(@item)} data-scope="select" data-part="item-text">
                  {item.label}
                </span>
                <span :if={!Enum.empty?(@item_indicator)} data-scope="select" data-part="item-indicator">
                  {render_slot(@item_indicator)}
                </span>
              </li>
            </div>

            <li :if={!@has_groups} :for={item <- @collection} data-scope="select" data-part="item" data-value={item.id} data-template="true">
              <span :if={!Enum.empty?(@item)} data-scope="select" data-part="item-text">
                {render_slot(@item, item)}
              </span>
              <span :if={Enum.empty?(@item)} data-scope="select" data-part="item-text">
                {item.label}
              </span>
              <span :if={!Enum.empty?(@item_indicator)} data-scope="select" data-part="item-indicator">
                {render_slot(@item_indicator)}
              </span>
            </li>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp get_disabled_values(collection) do
    collection
    |> Enum.filter(&Map.get(&1, :disabled, false))
    |> Enum.map(& &1.id)
  end

  defp value_for_hidden_input(value_list, _multiple) when value_list == [], do: ""
  defp value_for_hidden_input(value_list, false), do: List.first(value_list)
  defp value_for_hidden_input(value_list, true), do: Enum.join(value_list, ",")

  defp transform_collection_to_options(collection) do
    grouped = Enum.group_by(collection, &Map.get(&1, :group))

    case Map.keys(grouped) do
      [nil] ->
        Enum.map(collection, fn item ->
          {item.label, item.id}
        end)

      _ ->
        grouped
        |> Enum.sort_by(fn {group, _} -> group || "" end)
        |> Enum.flat_map(fn
          {nil, items} ->
            Enum.map(items, fn item -> {item.label, item.id} end)

          {group, items} ->
            [{group, Enum.map(items, fn item -> {item.label, item.id} end)}]
        end)
    end
  end

  defp get_value(field_value) do
    case field_value do
      nil -> []
      [] -> []
      value when is_list(value) -> Enum.map(value, &to_string/1)
      value -> [to_string(value)]
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
end
