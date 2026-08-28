defmodule CorexAdmin.Filter.Cast do
  @moduledoc """
  Casting primitives shared by filter modules.

  Filter modules turn untrusted params into canonical values. These helpers do
  the type work and always answer `nil` for "not a usable value", so a filter's
  `parse/2` stays a description of its own shape.
  """

  alias CorexAdmin.Params
  alias CorexAdmin.Resource.Filter

  @doc "Trimmed string, or nil when blank."
  @spec text(term()) :: String.t() | nil
  def text(%{contains: value}), do: text(value)
  def text(%{value: value}), do: text(value)
  def text(%{"contains" => value}), do: text(value)
  def text(%{"value" => value}), do: text(value)

  def text(value) when is_binary(value) do
    case String.trim(value) do
      "" -> nil
      trimmed -> trimmed
    end
  end

  def text(value) when is_number(value), do: to_string(value)
  def text(_), do: nil

  @doc "Integer or float, or nil."
  @spec number(term()) :: number() | nil
  def number(value) when is_integer(value), do: value
  def number(value) when is_float(value), do: value

  def number(value) when is_binary(value) do
    trimmed = String.trim(value)

    case Integer.parse(trimmed) do
      {int, ""} ->
        int

      _ ->
        case Float.parse(trimmed) do
          {float, ""} -> float
          _ -> nil
        end
    end
  end

  def number(_), do: nil

  @doc "Lowercased single token from a scalar or one-element list."
  @spec token(term()) :: String.t()
  def token(value) when is_list(value), do: token(List.first(value))
  def token(value) when is_binary(value), do: value |> String.trim() |> String.downcase()
  def token(true), do: "true"
  def token(false), do: "false"
  def token(_), do: ""

  @doc """
  Deduplicated list of allowed option values.

  Comma-joined strings are split, so a URL may carry either repeated keys or one
  joined value. When the filter declares `options:`, anything outside them is
  dropped rather than passed to the query.
  """
  @spec option_list(Filter.t(), term()) :: [String.t()] | nil
  def option_list(%Filter{} = filter, value) do
    allowed = option_values(filter)

    value
    |> List.wrap()
    |> Enum.flat_map(&split_multi/1)
    |> Enum.map(&to_string/1)
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.filter(&(allowed == [] or &1 in allowed))
    |> Enum.uniq()
    |> case do
      [] -> nil
      list -> list
    end
  end

  @doc "Single allowed option value, or nil."
  @spec option(Filter.t(), term()) :: String.t() | nil
  def option(%Filter{} = filter, value) do
    value = if is_list(value), do: List.first(value), else: value

    case text(value) do
      nil ->
        nil

      trimmed ->
        allowed = option_values(filter)
        if allowed == [] or trimmed in allowed, do: trimmed, else: nil
    end
  end

  @doc "Declared option values as strings."
  @spec option_values(Filter.t()) :: [String.t()]
  def option_values(%Filter{options: options}) when is_list(options) do
    Enum.map(options, fn
      {_label, value} -> to_string(value)
      value -> to_string(value)
    end)
  end

  def option_values(_), do: []

  @doc """
  `%{from: _, to: _}` range of `kind`, or nil.

  Accepts a map, a `"from,to"` string, or a two-element list, because the URL,
  the date picker, and native inputs each use a different one.
  """
  @spec range(term(), :date | :datetime) :: map() | nil
  def range(value, kind) when is_list(value) do
    range(Enum.map_join(value, ",", &to_string/1), kind)
  end

  def range(value, kind) when is_binary(value) do
    case String.split(value, ",", trim: true) do
      [from, to] -> range(%{"from" => from, "to" => to}, kind)
      [from] -> range(%{"from" => from}, kind)
      _ -> nil
    end
  end

  def range(value, kind) when is_map(value) and not is_struct(value) do
    map = Params.stringify(value)

    compact(%{
      from: bound(kind, Map.get(map, "from")),
      to: bound(kind, Map.get(map, "to"))
    })
  end

  def range(_value, _kind), do: nil

  @doc "`%{min: _, max: _}` numeric range, or nil."
  @spec number_range(term()) :: map() | nil
  def number_range(value) when is_list(value) do
    case value do
      [min, max] -> number_range(%{"min" => min, "max" => max})
      _ -> nil
    end
  end

  def number_range(value) when is_map(value) and not is_struct(value) do
    map = Params.stringify(value)

    compact(%{
      min: number(Map.get(map, "min")),
      max: number(Map.get(map, "max"))
    })
  end

  def number_range(_), do: nil

  @doc "Map without nil values, or nil when nothing is left."
  @spec compact(map()) :: map() | nil
  def compact(map) when is_map(map) do
    map
    |> Enum.reject(fn {_key, value} -> is_nil(value) end)
    |> Map.new()
    |> case do
      empty when empty == %{} -> nil
      kept -> kept
    end
  end

  @doc """
  Splits `value` into `{operator, inner}` using the filter's allowlist.

  An operator outside `operators:` falls back to the default rather than
  reaching the query.
  """
  @spec split_op(Filter.t(), term()) :: {atom() | nil, term()}
  def split_op(%Filter{} = filter, value) when is_map(value) and not is_struct(value) do
    map = Params.stringify(value)
    op = allowed_op(filter, Map.get(map, "op"))
    inner = Map.get(map, "value", Map.get(map, "contains", Map.get(map, "q")))
    {op || Filter.default_operator(filter), inner}
  end

  def split_op(%Filter{} = filter, value), do: {Filter.default_operator(filter), value}

  @doc """
  Wraps `parsed` with `op`, compacting the default operator away.

  Keeping the default implicit means the common case produces a short URL
  (`filters[email]=ops`) instead of `filters[email][op]=contains`.
  """
  @spec wrap_op(Filter.t(), atom() | nil, term()) :: term() | nil
  def wrap_op(%Filter{} = filter, op, parsed) do
    default = Filter.default_operator(filter)

    cond do
      is_nil(parsed) and op not in [nil, default] -> %{op: op}
      is_nil(parsed) -> nil
      op != default -> %{op: op, value: parsed}
      op == :contains -> %{contains: parsed}
      op in [nil, :equals, :eq, :in] -> parsed
      true -> %{op: op, value: parsed}
    end
  end

  @doc "Parses `value` with `parser` and wraps the result in the chosen operator."
  @spec op_filter(Filter.t(), term(), (term() -> term() | nil)) :: term() | nil
  def op_filter(%Filter{} = filter, value, parser) do
    {op, inner} = split_op(filter, value)
    wrap_op(filter, op, parser.(inner))
  end

  defp allowed_op(filter, raw) do
    op = Filter.parse_atom(raw)
    if op in Filter.operators(filter), do: op, else: nil
  end

  defp split_multi(value) when is_binary(value) do
    if String.contains?(value, ","), do: String.split(value, ",", trim: true), else: [value]
  end

  defp split_multi(value), do: [value]

  defp bound(:date, %Date{} = date), do: date

  defp bound(:date, value) when is_binary(value) do
    case Date.from_iso8601(String.trim(value)) do
      {:ok, date} -> date
      _ -> nil
    end
  end

  defp bound(:datetime, %DateTime{} = dt), do: dt
  defp bound(:datetime, %NaiveDateTime{} = dt), do: DateTime.from_naive!(dt, "Etc/UTC")

  defp bound(:datetime, value) when is_binary(value) do
    trimmed = value |> String.trim() |> String.replace(" ", "T")

    cond do
      dt = datetime_from_iso8601(trimmed) -> DateTime.truncate(dt, :second)
      ndt = naive_from_iso8601(pad_seconds(trimmed)) -> DateTime.from_naive!(ndt, "Etc/UTC")
      date = date_from_iso8601(trimmed) -> DateTime.new!(date, ~T[00:00:00], "Etc/UTC")
      true -> nil
    end
  end

  defp bound(_kind, _), do: nil

  defp datetime_from_iso8601(value) do
    case DateTime.from_iso8601(value) do
      {:ok, dt, _} -> dt
      _ -> nil
    end
  end

  defp naive_from_iso8601(value) do
    case NaiveDateTime.from_iso8601(value) do
      {:ok, ndt} -> ndt
      _ -> nil
    end
  end

  defp date_from_iso8601(value) do
    case Date.from_iso8601(value) do
      {:ok, date} -> date
      _ -> nil
    end
  end

  # `datetime-local` inputs omit seconds.
  defp pad_seconds(value) do
    case String.split(value, "T") do
      [date, time] ->
        time = if length(String.split(time, ":")) == 2, do: time <> ":00", else: time
        date <> "T" <> time

      _ ->
        value
    end
  end
end
