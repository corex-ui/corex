defmodule CorexAdmin.UI.Filters do
  @moduledoc """
  Filter chrome: saved views, the filter row, per-filter dialogs, and overflow.

  ## Where a filter renders

  The filter row holds controls a user can operate in one gesture — a select, a
  text input, a number. Anything that needs a calendar, a slider, or two bounds
  gets a **compact trigger** on the row and opens its own dialog, because a
  calendar pinned to a toolbar makes the row jump and cannot close on outside
  click.

  | Filter | Row | Dialog |
  | ------ | --- | ------ |
  | `:select`, `:multi_select`, `:boolean`, `:presence`, `:relative_date` | Corex select (combobox past 12 options) | same, plus operators |
  | `:text`, `:id` | input with the label as placeholder | same, plus operators |
  | `:number` | number input | same, plus operators |
  | `:tags` | tags input | same |
  | `:date_range`, `:datetime_range` | summary trigger | presets and a range picker |
  | `:number_range` | summary trigger | slider and bounds |

  **More filters** holds every filter again, with operators and presets, for the
  ones not pinned to the row.
  """

  use CorexAdmin.UI

  alias CorexAdmin.State.Filters, as: State

  @combobox_threshold 12

  attr :spec, Spec, required: true
  attr :list_opts, ListOpts, required: true
  attr :canned_filters, :list, required: true

  @doc "Saved views as a select: All plus each named view."
  def views(assigns) do
    assigns =
      assigns
      |> assign(:active, List.wrap(active_view(assigns.canned_filters, assigns.list_opts)))
      |> assign(:items, view_items(assigns.canned_filters))

    ~H"""
    <.select
      id={"#{@spec.slug}-views"}
      class="select ui-size-sm admin-filter-views"
      items={@items}
      value={@active}
      on_value_change="apply_view"
      translation={%Corex.Select.Translation{placeholder: Gettext.t("All")}}
    >
      <:label class="sr-only">{Gettext.t("View")}</:label>
      <:trigger>
        <.heroicon name="hero-chevron-down" class="icon" />
      </:trigger>
    </.select>
    """
  end

  attr :spec, Spec, required: true
  attr :list_opts, ListOpts, required: true
  attr :drafts, :list, default: []
  attr :options, :map, default: %{}
  attr :bounds, :map, default: %{}

  @doc "The filter row: pinned controls, Add filter, More filters, and Clear all."
  def bar(assigns) do
    visible = visible_filters(assigns.spec, assigns.list_opts, assigns.drafts)
    hidden = hidden_filters(assigns.spec, visible)

    assigns =
      assigns
      |> assign(:visible, visible)
      |> assign(:hidden, hidden)
      |> assign(:count, active_count(assigns.list_opts))
      |> assign(:add_items, add_filter_tree(hidden))
      |> assign(:add_list, list_items(Enum.map(hidden, &{&1.label, &1.name})))
      |> assign(:searchable_add?, length(hidden) > 8)

    ~H"""
    <div
      :if={@spec.filters != []}
      id={"#{@spec.slug}-filters"}
      class="admin-filter-bar"
      aria-label={Gettext.t("Filters")}
    >
      <.row_filter
        :for={filter <- @visible}
        spec={@spec}
        filter={filter}
        list_opts={@list_opts}
        options={@options}
        bounds={@bounds}
      />
      <.menu
        :if={@hidden != [] and not @searchable_add?}
        id={"#{@spec.slug}-add-filter"}
        class="menu ui-size-sm admin-add-filter"
        items={@add_items}
        close_on_select
        loop_focus
        on_select="add_filter"
      >
        <:trigger class="button ui-size-sm">
          <.heroicon name="hero-plus" class="icon" />
          {Gettext.t("Add filter")}
        </:trigger>
      </.menu>
      <.combobox
        :if={@searchable_add?}
        id={"#{@spec.slug}-add-filter"}
        class="combobox ui-size-sm admin-add-filter"
        items={@add_list}
        on_value_change="add_filter"
        translation={%Corex.Combobox.Translation{placeholder: Gettext.t("Add filter")}}
      >
        <:label class="sr-only">{Gettext.t("Add filter")}</:label>
        <:trigger>
          <.heroicon name="hero-plus" class="icon" />
        </:trigger>
      </.combobox>
      <.more_dialog spec={@spec} list_opts={@list_opts} options={@options} bounds={@bounds} />
      <span :if={@count > 0} class="badge ui-size-sm admin-filter-count">{@count}</span>
      <.action
        :if={@count > 0}
        id={"#{@spec.slug}-clear-filters"}
        type="button"
        phx-click="reset_filters"
        class="button ui-size-sm ui-ghost ui-alert"
      >
        {Gettext.t("Clear all")}
      </.action>
    </div>
    """
  end

  attr :spec, Spec, required: true
  attr :filter, Filter, required: true
  attr :list_opts, ListOpts, required: true
  attr :options, :map, default: %{}
  attr :bounds, :map, default: %{}

  defp row_filter(assigns) do
    value = Map.get(assigns.list_opts.filters, assigns.filter.name)

    assigns =
      assigns
      |> assign(:active?, State.active?(value))
      |> assign(:value, value)

    ~H"""
    <div class={[
      "admin-filter-control",
      "admin-filter-control--#{@filter.type}",
      @active? && "admin-is-active"
    ]}>
      <.range_trigger
        :if={range_filter?(@filter)}
        spec={@spec}
        filter={@filter}
        value={@value}
        active?={@active?}
      />
      <.control
        :if={!range_filter?(@filter)}
        spec={@spec}
        filter={@filter}
        list_opts={@list_opts}
        variant={:row}
        options={@options}
        bounds={@bounds}
      />
      <.action
        :if={@filter.pin != true}
        type="button"
        phx-click="reset_filter"
        phx-value-field={Atom.to_string(@filter.name)}
        class="button ui-size-sm ui-ghost ui-trigger--square"
        aria_label={Gettext.t("Remove %{label} filter", label: @filter.label)}
      >
        <.heroicon name="hero-x-mark" class="icon" />
      </.action>
    </div>
    """
  end

  attr :spec, Spec, required: true
  attr :filter, Filter, required: true
  attr :value, :any, default: nil
  attr :active?, :boolean, default: false

  # A range needs a calendar or two bounds, so the row shows what is chosen and
  # the editing surface lives in a dialog that closes on outside click.
  defp range_trigger(assigns) do
    assigns =
      assigns
      |> assign(:summary, Labels.summary(assigns.filter, assigns.value))
      |> assign(:dialog_id, range_dialog_id(assigns.spec, assigns.filter))

    ~H"""
    <.action
      id={"#{@dialog_id}-trigger"}
      type="button"
      phx-click={Corex.Dialog.set_open(@dialog_id, true)}
      class={["button ui-size-sm admin-filter-summary", @active? && "admin-is-active"]}
    >
      <.heroicon name={range_icon(@filter)} class="icon" />
      <span class="admin-truncate">{@summary || @filter.label}</span>
    </.action>
    """
  end

  attr :spec, Spec, required: true
  attr :list_opts, ListOpts, required: true
  attr :options, :map, default: %{}
  attr :bounds, :map, default: %{}

  @doc """
  One dialog per range filter, rendered once per page.

  Kept out of the row markup so opening a dialog does not depend on which
  filters happen to be pinned.
  """
  def range_dialogs(assigns) do
    assigns = assign(assigns, :filters, Enum.filter(assigns.spec.filters, &range_filter?/1))

    ~H"""
    <.dialog
      :for={filter <- @filters}
      id={range_dialog_id(@spec, filter)}
      class="dialog admin-dialog--scroll"
      modal
    >
      <:trigger class="admin-visually-hidden">{filter.label}</:trigger>
      <:title>{filter.label}</:title>
      <:description>{range_hint(filter)}</:description>
      <:content>
        <div class="admin-filter-form">
          <.control
            spec={@spec}
            filter={filter}
            list_opts={@list_opts}
            variant={:dialog}
            id_prefix={"#{@spec.slug}-range"}
            options={@options}
            bounds={@bounds}
          />
        </div>
        <div class="admin-dialog-actions">
          <.action
            type="button"
            phx-click="reset_filter"
            phx-value-field={Atom.to_string(filter.name)}
            class="button ui-size-sm ui-ghost ui-alert"
          >
            {Gettext.t("Clear")}
          </.action>
          <.action
            type="button"
            phx-click={Corex.Dialog.set_open(range_dialog_id(@spec, filter), false)}
            class="button ui-size-sm ui-solid ui-brand"
          >
            {Gettext.t("Done")}
          </.action>
        </div>
      </:content>
    </.dialog>
    """
  end

  attr :spec, Spec, required: true
  attr :list_opts, ListOpts, required: true
  attr :options, :map, default: %{}
  attr :bounds, :map, default: %{}

  # Range filters are edited in their own dialogs, so listing them here too
  # would render every calendar and preset twice.
  defp more_dialog(assigns) do
    assigns =
      assign(assigns, :dialog_filters, Enum.reject(assigns.spec.filters, &range_filter?/1))

    ~H"""
    <.dialog
      id={"#{@spec.slug}-more-filters"}
      class="dialog admin-dialog--scroll"
      modal
    >
      <:trigger
        class="button ui-size-sm ui-trigger--square"
        aria_label={Gettext.t("More filters")}
        title={Gettext.t("More filters")}
      >
        <.heroicon name="hero-funnel" class="icon" />
        <span class="sr-only">{Gettext.t("More filters")}</span>
      </:trigger>
      <:title>{Gettext.t("Filters")}</:title>
      <:description>{Gettext.t("Apply additional filters to this list.")}</:description>
      <:content>
        <div class="admin-filter-form">
          <div :for={filter <- @dialog_filters} class="admin-filter-item">
            <.control
              spec={@spec}
              filter={filter}
              list_opts={@list_opts}
              variant={:dialog}
              id_prefix={"#{@spec.slug}-more"}
              options={@options}
              bounds={@bounds}
            />
          </div>
        </div>
        <div class="admin-dialog-actions">
          <.action
            type="button"
            phx-click="reset_filters"
            class="button ui-size-sm ui-ghost ui-alert"
          >
            {Gettext.t("Clear all")}
          </.action>
          <.action
            type="button"
            phx-click={Corex.Dialog.set_open("#{@spec.slug}-more-filters", false)}
            class="button ui-size-sm ui-solid ui-brand"
          >
            {Gettext.t("Done")}
          </.action>
        </div>
      </:content>
    </.dialog>
    """
  end

  attr :spec, Spec, required: true
  attr :filter, Filter, required: true
  attr :list_opts, ListOpts, required: true
  attr :variant, :atom, default: :row, values: [:row, :dialog]
  attr :id_prefix, :string, default: nil
  attr :options, :map, default: %{}
  attr :bounds, :map, default: %{}

  @doc """
  One filter's control.

  `variant: :row` renders the compact form for the filter row (label as
  placeholder, no operator picker). `variant: :dialog` renders the full form
  with a legend, operators, and presets.
  """
  def control(assigns) do
    filter = assigns.filter
    prefix = assigns.id_prefix || assigns.spec.slug

    assigns =
      assigns
      |> assign(:value, Map.get(assigns.list_opts.filters, filter.name))
      |> assign(:control_id, State.control_id(prefix, filter))
      |> assign(:id_base, State.control_id(prefix, filter))
      |> assign(:input_name, "filters[#{filter.name}]")
      |> assign(:row?, assigns.variant == :row)
      |> assign(:filter_options, Map.get(assigns.options, filter.name) || filter.options)
      |> assign(:filter_bounds, Map.get(assigns.bounds, filter.name) || static_bounds(filter))

    case filter.type do
      type when type in [:select, :multi_select] -> choice(assigns)
      :boolean -> boolean(assigns)
      :presence -> presence(assigns)
      :relative_date -> relative_date(assigns)
      :tags -> tags(assigns)
      :date_range -> date_range(assigns)
      :datetime_range -> datetime_range(assigns)
      :number_range -> number_range(assigns)
      :number -> number(assigns)
      _ -> text(assigns)
    end
  end

  attr :filter, Filter, required: true

  defp legend(assigns) do
    ~H"""
    <span class="admin-filter-legend">
      <span>{@filter.label}</span>
      <.action
        type="button"
        phx-click="reset_filter"
        phx-value-field={Atom.to_string(@filter.name)}
        class="button ui-size-sm ui-ghost ui-alert"
        aria_label={Gettext.t("Reset %{label}", label: @filter.label)}
      >
        {Gettext.t("Reset")}
      </.action>
    </span>
    """
  end

  defp choice(assigns) do
    ops = Filter.operators(assigns.filter)
    count = length(List.wrap(assigns.filter_options))

    assigns =
      assigns
      |> assign(:items, list_items(assigns.filter_options))
      |> assign(:selected, selected_values(State.inner_value(assigns.value)))
      |> assign(:multiple, assigns.filter.type == :multi_select)
      |> assign(:combobox?, count > @combobox_threshold)
      |> assign(:show_op?, not assigns.row? and :not_in in ops)
      |> assign(:op, membership_op(assigns.value))
      |> assign(:placeholder, placeholder(assigns))

    ~H"""
    <div class="admin-filter-stack">
      <.legend :if={!@row?} filter={@filter} />
      <.toggle_group
        :if={@show_op?}
        id={"#{@id_base}-op"}
        class="toggle-group ui-size-sm"
        deselectable={false}
        value={List.wrap(@op)}
        on_value_change="filter"
      >
        <:item value="in">{Gettext.t("Is")}</:item>
        <:item value="not_in">{Gettext.t("Is not")}</:item>
      </.toggle_group>
      <.combobox
        :if={@combobox?}
        id={@control_id}
        class="combobox ui-size-sm"
        name={@input_name}
        multiple={@multiple}
        items={@items}
        value={@selected}
        on_value_change="filter"
        translation={%Corex.Combobox.Translation{placeholder: @placeholder}}
      >
        <:label class="sr-only">{@filter.label}</:label>
        <:trigger>
          <.heroicon name="hero-chevron-down" class="icon" />
        </:trigger>
      </.combobox>
      <.select
        :if={!@combobox?}
        id={@control_id}
        class="select ui-size-sm"
        name={@input_name}
        multiple={@multiple}
        items={@items}
        value={@selected}
        on_value_change="filter"
        translation={%Corex.Select.Translation{placeholder: @placeholder}}
      >
        <:label class="sr-only">{@filter.label}</:label>
        <:trigger>
          <.heroicon name="hero-chevron-down" class="icon" />
        </:trigger>
      </.select>
    </div>
    """
  end

  defp boolean(assigns) do
    assigns
    |> assign(:items, list_items([{Gettext.t("Yes"), "true"}, {Gettext.t("No"), "false"}]))
    |> assign(:selected, selected_values(assigns.value))
    |> assign(:placeholder, placeholder(assigns))
    |> simple_select()
  end

  defp presence(assigns) do
    selected =
      case assigns.value do
        :empty -> ["empty"]
        :set -> ["set"]
        _ -> []
      end

    assigns
    |> assign(
      :items,
      list_items([{Gettext.t("Has value"), "set"}, {Gettext.t("Is empty"), "empty"}])
    )
    |> assign(:selected, selected)
    |> assign(:placeholder, placeholder(assigns))
    |> simple_select()
  end

  defp relative_date(assigns) do
    selected =
      case assigns.value do
        %{relative: window} -> [to_string(window)]
        _ -> []
      end

    windows =
      Enum.map(Filter.relative_windows(assigns.filter), fn window ->
        {Labels.window(window), window}
      end)

    assigns
    |> assign(:items, list_items(windows))
    |> assign(:selected, selected)
    |> assign(:placeholder, placeholder(assigns))
    |> simple_select()
  end

  defp simple_select(assigns) do
    ~H"""
    <div class="admin-filter-stack">
      <.legend :if={!@row?} filter={@filter} />
      <.select
        id={@control_id}
        class="select ui-size-sm"
        name={@input_name}
        items={@items}
        value={@selected}
        on_value_change="filter"
        translation={%Corex.Select.Translation{placeholder: @placeholder}}
      >
        <:label class="sr-only">{@filter.label}</:label>
        <:trigger>
          <.heroicon name="hero-chevron-down" class="icon" />
        </:trigger>
      </.select>
    </div>
    """
  end

  defp tags(assigns) do
    values =
      case State.inner_value(assigns.value) do
        list when is_list(list) -> Enum.map(list, &to_string/1)
        nil -> []
        other -> [to_string(other)]
      end

    assigns = assign(assigns, :tags, values)

    ~H"""
    <div class="admin-filter-stack">
      <.legend :if={!@row?} filter={@filter} />
      <.tags_input
        id={@control_id}
        class="tags-input ui-size-sm"
        name={@input_name}
        value={@tags}
        blur_behavior="add"
        on_value_change="filter"
      >
        <:label class="sr-only">{@filter.label}</:label>
        <:close><.heroicon name="hero-x-mark" class="icon" /></:close>
      </.tags_input>
    </div>
    """
  end

  defp date_range(assigns) do
    assigns =
      assigns
      |> assign(:picked, picker_value(assigns.value))
      |> assign(:presets, Labels.window_options())

    ~H"""
    <div class="admin-filter-date">
      <div class="admin-filter-presets">
        <.action
          :for={{label, id} <- @presets}
          type="button"
          phx-click="filter_preset"
          phx-value-field={Atom.to_string(@filter.name)}
          phx-value-preset={id}
          class="button ui-size-sm"
        >
          {label}
        </.action>
      </div>
      <.date_picker
        id={@control_id}
        class="date-picker ui-size-sm"
        selection_mode="range"
        close_on_select={false}
        value={@picked}
        on_value_change="filter"
        placeholder={@filter.label}
      >
        <:label>{Gettext.t("Custom range")}</:label>
        <:trigger>
          <.heroicon name="hero-calendar" class="icon" />
        </:trigger>
        <:prev_trigger>
          <.heroicon name="hero-chevron-left" class="icon" />
        </:prev_trigger>
        <:next_trigger>
          <.heroicon name="hero-chevron-right" class="icon" />
        </:next_trigger>
      </.date_picker>
    </div>
    """
  end

  # Corex DatePicker has no time-of-day UI, so a datetime range uses two
  # native inputs that carry both date and time.
  #
  # They sit in a form because LiveView serializes a `phx-change` input through
  # its enclosing form; a bare input has nothing to serialize and the event
  # never carries a value.
  defp datetime_range(assigns) do
    range = assigns.value || %{}

    assigns =
      assigns
      |> assign(:from, datetime_local(Map.get(range, :from)))
      |> assign(:to, datetime_local(Map.get(range, :to)))

    ~H"""
    <form id={"#{@id_base}-form"} phx-change="search" class="admin-filter-inline-form">
      <div class="admin-filter-row">
        <.native_input
          id={"#{@id_base}-from"}
          type="datetime-local"
          name={"#{@input_name}[from]"}
          value={@from}
          class="native-input ui-size-sm"
        >
          <:label>{Gettext.t("From")}</:label>
        </.native_input>
        <.native_input
          id={"#{@id_base}-to"}
          type="datetime-local"
          name={"#{@input_name}[to]"}
          value={@to}
          class="native-input ui-size-sm"
        >
          <:label>{Gettext.t("To")}</:label>
        </.native_input>
      </div>
    </form>
    """
  end

  defp number_range(assigns) do
    range = assigns.value || %{}
    bounds = assigns.filter_bounds
    min_bound = bounds && bounds.min
    max_bound = bounds && bounds.max

    assigns =
      assigns
      |> assign(:min, Map.get(range, :min))
      |> assign(:max, Map.get(range, :max))
      |> assign(:min_bound, min_bound)
      |> assign(:max_bound, max_bound)
      |> assign(:slider?, is_number(min_bound) and is_number(max_bound))
      |> assign(:slider_value, [
        Map.get(range, :min) || min_bound,
        Map.get(range, :max) || max_bound
      ])

    ~H"""
    <div class="admin-filter-stack">
      <.slider
        :if={@slider?}
        id={"#{@id_base}-slider"}
        class="slider ui-size-sm"
        min={@min_bound}
        max={@max_bound}
        value={@slider_value}
        on_value_change_end="filter"
      >
        <:label class="sr-only">{Gettext.t("Range")}</:label>
      </.slider>
      <div class="admin-filter-row admin-filter-row--nowrap">
        <.number_input
          id={"#{@id_base}-min"}
          name={"#{@input_name}[min]"}
          value={@min}
          min={@min_bound}
          max={@max_bound}
          class="number-input ui-size-sm"
          orientation="vertical"
          on_value_change="filter"
        >
          <:label>{Gettext.t("Min")}</:label>
          <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
          <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
        </.number_input>
        <.number_input
          id={"#{@id_base}-max"}
          name={"#{@input_name}[max]"}
          value={@max}
          min={@min_bound}
          max={@max_bound}
          class="number-input ui-size-sm"
          orientation="vertical"
          on_value_change="filter"
        >
          <:label>{Gettext.t("Max")}</:label>
          <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
          <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
        </.number_input>
      </div>
    </div>
    """
  end

  defp number(assigns) do
    ops = Filter.operators(assigns.filter)
    bounds = assigns.filter_bounds

    assigns =
      assigns
      |> assign(:number, State.inner_value(assigns.value))
      |> assign(:show_op?, not assigns.row? and length(ops) > 1)
      |> assign(:op, current_op(assigns.filter, assigns.value))
      |> assign(:op_items, list_items(Labels.operator_options(ops)))
      |> assign(:min_bound, bounds && bounds.min)
      |> assign(:max_bound, bounds && bounds.max)

    assigns =
      assign(
        assigns,
        :number_name,
        if(assigns.show_op?, do: "#{assigns.input_name}[value]", else: assigns.input_name)
      )

    ~H"""
    <div class="admin-filter-stack">
      <.legend :if={!@row?} filter={@filter} />
      <div class="admin-filter-operator">
        <.select
          :if={@show_op?}
          id={"#{@id_base}-op"}
          class="select ui-size-sm"
          items={@op_items}
          value={List.wrap(@op)}
          on_value_change="filter"
        >
          <:label class="sr-only">{Gettext.t("Operator")}</:label>
          <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
        </.select>
        <.number_input
          id={@control_id}
          name={@number_name}
          value={@number}
          min={@min_bound}
          max={@max_bound}
          class="number-input ui-size-sm"
          orientation="vertical"
          on_value_change="filter"
        >
          <:label class="sr-only">{@filter.label}</:label>
          <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
          <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
        </.number_input>
      </div>
    </div>
    """
  end

  defp text(assigns) do
    ops = Filter.operators(assigns.filter)

    assigns =
      assigns
      |> assign(:text, State.inner_value(assigns.value))
      |> assign(:show_op?, not assigns.row? and length(ops) > 1)
      |> assign(:op, current_op(assigns.filter, assigns.value))
      |> assign(:op_items, list_items(Labels.operator_options(ops)))

    assigns =
      assign(
        assigns,
        :text_name,
        if(assigns.show_op?, do: "#{assigns.input_name}[value]", else: assigns.input_name)
      )

    ~H"""
    <div class="admin-filter-stack">
      <.legend :if={!@row?} filter={@filter} />
      <div class="admin-filter-operator">
        <.select
          :if={@show_op?}
          id={"#{@id_base}-op"}
          class="select ui-size-sm"
          items={@op_items}
          value={List.wrap(@op)}
          on_value_change="filter"
        >
          <:label class="sr-only">{Gettext.t("Operator")}</:label>
          <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
        </.select>
        <form id={"#{@id_base}-form"} phx-change="search" class="admin-filter-inline-form">
          <.native_input
            id={@control_id}
            type="text"
            name={@text_name}
            value={@text}
            class="native-input ui-size-sm"
            placeholder={@filter.label}
            phx-debounce="400"
          >
            <:label class="sr-only">{@filter.label}</:label>
          </.native_input>
        </form>
      </div>
    </div>
    """
  end

  @doc "Whether a filter is edited in its own dialog rather than on the row."
  @spec range_filter?(Filter.t()) :: boolean()
  def range_filter?(%Filter{type: type}) do
    type in [:date_range, :datetime_range, :number_range]
  end

  @doc "Dialog id for a range filter."
  @spec range_dialog_id(Spec.t(), Filter.t()) :: String.t()
  def range_dialog_id(%Spec{slug: slug}, %Filter{name: name}), do: "#{slug}-range-#{name}"

  defp range_icon(%Filter{type: :number_range}), do: "hero-adjustments-horizontal"
  defp range_icon(_filter), do: "hero-calendar"

  defp range_hint(%Filter{type: :number_range}), do: CorexAdmin.Gettext.t("Choose a range.")
  defp range_hint(_filter), do: CorexAdmin.Gettext.t("Pick a preset or a custom range.")

  defp static_bounds(%Filter{min: min, max: max}) when is_number(min) and is_number(max) do
    %{min: min, max: max}
  end

  defp static_bounds(_), do: nil

  defp placeholder(%{row?: true, filter: filter}), do: filter.label
  defp placeholder(_assigns), do: CorexAdmin.Gettext.t("Any")

  defp visible_filters(%Spec{} = spec, %ListOpts{} = list_opts, drafts) do
    drafted = MapSet.new(Enum.map(List.wrap(drafts), &draft_name/1))

    Enum.filter(spec.filters, fn %Filter{} = filter ->
      filter.pin == true or
        Map.has_key?(list_opts.filters, filter.name) or
        MapSet.member?(drafted, filter.name)
    end)
  end

  defp hidden_filters(%Spec{} = spec, visible) do
    names = MapSet.new(visible, & &1.name)
    Enum.reject(spec.filters, &MapSet.member?(names, &1.name))
  end

  defp add_filter_tree(filters) do
    Corex.Tree.new(
      Enum.map(filters, fn %Filter{} = filter ->
        %{value: Atom.to_string(filter.name), label: filter.label}
      end)
    )
  end

  defp view_items(canned) do
    named =
      canned
      |> Enum.with_index()
      |> Enum.map(fn {entry, index} -> {view_label(entry), Integer.to_string(index)} end)

    list_items([{Gettext.t("All"), "all"} | named])
  end

  defp view_label({label, _params}) when is_binary(label), do: label
  defp view_label(%{label: label}) when is_binary(label), do: label
  defp view_label(_), do: Gettext.t("View")

  # A view is "active" when its filter params equal the current ones.
  defp active_view(canned, %ListOpts{} = list_opts) do
    current = Map.get(ListOpts.to_params(list_opts), "filters", %{})

    canned
    |> Enum.with_index()
    |> Enum.find_value("all", fn {entry, index} ->
      params =
        case entry do
          {_label, map} when is_map(map) -> map
          %{params: map} when is_map(map) -> map
          _ -> %{}
        end

      if deep_stringify(Map.get(deep_stringify(params), "filters", %{})) ==
           deep_stringify(current) do
        Integer.to_string(index)
      end
    end)
  end

  defp deep_stringify(map) when is_map(map) and not is_struct(map) do
    Map.new(map, fn {key, value} -> {to_string(key), deep_stringify(value)} end)
  end

  defp deep_stringify(list) when is_list(list), do: Enum.map(list, &deep_stringify/1)
  defp deep_stringify(other), do: other

  # Draft names come from client events, so only existing atoms are accepted.
  defp draft_name(name) when is_atom(name), do: name

  defp draft_name(name) when is_binary(name) do
    String.to_existing_atom(name)
  rescue
    ArgumentError -> nil
  end

  defp draft_name(_), do: nil

  defp active_count(%ListOpts{} = opts) do
    search = if CorexAdmin.Params.blank?(opts.search), do: 0, else: 1
    search + Enum.count(opts.filters, fn {_name, value} -> State.active?(value) end)
  end

  defp selected_values(nil), do: []
  defp selected_values(list) when is_list(list), do: Enum.map(list, &to_string/1)
  defp selected_values(true), do: ["true"]
  defp selected_values(false), do: ["false"]
  defp selected_values(value), do: [to_string(value)]

  defp membership_op(%{op: :not_in}), do: "not_in"
  defp membership_op(%{op: "not_in"}), do: "not_in"
  defp membership_op(_), do: "in"

  defp current_op(filter, value) do
    case State.operator(filter, value) do
      nil -> nil
      op -> Atom.to_string(op)
    end
  end

  defp picker_value(nil), do: nil

  defp picker_value(range) when is_map(range) do
    [Map.get(range, :from), Map.get(range, :to)]
    |> Enum.reject(&is_nil/1)
    |> Enum.map_join(",", &iso/1)
    |> case do
      "" -> nil
      joined -> joined
    end
  end

  defp picker_value(_), do: nil

  defp datetime_local(nil), do: nil
  defp datetime_local(%DateTime{} = dt), do: Calendar.strftime(dt, "%Y-%m-%dT%H:%M")
  defp datetime_local(%NaiveDateTime{} = dt), do: Calendar.strftime(dt, "%Y-%m-%dT%H:%M")
  defp datetime_local(other), do: to_string(other)

  defp iso(%Date{} = date), do: Date.to_iso8601(date)
  defp iso(%DateTime{} = dt), do: DateTime.to_iso8601(dt)
  defp iso(%NaiveDateTime{} = dt), do: NaiveDateTime.to_iso8601(dt)
  defp iso(other), do: to_string(other)
end
