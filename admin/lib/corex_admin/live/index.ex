defmodule CorexAdmin.Live.Index do
  @moduledoc false

  use Phoenix.LiveView
  use Corex

  alias CorexAdmin.Context
  alias CorexAdmin.ListOpts
  alias CorexAdmin.Live.Components
  alias CorexAdmin.Live.Helpers
  alias CorexAdmin.Page
  alias Corex.DataTable.Selection
  alias Phoenix.LiveView.JS

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:selected, [])
     |> assign(:entries, [])
     |> assign(:selection_table_id, nil)
     |> assign(:selection_row_id, nil)}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    slug = params["resource"]

    with {:ok, resource_mod} <- Helpers.fetch_resource(socket, slug),
         :ok <- Helpers.authorize(socket, :index, resource_mod, nil) do
      spec = Helpers.spec(resource_mod)
      list_opts = ListOpts.from_params(spec, params)
      scope = Helpers.actor(socket)

      case list_page(spec, scope, list_opts) do
        {:ok, list_opts, page, patched?} ->
          socket =
            socket
            |> assign_index(resource_mod, spec, list_opts, page)
            |> maybe_patch_page(spec, list_opts, patched?)

          {:noreply, socket}

        {:error, _} ->
          {:noreply, Helpers.unauthorized(socket, "Could not load records.")}
      end
    else
      {:error, :not_found} -> {:noreply, Helpers.unauthorized(socket, :not_found)}
      {:error, _} -> {:noreply, Helpers.unauthorized(socket)}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Components.shell :if={assigns[:spec]}>
      <.layout_heading class="layout-heading">
        <:title>{@spec.label}</:title>
        <:actions>
          <.navigate
            :if={Helpers.authorize(assigns, :new, @resource_mod, nil) == :ok}
            to={Helpers.new_path(assigns, @spec)}
            type="navigate"
            class="button ui-solid ui-brand ui-trigger--square"
            aria_label={"New #{@spec.label}"}
            title={"New #{@spec.label}"}
          >
            <.heroicon name="hero-plus" />
            <span class="sr-only">New {@spec.label}</span>
          </.navigate>
        </:actions>
      </.layout_heading>

      <div
        :if={@list_opts.search_fields != [] or @spec.filters != []}
        class="admin-command-bar"
      >
        <form
          :if={@list_opts.search_fields != []}
          id={"#{@spec.slug}-search"}
          phx-change="search"
          class="admin-command-search"
        >
          <.native_input
            id={"#{@spec.slug}-search-q"}
            type="search"
            name="q"
            value={@list_opts.search}
            class="native-input ui-size-sm"
            placeholder={"Search #{@spec.label}"}
            phx-debounce="400"
          >
            <:label class="sr-only">Search {@spec.label}</:label>
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
            Filters
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
                  Reset all
                </.action>
              </div>
            </div>
          </:content>
        </.collapsible>
      </div>

      <Components.filter_chips spec={@spec} list_opts={@list_opts} />

      <div :if={@spec.selectable} class="admin-table-bar">
        <p class="admin-muted admin-table-bar-count">
          {length(@selected)} selected
        </p>
        <div
          :if={Helpers.authorize(assigns, :delete, @resource_mod, nil) == :ok}
          class={if(@selected == [], do: "admin-is-disabled")}
        >
          <Components.bulk_delete_dialog
            id={"#{@spec.slug}-bulk-delete"}
            spec={@spec}
            count={length(@selected)}
          />
        </div>
      </div>

      <div class="admin-table-wrap">
        <.data_table
          id={"#{@spec.slug}-table"}
          class="data-table max-w-none ui-size-sm"
          rows={@entries}
          sort_by={sort_by(@list_opts)}
          sort_order={sort_order(@list_opts)}
          on_sort="sort"
          row_id={&Helpers.record_id(@spec, &1)}
          row_click={fn record -> JS.navigate(Helpers.record_path(assigns, @spec, record)) end}
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
                Show
              </.navigate>
            </div>
            <.navigate
              :if={Helpers.authorize(assigns, :edit, @resource_mod, record) == :ok}
              to={Helpers.edit_path(assigns, @spec, record)}
              type="navigate"
              class="button ui-size-sm ui-trigger--square"
              aria_label="Edit"
            >
              <.heroicon name="hero-pencil-square" />
            </.navigate>
          </:action>
          <:action :let={record}>
            <Components.delete_dialog
              :if={Helpers.authorize(assigns, :delete, @resource_mod, record) == :ok}
              id={"delete-#{Helpers.record_id(@spec, record)}"}
              spec={@spec}
              record={record}
            />
          </:action>
        </.data_table>
      </div>

      <div class="admin-footer">
        <p class="admin-footer-meta">
          Showing {elem(@window, 0)}–{elem(@window, 1)} of {elem(@window, 2)}
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
            <:label class="sr-only">Per page</:label>
            <:trigger>
              <.heroicon name="hero-chevron-down" />
            </:trigger>
          </.select>
        </div>
      </div>
    </Components.shell>
    """
  end

  @impl true
  def handle_event("search", params, socket) do
    spec = socket.assigns.spec
    current = ListOpts.to_params(socket.assigns.list_opts)

    next =
      socket
      |> merge_params(params)
      |> reject_incomplete_date_ranges(spec)

    parsed = ListOpts.to_params(ListOpts.from_params(spec, next))

    if index_query_equivalent?(parsed, current) do
      {:noreply, socket}
    else
      {:noreply, patch_index(socket, Map.put(parsed, "page", "1"))}
    end
  end

  def handle_event("filter", params, socket) do
    case merge_filter_event(socket, params) do
      :ignore ->
        {:noreply, socket}

      params ->
        {:noreply, patch_index(socket, Map.put(params, "page", "1"))}
    end
  end

  def handle_event("filter_preset", %{"field" => field, "preset" => preset}, socket) do
    case date_preset_bounds(preset) do
      {from, to} ->
        current = ListOpts.to_params(socket.assigns.list_opts)
        filters = Map.get(current, "filters", %{})

        filters =
          Map.put(filters, field, %{
            "from" => Date.to_iso8601(from),
            "to" => Date.to_iso8601(to)
          })

        params =
          current
          |> Map.put("filters", filters)
          |> Map.delete("page")

        {:noreply, patch_index(socket, params)}

      :error ->
        {:noreply, socket}
    end
  end

  def handle_event("page_size", params, socket) do
    current = ListOpts.to_params(socket.assigns.list_opts)

    params =
      current
      |> Map.put("page_size", page_size_param(params))
      |> Map.delete("page")

    {:noreply, patch_index(socket, params)}
  end

  def handle_event("sort", %{"sort_by" => sort_by}, socket) do
    current = socket.assigns.list_opts

    params =
      current
      |> ListOpts.to_params()
      |> Map.put("sort", sort_by)
      |> Map.put("dir", toggle_dir(current.sort, sort_by))
      |> Map.delete("page")

    {:noreply, patch_index(socket, params)}
  end

  def handle_event("clear_filter", %{"field" => "q"}, socket) do
    params =
      socket.assigns.list_opts |> ListOpts.to_params() |> Map.delete("q") |> Map.delete("page")

    {:noreply, patch_index(socket, params)}
  end

  def handle_event("clear_filter", %{"field" => field}, socket) do
    params = ListOpts.to_params(socket.assigns.list_opts)
    filters = params |> Map.get("filters", %{}) |> Map.put(field, "")

    params =
      params
      |> Map.put("filters", filters)
      |> Map.delete("page")

    {:noreply, patch_index_and_sync_filters(socket, params, field)}
  end

  def handle_event("reset_filter", %{"field" => field}, socket) do
    params = ListOpts.to_params(socket.assigns.list_opts)
    filters = params |> Map.get("filters", %{}) |> Map.delete(field)

    params =
      params
      |> then(fn map ->
        if filters == %{}, do: Map.delete(map, "filters"), else: Map.put(map, "filters", filters)
      end)
      |> Map.delete("page")

    {:noreply, patch_index_and_sync_filters(socket, params, field)}
  end

  def handle_event("reset_filters", _params, socket) do
    params =
      socket.assigns.list_opts
      |> ListOpts.to_params()
      |> Map.drop(["q", "filters", "page"])

    {:noreply, patch_index_and_sync_filters(socket, params, :all)}
  end

  def handle_event("clear_filters", _params, socket) do
    handle_event("reset_filters", %{}, socket)
  end

  def handle_event("select", params, socket) do
    {:noreply, Selection.handle_select(socket, params, :entries)}
  end

  def handle_event("select_all", params, socket) do
    {:noreply, apply_select_all(socket, params)}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    spec = socket.assigns.spec
    resource_mod = socket.assigns.resource_mod
    scope = Helpers.actor(socket)

    case Context.fetch(spec, scope, id) do
      {:ok, record} ->
        with :ok <- Helpers.authorize(socket, :delete, resource_mod, record),
             {:ok, _} <- Context.delete(spec, scope, record) do
          {:noreply,
           socket
           |> put_flash(:info, "Deleted.")
           |> push_patch(to: Helpers.index_path(socket, spec, socket.assigns.list_opts))}
        else
          {:error, _} -> {:noreply, put_flash(socket, :error, "Could not delete.")}
        end

      {:error, :not_found} ->
        {:noreply, Helpers.not_found(socket)}
    end
  end

  def handle_event("bulk_delete", _params, socket) do
    spec = socket.assigns.spec
    resource_mod = socket.assigns.resource_mod
    scope = Helpers.actor(socket)

    {deleted, denied} =
      Enum.reduce(socket.assigns.selected, {0, 0}, fn id, {ok, no} ->
        case Context.fetch(spec, scope, id) do
          {:ok, record} ->
            with :ok <- Helpers.authorize(socket, :delete, resource_mod, record),
                 {:ok, _} <- Context.delete(spec, scope, record) do
              {ok + 1, no}
            else
              _ -> {ok, no + 1}
            end

          {:error, _} ->
            {ok, no + 1}
        end
      end)

    flash =
      cond do
        deleted > 0 and denied == 0 -> {:info, "Deleted #{deleted}."}
        deleted > 0 -> {:info, "Deleted #{deleted}. #{denied} could not be deleted."}
        true -> {:error, "Could not delete."}
      end

    {:noreply,
     socket
     |> assign(:selected, [])
     |> put_flash(elem(flash, 0), elem(flash, 1))
     |> push_patch(to: Helpers.index_path(socket, spec, socket.assigns.list_opts))}
  end

  defp list_page(spec, scope, list_opts) do
    case Context.list(spec, scope, list_opts) do
      {:ok, page} ->
        last = Page.last_page(page)

        if list_opts.page > last do
          clamped = %{list_opts | page: last}

          case Context.list(spec, scope, clamped) do
            {:ok, page} -> {:ok, clamped, page, true}
            other -> other
          end
        else
          {:ok, list_opts, page, false}
        end

      other ->
        other
    end
  end

  defp assign_index(socket, resource_mod, spec, list_opts, page) do
    table_id = "#{spec.slug}-table"
    previous = socket.assigns[:list_opts]
    selected = if previous == list_opts, do: socket.assigns[:selected] || [], else: []

    socket
    |> assign(:page_title, spec.label)
    |> assign(:resource_mod, resource_mod)
    |> assign(:spec, spec)
    |> assign(:list_opts, list_opts)
    |> assign(:page, page)
    |> assign(:entries, page.entries)
    |> assign(:index_fields, Helpers.index_fields(spec))
    |> assign(:page_size_options, CorexAdmin.page_size_options(spec))
    |> assign(:window, Page.window(page))
    |> assign(:selected, selected)
    |> assign(:selection_table_id, table_id)
    |> assign(:selection_row_id, &Helpers.record_id(spec, &1))
  end

  defp maybe_patch_page(socket, spec, list_opts, true) do
    push_patch(socket, to: Helpers.index_path(socket, spec, list_opts))
  end

  defp maybe_patch_page(socket, _spec, _list_opts, false), do: socket

  defp patch_index_and_sync_filters(socket, params, fields) do
    socket
    |> clear_filter_widgets(fields)
    |> patch_index(params)
  end

  defp clear_filter_widgets(socket, :all) do
    Enum.reduce(socket.assigns.spec.filters, socket, &clear_filter_widget(&2, &1))
  end

  defp clear_filter_widgets(socket, field) when is_binary(field) do
    case Enum.find(socket.assigns.spec.filters, fn filter ->
           to_string(filter.field) == field or to_string(filter.name) == field
         end) do
      nil -> socket
      filter -> clear_filter_widget(socket, filter)
    end
  end

  defp clear_filter_widget(socket, filter) do
    id = "#{socket.assigns.spec.slug}-filter-#{filter.name}"
    option_count = length(List.wrap(filter.options))

    cond do
      filter.type == :boolean ->
        Corex.ToggleGroup.set_value(socket, id, [])

      filter.type in [:select, :multi_select] and option_count > 12 ->
        Corex.Combobox.set_value(socket, id, [])

      filter.type in [:select, :multi_select] ->
        Corex.Select.set_value(socket, id, [])

      true ->
        socket
    end
  end

  defp patch_index(socket, params) when is_map(params) do
    spec = socket.assigns.spec
    list_opts = ListOpts.from_params(spec, params)
    push_patch(socket, to: Helpers.index_path(socket, spec, list_opts))
  end

  defp merge_params(socket, params) do
    socket.assigns.list_opts
    |> ListOpts.to_params()
    |> Map.merge(stringify_keys(params))
    |> Map.drop(["_target", "_unused"])
  end

  defp merge_filter_event(socket, params) do
    id = to_string(Map.get(params, "id") || "")
    value = Map.get(params, "value")
    current = ListOpts.to_params(socket.assigns.list_opts)
    filters = Map.get(current, "filters", %{})
    spec = socket.assigns.spec

    case parse_filter_control_id(id) do
      {:value, name} ->
        if date_range_filter?(spec, name) do
          case complete_date_range_value(value) do
            :incomplete ->
              :ignore

            normalized ->
              put_filters(current, put_or_delete_filter(spec, filters, name, normalized))
          end
        else
          put_filters(
            current,
            put_or_delete_filter(spec, filters, name, normalize_filter_param(value))
          )
        end

      {:range, name, bound} ->
        nested = stringify_keys(Map.get(filters, name, %{}))
        nested = put_or_delete(nested, bound, normalize_filter_param(value))

        put_filters(
          current,
          put_or_delete_filter(spec, filters, name, if(nested == %{}, do: nil, else: nested))
        )

      :error ->
        :ignore
    end
  end

  defp put_filters(current, filters) do
    if filters == %{} do
      Map.delete(current, "filters")
    else
      Map.put(current, "filters", filters)
    end
  end

  defp date_range_filter?(%{filters: filters}, name) do
    Enum.any?(filters, fn filter ->
      to_string(filter.name) == name and filter.type == :date_range
    end)
  end

  defp complete_date_range_value(value) do
    case normalize_filter_param(value) do
      nil ->
        nil

      str when is_binary(str) ->
        case String.split(str, ",", trim: true) do
          [_from, _to] -> str
          _ -> :incomplete
        end

      list when is_list(list) ->
        case Enum.reject(list, &(&1 in [nil, ""])) do
          [from, to] -> Enum.join([from, to], ",")
          _ -> :incomplete
        end

      %{} = map ->
        map = stringify_keys(map)
        from = Map.get(map, "from")
        to = Map.get(map, "to")

        if present_filter_value?(from) and present_filter_value?(to) do
          map
        else
          :incomplete
        end

      other ->
        other
    end
  end

  defp present_filter_value?(value), do: normalize_filter_param(value) != nil

  defp reject_incomplete_date_ranges(params, spec) do
    filters = Map.get(params, "filters", %{})

    if not is_map(filters) do
      params
    else
      reduced =
        Enum.reduce(spec.filters, filters, fn filter, acc ->
          name = to_string(filter.name)

          if filter.type == :date_range do
            case complete_date_range_value(Map.get(acc, name)) do
              :incomplete -> Map.delete(acc, name)
              nil -> Map.delete(acc, name)
              normalized -> Map.put(acc, name, normalized)
            end
          else
            acc
          end
        end)

      put_filters(params, reduced)
    end
  end

  defp index_query_equivalent?(left, right) do
    normalize_index_query(left) == normalize_index_query(right)
  end

  defp normalize_index_query(params) when is_map(params) do
    q =
      case Map.get(params, "q") do
        value when value in [nil, ""] -> nil
        value -> value
      end

    filters =
      case Map.get(params, "filters") do
        value when value in [nil, %{}] -> nil
        value -> value
      end

    %{
      "q" => q,
      "filters" => filters,
      "sort" => Map.get(params, "sort"),
      "dir" => Map.get(params, "dir"),
      "page_size" => Map.get(params, "page_size")
    }
  end

  defp parse_filter_control_id(id) do
    case String.split(id, "-filter-", parts: 2) do
      [_, rest] ->
        cond do
          String.ends_with?(rest, "-min") ->
            {:range, String.trim_trailing(rest, "-min"), "min"}

          String.ends_with?(rest, "-max") ->
            {:range, String.trim_trailing(rest, "-max"), "max"}

          String.ends_with?(rest, "-from") ->
            {:range, String.trim_trailing(rest, "-from"), "from"}

          String.ends_with?(rest, "-to") ->
            {:range, String.trim_trailing(rest, "-to"), "to"}

          true ->
            {:value, rest}
        end

      _ ->
        :error
    end
  end

  defp normalize_filter_param(nil), do: nil
  defp normalize_filter_param(""), do: nil
  defp normalize_filter_param([]), do: nil
  defp normalize_filter_param([value]), do: value
  defp normalize_filter_param(value), do: value

  defp put_or_delete(map, key, nil), do: Map.delete(map, to_string(key))
  defp put_or_delete(map, key, value), do: Map.put(map, to_string(key), value)

  defp put_or_delete_filter(spec, filters, name, nil) do
    if filter_has_default?(spec, name) do
      Map.put(filters, to_string(name), "")
    else
      Map.delete(filters, to_string(name))
    end
  end

  defp put_or_delete_filter(_spec, filters, name, value) do
    Map.put(filters, to_string(name), value)
  end

  defp filter_has_default?(spec, name) do
    key = to_string(name)

    spec.default_filters
    |> Map.keys()
    |> Enum.any?(&(Atom.to_string(&1) == key))
  end

  defp stringify_keys(map) when is_map(map) do
    Map.new(map, fn
      {key, value} when is_atom(key) -> {Atom.to_string(key), value}
      {key, value} -> {key, value}
    end)
  end

  defp stringify_keys(_), do: %{}

  defp page_size_param(%{"page_size" => value}), do: value
  defp page_size_param(%{"value" => [value | _]}), do: value
  defp page_size_param(%{"value" => value}) when is_binary(value), do: value
  defp page_size_param(_), do: nil

  defp sort_by(%ListOpts{sort: {field, _}}), do: field
  defp sort_by(_), do: nil

  defp sort_order(%ListOpts{sort: {_, dir}}), do: dir
  defp sort_order(_), do: :asc

  defp toggle_dir({field, :asc}, sort_by) do
    if Atom.to_string(field) == to_string(sort_by), do: "desc", else: "asc"
  end

  defp toggle_dir({field, :desc}, sort_by) do
    if Atom.to_string(field) == to_string(sort_by), do: "asc", else: "asc"
  end

  defp toggle_dir(_, _), do: "asc"

  defp empty_copy(spec, list_opts) do
    if ListOpts.filtered?(list_opts) do
      "No #{spec.label} match these filters."
    else
      "No #{spec.label} yet."
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

  defp date_preset_bounds("today") do
    today = Date.utc_today()
    {today, today}
  end

  defp date_preset_bounds("last_7") do
    today = Date.utc_today()
    {Date.add(today, -6), today}
  end

  defp date_preset_bounds("last_30") do
    today = Date.utc_today()
    {Date.add(today, -29), today}
  end

  defp date_preset_bounds("this_month") do
    today = Date.utc_today()
    {%{today | day: 1}, today}
  end

  defp date_preset_bounds("ytd") do
    today = Date.utc_today()
    {%{today | month: 1, day: 1}, today}
  end

  defp date_preset_bounds(_), do: :error

  # Table header checkboxes are library-controlled. Zag can echo onCheckedChange
  # when the header is patched to indeterminate or false after a partial select.
  defp apply_select_all(socket, params) do
    case select_all_checked_param(params) do
      :indeterminate ->
        socket

      true ->
        Selection.handle_select_all(socket, %{"checked" => true}, :entries)

      false ->
        entries = socket.assigns.entries || []
        selected = socket.assigns.selected || []
        all_selected? = entries != [] and length(selected) == length(entries)

        if all_selected? or selected == [] do
          Selection.handle_select_all(socket, %{"checked" => false}, :entries)
        else
          socket
        end
    end
  end

  defp select_all_checked_param(params) do
    case Map.get(params, "checked") do
      true -> true
      "true" -> true
      :indeterminate -> :indeterminate
      "indeterminate" -> :indeterminate
      _ -> false
    end
  end
end
