defmodule CorexAdmin.Live.Index do
  @moduledoc false

  use Phoenix.LiveView
  use Corex

  alias CorexAdmin.Context
  alias CorexAdmin.ListOpts
  alias CorexAdmin.Live.Components
  alias CorexAdmin.Live.Helpers
  alias Phoenix.LiveView.JS

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    slug = params["resource"]

    with {:ok, resource_mod} <- Helpers.fetch_resource(socket, slug),
         :ok <- Helpers.authorize(socket, :index, resource_mod, nil) do
      spec = Helpers.spec(resource_mod)
      list_opts = ListOpts.from_params(spec, params)
      scope = Helpers.actor(socket)

      case Context.list(spec, scope, list_opts) do
        {:ok, page} ->
          {:noreply,
           socket
           |> assign(:page_title, spec.label)
           |> assign(:resource_mod, resource_mod)
           |> assign(:spec, spec)
           |> assign(:list_opts, list_opts)
           |> assign(:page, page)
           |> assign(:index_fields, Helpers.index_fields(spec))}

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
    <Components.shell :if={assigns[:spec]} socket={assigns} current={@spec}>
      <Components.breadcrumbs prefix={@corex_admin_prefix} spec={@spec} live_action={:index} />
      <.layout_heading class="layout-heading">
        <:title>{@spec.label}</:title>
        <:actions>
          <.navigate
            :if={Helpers.authorize(assigns, :new, @resource_mod, nil) == :ok}
            to={Helpers.new_path(assigns, @spec)}
            type="navigate"
            class="button ui-accent"
            aria_label={"New #{@spec.label}"}
          >
            <.heroicon name="hero-plus" /> New
          </.navigate>
        </:actions>
      </.layout_heading>

      <form id={"#{@spec.slug}-search"} phx-change="search" class="flex flex-wrap items-end gap-space">
        <.native_input
          :if={@list_opts.search_fields != []}
          id={"#{@spec.slug}-search-q"}
          type="search"
          name="q"
          value={@list_opts.search}
          class="native-input"
        >
          <:label>Search</:label>
        </.native_input>
        <.native_input
          :for={filter <- @spec.filters}
          id={"#{@spec.slug}-filter-#{filter.name}"}
          type={filter_input_type(filter)}
          name={"filters[#{filter.name}]"}
          value={Map.get(@list_opts.filters, filter.name)}
          options={filter_options(filter)}
          prompt="Any"
          class="native-input"
        >
          <:label>{filter.label}</:label>
        </.native_input>
      </form>

      <.data_table
        id={"#{@spec.slug}-table"}
        class="data-table max-w-none"
        rows={@page.entries}
        sort_by={sort_by(@list_opts)}
        sort_order={sort_order(@list_opts)}
        on_sort="sort"
        row_click={fn record -> JS.navigate(Helpers.record_path(assigns, @spec, record)) end}
      >
        <:empty>No {@spec.label} yet.</:empty>
        <:col
          :let={record}
          :for={field <- @index_fields}
          label={field.label}
          name={if(field.sortable, do: field.name)}
        >
          <Components.field_value field={field} record={record} />
        </:col>
        <:action :let={record}>
          <.navigate
            to={Helpers.record_path(assigns, @spec, record)}
            type="navigate"
            class="button ui-size-sm"
            aria_label="Show"
          >
            <.heroicon name="hero-eye" />
          </.navigate>
        </:action>
        <:action :let={record}>
          <.navigate
            :if={Helpers.authorize(assigns, :edit, @resource_mod, record) == :ok}
            to={Helpers.edit_path(assigns, @spec, record)}
            type="navigate"
            class="button ui-size-sm"
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

      <.pagination
        :if={@page.total > @page.page_size}
        id={"#{@spec.slug}-pagination"}
        class="pagination"
        count={@page.total}
        page={@page.page}
        page_size={@page.page_size}
        type={:link}
        to={Helpers.pagination_to(assigns, @spec, @list_opts)}
        page_param="page"
        page_size_param="page_size"
      >
        <:prev_trigger><.heroicon name="hero-chevron-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-chevron-right" /></:next_trigger>
        <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
      </.pagination>
    </Components.shell>
    """
  end

  @impl true
  def handle_event("search", params, socket) do
    spec = socket.assigns.spec
    list_opts = ListOpts.from_params(spec, Map.put(params, "page", "1"))
    {:noreply, push_patch(socket, to: Helpers.index_path(socket, spec, list_opts))}
  end

  def handle_event("sort", %{"sort_by" => sort_by}, socket) do
    spec = socket.assigns.spec
    current = socket.assigns.list_opts

    params =
      ListOpts.to_params(current)
      |> Map.put("sort", sort_by)
      |> Map.put("dir", toggle_dir(current.sort, sort_by))
      |> Map.delete("page")

    list_opts = ListOpts.from_params(spec, params)
    {:noreply, push_patch(socket, to: Helpers.index_path(socket, spec, list_opts))}
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

  defp filter_input_type(%{type: :select}), do: "select"
  defp filter_input_type(_), do: "text"

  defp filter_options(%{options: options}) when is_list(options) do
    Enum.map(options, fn
      {label, value} -> {to_string(label), to_string(value)}
      value -> {to_string(value), to_string(value)}
    end)
  end

  defp filter_options(_), do: nil
end
