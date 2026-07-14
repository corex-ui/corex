defmodule Corex.DataTable.Sort do
  import Phoenix.Component, only: [assign: 3]

  @moduledoc """
  Helpers for sortable [`data_table/1`](Corex.DataTable.html#data_table/1) usage in LiveViews.

  Use with [`Corex.DataTable`](Corex.DataTable.html): set `sort_by`, `sort_order`, `on_sort`, and
  a `name` on each sortable column (see the **Sortable** pattern in
  [`data_table/1`](Corex.DataTable.html#data_table/1) docs). In the LiveView, call
  `assign_for_sort/3` in `mount/3`, then `handle_sort/3` from the `on_sort` event handler.

  Set `:sort_columns` in `assign_for_sort/3` to whitelist sortable columns on the server. When
  omitted, `:sort_columns` is inferred from atom keys on the first row map. Prefer an explicit
  list when rows carry extra keys not shown in the table.

  ## Example (in-memory rows)

      def mount(_params, _session, socket) do
        socket =
          socket
          |> assign(:users, fetch_users())
          |> Corex.DataTable.Sort.assign_for_sort(:users,
            default_sort_by: :id,
            default_sort_order: :asc,
            sort_columns: [:id, :name]
          )

        {:ok, socket}
      end

      def handle_event("sort", params, socket) do
        {:noreply, Corex.DataTable.Sort.handle_sort(socket, params, :users)}
      end

      def render(assigns) do
        ~H\"\"\"
        <.data_table
          id="users-table"
          rows={@users}
          sort_by={@sort_by}
          sort_order={@sort_order}
          on_sort="sort"
        >
          <:col :let={user} label="ID" name={:id}>{user.id}</:col>
          <:col :let={user} label="Name" name={:name}>{user.name}</:col>
        </.data_table>
        \"\"\"
      end

  ## Example (database-backed rows)

      def mount(_params, _session, socket) do
        {rows, total} = MyApp.list_cities(page: 1, page_size: 10, order_by: :name, order_dir: :asc)

        {:ok,
         socket
         |> assign(:cities, rows)
         |> assign(:sort_columns, [:name])
         |> assign(:sort_by, :name)
         |> assign(:sort_order, :asc)
         |> assign(:total, total)}
      end

      def handle_event("sort", %{"sort_by" => sort_by_param}, socket) do
        case Corex.DataTable.Sort.parse_sort_by(sort_by_param, socket.assigns.sort_columns) do
          {:ok, sort_by} ->
            order =
              if socket.assigns.sort_by == sort_by do
                if socket.assigns.sort_order == :asc, do: :desc, else: :asc
              else
                :asc
              end

            {rows, total} =
              MyApp.list_cities(
                page: 1,
                page_size: socket.assigns.page_size,
                order_by: sort_by,
                order_dir: order
              )

            {:noreply,
             socket
             |> assign(:cities, rows)
             |> assign(:sort_by, sort_by)
             |> assign(:sort_order, order)
             |> assign(:total, total)}

          :error ->
            {:noreply, socket}
        end
      end
  """

  @doc """
  Assigns sort state and sorts the rows for a [`data_table/1`](Corex.DataTable.html#data_table/1) instance.

  Use in `mount/3` after assigning the list. Options:

  - `:default_sort_by` – atom; column `name` on [`data_table/1`](Corex.DataTable.html#data_table/1) (e.g. `:id`)
  - `:default_sort_order` – `:asc` or `:desc`, default `:asc`
  - `:sort_columns` – list of atoms the browser may sort by (e.g. `[:id, :name]`). When omitted,
    inferred from atom keys on the first row in `rows_assign`. Prefer an explicit list in
    production when row maps include keys you do not expose as sortable columns.

  The socket must already have an assign at `rows_assign` (e.g. `:users`) with the same list
  passed as `rows` to [`data_table/1`](Corex.DataTable.html#data_table/1). Adds `:sort_by`,
  `:sort_order`, `:sort_columns`, and replaces the rows assign with the sorted list.
  """
  def assign_for_sort(socket, rows_assign, opts \\ []) do
    sort_by = Keyword.get(opts, :default_sort_by)
    sort_order = Keyword.get(opts, :default_sort_order, :asc)
    rows = socket.assigns[rows_assign] || []

    sort_columns =
      case Keyword.fetch(opts, :sort_columns) do
        {:ok, columns} -> columns
        :error -> infer_sort_columns(rows, sort_by)
      end

    socket
    |> assign(:sort_by, sort_by)
    |> assign(:sort_order, sort_order)
    |> assign(:sort_columns, sort_columns)
    |> assign(rows_assign, sort_rows(rows, sort_by, sort_order))
  end

  @doc """
  Handles the `on_sort` event from [`data_table/1`](Corex.DataTable.html#data_table/1) and returns the updated socket.

  Use in `handle_event("sort", params, socket)` (same name as `on_sort`) and return
  `{:noreply, Corex.DataTable.Sort.handle_sort(socket, params, :users)}`.

  `params` must contain `"sort_by"` (string, e.g. `"id"`). Only columns in `:sort_columns` from
  [`assign_for_sort/3`](#assign_for_sort/3) are accepted. Unknown or disallowed values never crash
  the LiveView process.

  `rows_assign` is the assign key passed to [`data_table/1`](Corex.DataTable.html#data_table/1) as `rows`.
  """
  def handle_sort(socket, %{"sort_by" => sort_by_param}, rows_assign) do
    case parse_sort_by(sort_by_param, socket.assigns[:sort_columns]) do
      {:ok, sort_by} -> apply_sort(socket, sort_by, rows_assign)
      :error -> socket
    end
  end

  @doc """
  Like [`handle_sort/3`](#handle_sort/3), but keeps sort state per table `id`.

  Expects `"table_id"` and `"sort_by"` in `params` (sent by [`data_table/1`](Corex.DataTable.html#data_table/1)).
  Stores `%{sort_by, sort_order}` under `:data_table_sort` keyed by table id. Does not mutate rows;
  use [`sorted_rows/3`](#sorted_rows/3) when rendering each table.
  """
  def handle_sort_for(socket, params, opts \\ [])

  def handle_sort_for(socket, %{"sort_by" => sort_by_param, "table_id" => table_id}, opts)
      when is_binary(table_id) do
    sort_columns = Keyword.get(opts, :sort_columns, socket.assigns[:sort_columns])

    case parse_sort_by(sort_by_param, sort_columns) do
      {:ok, sort_by} ->
        sorts = socket.assigns[:data_table_sort] || %{}
        current = Map.get(sorts, table_id, %{sort_by: nil, sort_order: :asc})

        {sort_by, sort_order} =
          if current.sort_by == sort_by do
            {sort_by, toggle_sort_order(current.sort_order)}
          else
            {sort_by, :asc}
          end

        assign(socket, :data_table_sort, Map.put(sorts, table_id, %{sort_by: sort_by, sort_order: sort_order}))

      :error ->
        socket
    end
  end

  def handle_sort_for(socket, _params, _opts), do: socket

  @doc """
  Returns `%{sort_by: atom | nil, sort_order: :asc | :desc}` for a table id from `:data_table_sort`.
  """
  def sort_state(assigns_or_socket, table_id, default \\ %{sort_by: nil, sort_order: :asc})

  def sort_state(%Phoenix.LiveView.Socket{} = socket, table_id, default) do
    sort_state(socket.assigns, table_id, default)
  end

  def sort_state(%{} = assigns, table_id, default) when is_binary(table_id) do
    Map.get(assigns[:data_table_sort] || %{}, table_id, default)
  end

  @doc """
  Sorts `rows` by `sort_by` / `sort_order` without touching the socket.
  """
  def sorted_rows(rows, sort_by, sort_order), do: sort_rows(rows, sort_by, sort_order)

  def sorted_rows(rows, %{sort_by: sort_by, sort_order: sort_order}),
    do: sort_rows(rows, sort_by, sort_order)

  @doc """
  Parses a `"sort_by"` param from a LiveView event against an optional column whitelist.

  Returns `{:ok, atom}` when the param is a safe existing atom and is allowed, or `:error` otherwise.
  When `sort_columns` is `nil`, always returns `:error`. Use in database-backed handlers before
  calling your context with `order_by`.
  """
  def parse_sort_by(param, columns) when is_binary(param) and is_list(columns) do
    with {:ok, sort_by} <- safe_existing_atom(param), true <- sort_by in columns do
      {:ok, sort_by}
    else
      _ -> :error
    end
  end

  def parse_sort_by(_param, _columns), do: :error

  defp infer_sort_columns([], nil), do: []

  defp infer_sort_columns([], sort_by) when is_atom(sort_by), do: [sort_by]

  defp infer_sort_columns([row | _], _sort_by) when is_map(row) do
    row
    |> Map.keys()
    |> Enum.filter(&is_atom/1)
  end

  defp infer_sort_columns(_, _), do: []

  defp apply_sort(socket, sort_by, rows_assign) do
    current_sort_by = socket.assigns.sort_by
    current_sort_order = socket.assigns.sort_order

    {sort_by, sort_order} =
      if current_sort_by == sort_by do
        {sort_by, toggle_sort_order(current_sort_order)}
      else
        {sort_by, :asc}
      end

    rows = socket.assigns[rows_assign] || []

    socket
    |> assign(:sort_by, sort_by)
    |> assign(:sort_order, sort_order)
    |> assign(rows_assign, sort_rows(rows, sort_by, sort_order))
  end

  defp safe_existing_atom(param) when is_binary(param) do
    {:ok, String.to_existing_atom(param)}
  rescue
    ArgumentError -> :error
  end

  defp toggle_sort_order(:asc), do: :desc
  defp toggle_sort_order(:desc), do: :asc

  defp sort_rows(rows, nil, _sort_order), do: rows

  defp sort_rows(rows, sort_by, sort_order) do
    Enum.sort_by(rows, &Map.get(&1, sort_by), fn a, b ->
      case sort_order do
        :asc -> a <= b
        :desc -> a >= b
      end
    end)
  end
end
