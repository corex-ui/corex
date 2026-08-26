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

  attr(:socket, :any, required: true)
  attr(:current, :any, default: nil)
  slot(:inner_block, required: true)

  def shell(assigns) do
    prefix = Helpers.home_path(assigns.socket)
    grouped = Helpers.grouped_resources(assigns.socket)
    mobile_resources = Enum.flat_map(grouped, fn {_group, resources} -> resources end)

    assigns =
      assigns
      |> assign(:prefix, prefix)
      |> assign(:mobile_resources, mobile_resources)

    ~H"""
    <div class="flex min-h-0 min-w-0 flex-1">
      <aside class="sticky top-0 hidden h-dvh w-full max-w-2xs shrink-0 flex-col gap-space-lg overflow-y-auto border-r border-border bg-surface px-space py-space lg:flex">
        <.navigate to={@prefix} class="link font-semibold text-ink no-underline">
          Admin
        </.navigate>
        <.nav socket={@socket} current={@current} />
      </aside>
      <div class="flex min-w-0 flex-1 flex-col">
        <nav
          class="flex flex-wrap items-center gap-space border-b border-border px-space py-space-sm lg:hidden"
          aria-label="Admin resources"
        >
          <.navigate
            to={@prefix}
            class="link ui-nav ui-size-sm"
            aria-current={if(is_nil(@current), do: "page")}
          >
            Admin
          </.navigate>
          <.navigate
            :for={resource <- @mobile_resources}
            to={Helpers.resource_path(@socket, Helpers.spec(resource))}
            class="link ui-nav ui-size-sm"
            aria-current={nav_current(@current, Helpers.spec(resource))}
          >
            {Helpers.spec(resource).label}
          </.navigate>
        </nav>
        <div class="flex min-w-0 flex-1 flex-col gap-space px-space py-space lg:px-space">
          {render_slot(@inner_block)}
        </div>
      </div>
    </div>
    """
  end

  attr(:socket, :any, required: true)
  attr(:current, :any, default: nil)

  def nav(assigns) do
    grouped = Helpers.grouped_resources(assigns.socket)
    assigns = assign(assigns, :grouped, grouped)

    ~H"""
    <nav class="flex flex-col gap-space-lg" aria-label="Admin">
      <div :for={{group, resources} <- @grouped} class="flex flex-col gap-space-sm">
        <p class="m-0 text-sm font-medium tracking-wide text-ink-muted uppercase">{group}</p>
        <.navigate
          :for={resource <- resources}
          to={Helpers.resource_path(@socket, Helpers.spec(resource))}
          class="link ui-nav"
          aria-current={nav_current(@current, Helpers.spec(resource))}
        >
          {Helpers.spec(resource).label}
        </.navigate>
      </div>
    </nav>
    """
  end

  attr(:prefix, :string, required: true)
  attr(:spec, Spec, default: nil)
  attr(:live_action, :atom, default: :index)
  attr(:record, :any, default: nil)

  def breadcrumbs(assigns) do
    ~H"""
    <nav aria-label="Breadcrumb" class="text-sm text-ink-muted">
      <ol class="m-0 flex list-none flex-wrap items-center gap-space p-0">
        <li>
          <.navigate to={@prefix} class="link">Admin</.navigate>
        </li>
        <li :if={@spec} class="flex items-center gap-space">
          <span aria-hidden="true">/</span>
          <.navigate to={Path.join(@prefix, @spec.slug)} class="link">{@spec.label}</.navigate>
        </li>
        <li :if={@live_action == :new} class="flex items-center gap-space">
          <span aria-hidden="true">/</span>
          <span>New</span>
        </li>
        <li :if={@live_action in [:show, :edit] and @record} class="flex items-center gap-space">
          <span aria-hidden="true">/</span>
          <span>{Helpers.record_title(@spec, @record)}</span>
        </li>
        <li :if={@live_action == :edit and @record} class="flex items-center gap-space">
          <span aria-hidden="true">/</span>
          <span>Edit</span>
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
    <span :if={!@badge} class="block max-w-48 truncate" title={@formatted}>{@formatted}</span>
    """
  end

  attr(:field, Field, required: true)
  attr(:form, :any, required: true)

  def field_input(%{field: %Field{type: :select}} = assigns) do
    assigns = assign(assigns, :items, list_items(assigns.field.options))

    ~H"""
    <.select field={@form[@field.name]} class="select" items={@items} auto_invalid>
      <:label>{@field.label}</:label>
      <:trigger>
        <.heroicon name="hero-chevron-down" />
      </:trigger>
    </.select>
    """
  end

  def field_input(%{field: %Field{type: :date}} = assigns) do
    ~H"""
    <.date_picker field={@form[@field.name]} class="date-picker" auto_invalid>
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
    </.date_picker>
    """
  end

  def field_input(%{field: %Field{type: :number}} = assigns) do
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
    ~H"""
    <.switch field={@form[@field.name]} class="switch">
      <:label>{@field.label}</:label>
    </.switch>
    """
  end

  def field_input(%{field: %Field{type: :password}} = assigns) do
    ~H"""
    <.password_input field={@form[@field.name]} class="password-input" value="" auto_invalid>
      <:label>{@field.label}</:label>
    </.password_input>
    """
  end

  def field_input(%{field: %Field{type: :datetime}} = assigns) do
    ~H"""
    <.native_input type="datetime-local" field={@form[@field.name]} class="native-input" auto_invalid>
      <:label>{@field.label}</:label>
    </.native_input>
    """
  end

  def field_input(assigns) do
    ~H"""
    <.native_input
      type={native_type(@field.type)}
      field={@form[@field.name]}
      class="native-input"
      auto_invalid
    >
      <:label>{@field.label}</:label>
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
      type when type in [:select, :multi_select] ->
        filter_select(assigns)

      :date_range ->
        filter_date_range(assigns)

      :datetime_range ->
        filter_datetime_range(assigns)

      :number_range ->
        filter_number_range(assigns)

      :boolean ->
        filter_boolean(assigns)

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
    <div :if={@chips != []} class="flex flex-wrap items-center gap-space-sm">
      <span :for={chip <- @chips} class="badge ui-size-sm">
        {chip.label}: {chip.text}
        <.action
          type="button"
          phx-click="clear_filter"
          phx-value-field={chip.field}
          class="button ui-size-sm ui-ghost"
          aria_label={"Clear #{chip.label}"}
        >
          <.heroicon name="hero-x-mark" />
        </.action>
      </span>
      <.action type="button" phx-click="clear_filters" class="button ui-size-sm">
        Clear all
      </.action>
    </div>
    """
  end

  attr(:id, :string, required: true)
  attr(:spec, Spec, required: true)
  attr(:record, :any, required: true)
  attr(:trigger, :atom, default: :icon, values: [:icon, :labeled])

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
        class={
          if(@trigger == :labeled,
            do: "button ui-alert",
            else: "button ui-size-sm ui-alert ui-trigger--square"
          )
        }
        aria_label={"Delete #{@spec.label}"}
      >
        <.heroicon name="hero-trash" />
        <span :if={@trigger == :labeled}>Delete</span>
      </:trigger>
      <:title>Delete {@spec.label}?</:title>
      <:description>This action cannot be undone.</:description>
      <:content>
        <div class="mt-space-lg flex flex-wrap justify-end gap-space-sm">
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
            class="button ui-size-sm ui-alert"
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
      <:trigger class="button ui-size-sm ui-alert" aria_label={"Delete selected #{@spec.label}"}>
        <.heroicon name="hero-trash" /> Delete selected
      </:trigger>
      <:title>Delete {@count} {@spec.label}?</:title>
      <:description>This action cannot be undone. Each record is authorized separately.</:description>
      <:content>
        <div class="mt-space-lg flex flex-wrap justify-end gap-space-sm">
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
            class="button ui-size-sm ui-alert"
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

  defp filter_select(assigns) do
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
      <:label>{@filter.label}</:label>
      <:trigger>
        <.heroicon name="hero-chevron-down" />
      </:trigger>
    </.select>
    """
  end

  defp filter_date_range(assigns) do
    assigns = assign(assigns, :picked, date_picker_value(assigns.value))

    ~H"""
    <.date_picker
      id={@control_id}
      class="date-picker ui-size-sm w-full"
      name={@input_name}
      selection_mode="range"
      value={@picked}
      on_value_change="filter"
    >
      <:label>{@filter.label}</:label>
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
    """
  end

  defp filter_datetime_range(assigns) do
    range = assigns.value || %{}

    assigns =
      assigns
      |> assign(:from, datetime_local(Map.get(range, :from)))
      |> assign(:to, datetime_local(Map.get(range, :to)))

    ~H"""
    <div class="flex flex-col gap-space-sm">
      <span class="text-sm">{@filter.label}</span>
      <div class="flex flex-wrap items-end gap-space-sm">
        <.native_input
          id={"#{@control_id}-from"}
          type="datetime-local"
          name={"#{@input_name}[from]"}
          value={@from}
          class="native-input ui-size-sm"
        >
          <:label>From</:label>
        </.native_input>
        <.native_input
          id={"#{@control_id}-to"}
          type="datetime-local"
          name={"#{@input_name}[to]"}
          value={@to}
          class="native-input ui-size-sm"
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
    <div class="flex flex-col gap-space-sm">
      <span class="text-sm">{@filter.label}</span>
      <div class="flex flex-wrap items-end gap-space-sm">
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

  defp filter_boolean(assigns) do
    assigns = assign(assigns, :selected, select_value(assigns.value))

    ~H"""
    <.select
      id={@control_id}
      class="select ui-size-sm"
      name={@input_name}
      items={
        Corex.List.new([
          %{label: "Yes", value: "true"},
          %{label: "No", value: "false"}
        ])
      }
      value={@selected}
      on_value_change="filter"
      translation={%Corex.Select.Translation{placeholder: "Any"}}
    >
      <:label>{@filter.label}</:label>
      <:trigger>
        <.heroicon name="hero-chevron-down" />
      </:trigger>
    </.select>
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
    >
      <:label>{@filter.label}</:label>
    </.native_input>
    """
  end

  defp nav_current(%Spec{slug: slug}, %Spec{slug: slug}), do: "page"
  defp nav_current(_, _), do: nil

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
    <section class="flex w-full flex-col gap-space">
      <h2 class="m-0 text-base font-medium">{@field.label}</h2>
      <p :if={@rows == []} class="m-0 text-sm text-ink-muted">None</p>
      <div :if={@rows != []} class="flex w-full flex-col gap-space-sm">
        <div :for={row <- @rows} class="grid w-full grid-cols-1 gap-space-sm md:grid-cols-3">
          <div :for={child <- @field.fields} class="flex min-w-0 flex-col gap-space-sm">
            <span class="text-sm text-ink-muted">{child.label}</span>
            <span class="text-sm">{format_value(child, row)}</span>
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
