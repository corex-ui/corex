defmodule CorexAdmin.UI.Index do
  @moduledoc """
  Index page blocks.

  `page/1` is the default composition. Each block below is also public, so a
  host LiveView can reorder them, drop one, or wrap one without copying package
  internals:

      <CorexAdmin.UI.Index.page {assigns}>
        <:command_bar_actions>...</:command_bar_actions>
      </CorexAdmin.UI.Index.page>

  ## Layout

  The command bar is two rows. The first holds identity and destination —
  saved views, search, and the actions that apply to a selection. The second
  holds the filters. Splitting them keeps the row from reflowing every time a
  filter is added, which is what made the single-row version jump.
  """

  use CorexAdmin.UI

  alias CorexAdmin.Action
  alias CorexAdmin.UI.Dialogs
  alias CorexAdmin.UI.Filters

  slot :heading_actions, doc: "Extra controls beside New."
  slot :command_bar_actions, doc: "Extra controls in the command bar action cluster."
  slot :before_table, doc: "Content between the filters and the table."
  slot :after_table, doc: "Content between the table and the footer."

  @doc "The whole index page."
  def page(assigns) do
    ~H"""
    <.shell :if={assigns[:spec]}>
      <.heading {assigns}>
        <:actions>{render_slot(@heading_actions)}</:actions>
      </.heading>
      <.metrics :if={assigns[:metrics] not in [nil, []]} metrics={@metrics} />
      <.command {assigns}>
        <:actions>{render_slot(@command_bar_actions)}</:actions>
      </.command>
      {render_slot(@before_table)}
      <.table {assigns} />
      {render_slot(@after_table)}
      <.footer {assigns} />
      <Dialogs.export
        :if={assigns[:can_export]}
        spec={@spec}
        token={@export_token}
        fields={@export_fields}
        action={Helpers.export_path(assigns, @spec)}
      />
      <Filters.range_dialogs
        spec={@spec}
        list_opts={@list_opts}
        options={assigns[:filter_options] || %{}}
        bounds={assigns[:filter_bounds] || %{}}
      />
    </.shell>
    """
  end

  slot :actions

  @doc "Page title and the New button."
  def heading(assigns) do
    ~H"""
    <.layout_heading class="layout-heading">
      <:title>{@spec.label}</:title>
      <:actions>
        {render_slot(@actions)}
        <.navigate
          :if={Helpers.authorize(assigns, :new, @resource_mod, nil) == :ok}
          to={Helpers.new_path(assigns, @spec)}
          type="navigate"
          class="button ui-solid ui-brand ui-trigger--square"
          aria_label={Gettext.t("New %{name}", name: @spec.singular)}
          title={Gettext.t("New %{name}", name: @spec.singular)}
        >
          <.heroicon name="hero-plus" class="icon" />
          <span class="sr-only">{Gettext.t("New %{name}", name: @spec.singular)}</span>
        </.navigate>
      </:actions>
    </.layout_heading>
    """
  end

  attr :metrics, :list, required: true

  @doc "Metric cards supplied by the resource's `metrics/2`."
  def metrics(assigns) do
    ~H"""
    <div class="admin-metrics">
      <div :for={metric <- @metrics} class="admin-metric">
        <span class="admin-metric-label">{metric.label}</span>
        <span class="admin-metric-value">{metric.value}</span>
        <span :if={metric[:hint]} class="admin-metric-hint">{metric.hint}</span>
      </div>
    </div>
    """
  end

  slot :actions

  @doc "Saved views, search, selection actions, and the filter row."
  def command(assigns) do
    assigns =
      assigns
      |> assign(:selected_count, length(assigns[:selected] || []))
      |> assign(:bulk_actions, Action.custom(assigns.spec, :bulk))
      |> assign(
        :show?,
        assigns.list_opts.search_fields != [] or assigns.spec.filters != [] or
          assigns.spec.selectable or assigns[:canned_filters] != [] or assigns[:can_export]
      )

    ~H"""
    <div :if={@show?} class="admin-command">
      <div class="admin-command-bar">
        <Filters.views
          :if={@canned_filters != []}
          spec={@spec}
          list_opts={@list_opts}
          canned_filters={@canned_filters}
        />
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
            <:icon><.heroicon name="hero-magnifying-glass" class="icon" /></:icon>
          </.native_input>
        </form>
        <div :if={@spec.selectable or @can_export} class="admin-command-selection">
          <p :if={@spec.selectable} class="admin-muted admin-table-bar-count">
            {Gettext.t("%{count} selected", count: @selected_count)}
          </p>
          <div class="admin-command-actions">
            {render_slot(@actions)}
            <div
              :for={mod <- @bulk_actions}
              class={["admin-command-action", @selected_count == 0 && "admin-is-disabled"]}
            >
              <Dialogs.action_dialog
                spec={@spec}
                action_mod={mod}
                kind={:bulk}
                count={@selected_count}
              />
            </div>
            <div
              :if={@can_export}
              class={["admin-command-action", @selected_count == 0 && "admin-is-disabled"]}
            >
              <.export_trigger spec={@spec} />
            </div>
            <div
              :if={
                @spec.selectable and
                  Action.registered?(@spec, :bulk, CorexAdmin.Action.BulkDelete) and
                  Helpers.authorize(assigns, :delete, @resource_mod, nil) == :ok
              }
              class={["admin-command-delete", @selected_count == 0 && "admin-is-disabled"]}
            >
              <Dialogs.bulk_delete
                id={"#{@spec.slug}-bulk-delete"}
                spec={@spec}
                count={@selected_count}
              />
            </div>
          </div>
        </div>
      </div>
      <Filters.bar
        spec={@spec}
        list_opts={@list_opts}
        drafts={assigns[:filter_drafts] || []}
        options={assigns[:filter_options] || %{}}
        bounds={assigns[:filter_bounds] || %{}}
      />
    </div>
    """
  end

  attr :spec, Spec, required: true

  defp export_trigger(assigns) do
    ~H"""
    <.icon_tooltip id={"#{@spec.slug}-export-tip"} label={Gettext.t("Export")}>
      <.action
        type="button"
        phx-click={Corex.Dialog.set_open("#{@spec.slug}-export", true)}
        class="button ui-size-sm ui-trigger--square"
        aria_label={Gettext.t("Export")}
      >
        <.heroicon name="hero-arrow-down-tray" class="icon" />
        <span class="sr-only">{Gettext.t("Export")}</span>
      </.action>
    </.icon_tooltip>
    """
  end

  @doc "The record table."
  def table(assigns) do
    assigns = assign(assigns, :record_actions, Action.custom(assigns.spec, :record))

    ~H"""
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
        <:checkbox_indicator><.heroicon name="hero-check" class="icon" /></:checkbox_indicator>
        <:checkbox_indeterminate>
          <.heroicon name="hero-minus" class="icon" />
        </:checkbox_indeterminate>
        <:sort_icon :let={%{direction: direction}}>
          <.heroicon name={sort_icon(direction)} class="icon" />
        </:sort_icon>
        <:empty>{empty_copy(@spec, @list_opts)}</:empty>
        <:col
          :let={record}
          :for={field <- @index_fields}
          label={field.label}
          name={if(field.sortable, do: field.name)}
        >
          <CorexAdmin.UI.Fields.value field={field} record={record} />
        </:col>
        <:action :let={record}>
          <div class="sr-only">
            <.navigate to={Helpers.record_path(assigns, @spec, record)} type="navigate" class="link">
              {Gettext.t("Show")}
            </.navigate>
          </div>
          <Dialogs.action_dialog
            :for={mod <- @record_actions}
            spec={@spec}
            action_mod={mod}
            kind={:record}
            record={record}
          />
          <.navigate
            :if={Helpers.authorize(assigns, :edit, @resource_mod, record) == :ok}
            to={Helpers.edit_path(assigns, @spec, record)}
            type="navigate"
            class="button ui-size-sm ui-trigger--square"
            aria_label={Gettext.t("Edit")}
          >
            <.heroicon name="hero-pencil-square" class="icon" />
          </.navigate>
        </:action>
        <:action :let={record}>
          <Dialogs.delete
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
    """
  end

  @doc "Result window, pagination, and page size."
  def footer(assigns) do
    ~H"""
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
        <:prev_trigger><.heroicon name="hero-chevron-left" class="icon" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-chevron-right" class="icon" /></:next_trigger>
        <:ellipsis><.heroicon name="hero-ellipsis-horizontal" class="icon" /></:ellipsis>
      </.pagination>
      <div class="admin-page-size">
        <.select
          id={"#{@spec.slug}-page-size"}
          class="select ui-size-sm"
          name="page_size"
          items={list_items(@page_size_options)}
          value={[to_string(@list_opts.page_size)]}
          on_value_change="page_size"
          positioning={%Corex.Positioning{placement: "top-end", same_width: false}}
        >
          <:label class="sr-only">{Gettext.t("Per page")}</:label>
          <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
        </.select>
      </div>
    </div>
    """
  end

  defp sort_icon(:asc), do: "hero-chevron-up"
  defp sort_icon(:desc), do: "hero-chevron-down"
  defp sort_icon(_), do: "hero-chevron-up-down"

  defp sort_by(%ListOpts{sort: {field, _}}), do: field
  defp sort_by(_), do: nil

  defp sort_order(%ListOpts{sort: {_, dir}}), do: dir
  defp sort_order(_), do: nil

  defp empty_copy(%Spec{} = spec, %ListOpts{} = list_opts) do
    if ListOpts.filtered?(list_opts) do
      Gettext.t("No %{label} match these filters.", label: spec.label)
    else
      Gettext.t("No %{label} yet.", label: spec.label)
    end
  end
end
