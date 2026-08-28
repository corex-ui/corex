defmodule CorexAdmin.Live.Index.Controller do
  @moduledoc """
  Behaviour behind `use CorexAdmin.Live, :index`.

  Owns auth, URL state, and events. It does not render: a host LiveView may
  replace `render/1` entirely and still delegate every callback here.
  """

  import Phoenix.Component, only: [assign: 3]
  import Phoenix.LiveView, only: [put_flash: 3, push_patch: 2, stream: 4]

  alias CorexAdmin.Action
  alias CorexAdmin.Export
  alias CorexAdmin.Gettext
  alias CorexAdmin.ListOpts
  alias CorexAdmin.Live.Helpers
  alias CorexAdmin.Page
  alias CorexAdmin.Params
  alias CorexAdmin.State.Filters
  alias Corex.DataTable.Selection

  @doc false
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:selected, [])
     |> assign(:entries, [])
     |> stream(:entries, [], reset: true)
     |> assign(:selection_table_id, nil)
     |> assign(:selection_row_id, nil)
     |> assign(:export_token, nil)
     |> assign(:canned_filters, [])
     |> assign(:filter_drafts, [])
     |> assign(:filter_bounds, %{})
     |> assign(:filter_options, %{})
     |> assign(:metrics, [])
     |> assign(:action_form, nil)
     |> assign(:table_row_item, &Function.identity/1)
     |> assign(:can_export, false)
     |> assign(:export_fields, [])}
  end

  @doc false
  def handle_params(params, _uri, socket) do
    slug = Helpers.resource_slug(socket, params)

    with {:ok, resource_mod} <- Helpers.fetch_resource(socket, slug),
         :ok <- Helpers.authorize(socket, :index, resource_mod, nil) do
      spec = Helpers.spec(resource_mod)
      list_opts = ListOpts.from_params(spec, params)
      scope = Helpers.actor(socket)

      case list_page(resource_mod, scope, list_opts) do
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

  @doc false
  def handle_event("search", params, socket) do
    spec = socket.assigns.spec
    current = ListOpts.to_params(socket.assigns.list_opts)

    next =
      socket
      |> merge_form_params(params)
      |> then(&Filters.reject_incomplete_ranges(spec, &1))

    parsed = ListOpts.to_params(ListOpts.from_params(spec, next))

    # Form changes echo every control, so most events are no-ops for the query.
    if query_equivalent?(parsed, current) do
      {:noreply, socket}
    else
      {:noreply, patch_index(socket, Map.put(parsed, "page", "1"))}
    end
  end

  def handle_event("filter", params, socket) do
    spec = socket.assigns.spec
    current = ListOpts.to_params(socket.assigns.list_opts)

    case Filters.merge_event(spec, current, params) do
      :ignore -> {:noreply, socket}
      merged -> {:noreply, patch_index(socket, Map.put(merged, "page", "1"))}
    end
  end

  def handle_event("filter_preset", %{"field" => field, "preset" => preset}, socket) do
    current = ListOpts.to_params(socket.assigns.list_opts)

    case Filters.apply_preset(current, field, preset) do
      :error -> {:noreply, socket}
      params -> {:noreply, patch_index(socket, Map.delete(params, "page"))}
    end
  end

  def handle_event("page_size", params, socket) do
    params =
      socket.assigns.list_opts
      |> ListOpts.to_params()
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
    params =
      socket.assigns.spec
      |> Filters.clear(ListOpts.to_params(socket.assigns.list_opts), field)
      |> Map.delete("page")

    {:noreply,
     socket
     |> drop_filter_draft(field)
     |> patch_and_sync(params, field)}
  end

  def handle_event("reset_filter", %{"field" => field}, socket) do
    params =
      socket.assigns.list_opts
      |> ListOpts.to_params()
      |> Filters.reset(field)
      |> Map.delete("page")

    {:noreply,
     socket
     |> drop_filter_draft(field)
     |> patch_and_sync(params, field)}
  end

  def handle_event("canned_filter", %{"index" => index}, socket) do
    case canned_filter_params(socket.assigns.canned_filters, index) do
      {:ok, params} ->
        {:noreply,
         socket
         |> assign(:filter_drafts, [])
         |> patch_index(Map.put(params, "page", "1"))}

      :error ->
        {:noreply, socket}
    end
  end

  def handle_event("apply_view", params, socket) do
    case Params.event_value(params) do
      "all" -> handle_event("reset_filters", %{}, socket)
      index -> handle_event("canned_filter", %{"index" => index}, socket)
    end
  end

  def handle_event("add_filter", params, socket) do
    name = Params.event_value(params)
    allowed = MapSet.new(socket.assigns.spec.filters, &Atom.to_string(&1.name))

    if is_binary(name) and MapSet.member?(allowed, name) do
      drafts = Enum.uniq(List.wrap(socket.assigns[:filter_drafts]) ++ [name])
      {:noreply, assign(socket, :filter_drafts, drafts)}
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
     |> patch_and_sync(params, :all)}
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
    run_bulk_action(socket, :bulk_delete, %{})
  end

  def handle_event("action", %{"name" => name} = params, socket) do
    with {:ok, action} <- fetch_action(socket.assigns.spec.record_actions, name) do
      run_record_action(socket, action.name(), params)
    else
      :error -> {:noreply, put_flash(socket, :error, Gettext.t("Could not run action."))}
    end
  end

  def handle_event("bulk_action", %{"name" => name} = params, socket) do
    with {:ok, action} <- fetch_action(socket.assigns.spec.bulk_actions, name) do
      run_bulk_action(socket, action.name(), params)
    else
      :error -> {:noreply, put_flash(socket, :error, Gettext.t("Could not run action."))}
    end
  end

  # Action names arrive from the client, so they are matched against the
  # resource's registered actions rather than converted to atoms.
  defp fetch_action(modules, name) when is_binary(name) do
    case Enum.find(modules, &(Atom.to_string(&1.name()) == name)) do
      nil -> :error
      mod -> {:ok, mod}
    end
  end

  defp fetch_action(_modules, _name), do: :error

  defp run_record_action(socket, name, payload) do
    spec = socket.assigns.spec
    resource_mod = socket.assigns.resource_mod
    scope = Helpers.actor(socket)

    with {:ok, mod} <- Action.fetch(spec.record_actions, name),
         {:ok, record} <- CorexAdmin.Context.fetch(spec, scope, record_id(payload)),
         :ok <- Helpers.authorize(socket, mod.policy_action(), resource_mod, record),
         {:ok, message} <- mod.handle(spec, scope, Map.put(payload, :record, record)) do
      {:noreply,
       socket
       |> put_flash(:info, message)
       |> push_patch(to: Helpers.index_path(socket, spec, socket.assigns.list_opts))}
    else
      {:error, :not_found} -> {:noreply, Helpers.not_found(socket)}
      {:error, reason} -> {:noreply, put_flash(socket, :error, action_error(reason))}
    end
  end

  defp run_bulk_action(socket, name, payload) do
    spec = socket.assigns.spec
    scope = Helpers.actor(socket)

    with {:ok, mod} <- Action.fetch(spec.bulk_actions, name),
         :ok <- Helpers.authorize(socket, mod.policy_action(), socket.assigns.resource_mod, nil) do
      payload =
        payload
        |> Params.stringify_shallow()
        |> Map.put("ids", socket.assigns.selected)
        |> Map.put(:assigns, socket)

      {kind, message} =
        case mod.handle(spec, scope, payload) do
          {:ok, msg} -> {:info, msg}
          {:error, reason} -> {:error, action_error(reason)}
        end

      {:noreply,
       socket
       |> assign(:selected, [])
       |> put_flash(kind, message)
       |> push_patch(to: Helpers.index_path(socket, spec, socket.assigns.list_opts))}
    else
      _ -> {:noreply, put_flash(socket, :error, Gettext.t("Could not run action."))}
    end
  end

  defp action_error(reason) when is_binary(reason), do: reason
  defp action_error(_reason), do: Gettext.t("Could not run action.")

  # Action dialogs post `record_id` rather than `id`, because a hidden input
  # named `id` would override the form element's own DOM id.
  defp record_id(payload), do: payload["id"] || payload["record_id"]

  defp list_page(resource_mod, scope, list_opts) do
    case resource_mod.query(scope, list_opts) do
      {:ok, page} ->
        last = Page.last_page(page)

        # A deep page can go out of range when filters narrow the result set.
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
    previous = socket.assigns[:list_opts]
    selected = if previous == list_opts, do: socket.assigns[:selected] || [], else: []
    scope = Helpers.actor(socket)

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
    |> assign(:selection_table_id, "#{spec.slug}-table")
    |> assign(:selection_row_id, fn row -> Helpers.record_id(spec, unwrap.(row)) end)
    |> assign(:table_row_item, unwrap)
    |> assign(:can_export, Helpers.authorize(socket, :export, resource_mod, nil) == :ok)
    |> assign(:canned_filters, Helpers.canned_filters(resource_mod))
    |> assign(:filter_bounds, Helpers.filter_bounds(resource_mod, spec, scope))
    |> assign(:filter_options, Helpers.filter_options(resource_mod, spec, scope))
    |> assign(:metrics, Helpers.metrics(resource_mod, scope, list_opts))
    |> assign_export_token()
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
      {_, params} when is_map(params) -> {:ok, Params.stringify(params)}
      %{params: params} when is_map(params) -> {:ok, Params.stringify(params)}
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

  defp patch_and_sync(socket, params, fields) do
    socket
    |> clear_filter_widgets(fields)
    |> patch_index(params)
  end

  # Zag widgets hold their own value; clearing the URL is not enough.
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
    spec = socket.assigns.spec
    id = Filters.control_id(spec.slug, filter)
    options = Map.get(socket.assigns[:filter_options] || %{}, filter.name, filter.options)
    option_count = length(List.wrap(options))

    cond do
      filter.type == :tags ->
        Corex.TagsInput.set_value(socket, id, [])

      filter.type in [:select, :multi_select, :boolean, :presence, :relative_date] and
          option_count > 12 ->
        Corex.Combobox.set_value(socket, id, [])

      filter.type in [:select, :multi_select, :boolean, :presence, :relative_date] ->
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

  defp merge_form_params(socket, params) do
    current = ListOpts.to_params(socket.assigns.list_opts)
    incoming = params |> Params.stringify_shallow() |> Map.drop(["_target", "_unused"])
    {filters, incoming} = Map.pop(incoming, "filters")

    current
    |> Map.merge(incoming)
    |> merge_incoming_filters(filters)
  end

  defp merge_incoming_filters(current, incoming) when is_map(incoming) do
    left = Params.stringify(Map.get(current, "filters", %{}))
    right = Params.stringify(incoming)

    left
    |> Map.merge(right, fn _key, old, new ->
      if is_map(old) and is_map(new), do: Map.merge(old, new), else: new
    end)
    |> Filters.put_filters(current)
  end

  defp merge_incoming_filters(current, _), do: current

  defp query_equivalent?(left, right) do
    normalize_query(left) == normalize_query(right)
  end

  defp normalize_query(params) when is_map(params) do
    %{
      "q" => presence(Map.get(params, "q")),
      "filters" => presence(Map.get(params, "filters")),
      "sort" => Map.get(params, "sort"),
      "dir" => Map.get(params, "dir"),
      "page_size" => Map.get(params, "page_size")
    }
  end

  defp presence(value), do: if(Params.blank?(value), do: nil, else: value)

  defp page_size_param(%{"page_size" => value}), do: value
  defp page_size_param(params), do: Params.event_value(params)

  defp toggle_dir({field, :asc}, sort_by) do
    if Atom.to_string(field) == to_string(sort_by), do: "desc", else: "asc"
  end

  defp toggle_dir(_, _), do: "asc"

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
