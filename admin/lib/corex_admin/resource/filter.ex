defmodule CorexAdmin.Resource.Filter do
  @moduledoc false

  defstruct [
    :name,
    :type,
    :label,
    :options,
    :field,
    :min,
    :max,
    :operators,
    :default_operator,
    pin: true
  ]

  @type t :: %__MODULE__{
          name: atom(),
          type: atom(),
          label: String.t(),
          options: [term()] | nil,
          field: atom(),
          pin: boolean(),
          min: number() | nil,
          max: number() | nil,
          operators: [atom()] | nil,
          default_operator: atom() | nil
        }

  @text_ops [:contains, :equals, :starts_with, :ends_with, :not_contains]
  @select_ops [:in, :not_in]
  @number_ops [:eq, :gte, :lte]
  @relative_windows [
    :today,
    :yesterday,
    :last_7,
    :last_30,
    :last_90,
    :this_week,
    :this_month,
    :this_quarter,
    :ytd
  ]

  @doc "Operators allowed for a filter type."
  def allowed_operators(:text), do: @text_ops
  def allowed_operators(:id), do: [:equals]
  def allowed_operators(:number), do: @number_ops
  def allowed_operators(type) when type in [:select, :multi_select, :tags], do: @select_ops
  def allowed_operators(_), do: []

  @doc "Default operators when the resource does not set `operators:`."
  def default_operators(:text), do: @text_ops
  def default_operators(:id), do: [:equals]
  def default_operators(:number), do: @number_ops
  def default_operators(type) when type in [:select, :multi_select, :tags], do: [:in]
  def default_operators(_), do: []

  @known_atoms Map.new(
                 @text_ops ++ @select_ops ++ @number_ops ++ @relative_windows ++ [:equals],
                 &{Atom.to_string(&1), &1}
               )

  @doc "Allowlisted operators for this filter, in display order."
  def operators(%__MODULE__{} = filter) do
    allowed = allowed_operators(filter.type)

    case filter.operators do
      list when is_list(list) and list != [] ->
        list
        |> Enum.map(&cast_op/1)
        |> Enum.filter(&(&1 in allowed))

      _ ->
        default_operators(filter.type)
    end
  end

  @doc "Operator used when the URL omits `op`."
  def default_operator(%__MODULE__{} = filter) do
    ops = operators(filter)
    op = cast_op(filter.default_operator)

    if op in ops, do: op, else: List.first(ops)
  end

  def relative_window_ids, do: @relative_windows

  @doc "Named rolling windows for `:relative_date` (config `options:` or the full set)."
  def relative_windows(%__MODULE__{type: :relative_date} = filter) do
    case filter.options do
      list when is_list(list) and list != [] ->
        list
        |> Enum.map(&cast_op/1)
        |> Enum.filter(&(&1 in @relative_windows))

      _ ->
        @relative_windows
    end
  end

  def relative_windows(_), do: []

  @doc "Inclusive `{from, to}` calendar dates for a named window."
  def relative_bounds(window, today \\ Date.utc_today())

  def relative_bounds(window, today) when is_atom(window) do
    relative_bounds(Atom.to_string(window), today)
  end

  def relative_bounds("today", today), do: {today, today}

  def relative_bounds("yesterday", today) do
    day = Date.add(today, -1)
    {day, day}
  end

  def relative_bounds("last_7", today), do: {Date.add(today, -6), today}
  def relative_bounds("last_30", today), do: {Date.add(today, -29), today}
  def relative_bounds("last_90", today), do: {Date.add(today, -89), today}
  def relative_bounds("this_week", today), do: {Date.beginning_of_week(today, :monday), today}
  def relative_bounds("this_month", today), do: {%{today | day: 1}, today}

  def relative_bounds("this_quarter", today) do
    start_month = div(today.month - 1, 3) * 3 + 1
    {Date.new!(today.year, start_month, 1), today}
  end

  def relative_bounds("ytd", today), do: {%{today | month: 1, day: 1}, today}
  def relative_bounds(_, _), do: :error

  @doc "Whether a parsed filter value constrains the query."
  def active_value?(value) do
    case value do
      nil -> false
      "" -> false
      [] -> false
      %{op: _, value: inner} -> active_value?(inner)
      %{op: _} -> false
      %{contains: inner} -> active_value?(inner)
      %{relative: window} when window not in [nil, ""] -> true
      map when is_map(map) -> map != %{}
      _ -> true
    end
  end

  def parse_atom(value) when is_atom(value), do: value
  def parse_atom(value) when is_binary(value), do: Map.get(@known_atoms, value)
  def parse_atom(_), do: nil

  defp cast_op(op), do: parse_atom(op)
end
