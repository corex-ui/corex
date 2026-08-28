defmodule CorexAdmin.Live.Components do
  @moduledoc false

  use Phoenix.Component
  use Corex

  alias CorexAdmin.Gettext
  alias CorexAdmin.ListOpts
  alias CorexAdmin.Live.Helpers
  alias CorexAdmin.Resource.Field
  alias CorexAdmin.Resource.Filter
  alias CorexAdmin.Resource.Spec
  alias Phoenix.LiveView.JS

  slot(:inner_block, required: true)

  def shell(assigns) do
    ~H"""
    <div class="admin-stack admin-stack--lg">
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:socket, :any, required: true)

  def mobile_nav(assigns) do
    ~H"""
    <.collapsible id="admin-nav-mobile" class="collapsible admin-mobile-menu">
      <:trigger>
        <.heroicon name="hero-bars-3" />
        <span class="sr-only">{Gettext.t("Open admin navigation")}</span>
      </:trigger>
      <:content>
        <.nav_tree socket={@socket} id="admin-nav-tree-mobile" />
      </:content>
    </.collapsible>
    """
  end

  attr(:socket, :any, required: true)
  attr(:id, :string, required: true)
  attr(:class, :string, default: "tree-view navigation max-w-xs aside-nav-tree")

  def nav_tree(assigns) do
    grouped = Helpers.grouped_resources(assigns.socket)
    request_path = Helpers.current_path(assigns.socket)
    items = nav_tree_items(assigns.socket, grouped)
    current_to = longest_matching_to(request_path, nav_leaf_tos(items))

    expanded = Enum.map(grouped, fn {group, _} -> "group:#{group}" end)

    assigns =
      assigns
      |> assign(:items, items)
      |> assign(:selected, List.wrap(current_to))
      |> assign(:expanded, expanded)
      |> assign(:current_to, current_to)
      |> assign(:hub_title, Helpers.hub_title(assigns.socket))

    ~H"""
    <.tree_view
      id={@id}
      class={@class}
      redirect
      value={@selected}
      expanded_value={@expanded}
      items={@items}
    >
      <:label>{@hub_title}</:label>
      <:branch :let={branch}>
        <span class="admin-truncate">{branch.label}</span>
      </:branch>
      <:item :let={item}>
        <span
          class={["admin-truncate", item.to == @current_to && "admin-nav-current"]}
          data-current={if(item.to == @current_to, do: "")}
        >
          {item.label}
        </span>
      </:item>
      <:branch_indicator>
        <.heroicon name="hero-chevron-right" class="icon" />
      </:branch_indicator>
    </.tree_view>
    """
  end

  attr(:prefix, :string, required: true)
  attr(:spec, Spec, default: nil)
  attr(:live_action, :atom, default: :index)
  attr(:record, :any, default: nil)
  attr(:hub_title, :string, default: "Admin")

  def breadcrumbs(assigns) do
    ~H"""
    <nav
      :if={@live_action in [:show, :new, :edit]}
      aria-label={Gettext.t("Breadcrumb")}
      class="admin-crumbs"
    >
      <ol class="admin-crumbs-list">
        <li>
          <.navigate to={@prefix} class="admin-crumb-link">{@hub_title}</.navigate>
        </li>
        <li :if={@spec} class="admin-crumbs-item">
          <.heroicon name="hero-chevron-right" class="icon ui-size-sm" />
          <.navigate
            :if={@live_action != :index}
            to={Path.join(@prefix, @spec.slug)}
            class="admin-crumb-link"
          >
            {@spec.label}
          </.navigate>
        </li>
        <li :if={@live_action == :new} class="admin-crumbs-item">
          <.heroicon name="hero-chevron-right" class="icon ui-size-sm" />
          <span class="admin-crumb-current">{Gettext.t("New")}</span>
        </li>
        <li :if={@live_action == :show and @record} class="admin-crumbs-item">
          <.heroicon name="hero-chevron-right" class="icon ui-size-sm" />
          <span class="admin-crumb-current">{Helpers.record_title(@spec, @record)}</span>
        </li>
        <li :if={@live_action == :edit and @record} class="admin-crumbs-item">
          <.heroicon name="hero-chevron-right" class="icon ui-size-sm" />
          <.navigate
            to={Path.join([@prefix, @spec.slug, Helpers.record_id(@spec, @record)])}
            class="admin-crumb-link"
          >
            {Helpers.record_title(@spec, @record)}
          </.navigate>
        </li>
        <li :if={@live_action == :edit and @record} class="admin-crumbs-item">
          <.heroicon name="hero-chevron-right" class="icon ui-size-sm" />
          <span class="admin-crumb-current">{Gettext.t("Edit")}</span>
        </li>
      </ol>
    </nav>
    """
  end

  attr(:field, Field, required: true)
  attr(:record, :any, required: true)

  def field_value(assigns) do
    CorexAdmin.Field.display(assigns)
  end

  def field_input(assigns) do
    CorexAdmin.Field.input(assigns)
  end

  def format_value(field, record), do: CorexAdmin.Field.format(field, record)

  def embed_show(assigns), do: CorexAdmin.Field.Renderer.embed_show(assigns)

  attr(:spec, Spec, required: true)
  attr(:list_opts, ListOpts, required: true)
  attr(:canned_filters, :list, required: true)

  def filter_views(assigns) do
    active = active_view_value(assigns.canned_filters, assigns.list_opts)
    assigns = assign(assigns, :active, active)

    ~H"""
    <.toggle_group
      id={"#{@spec.slug}-views"}
      class="toggle-group ui-size-sm admin-filter-views"
      deselectable={false}
      value={List.wrap(@active)}
      on_value_change="apply_view"
    >
      <:item value="all">{Gettext.t("All")}</:item>
      <:item
        :for={{{label, _params}, index} <- Enum.with_index(@canned_filters)}
        value={Integer.to_string(index)}
      >
        {label}
      </:item>
    </.toggle_group>
    """
  end

  attr(:spec, Spec, required: true)
  attr(:list_opts, ListOpts, required: true)
  attr(:drafts, :list, default: [])
  attr(:focus, :string, default: nil)

  def filter_bar(assigns) do
    visible = visible_filters(assigns.spec, assigns.list_opts, assigns.drafts)
    hidden = hidden_filters(assigns.spec, visible)
    chips = active_chips(assigns.spec, assigns.list_opts)
    count = filter_badge_count(assigns.list_opts)
    focus = assigns[:focus]

    assigns =
      assigns
      |> assign(:visible, visible)
      |> assign(:hidden, hidden)
      |> assign(:chips, chips)
      |> assign(:count, count)
      |> assign(:add_items, add_filter_items(hidden))
      |> assign(:add_list, add_filter_list(hidden))
      |> assign(:searchable_add?, length(hidden) > 8)
      |> assign(:focus, if(is_binary(focus), do: focus))

    ~H"""
    <div
      :if={@spec.filters != []}
      id={"#{@spec.slug}-filters"}
      class="admin-filter-bar admin-chips"
      aria-label={Gettext.t("Filters")}
    >
      <.filter_pill
        :for={{filter, index} <- Enum.with_index(@visible)}
        spec={@spec}
        filter={filter}
        list_opts={@list_opts}
        chip={Enum.find(@chips, &(&1.field == Atom.to_string(filter.name)))}
        open={
          to_string(filter.name) == @focus or
            (index == 0 and @spec.filters_open and @focus in [nil, ""])
        }
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
      <span :if={@count > 0} class="badge ui-size-sm ui-trigger--square">{@count}</span>
      <.action
        :if={@count > 0}
        type="button"
        phx-click="reset_filters"
        class="button ui-size-sm ui-ghost ui-alert"
      >
        {Gettext.t("Clear all")}
      </.action>
    </div>
    """
  end

  attr(:spec, Spec, required: true)
  attr(:filter, Filter, required: true)
  attr(:list_opts, ListOpts, required: true)
  attr(:chip, :map, default: nil)
  attr(:open, :boolean, default: false)

  defp filter_pill(assigns) do
    ~H"""
    <div class={["admin-filter-pill-wrap", @chip && "admin-is-active"]}>
      <.collapsible
        id={"#{@spec.slug}-filter-pill-#{@filter.name}"}
        class="collapsible admin-filter-pill"
        open={@open}
      >
        <:trigger>
          <span :if={@chip} class="admin-filter-pill-label">
            {@chip.label}: {@chip.text}
          </span>
          <span :if={!@chip} class="admin-filter-pill-label">{@filter.label}</span>
        </:trigger>
        <:closed>
          <.heroicon name="hero-chevron-down" />
        </:closed>
        <:content>
          <.filter_control spec={@spec} filter={@filter} list_opts={@list_opts} />
        </:content>
      </.collapsible>
      <.action
        :if={@chip}
        type="button"
        phx-click="clear_filter"
        phx-value-field={@chip.field}
        class="button ui-size-sm ui-ghost ui-trigger--square"
        aria_label={Gettext.t("Clear %{label}", label: @filter.label)}
      >
        <.heroicon name="hero-x-mark" />
      </.action>
    </div>
    """
  end

  attr(:spec, Spec, required: true)
  attr(:filter, Filter, required: true)
  attr(:list_opts, ListOpts, required: true)

  def filter_control(assigns) do
    value = Map.get(assigns.list_opts.filters, assigns.filter.name)
    slug = assigns.spec.slug
    name = assigns.filter.name

    assigns =
      assigns
      |> assign(:value, value)
      |> assign(:control_id, "#{slug}-filter-#{name}")
      |> assign(:input_name, "filters[#{name}]")

    case assigns.filter.type do
      type when type in [:select, :multi_select, :boolean] ->
        filter_select(assigns)

      :date_range ->
        filter_date_range(assigns)

      :datetime_range ->
        filter_datetime_range(assigns)

      :number_range ->
        filter_number_range(assigns)

      :number ->
        filter_number(assigns)

      :presence ->
        filter_presence(assigns)

      :tags ->
        filter_tags(assigns)

      :relative_date ->
        filter_relative_date(assigns)

      type when type in [:text, :id] ->
        filter_text(assigns)

      _ ->
        filter_text(assigns)
    end
  end

  attr(:spec, Spec, required: true)
  attr(:list_opts, ListOpts, required: true)

  def filter_chips(assigns) do
    chips = active_chips(assigns.spec, assigns.list_opts)
    assigns = assign(assigns, :chips, chips)

    ~H"""
    <div :if={@chips != []} class="admin-chips">
      <span :for={chip <- @chips} class="badge ui-size-sm">
        {chip.label}: {chip.text}
        <.action
          type="button"
          phx-click="clear_filter"
          phx-value-field={chip.field}
          class="button ui-size-sm ui-ghost ui-trigger--square"
          aria_label={Gettext.t("Clear %{label}", label: chip.label)}
        >
          <.heroicon name="hero-x-mark" />
        </.action>
      </span>
    </div>
    """
  end

  attr(:id, :string, required: true)
  attr(:spec, Spec, required: true)
  attr(:record, :any, required: true)
  attr(:trigger, :atom, default: :icon, values: [:icon, :labeled, :hidden])

  def delete_dialog(assigns) do
    ~H"""
    <.dialog
      id={@id}
      class="dialog"
      role="alertdialog"
      modal
      close_on_interact_outside={false}
      initial_focus={"#{@id}-cancel"}
      final_focus={"dialog:#{@id}:trigger"}
    >
      <:trigger
        class={delete_trigger_class(@trigger)}
        aria_label={Gettext.t("Delete %{label}", label: @spec.label)}
      >
        <.heroicon :if={@trigger != :labeled} name="hero-trash" />
        <span :if={@trigger == :labeled}>{Gettext.t("Delete")}</span>
        <span :if={@trigger == :hidden} class="admin-visually-hidden">{Gettext.t("Delete")}</span>
      </:trigger>
      <:title>{Gettext.t("Delete %{label}?", label: @spec.label)}</:title>
      <:description>{Gettext.t("This action cannot be undone.")}</:description>
      <:content>
        <div class="admin-dialog-actions">
          <.action
            id={"#{@id}-cancel"}
            phx-click={Corex.Dialog.set_open(@id, false)}
            class="button ui-size-sm"
          >
            {Gettext.t("Cancel")}
          </.action>
          <.action
            id={"#{@id}-confirm"}
            phx-click={
              Corex.Dialog.set_open(@id, false)
              |> JS.push("delete", value: %{id: Helpers.record_id(@spec, @record)})
            }
            class="button ui-size-sm ui-solid ui-alert"
          >
            {Gettext.t("Delete")}
          </.action>
        </div>
      </:content>
    </.dialog>
    """
  end

  attr(:id, :string, required: true)
  attr(:spec, Spec, required: true)
  attr(:count, :integer, required: true)

  def bulk_delete_dialog(assigns) do
    ~H"""
    <.dialog
      id={@id}
      class="dialog"
      role="alertdialog"
      modal
      close_on_interact_outside={false}
      initial_focus={"#{@id}-cancel"}
      final_focus={"dialog:#{@id}:trigger"}
    >
      <:trigger
        class="button ui-size-sm ui-solid ui-alert"
        aria_label={Gettext.t("Delete selected %{label}", label: @spec.label)}
      >
        <.heroicon name="hero-trash" /> {Gettext.t("Delete selected")}
      </:trigger>
      <:title>{Gettext.t("Delete %{count} %{label}?", count: @count, label: @spec.label)}</:title>
      <:description>
        {Gettext.t("This action cannot be undone. Each record is authorized separately.")}
      </:description>
      <:content>
        <div class="admin-dialog-actions">
          <.action
            id={"#{@id}-cancel"}
            phx-click={Corex.Dialog.set_open(@id, false)}
            class="button ui-size-sm"
          >
            {Gettext.t("Cancel")}
          </.action>
          <.action
            id={"#{@id}-confirm"}
            phx-click={Corex.Dialog.set_open(@id, false) |> JS.push("bulk_delete")}
            class="button ui-size-sm ui-solid ui-alert"
          >
            {Gettext.t("Delete selected")}
          </.action>
        </div>
      </:content>
    </.dialog>
    """
  end

  attr(:spec, Spec, required: true)
  attr(:token, :string, default: nil)
  attr(:fields, :list, required: true)
  attr(:action, :string, required: true)

  def export_dialog(assigns) do
    assigns = assign(assigns, :csrf, Plug.CSRFProtection.get_csrf_token())

    ~H"""
    <.dialog id={"#{@spec.slug}-export"} class="dialog" modal>
      <:trigger class="admin-visually-hidden">{Gettext.t("Export")}</:trigger>
      <:title>{Gettext.t("Export %{label}", label: @spec.label)}</:title>
      <:description>{Gettext.t("Download the current list as CSV or JSON.")}</:description>
      <:content>
        <form
          id={"#{@spec.slug}-export-form"}
          action={@action}
          method="post"
          class="admin-form"
        >
          <input type="hidden" name="_csrf_token" value={@csrf} />
          <input type="hidden" name="token" value={@token} />
          <.native_input
            id={"#{@spec.slug}-export-format"}
            type="select"
            name="format"
            value="csv"
            options={[{Gettext.t("CSV"), "csv"}, {Gettext.t("JSON"), "json"}]}
            class="native-input"
          >
            <:label>{Gettext.t("Format")}</:label>
          </.native_input>
          <fieldset class="admin-export-fields">
            <legend>{Gettext.t("Fields")}</legend>
            <label
              :for={field <- @fields}
              class="admin-export-field"
            >
              <input
                id={"#{@spec.slug}-export-field-#{field.name}"}
                type="checkbox"
                name="fields[]"
                value={Atom.to_string(field.name)}
                checked
              />
              {field.label}
            </label>
          </fieldset>
          <div class="admin-dialog-actions">
            <.action
              type="button"
              phx-click={Corex.Dialog.set_open("#{@spec.slug}-export", false)}
              class="button ui-size-sm"
            >
              {Gettext.t("Cancel")}
            </.action>
            <.action
              type="submit"
              phx-click={Corex.Dialog.set_open("#{@spec.slug}-export", false)}
              class="button ui-size-sm ui-solid ui-brand"
            >
              {Gettext.t("Download")}
            </.action>
          </div>
        </form>
      </:content>
    </.dialog>
    """
  end

  def icon_tooltip(assigns) do
    ~H"""
    <.tooltip id={@id} class="tooltip" show_arrow={false}>
      <:trigger>
        {render_slot(@inner_block)}
      </:trigger>
      <:content>{@label}</:content>
    </.tooltip>
    """
  end

  attr(:filter, Filter, required: true)

  defp filter_legend(assigns) do
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

  defp filter_select(assigns) do
    option_count = length(List.wrap(assigns.filter.options))

    cond do
      assigns.filter.type == :boolean ->
        filter_toggle(assigns)

      assigns.filter.type in [:select, :multi_select] and option_count > 12 ->
        filter_combobox(assigns)

      true ->
        filter_select_dropdown(assigns)
    end
  end

  defp filter_select_dropdown(assigns) do
    assigns =
      assigns
      |> assign(:items, list_items(assigns.filter.options))
      |> assign(:selected, select_value(unwrap_membership(assigns.value)))
      |> assign(:multiple, assigns.filter.type == :multi_select)
      |> assign(:show_op?, :not_in in Filter.operators(assigns.filter))
      |> assign(:membership_op, membership_op(assigns.filter, assigns.value))

    ~H"""
    <div class="admin-filter-stack">
      <.filter_legend filter={@filter} />
      <.toggle_group
        :if={@show_op?}
        id={"#{@control_id}-op"}
        class="toggle-group ui-size-sm"
        deselectable={false}
        value={List.wrap(@membership_op)}
        on_value_change="filter"
      >
        <:item value="in">{Gettext.t("Is")}</:item>
        <:item value="not_in">{Gettext.t("Is not")}</:item>
      </.toggle_group>
      <.select
        id={@control_id}
        class="select ui-size-sm"
        name={@input_name}
        multiple={@multiple}
        items={@items}
        value={@selected}
        on_value_change="filter"
        translation={%Corex.Select.Translation{placeholder: Gettext.t("Any")}}
      >
        <:label class="sr-only">{@filter.label}</:label>
        <:trigger>
          <.heroicon name="hero-chevron-down" />
        </:trigger>
      </.select>
    </div>
    """
  end

  defp filter_toggle(assigns) do
    {options, multiple} =
      case assigns.filter.type do
        :boolean ->
          {[%{label: Gettext.t("Yes"), value: "true"}, %{label: Gettext.t("No"), value: "false"}],
           false}

        :multi_select ->
          {option_maps(assigns.filter.options), true}

        _ ->
          {option_maps(assigns.filter.options), false}
      end

    assigns =
      assigns
      |> assign(:options, options)
      |> assign(:multiple, multiple)
      |> assign(:selected, select_value(assigns.value))

    ~H"""
    <div class="admin-filter-stack">
      <.filter_legend filter={@filter} />
      <.toggle_group
        id={@control_id}
        class="toggle-group ui-size-sm"
        multiple={@multiple}
        deselectable
        value={@selected}
        on_value_change="filter"
      >
        <:item :for={opt <- @options} value={opt.value}>{opt.label}</:item>
      </.toggle_group>
    </div>
    """
  end

  defp filter_combobox(assigns) do
    assigns =
      assigns
      |> assign(:items, list_items(assigns.filter.options))
      |> assign(:selected, select_value(unwrap_membership(assigns.value)))
      |> assign(:multiple, assigns.filter.type == :multi_select)

    ~H"""
    <.combobox
      id={@control_id}
      class="combobox ui-size-sm"
      name={@input_name}
      multiple={@multiple}
      items={@items}
      value={@selected}
      on_value_change="filter"
    >
      <:label>
        <.filter_legend filter={@filter} />
      </:label>
      <:trigger>
        <.heroicon name="hero-chevron-down" />
      </:trigger>
    </.combobox>
    """
  end

  defp filter_date_range(assigns) do
    assigns =
      assigns
      |> assign(:picked, date_picker_value(assigns.value))
      |> assign(:presets, date_presets())

    ~H"""
    <div class="admin-filter-date">
      <.filter_legend filter={@filter} />
      <div class="admin-filter-presets">
        <.action
          :for={preset <- @presets}
          type="button"
          phx-click="filter_preset"
          phx-value-field={Atom.to_string(@filter.name)}
          phx-value-preset={preset.id}
          class="button ui-size-sm"
        >
          {preset.label}
        </.action>
      </div>
      <.date_picker
        id={@control_id}
        class="date-picker ui-size-sm"
        selection_mode="range"
        close_on_select={false}
        value={@picked}
        on_value_change="filter"
      >
        <:label>{Gettext.t("Custom")}</:label>
        <:trigger>
          <.heroicon name="hero-calendar" />
        </:trigger>
        <:prev_trigger>
          <.heroicon name="hero-chevron-left" />
        </:prev_trigger>
        <:next_trigger>
          <.heroicon name="hero-chevron-right" />
        </:next_trigger>
      </.date_picker>
    </div>
    """
  end

  defp filter_datetime_range(assigns) do
    range = assigns.value || %{}

    assigns =
      assigns
      |> assign(:from, datetime_local(Map.get(range, :from)))
      |> assign(:to, datetime_local(Map.get(range, :to)))

    ~H"""
    <div class="admin-filter-stack">
      <.filter_legend filter={@filter} />
      <div class="admin-filter-row">
        <.native_input
          id={"#{@control_id}-from"}
          type="datetime-local"
          name={"#{@input_name}[from]"}
          value={@from}
          class="native-input ui-size-sm"
          phx-change="search"
        >
          <:label>{Gettext.t("From")}</:label>
        </.native_input>
        <.native_input
          id={"#{@control_id}-to"}
          type="datetime-local"
          name={"#{@input_name}[to]"}
          value={@to}
          class="native-input ui-size-sm"
          phx-change="search"
        >
          <:label>{Gettext.t("To")}</:label>
        </.native_input>
      </div>
    </div>
    """
  end

  defp filter_number_range(assigns) do
    range = assigns.value || %{}
    min_bound = assigns.filter.min
    max_bound = assigns.filter.max
    slider? = is_number(min_bound) and is_number(max_bound)

    slider_value =
      if slider? do
        [
          Map.get(range, :min) || min_bound,
          Map.get(range, :max) || max_bound
        ]
      end

    assigns =
      assigns
      |> assign(:min, Map.get(range, :min))
      |> assign(:max, Map.get(range, :max))
      |> assign(:slider?, slider?)
      |> assign(:min_bound, min_bound)
      |> assign(:max_bound, max_bound)
      |> assign(:slider_value, slider_value)

    ~H"""
    <div class="admin-filter-stack">
      <.filter_legend filter={@filter} />
      <.slider
        :if={@slider?}
        id={"#{@control_id}-slider"}
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
          id={"#{@control_id}-min"}
          name={"#{@input_name}[min]"}
          value={@min}
          min={@min_bound}
          max={@max_bound}
          class="number-input ui-size-sm"
          orientation="vertical"
          on_value_change="filter"
        >
          <:label>{Gettext.t("Min")}</:label>
          <:decrement_trigger>
            <.heroicon name="hero-chevron-down" class="icon" />
          </:decrement_trigger>
          <:increment_trigger>
            <.heroicon name="hero-chevron-up" class="icon" />
          </:increment_trigger>
        </.number_input>
        <.number_input
          id={"#{@control_id}-max"}
          name={"#{@input_name}[max]"}
          value={@max}
          min={@min_bound}
          max={@max_bound}
          class="number-input ui-size-sm"
          orientation="vertical"
          on_value_change="filter"
        >
          <:label>{Gettext.t("Max")}</:label>
          <:decrement_trigger>
            <.heroicon name="hero-chevron-down" class="icon" />
          </:decrement_trigger>
          <:increment_trigger>
            <.heroicon name="hero-chevron-up" class="icon" />
          </:increment_trigger>
        </.number_input>
      </div>
    </div>
    """
  end

  defp filter_text(assigns) do
    ops = Filter.operators(assigns.filter)
    show_op? = length(ops) > 1
    op = current_op(assigns.filter, assigns.value)

    text =
      case assigns.value do
        %{contains: value} -> value
        %{op: _, value: value} -> value
        %{op: _} -> nil
        other -> other
      end

    assigns =
      assigns
      |> assign(:text, text)
      |> assign(:show_op?, show_op?)
      |> assign(:op, op && Atom.to_string(op))
      |> assign(:op_items, operator_items(ops))
      |> assign(
        :text_name,
        if(show_op?, do: "#{assigns.input_name}[value]", else: assigns.input_name)
      )

    ~H"""
    <div class="admin-filter-stack">
      <.filter_legend filter={@filter} />
      <div class="admin-filter-operator">
        <.select
          :if={@show_op?}
          id={"#{@control_id}-op"}
          class="select ui-size-sm"
          items={@op_items}
          value={List.wrap(@op)}
          on_value_change="filter"
        >
          <:label class="sr-only">{Gettext.t("Operator")}</:label>
          <:trigger>
            <.heroicon name="hero-chevron-down" />
          </:trigger>
        </.select>
        <.native_input
          id={@control_id}
          type="text"
          name={@text_name}
          value={@text}
          class="native-input ui-size-sm"
          phx-change="search"
          phx-debounce="400"
        >
          <:label class="sr-only">{@filter.label}</:label>
        </.native_input>
      </div>
    </div>
    """
  end

  defp filter_number(assigns) do
    ops = Filter.operators(assigns.filter)
    op = current_op(assigns.filter, assigns.value)

    number =
      case assigns.value do
        %{op: _, value: value} -> value
        %{op: _} -> nil
        value when is_number(value) -> value
        _ -> nil
      end

    assigns =
      assigns
      |> assign(:number, number)
      |> assign(:op, op && Atom.to_string(op))
      |> assign(:op_items, operator_items(ops))
      |> assign(:min_bound, assigns.filter.min)
      |> assign(:max_bound, assigns.filter.max)

    ~H"""
    <div class="admin-filter-stack">
      <.filter_legend filter={@filter} />
      <div class="admin-filter-operator">
        <.select
          id={"#{@control_id}-op"}
          class="select ui-size-sm"
          items={@op_items}
          value={List.wrap(@op)}
          on_value_change="filter"
        >
          <:label class="sr-only">{Gettext.t("Operator")}</:label>
          <:trigger>
            <.heroicon name="hero-chevron-down" />
          </:trigger>
        </.select>
        <.number_input
          id={@control_id}
          name={"#{@input_name}[value]"}
          value={@number}
          min={@min_bound}
          max={@max_bound}
          class="number-input ui-size-sm"
          orientation="vertical"
          on_value_change="filter"
        >
          <:label class="sr-only">{@filter.label}</:label>
          <:decrement_trigger>
            <.heroicon name="hero-chevron-down" class="icon" />
          </:decrement_trigger>
          <:increment_trigger>
            <.heroicon name="hero-chevron-up" class="icon" />
          </:increment_trigger>
        </.number_input>
      </div>
    </div>
    """
  end

  defp filter_relative_date(assigns) do
    selected =
      case assigns.value do
        %{relative: window} -> [to_string(window)]
        _ -> []
      end

    assigns =
      assigns
      |> assign(:selected, selected)
      |> assign(:windows, Filter.relative_windows(assigns.filter))

    ~H"""
    <div class="admin-filter-stack">
      <.filter_legend filter={@filter} />
      <.toggle_group
        id={@control_id}
        class="toggle-group ui-size-sm admin-filter-windows"
        deselectable
        value={@selected}
        on_value_change="filter"
      >
        <:item :for={window <- @windows} value={Atom.to_string(window)}>
          {relative_label(window)}
        </:item>
      </.toggle_group>
    </div>
    """
  end

  defp filter_presence(assigns) do
    selected =
      case assigns.value do
        :empty -> ["empty"]
        :set -> ["set"]
        _ -> []
      end

    assigns = assign(assigns, :selected, selected)

    ~H"""
    <div class="admin-filter-stack">
      <.filter_legend filter={@filter} />
      <.toggle_group
        id={@control_id}
        class="toggle-group ui-size-sm"
        deselectable
        value={@selected}
        on_value_change="filter"
      >
        <:item value="set">{Gettext.t("Has value")}</:item>
        <:item value="empty">{Gettext.t("Is empty")}</:item>
      </.toggle_group>
    </div>
    """
  end

  defp filter_tags(assigns) do
    values =
      case assigns.value do
        list when is_list(list) -> Enum.map(list, &to_string/1)
        _ -> []
      end

    assigns = assign(assigns, :tags, values)

    ~H"""
    <.tags_input
      id={@control_id}
      class="tags-input ui-size-sm"
      name={@input_name}
      value={@tags}
      blur_behavior="add"
      on_value_change="filter"
    >
      <:label>
        <.filter_legend filter={@filter} />
      </:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  defp nav_tree_items(socket, grouped) do
    home = Helpers.home_path(socket)

    home_item = %{
      label: Helpers.hub_title(socket),
      value: home,
      to: home,
      redirect: :navigate
    }

    group_items =
      Enum.map(grouped, fn {group, resources} ->
        %{
          label: group,
          value: "group:#{group}",
          children:
            Enum.map(resources, fn resource ->
              spec = Helpers.spec(resource)
              path = Helpers.resource_path(socket, spec)

              %{
                label: spec.label,
                value: path,
                to: path,
                redirect: :navigate
              }
            end)
        }
      end)

    Corex.Tree.new([home_item | group_items])
  end

  defp nav_leaf_tos(items) do
    Enum.flat_map(List.wrap(items), &leaf_tos/1)
  end

  defp leaf_tos(%{children: children} = node) when is_list(children) and children != [] do
    nested = Enum.flat_map(children, &leaf_tos/1)

    case Map.get(node, :to) do
      to when is_binary(to) -> nested ++ [to]
      _ -> nested
    end
  end

  defp leaf_tos(%{to: to}) when is_binary(to), do: [to]
  defp leaf_tos(_), do: []

  defp longest_matching_to(path, tos) when is_binary(path) do
    tos
    |> Enum.filter(fn to ->
      is_binary(to) and (path == to or String.starts_with?(path, to <> "/"))
    end)
    |> Enum.max_by(&String.length/1, fn -> nil end)
  end

  defp longest_matching_to(_path, _tos), do: nil

  defp date_presets do
    Enum.map(Filter.relative_window_ids(), fn id ->
      %{id: Atom.to_string(id), label: relative_label(id)}
    end)
  end

  defp list_items(options) when is_list(options) do
    Corex.List.new(
      Enum.map(options, fn
        {label, value} -> %{label: to_string(label), value: to_string(value)}
        value -> %{label: to_string(value), value: to_string(value)}
      end)
    )
  end

  defp list_items(_), do: Corex.List.new([])

  defp option_maps(options) when is_list(options) do
    Enum.map(options, fn
      {label, value} -> %{label: to_string(label), value: to_string(value)}
      value -> %{label: to_string(value), value: to_string(value)}
    end)
  end

  defp option_maps(_), do: []

  defp delete_trigger_class(:labeled), do: "button ui-solid ui-alert"
  defp delete_trigger_class(:hidden), do: "admin-visually-hidden"
  defp delete_trigger_class(_), do: "button ui-size-sm ui-solid ui-alert ui-trigger--square"

  defp select_value(nil), do: []
  defp select_value(list) when is_list(list), do: Enum.map(list, &to_string/1)
  defp select_value(true), do: ["true"]
  defp select_value(false), do: ["false"]
  defp select_value(value), do: [to_string(value)]

  defp date_picker_value(nil), do: nil

  defp date_picker_value(range) when is_map(range) do
    [Map.get(range, :from), Map.get(range, :to)]
    |> Enum.reject(&is_nil/1)
    |> Enum.map_join(",", &iso/1)
    |> case do
      "" -> nil
      joined -> joined
    end
  end

  defp datetime_local(nil), do: nil
  defp datetime_local(%DateTime{} = dt), do: Calendar.strftime(dt, "%Y-%m-%dT%H:%M")
  defp datetime_local(%NaiveDateTime{} = dt), do: Calendar.strftime(dt, "%Y-%m-%dT%H:%M")
  defp datetime_local(other), do: to_string(other)

  defp iso(%Date{} = date), do: Date.to_iso8601(date)
  defp iso(%DateTime{} = dt), do: DateTime.to_iso8601(dt)
  defp iso(%NaiveDateTime{} = dt), do: NaiveDateTime.to_iso8601(dt)
  defp iso(other), do: to_string(other)

  defp active_chips(%Spec{} = spec, %ListOpts{} = opts) do
    search_chip =
      if opts.search not in [nil, ""] do
        [%{field: "q", label: Gettext.t("Search"), text: opts.search}]
      else
        []
      end

    filter_chips =
      Enum.flat_map(spec.filters, fn %Filter{} = filter ->
        case Map.get(opts.filters, filter.name) do
          value ->
            if Filter.active_value?(value) do
              [
                %{
                  field: Atom.to_string(filter.name),
                  label: filter.label,
                  text: chip_text(value)
                }
              ]
            else
              []
            end
        end
      end)

    search_chip ++ filter_chips
  end

  defp chip_text(value) when is_list(value), do: Enum.join(value, ", ")
  defp chip_text(true), do: Gettext.t("Yes")
  defp chip_text(false), do: Gettext.t("No")
  defp chip_text(:empty), do: Gettext.t("empty")
  defp chip_text(:set), do: Gettext.t("set")
  defp chip_text(%{contains: value}), do: to_string(value)
  defp chip_text(%{relative: window}), do: relative_label(window)

  defp chip_text(%{op: :not_in, value: value}),
    do: Gettext.t("not %{value}", value: chip_text(value))

  defp chip_text(%{op: :contains, value: value}), do: to_string(value)
  defp chip_text(%{op: :equals, value: value}), do: "= #{value}"
  defp chip_text(%{op: :eq, value: value}), do: "= #{value}"
  defp chip_text(%{op: :gte, value: value}), do: "≥ #{value}"
  defp chip_text(%{op: :lte, value: value}), do: "≤ #{value}"

  defp chip_text(%{op: :starts_with, value: value}),
    do: Gettext.t("starts %{value}", value: value)

  defp chip_text(%{op: :ends_with, value: value}), do: Gettext.t("ends %{value}", value: value)
  defp chip_text(%{op: :not_contains, value: value}), do: Gettext.t("not %{value}", value: value)
  defp chip_text(%{op: _, value: value}), do: chip_text(value)
  defp chip_text(%{op: _}), do: ""

  defp chip_text(%{from: from, to: to}), do: "#{iso(from)} – #{iso(to)}"
  defp chip_text(%{from: from}), do: "from #{iso(from)}"
  defp chip_text(%{to: to}), do: "to #{iso(to)}"
  defp chip_text(%{min: min, max: max}), do: "#{min} – #{max}"
  defp chip_text(%{min: min}), do: "≥ #{min}"
  defp chip_text(%{max: max}), do: "≤ #{max}"
  defp chip_text(value), do: to_string(value)

  defp visible_filters(%Spec{} = spec, %ListOpts{} = list_opts, drafts) do
    drafted = MapSet.new(Enum.map(List.wrap(drafts), &draft_name/1))

    Enum.filter(spec.filters, fn %Filter{} = filter ->
      filter.pin == true or
        Map.has_key?(list_opts.filters, filter.name) or
        MapSet.member?(drafted, filter.name)
    end)
  end

  defp hidden_filters(%Spec{} = spec, visible) do
    names = MapSet.new(Enum.map(visible, & &1.name))
    Enum.reject(spec.filters, &MapSet.member?(names, &1.name))
  end

  defp add_filter_items(filters) do
    Corex.Tree.new(
      Enum.map(filters, fn %Filter{} = filter ->
        %{value: Atom.to_string(filter.name), label: filter.label}
      end)
    )
  end

  defp add_filter_list(filters) do
    list_items(Enum.map(filters, fn %Filter{} = filter -> {filter.label, filter.name} end))
  end

  defp draft_name(name) when is_atom(name), do: name

  defp draft_name(name) when is_binary(name) do
    try do
      String.to_existing_atom(name)
    rescue
      ArgumentError -> nil
    end
  end

  defp draft_name(_), do: nil

  defp filter_badge_count(%ListOpts{} = opts) do
    search = if opts.search not in [nil, ""], do: 1, else: 0
    active = Enum.count(opts.filters, fn {_name, value} -> Filter.active_value?(value) end)
    search + active
  end

  defp active_view_value(canned, %ListOpts{} = list_opts) do
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

      if view_filters(params) == stringify_keys_deep(current) do
        Integer.to_string(index)
      end
    end)
  end

  defp view_filters(params) do
    params
    |> stringify_keys_deep()
    |> Map.get("filters", %{})
  end

  defp stringify_keys_deep(map) when is_map(map) do
    Map.new(map, fn {key, value} ->
      {to_string(key), stringify_keys_deep(value)}
    end)
  end

  defp stringify_keys_deep(list) when is_list(list), do: Enum.map(list, &stringify_keys_deep/1)
  defp stringify_keys_deep(other), do: other

  defp unwrap_membership(%{op: _, value: value}), do: value
  defp unwrap_membership(%{op: _}), do: nil
  defp unwrap_membership(value), do: value

  defp current_op(_filter, %{op: op}) when is_atom(op), do: op

  defp current_op(filter, %{op: op}) when is_binary(op) do
    case Filter.parse_atom(op) do
      nil -> Filter.default_operator(filter)
      atom -> atom
    end
  end

  defp current_op(filter, _), do: Filter.default_operator(filter)

  defp membership_op(_filter, %{op: :not_in}), do: "not_in"
  defp membership_op(_filter, %{op: "not_in"}), do: "not_in"
  defp membership_op(_filter, _), do: "in"

  defp operator_items(ops) do
    list_items(Enum.map(ops, fn op -> {operator_label(op), Atom.to_string(op)} end))
  end

  defp operator_label(:contains), do: Gettext.t("Contains")
  defp operator_label(:equals), do: Gettext.t("Is")
  defp operator_label(:starts_with), do: Gettext.t("Starts with")
  defp operator_label(:ends_with), do: Gettext.t("Ends with")
  defp operator_label(:not_contains), do: Gettext.t("Does not contain")
  defp operator_label(:in), do: Gettext.t("Is")
  defp operator_label(:not_in), do: Gettext.t("Is not")
  defp operator_label(:eq), do: Gettext.t("Equals")
  defp operator_label(:gte), do: Gettext.t("At least")
  defp operator_label(:lte), do: Gettext.t("At most")
  defp operator_label(op), do: Phoenix.Naming.humanize(to_string(op))

  defp relative_label(window) when is_binary(window) do
    case Filter.parse_atom(window) do
      nil -> Phoenix.Naming.humanize(window)
      atom -> relative_label(atom)
    end
  end

  defp relative_label(:today), do: Gettext.t("Today")
  defp relative_label(:yesterday), do: Gettext.t("Yesterday")
  defp relative_label(:last_7), do: Gettext.t("Last 7 days")
  defp relative_label(:last_30), do: Gettext.t("Last 30 days")
  defp relative_label(:last_90), do: Gettext.t("Last 90 days")
  defp relative_label(:this_week), do: Gettext.t("This week")
  defp relative_label(:this_month), do: Gettext.t("This month")
  defp relative_label(:this_quarter), do: Gettext.t("This quarter")
  defp relative_label(:ytd), do: Gettext.t("YTD")
  defp relative_label(other), do: Phoenix.Naming.humanize(to_string(other))
end
