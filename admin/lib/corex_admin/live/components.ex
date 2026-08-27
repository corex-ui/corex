defmodule CorexAdmin.Live.Components do
  @moduledoc false

  use Phoenix.Component
  use Corex

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
        <span class="sr-only">Open admin navigation</span>
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
      |> assign(:selected, [request_path])
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
      aria-label="Breadcrumb"
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
          <span class="admin-crumb-current">New</span>
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
          <span class="admin-crumb-current">Edit</span>
        </li>
      </ol>
    </nav>
    """
  end

  attr(:field, Field, required: true)
  attr(:record, :any, required: true)

  def field_value(assigns) do
    formatted = format_value(assigns.field, assigns.record)

    assigns =
      assigns
      |> assign(:formatted, formatted)
      |> assign(:badge, select_badge_class(assigns.field, assigns.record))

    ~H"""
    <span :if={@badge} class={@badge}>{@formatted}</span>
    <span :if={!@badge} class="admin-cell" title={@formatted}>{@formatted}</span>
    """
  end

  attr(:field, Field, required: true)
  attr(:form, :any, required: true)

  def field_input(%{field: %Field{type: :select}} = assigns) do
    assigns =
      assigns
      |> assign(:items, list_items(assigns.field.options))
      |> assign(:tip_id, field_error_id(assigns.form, assigns.field))

    ~H"""
    <.select
      field={@form[@field.name]}
      class="select"
      items={@items}
      auto_invalid
    >
      <:label>{@field.label}</:label>
      <:trigger>
        <.heroicon name="hero-chevron-down" />
      </:trigger>
      <:error :let={msg} class="admin-field-error">
        <.field_error_tip id={@tip_id} msg={msg} />
      </:error>
    </.select>
    """
  end

  def field_input(%{field: %Field{type: :date}} = assigns) do
    assigns = assign(assigns, :tip_id, field_error_id(assigns.form, assigns.field))

    ~H"""
    <.date_picker
      field={@form[@field.name]}
      class="date-picker"
      auto_invalid
    >
      <:label>{@field.label}</:label>
      <:trigger>
        <.heroicon name="hero-calendar" />
      </:trigger>
      <:prev_trigger>
        <.heroicon name="hero-chevron-left" />
      </:prev_trigger>
      <:next_trigger>
        <.heroicon name="hero-chevron-right" />
      </:next_trigger>
      <:error :let={msg} class="admin-field-error">
        <.field_error_tip id={@tip_id} msg={msg} />
      </:error>
    </.date_picker>
    """
  end

  def field_input(%{field: %Field{type: :number}} = assigns) do
    assigns = assign(assigns, :tip_id, field_error_id(assigns.form, assigns.field))

    ~H"""
    <.number_input
      field={@form[@field.name]}
      class="number-input"
      orientation="vertical"
      auto_invalid
    >
      <:label>{@field.label}</:label>
      <:decrement_trigger>
        <.heroicon name="hero-chevron-down" class="icon" />
      </:decrement_trigger>
      <:increment_trigger>
        <.heroicon name="hero-chevron-up" class="icon" />
      </:increment_trigger>
      <:error :let={msg} class="admin-field-error">
        <.field_error_tip id={@tip_id} msg={msg} />
      </:error>
    </.number_input>
    """
  end

  def field_input(%{field: %Field{type: :embeds_many}} = assigns) do
    ~H"""
    <.nested_fields field={@form[@field.name]} class="nested-fields">
      <:label>{@field.label}</:label>
      <:empty>No {@field.label} yet.</:empty>
      <:col :let={nested} :for={child <- @field.fields} label={child.label}>
        <.field_input field={child} form={nested} />
      </:col>
      <:add_trigger>Add {@field.label}</:add_trigger>
      <:remove_trigger>
        <.heroicon name="hero-trash" class="icon" />
      </:remove_trigger>
    </.nested_fields>
    """
  end

  def field_input(%{field: %Field{type: :boolean}} = assigns) do
    assigns = assign(assigns, :tip_id, field_error_id(assigns.form, assigns.field))

    ~H"""
    <.switch field={@form[@field.name]} class="switch" auto_invalid>
      <:label>{@field.label}</:label>
      <:error :let={msg} class="admin-field-error">
        <.field_error_tip id={@tip_id} msg={msg} />
      </:error>
    </.switch>
    """
  end

  def field_input(%{field: %Field{type: :password}} = assigns) do
    assigns = assign(assigns, :tip_id, field_error_id(assigns.form, assigns.field))

    ~H"""
    <.password_input
      field={@form[@field.name]}
      class="password-input"
      value=""
      auto_invalid
    >
      <:label>{@field.label}</:label>
      <:error :let={msg} class="admin-field-error">
        <.field_error_tip id={@tip_id} msg={msg} />
      </:error>
    </.password_input>
    """
  end

  def field_input(%{field: %Field{type: :datetime}} = assigns) do
    assigns = assign(assigns, :tip_id, field_error_id(assigns.form, assigns.field))

    ~H"""
    <.native_input
      type="datetime-local"
      field={@form[@field.name]}
      class="native-input"
      auto_invalid
    >
      <:label>{@field.label}</:label>
      <:error :let={msg} class="admin-field-error">
        <.field_error_tip id={@tip_id} msg={msg} />
      </:error>
    </.native_input>
    """
  end

  def field_input(assigns) do
    assigns = assign(assigns, :tip_id, field_error_id(assigns.form, assigns.field))

    ~H"""
    <.native_input
      type={native_type(@field.type)}
      field={@form[@field.name]}
      class="native-input"
      auto_invalid
    >
      <:label>{@field.label}</:label>
      <:error :let={msg} class="admin-field-error">
        <.field_error_tip id={@tip_id} msg={msg} />
      </:error>
    </.native_input>
    """
  end

  attr(:spec, Spec, required: true)
  attr(:filter, Filter, required: true)
  attr(:list_opts, ListOpts, required: true)

  def filter_control(assigns) do
    value = Map.get(assigns.list_opts.filters, assigns.filter.field)
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
    <div class="admin-chips">
      <span :for={chip <- @chips} class="badge ui-size-sm">
        {chip.label}: {chip.text}
        <.action
          type="button"
          phx-click="clear_filter"
          phx-value-field={chip.field}
          class="button ui-size-sm ui-ghost ui-trigger--square"
          aria_label={"Clear #{chip.label}"}
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
        aria_label={"Delete #{@spec.label}"}
      >
        <.heroicon :if={@trigger != :labeled} name="hero-trash" />
        <span :if={@trigger == :labeled}>Delete</span>
        <span :if={@trigger == :hidden} class="admin-visually-hidden">Delete</span>
      </:trigger>
      <:title>Delete {@spec.label}?</:title>
      <:description>This action cannot be undone.</:description>
      <:content>
        <div class="admin-dialog-actions">
          <.action
            id={"#{@id}-cancel"}
            phx-click={Corex.Dialog.set_open(@id, false)}
            class="button ui-size-sm"
          >
            Cancel
          </.action>
          <.action
            id={"#{@id}-confirm"}
            phx-click={
              Corex.Dialog.set_open(@id, false)
              |> JS.push("delete", value: %{id: Helpers.record_id(@spec, @record)})
            }
            class="button ui-size-sm ui-solid ui-alert"
          >
            Delete
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
        aria_label={"Delete selected #{@spec.label}"}
      >
        <.heroicon name="hero-trash" /> Delete selected
      </:trigger>
      <:title>Delete {@count} {@spec.label}?</:title>
      <:description>This action cannot be undone. Each record is authorized separately.</:description>
      <:content>
        <div class="admin-dialog-actions">
          <.action
            id={"#{@id}-cancel"}
            phx-click={Corex.Dialog.set_open(@id, false)}
            class="button ui-size-sm"
          >
            Cancel
          </.action>
          <.action
            id={"#{@id}-confirm"}
            phx-click={Corex.Dialog.set_open(@id, false) |> JS.push("bulk_delete")}
            class="button ui-size-sm ui-solid ui-alert"
          >
            Delete selected
          </.action>
        </div>
      </:content>
    </.dialog>
    """
  end

  attr(:id, :string, required: true)
  attr(:label, :string, required: true)
  slot(:inner_block, required: true)

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
        phx-value-field={Atom.to_string(@filter.field)}
        class="button ui-size-sm ui-ghost ui-alert"
        aria_label={"Reset #{@filter.label}"}
      >
        Reset
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
      |> assign(:selected, select_value(assigns.value))
      |> assign(:multiple, assigns.filter.type == :multi_select)

    ~H"""
    <.select
      id={@control_id}
      class="select ui-size-sm"
      name={@input_name}
      multiple={@multiple}
      items={@items}
      value={@selected}
      on_value_change="filter"
      translation={%Corex.Select.Translation{placeholder: "Any"}}
    >
      <:label>
        <.filter_legend filter={@filter} />
      </:label>
      <:trigger>
        <.heroicon name="hero-chevron-down" />
      </:trigger>
    </.select>
    """
  end

  defp filter_toggle(assigns) do
    {options, multiple} =
      case assigns.filter.type do
        :boolean ->
          {[%{label: "Yes", value: "true"}, %{label: "No", value: "false"}], false}

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
      |> assign(:selected, select_value(assigns.value))
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
        <:label>Custom</:label>
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
          <:label>From</:label>
        </.native_input>
        <.native_input
          id={"#{@control_id}-to"}
          type="datetime-local"
          name={"#{@input_name}[to]"}
          value={@to}
          class="native-input ui-size-sm"
          phx-change="search"
        >
          <:label>To</:label>
        </.native_input>
      </div>
    </div>
    """
  end

  defp filter_number_range(assigns) do
    range = assigns.value || %{}

    assigns =
      assigns
      |> assign(:min, Map.get(range, :min))
      |> assign(:max, Map.get(range, :max))

    ~H"""
    <div class="admin-filter-stack">
      <.filter_legend filter={@filter} />
      <div class="admin-filter-row admin-filter-row--nowrap">
        <.number_input
          id={"#{@control_id}-min"}
          name={"#{@input_name}[min]"}
          value={@min}
          class="number-input ui-size-sm"
          orientation="vertical"
          on_value_change="filter"
        >
          <:label>Min</:label>
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
          class="number-input ui-size-sm"
          orientation="vertical"
          on_value_change="filter"
        >
          <:label>Max</:label>
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
    ~H"""
    <.native_input
      id={@control_id}
      type="text"
      name={@input_name}
      value={@value}
      class="native-input ui-size-sm"
      phx-change="search"
      phx-debounce="400"
    >
      <:label>
        <.filter_legend filter={@filter} />
      </:label>
    </.native_input>
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
    [
      %{id: "today", label: "Today"},
      %{id: "last_7", label: "Last 7 days"},
      %{id: "last_30", label: "Last 30 days"},
      %{id: "this_month", label: "This month"},
      %{id: "ytd", label: "YTD"}
    ]
  end

  attr(:id, :string, required: true)
  attr(:msg, :string, required: true)

  defp field_error_tip(assigns) do
    ~H"""
    <.tooltip
      id={@id}
      class="tooltip ui-size-sm"
      positioning={%Corex.Positioning{placement: "top-end"}}
    >
      <:trigger>
        <.heroicon name="hero-exclamation-circle" class="icon" />
      </:trigger>
      <:content>{@msg}</:content>
    </.tooltip>
    """
  end

  defp field_error_id(form, %Field{name: name}) do
    base =
      cond do
        is_binary(form.id) and form.id != "" -> form.id
        is_binary(form.name) and form.name != "" -> form.name
        true -> "field"
      end

    "#{base}-#{name}-error-tip"
  end

  defp native_type(:id), do: "text"
  defp native_type(:text), do: "text"
  defp native_type(:textarea), do: "textarea"
  defp native_type(:email), do: "email"
  defp native_type(:password), do: "password"
  defp native_type(:url), do: "url"
  defp native_type(_), do: "text"

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

  defp select_badge_class(%Field{type: :select, name: name}, record) do
    case Map.get(record, name) do
      "done" -> "badge ui-success ui-size-sm"
      "open" -> "badge ui-info ui-size-sm"
      value when value not in [nil, ""] -> "badge ui-size-sm"
      _ -> nil
    end
  end

  defp select_badge_class(_, _), do: nil

  defp active_chips(%Spec{} = spec, %ListOpts{} = opts) do
    search_chip =
      if opts.search not in [nil, ""] do
        [%{field: "q", label: "Search", text: opts.search}]
      else
        []
      end

    filter_chips =
      Enum.flat_map(spec.filters, fn %Filter{} = filter ->
        case Map.get(opts.filters, filter.field) do
          nil ->
            []

          value ->
            [%{field: Atom.to_string(filter.field), label: filter.label, text: chip_text(value)}]
        end
      end)

    search_chip ++ filter_chips
  end

  defp chip_text(value) when is_list(value), do: Enum.join(value, ", ")
  defp chip_text(true), do: "Yes"
  defp chip_text(false), do: "No"

  defp chip_text(%{from: from, to: to}), do: "#{iso(from)} – #{iso(to)}"
  defp chip_text(%{from: from}), do: "from #{iso(from)}"
  defp chip_text(%{to: to}), do: "to #{iso(to)}"
  defp chip_text(%{min: min, max: max}), do: "#{min} – #{max}"
  defp chip_text(%{min: min}), do: "≥ #{min}"
  defp chip_text(%{max: max}), do: "≤ #{max}"
  defp chip_text(value), do: to_string(value)

  def format_value(%Field{redact: true}, _record), do: "••••"

  def format_value(%Field{type: :embeds_many, name: name, fields: children}, record) do
    case Map.get(record, name) do
      list when is_list(list) and list != [] ->
        Enum.map_join(list, "; ", &embed_row_text(&1, children))

      _ ->
        "—"
    end
  end

  def format_value(%Field{name: name, type: type}, record) do
    case Map.get(record, name) do
      nil -> "—"
      true -> "Yes"
      false -> "No"
      %Date{} = date -> Date.to_iso8601(date)
      %DateTime{} = dt -> Calendar.strftime(dt, "%Y-%m-%d %H:%M")
      %NaiveDateTime{} = dt -> NaiveDateTime.to_iso8601(dt)
      _value when type == :password -> "••••"
      value when is_binary(value) -> value
      value when is_integer(value) or is_float(value) -> to_string(value)
      value when is_atom(value) -> Atom.to_string(value)
      value -> inspect(value)
    end
  end

  attr(:field, Field, required: true)
  attr(:record, :any, required: true)

  def embed_show(%{field: %Field{type: :embeds_many}} = assigns) do
    rows = List.wrap(Map.get(assigns.record, assigns.field.name))
    assigns = assign(assigns, :rows, rows)

    ~H"""
    <section class="admin-embed">
      <h2 class="admin-embed-title">{@field.label}</h2>
      <p :if={@rows == []} class="admin-embed-empty">None</p>
      <div :if={@rows != []} class="admin-embed-rows">
        <div :for={row <- @rows} class="admin-embed-row">
          <div :for={child <- @field.fields} class="admin-embed-field">
            <span class="admin-embed-label">{child.label}</span>
            <span class="admin-embed-value">{format_value(child, row)}</span>
          </div>
        </div>
      </div>
    </section>
    """
  end

  defp embed_row_text(row, children) do
    children
    |> Enum.map(&format_value(&1, row))
    |> Enum.reject(&(&1 in [nil, "", "—"]))
    |> Enum.join(" · ")
  end
end
