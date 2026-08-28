defmodule CorexAdmin.Live.Index.Controller do
  @moduledoc false

  import Phoenix.Component, only: [assign: 3]
  import Phoenix.LiveView, only: [put_flash: 3, push_patch: 2, stream: 4]

  alias CorexAdmin.Action
  alias CorexAdmin.Export
  alias CorexAdmin.Gettext
  alias CorexAdmin.ListOpts
  alias CorexAdmin.Live.Helpers
  alias CorexAdmin.Page
  alias CorexAdmin.Resource.Filter
  alias Corex.DataTable.Selection
  alias Corex.ToggleGroup

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:selected, [])
     |> assign(:entries, [])
     |> stream(:entries, [], reset: true)
     |> assign(:selection_table_id, nil)
     |> assign(:selection_row_id, nil)
     |> assign(:export_token, nil)
     |> assign(:export_open, false)
     |> assign(:canned_filters, [])
     |> assign(:filter_drafts, [])
     |> assign(:filter_focus, nil)
     |> assign(:table_row_item, &Function.identity/1)
     |> assign(:can_export, false)
     |> assign(:export_fields, [])}
  end

  def handle_params(params, _uri, socket) do
    slug = Helpers.resource_slug(socket, params)

    with {:ok, resource_mod} <- Helpers.fetch_resource(socket, slug),
         :ok <- Helpers.authorize(socket, :index, resource_mod, nil) do
      spec = Helpers.spec(resource_mod)
      list_opts = ListOpts.from_params(spec, params)
      scope = Helpers.actor(socket)

      case list_page(resource_mod, spec, scope, list_opts) do
        {:ok, list_opts, page, patched?} ->
          socket =
            socket
            |> assign_index(resource_mod, spec, list_opts, page)
            |> maybe_patch_page(spec, list_opts, patched?)

          {:noreply, socket}

        {:error, _} ->
          {:noreply, Helpers.unauthorized(socket, Gettext.t("Could not load records."))}
      end
    else
      {:error, :not_found} -> {:noreply, Helpers.unauthorized(socket, :not_found)}
      {:error, _} -> {:noreply, Helpers.unauthorized(socket)}
    end
  end

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

    {:noreply,
     socket
     |> drop_filter_draft(field)
     |> patch_index_and_sync_filters(params, field)}
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

    {:noreply,
     socket
     |> drop_filter_draft(field)
     |> patch_index_and_sync_filters(params, field)}
  end

  def handle_event("canned_filter", %{"index" => index}, socket) do
    case canned_filter_params(socket.assigns.canned_filters, index) do
      {:ok, params} ->
        {:noreply,
         socket
         |> assign(:filter_drafts, [])
         |> assign(:filter_focus, nil)
         |> patch_index(Map.put(params, "page", "1"))}

      :error ->
        {:noreply, socket}
    end
  end

  def handle_event("apply_view", params, socket) do
    case event_scalar(params) do
      "all" ->
        handle_event("reset_filters", %{}, socket)

      index ->
        handle_event("canned_filter", %{"index" => index}, socket)
    end
  end

  def handle_event("add_filter", params, socket) do
    name = event_scalar(params)
    spec = socket.assigns.spec

    allowed =
      spec.filters
      |> Enum.map(&Atom.to_string(&1.name))
      |> MapSet.new()

    if is_binary(name) and MapSet.member?(allowed, name) do
      drafts = Enum.uniq(List.wrap(socket.assigns[:filter_drafts]) ++ [name])

      {:noreply,
       socket
       |> assign(:filter_drafts, drafts)
       |> assign(:filter_focus, name)}
    else
      {:noreply, socket}
    end
  end

  def handle_event("reset_filters", _params, socket) do
    params =
      socket.assigns.list_opts
      |> ListOpts.to_params()
      |> Map.drop(["q", "filters", "page"])

    {:noreply,
     socket
     |> assign(:filter_drafts, [])
     |> assign(:filter_focus, nil)
     |> patch_index_and_sync_filters(params, :all)}
  end

  def handle_event("clear_filters", _params, socket) do
    handle_event("reset_filters", %{}, socket)
  end

  def handle_event("select", params, socket) do
    {:noreply, socket |> Selection.handle_select(params, :entries) |> assign_export_token()}
  end

  def handle_event("select_all", params, socket) do
    {:noreply, socket |> apply_select_all(params) |> assign_export_token()}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    run_record_action(socket, :delete, %{"id" => id})
  end

  def handle_event("bulk_delete", _params, socket) do
    run_bulk_action(socket, :bulk_delete)
  end

  def handle_event("action", %{"name" => name} = params, socket) do
    run_record_action(socket, String.to_existing_atom(name), params)
  rescue
    ArgumentError -> {:noreply, put_flash(socket, :error, Gettext.t("Could not run action."))}
  end

  def handle_event("bulk_action", %{"name" => name}, socket) do
    run_bulk_action(socket, String.to_existing_atom(name))
  rescue
    ArgumentError -> {:noreply, put_flash(socket, :error, Gettext.t("Could not run action."))}
  end

  defp run_record_action(socket, name, payload) do
    spec = socket.assigns.spec
    resource_mod = socket.assigns.resource_mod
    scope = Helpers.actor(socket)

    with {:ok, mod} <- Action.fetch(spec.record_actions, name),
         {:ok, record} <- fetch_for_action(spec, scope, payload),
         :ok <- Helpers.authorize(socket, mod.policy_action(), resource_mod, record),
         {:ok, message} <- mod.handle(spec, scope, payload) do
      {:noreply,
       socket
       |> put_flash(:info, message)
       |> push_patch(to: Helpers.index_path(socket, spec, socket.assigns.list_opts))}
    else
      {:error, :not_found} -> {:noreply, Helpers.not_found(socket)}
      {:error, _} -> {:noreply, put_flash(socket, :error, Gettext.t("Could not delete."))}
    end
  end

  defp run_bulk_action(socket, name) do
    spec = socket.assigns.spec
    scope = Helpers.actor(socket)

    with {:ok, mod} <- Action.fetch(spec.bulk_actions, name),
         :ok <- Helpers.authorize(socket, mod.policy_action(), socket.assigns.resource_mod, nil) do
      payload = %{"ids" => socket.assigns.selected, assigns: socket}

      {kind, message} =
        case mod.handle(spec, scope, payload) do
          {:ok, msg} -> {:info, msg}
          {:error, _} -> {:error, Gettext.t("Could not delete.")}
        end

      {:noreply,
       socket
       |> assign(:selected, [])
       |> put_flash(kind, message)
       |> push_patch(to: Helpers.index_path(socket, spec, socket.assigns.list_opts))}
    else
      _ -> {:noreply, put_flash(socket, :error, Gettext.t("Could not delete."))}
    end
  end

  defp fetch_for_action(spec, scope, payload) do
    CorexAdmin.Context.fetch(spec, scope, payload["id"])
  end

  defp list_page(resource_mod, _spec, scope, list_opts) do
    case resource_mod.query(scope, list_opts) do
      {:ok, page} ->
        last = Page.last_page(page)

        if list_opts.page > last do
          clamped = %{list_opts | page: last}

          case resource_mod.query(scope, clamped) do
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

    unwrap = fn
      {_, record} -> record
      record -> record
    end

    socket
    |> assign(:page_title, spec.label)
    |> assign(:resource_mod, resource_mod)
    |> assign(:spec, spec)
    |> assign(:list_opts, list_opts)
    |> assign(:page, page)
    |> assign(:entries, page.entries)
    |> stream(:entries, page.entries, reset: true)
    |> assign(:index_fields, Helpers.index_fields(spec, socket))
    |> assign(:export_fields, Helpers.export_fields(spec, socket))
    |> assign(:page_size_options, CorexAdmin.page_size_options(spec))
    |> assign(:window, Page.window(page))
    |> assign(:selected, selected)
    |> assign(:selection_table_id, table_id)
    |> assign(:selection_row_id, fn row -> Helpers.record_id(spec, unwrap.(row)) end)
    |> assign(:table_row_item, unwrap)
    |> assign(:can_export, Helpers.authorize(socket, :export, resource_mod, nil) == :ok)
    |> assign(:canned_filters, canned_filter_list(resource_mod))
    |> assign_export_token()
  end

  defp canned_filter_list(resource_mod) do
    if function_exported?(resource_mod, :canned_filters, 0) do
      List.wrap(resource_mod.canned_filters())
    else
      []
    end
  end

  defp drop_filter_draft(socket, field) do
    drafts =
      socket.assigns[:filter_drafts]
      |> List.wrap()
      |> Enum.reject(&(to_string(&1) == to_string(field)))

    assign(socket, :filter_drafts, drafts)
  end

  defp canned_filter_params(filters, index) do
    parsed =
      case Integer.parse(to_string(index)) do
        {int, ""} -> int
        _ -> nil
      end

    entry = if is_integer(parsed), do: Enum.at(List.wrap(filters), parsed)

    case entry do
      {_, params} when is_map(params) -> {:ok, stringify_keys(params)}
      %{params: params} when is_map(params) -> {:ok, stringify_keys(params)}
      _ -> :error
    end
  end

  defp assign_export_token(socket) do
    spec = socket.assigns[:spec]

    if spec && socket.assigns[:can_export] do
      payload = %{
        hub: socket.assigns.corex_admin,
        slug: spec.slug,
        actor: Helpers.actor(socket),
        params: ListOpts.to_params(socket.assigns.list_opts),
        ids: socket.assigns.selected || []
      }

      assign(socket, :export_token, Phoenix.Token.sign(socket, Export.token_salt(), payload))
    else
      assign(socket, :export_token, nil)
    end
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
        ToggleGroup.set_value(socket, id, [])

      filter.type == :presence ->
        ToggleGroup.set_value(socket, id, [])

      filter.type == :relative_date ->
        ToggleGroup.set_value(socket, id, [])

      filter.type == :tags ->
        Corex.TagsInput.set_value(socket, id, [])

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
    current = ListOpts.to_params(socket.assigns.list_opts)
    incoming = params |> stringify_keys() |> Map.drop(["_target", "_unused"])
    filters = Map.get(incoming, "filters")

    current
    |> Map.merge(Map.delete(incoming, "filters"))
    |> merge_incoming_filters(filters)
  end

  defp merge_incoming_filters(current, nil), do: current

  defp merge_incoming_filters(current, incoming) when is_map(incoming) do
    left = stringify_keys(Map.get(current, "filters", %{}))
    right = stringify_keys(incoming)

    merged =
      Map.merge(left, right, fn _key, old, new ->
        if is_map(old) and is_map(new) do
          Map.merge(stringify_keys(old), stringify_keys(new))
        else
          new
        end
      end)

    put_filters(current, merged)
  end

  defp merge_incoming_filters(current, _), do: current

  defp merge_filter_event(socket, params) do
    id = to_string(Map.get(params, "id") || "")
    value = Map.get(params, "value")
    current = ListOpts.to_params(socket.assigns.list_opts)
    filters = Map.get(current, "filters", %{})
    spec = socket.assigns.spec

    case parse_filter_control_id(id) do
      {:value, name} ->
        cond do
          date_range_filter?(spec, name) ->
            case complete_date_range_value(value) do
              :incomplete ->
                :ignore

              normalized ->
                put_filters(current, put_or_delete_filter(spec, filters, name, normalized))
            end

          number_range_filter?(spec, name) ->
            put_filters(
              current,
              put_or_delete_filter(spec, filters, name, normalize_number_range_param(value))
            )

          true ->
            put_filters(
              current,
              put_or_delete_filter(
                spec,
                filters,
                name,
                merge_filter_value(Map.get(filters, name), normalize_filter_param(value))
              )
            )
        end

      {:op, name} ->
        put_filters(
          current,
          put_or_delete_filter(
            spec,
            filters,
            name,
            merge_filter_op(Map.get(filters, name), normalize_filter_param(value))
          )
        )

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

  defp number_range_filter?(%{filters: filters}, name) do
    Enum.any?(filters, fn filter ->
      to_string(filter.name) == name and filter.type == :number_range
    end)
  end

  defp normalize_number_range_param(value) do
    case normalize_filter_param(value) do
      [min, max] ->
        %{"min" => min, "max" => max}

      %{min: _, max: _} = map ->
        stringify_keys(map)

      %{"min" => _, "max" => _} = map ->
        map

      other ->
        other
    end
  end

  defp event_scalar(params) when is_map(params) do
    case Map.get(params, "value") do
      [value | _] -> to_string(value)
      value when is_binary(value) -> value
      value when is_atom(value) and not is_nil(value) -> Atom.to_string(value)
      _ -> nil
    end
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

          String.ends_with?(rest, "-slider") ->
            {:value, String.trim_trailing(rest, "-slider")}

          String.ends_with?(rest, "-op") ->
            {:op, String.trim_trailing(rest, "-op")}

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

  defp toggle_dir({field, :asc}, sort_by) do
    if Atom.to_string(field) == to_string(sort_by), do: "desc", else: "asc"
  end

  defp toggle_dir({field, :desc}, sort_by) do
    if Atom.to_string(field) == to_string(sort_by), do: "asc", else: "asc"
  end

  defp toggle_dir(_, _), do: "asc"

  defp date_preset_bounds(preset), do: Filter.relative_bounds(preset)

  defp merge_filter_value(existing, nil), do: drop_value_keep_op(existing)

  defp merge_filter_value(existing, value) when is_map(existing) do
    existing = stringify_keys(existing)

    if Map.has_key?(existing, "op") do
      Map.put(existing, "value", value)
    else
      value
    end
  end

  defp merge_filter_value(_existing, value), do: value

  defp merge_filter_op(existing, nil), do: existing

  defp merge_filter_op(existing, op) do
    op = to_string(op)

    case existing do
      map when is_map(map) ->
        map = stringify_keys(map)
        inner = Map.get(map, "value")

        if present_filter_value?(inner) do
          %{"op" => op, "value" => inner}
        else
          %{"op" => op}
        end

      value when value not in [nil, "", []] ->
        %{"op" => op, "value" => value}

      _ ->
        %{"op" => op}
    end
  end

  defp drop_value_keep_op(existing) when is_map(existing) do
    existing = stringify_keys(existing)

    case Map.get(existing, "op") do
      op when op not in [nil, ""] -> %{"op" => op}
      _ -> nil
    end
  end

  defp drop_value_keep_op(_), do: nil

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
