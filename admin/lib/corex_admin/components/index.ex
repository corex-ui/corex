defmodule CorexAdmin.Components.Index do
  @moduledoc false

  use Phoenix.Component
  use Corex

  alias CorexAdmin.Action
  alias CorexAdmin.Gettext
  alias CorexAdmin.ListOpts
  alias CorexAdmin.Live.Components
  alias CorexAdmin.Live.Helpers
  alias Phoenix.LiveView.JS

  def page(assigns) do
    ~H"""
    <Components.shell :if={assigns[:spec]}>
      <.layout_heading class="layout-heading">
        <:title>{@spec.label}</:title>
        <:actions>
          <.export_trigger :if={assigns[:can_export]} spec={@spec} />
          <.navigate
            :if={Helpers.authorize(assigns, :new, @resource_mod, nil) == :ok}
            to={Helpers.new_path(assigns, @spec)}
            type="navigate"
            class="button ui-solid ui-brand ui-trigger--square"
            aria_label={Gettext.t("New %{name}", name: @spec.singular)}
            title={Gettext.t("New %{name}", name: @spec.singular)}
          >
            <.heroicon name="hero-plus" />
            <span class="sr-only">{Gettext.t("New %{name}", name: @spec.singular)}</span>
          </.navigate>
        </:actions>
      </.layout_heading>

      <div
        :if={@list_opts.search_fields != [] or @spec.filters != [] or @spec.selectable}
        class="admin-command-bar"
      >
        <form
          :if={@list_opts.search_fields != []}
          id={"#{@spec.slug}-search"}
          phx-change="search"
          class="admin-command-search-form"
        >
          <.native_input
            id={"#{@spec.slug}-search-q"}
            type="search"
            name="q"
            value={@list_opts.search}
            class="native-input ui-size-sm admin-command-search"
            placeholder={Gettext.t("Search %{label}", label: @spec.label)}
            phx-debounce="400"
          >
            <:label class="sr-only">{Gettext.t("Search %{label}", label: @spec.label)}</:label>
            <:icon>
              <.heroicon name="hero-magnifying-glass" class="icon" />
            </:icon>
          </.native_input>
        </form>
        <.collapsible
          :if={@spec.filters != []}
          id={"#{@spec.slug}-filters"}
          class="collapsible admin-filters"
          open={@spec.filters_open}
        >
          <:trigger>
            {Gettext.t("Filters")}
            <span
              :if={filter_badge_count(@list_opts) > 0}
              class="badge ui-size-sm ui-trigger--square"
            >
              {filter_badge_count(@list_opts)}
            </span>
          </:trigger>
          <:closed>
            <.heroicon name="hero-chevron-right" />
          </:closed>
          <:content>
            <div class="admin-filter-form">
              <div
                :for={filter <- @spec.filters}
                class={filter_item_class(filter)}
              >
                <Components.filter_control spec={@spec} filter={filter} list_opts={@list_opts} />
              </div>
              <div class="admin-filter-actions">
                <.action
                  type="button"
                  phx-click="reset_filters"
                  class="button ui-size-sm ui-ghost ui-alert"
                >
                  {Gettext.t("Reset all")}
                </.action>
              </div>
            </div>
          </:content>
        </.collapsible>
        <div :if={@spec.selectable} class="admin-command-selection">
          <p class="admin-muted admin-table-bar-count">
            {Gettext.t("%{count} selected", count: length(@selected))}
          </p>
          <div class={if(@selected == [], do: "admin-is-disabled")}>
            <Components.bulk_delete_dialog
              :if={
                Action.registered?(@spec, :bulk, CorexAdmin.Action.BulkDelete) and
                  Helpers.authorize(assigns, :delete, @resource_mod, nil) == :ok
              }
              id={"#{@spec.slug}-bulk-delete"}
              spec={@spec}
              count={length(@selected)}
            />
            <.export_trigger
              :if={assigns[:can_export] and @selected != []}
              spec={@spec}
              variant={:bulk}
            />
          </div>
        </div>
      </div>

      <Components.filter_chips spec={@spec} list_opts={@list_opts} />

      <div :if={@canned_filters != []} class="admin-filter-presets">
        <.action
          :for={{{label, _params}, index} <- Enum.with_index(@canned_filters)}
          type="button"
          phx-click="canned_filter"
          phx-value-index={index}
          class="button ui-size-sm"
        >
          {label}
        </.action>
      </div>

      <div class="admin-table-wrap">
        <.data_table
          id={"#{@spec.slug}-table"}
          class="data-table max-w-none ui-size-sm"
          rows={@entries}
          row_item={@table_row_item}
          sort_by={sort_by(@list_opts)}
          sort_order={sort_order(@list_opts)}
          on_sort="sort"
          row_id={@selection_row_id}
          row_click={
            fn row -> JS.navigate(Helpers.record_path(assigns, @spec, @table_row_item.(row))) end
          }
          selectable={@spec.selectable}
          selected={@selected}
          on_select={if(@spec.selectable, do: "select")}
          on_select_all={if(@spec.selectable, do: "select_all")}
          checkbox_class="checkbox ui-size-sm"
        >
          <:checkbox_indicator>
            <.heroicon name="hero-check" class="icon" />
          </:checkbox_indicator>
          <:checkbox_indeterminate>
            <.heroicon name="hero-minus" class="icon" />
          </:checkbox_indeterminate>
          <:sort_icon :let={%{direction: direction}}>
            <.heroicon
              name={
                case direction do
                  :asc -> "hero-chevron-up"
                  :desc -> "hero-chevron-down"
                  _ -> "hero-chevron-up-down"
                end
              }
              class="icon"
            />
          </:sort_icon>
          <:empty>{empty_copy(@spec, @list_opts)}</:empty>
          <:col
            :let={record}
            :for={field <- @index_fields}
            label={field.label}
            name={if(field.sortable, do: field.name)}
          >
            <Components.field_value field={field} record={record} />
          </:col>
          <:action :let={record}>
            <div class="sr-only">
              <.navigate
                to={Helpers.record_path(assigns, @spec, record)}
                type="navigate"
                class="link"
              >
                {Gettext.t("Show")}
              </.navigate>
            </div>
            <.navigate
              :if={Helpers.authorize(assigns, :edit, @resource_mod, record) == :ok}
              to={Helpers.edit_path(assigns, @spec, record)}
              type="navigate"
              class="button ui-size-sm ui-trigger--square"
              aria_label={Gettext.t("Edit")}
            >
              <.heroicon name="hero-pencil-square" />
            </.navigate>
          </:action>
          <:action :let={record}>
            <Components.delete_dialog
              :if={
                Action.registered?(@spec, :record, CorexAdmin.Action.Delete) and
                  Helpers.authorize(assigns, :delete, @resource_mod, record) == :ok
              }
              id={"delete-#{Helpers.record_id(@spec, record)}"}
              spec={@spec}
              record={record}
            />
          </:action>
        </.data_table>
      </div>

      <div class="admin-footer">
        <p class="admin-footer-meta">
          {Gettext.t("Showing %{first}–%{last} of %{total}",
            first: elem(@window, 0),
            last: elem(@window, 1),
            total: elem(@window, 2)
          )}
        </p>
        <.pagination
          id={"#{@spec.slug}-pagination"}
          class="pagination"
          count={@page.total}
          page={@page.page}
          page_size={@page.page_size}
          type={:link}
          redirect={:patch}
          to={Helpers.pagination_to(assigns, @spec, @list_opts)}
          page_param="page"
          page_size_param="page_size"
        >
          <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
          <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
          <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
        </.pagination>
        <div class="admin-page-size">
          <.select
            id={"#{@spec.slug}-page-size"}
            class="select ui-size-sm"
            name="page_size"
            items={page_size_items(@page_size_options)}
            value={[to_string(@list_opts.page_size)]}
            on_value_change="page_size"
            positioning={%Corex.Positioning{placement: "top-end"}}
          >
            <:label class="sr-only">{Gettext.t("Per page")}</:label>
            <:trigger>
              <.heroicon name="hero-chevron-down" />
            </:trigger>
          </.select>
        </div>
      </div>

      <Components.export_dialog
        :if={assigns[:can_export]}
        spec={@spec}
        token={@export_token}
        fields={@export_fields}
        action={Helpers.export_path(assigns, @spec)}
      />
    </Components.shell>
    """
  end

  attr(:spec, :any, required: true)
  attr(:variant, :atom, default: :collection)

  defp export_trigger(assigns) do
    ~H"""
    <.action
      type="button"
      phx-click={Corex.Dialog.set_open("#{@spec.slug}-export", true)}
      class="button ui-size-sm"
      aria_label={Gettext.t("Export")}
    >
      <.heroicon name="hero-arrow-down-tray" />
      <span :if={@variant == :collection}>{Gettext.t("Export")}</span>
    </.action>
    """
  end

  defp sort_by(%ListOpts{sort: {field, _}}), do: field
  defp sort_by(_), do: nil

  defp sort_order(%ListOpts{sort: {_, dir}}), do: dir
  defp sort_order(_), do: :asc

  defp empty_copy(spec, list_opts) do
    if ListOpts.filtered?(list_opts) do
      Gettext.t("No %{label} match these filters.", label: spec.label)
    else
      Gettext.t("No %{label} yet.", label: spec.label)
    end
  end

  defp filter_item_class(%{type: type})
       when type in [:date_range, :datetime_range, :number_range],
       do: "admin-filter-item admin-filter-item--range"

  defp filter_item_class(_), do: "admin-filter-item"

  defp filter_badge_count(%ListOpts{} = opts) do
    search = if opts.search not in [nil, ""], do: 1, else: 0
    search + map_size(opts.filters)
  end

  defp page_size_items(options) do
    Corex.List.new(Enum.map(options, &%{label: to_string(&1), value: to_string(&1)}))
  end
end
