defmodule E2eWeb.DataTablePatternState do
  @moduledoc false

  import Phoenix.Component, only: [assign: 3]

  def handle_sort_ns(socket, %{"sort_by" => sort_by_param},
        rows: rows_k,
        sort_by: by_k,
        sort_order: order_k,
        sort_columns: sort_columns
      ) do
    case Corex.DataTable.Sort.parse_sort_by(sort_by_param, sort_columns) do
      {:ok, sort_by} ->
        current_by = Map.fetch!(socket.assigns, by_k)
        current_order = Map.fetch!(socket.assigns, order_k)

        {next_by, next_order} =
          if current_by == sort_by do
            {sort_by, toggle(current_order)}
          else
            {sort_by, :asc}
          end

        raw_rows = Map.fetch!(socket.assigns, rows_k)

        socket
        |> assign(by_k, next_by)
        |> assign(order_k, next_order)
        |> assign(rows_k, sort_rows(raw_rows, next_by, next_order))

      :error ->
        socket
    end
  end

  def handle_select_ns(
        socket,
        %{"id" => checkbox_id} = params,
        rows: rows_k,
        selected: selected_k,
        table_id: table_id
      ) do
    checked = Map.get(params, "checked", false)
    row_key = String.replace(checkbox_id, "#{table_id}-select-", "")
    rows = Map.fetch!(socket.assigns, rows_k) || []
    cur = Map.fetch!(socket.assigns, selected_k)

    selected =
      if checked_on?(checked) do
        [row_key | cur] |> Enum.uniq()
      else
        List.delete(cur, row_key)
      end

    all? = match?([_ | _], rows) and length(selected) == length(rows)

    socket
    |> assign(selected_k, selected)
    |> Corex.Checkbox.set_checked("#{table_id}-select-all", all?)
  end

  def handle_select_all_ns(
        socket,
        %{"checked" => checked},
        rows: rows_k,
        selected: selected_k,
        table_id: table_id,
        row_id: row_id_fn
      ) do
    rows = Map.fetch!(socket.assigns, rows_k) || []
    checked? = checked_on?(checked)

    selected = if(checked?, do: Enum.map(rows, row_id_fn), else: [])

    socket = assign(socket, selected_k, selected)

    socket =
      Enum.reduce(rows, socket, fn row, acc ->
        Corex.Checkbox.set_checked(acc, "#{table_id}-select-#{row_id_fn.(row)}", checked?)
      end)

    socket
  end

  defp checked_on?(c) when c in [true, "true", "on"], do: true
  defp checked_on?(c) when c in [false, "false", nil, ""], do: false
  defp checked_on?(_), do: false

  defp toggle(:asc), do: :desc
  defp toggle(:desc), do: :asc

  def sort_rows(rows, nil, _order), do: rows

  def sort_rows(rows, sort_by, order) do
    Enum.sort_by(rows, &Map.get(&1, sort_by), fn a, b ->
      case order do
        :asc -> a <= b
        :desc -> a >= b
      end
    end)
  end
end
