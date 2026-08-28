defmodule CorexAdmin.ListOpts do
  @moduledoc """
  Allowlisted list options parsed from URL query params.

  Unknown sort/filter keys are dropped. `page_size` must be in the resource
  `page_size_options` (and is capped). Field names are resolved through the
  resource allowlist — user input is never turned into an unbounded atom.

  Filters come only from the resource `filters do` block.
  """

  alias CorexAdmin.Resource.Filter
  alias CorexAdmin.Resource.Spec

  @enforce_keys [:page, :page_size]
  defstruct page: 1,
            page_size: 25,
            page_size_default: 25,
            sort: nil,
            sort_default: nil,
            search: nil,
            search_fields: [],
            filters: %{},
            filter_defaults: %{},
            filter_fields: %{},
            filters_cleared: MapSet.new()

  @type filter_value ::
          String.t()
          | boolean()
          | number()
          | [String.t()]
          | %{
              optional(:from) => Date.t() | DateTime.t() | NaiveDateTime.t(),
              optional(:to) => term()
            }
          | %{optional(:min) => number(), optional(:max) => number()}
          | %{optional(:op) => atom(), optional(:value) => term()}
          | %{optional(:contains) => String.t()}
          | %{optional(:relative) => atom()}
          | :empty
          | :set

  @type t :: %__MODULE__{
          page: pos_integer(),
          page_size: pos_integer(),
          page_size_default: pos_integer(),
          sort: {atom(), :asc | :desc} | nil,
          sort_default: {atom(), :asc | :desc} | nil,
          search: String.t() | nil,
          search_fields: [atom()],
          filters: %{optional(atom()) => filter_value()},
          filter_defaults: %{optional(atom()) => filter_value()},
          filter_fields: %{optional(atom()) => atom()},
          filters_cleared: MapSet.t(atom())
        }

  @doc "Builds list opts from a params map using the resource allowlist."
  @spec from_params(struct(), map()) :: t()
  def from_params(%Spec{} = spec, params) when is_map(params) do
    params = stringify_keys(params)
    page_size_default = default_page_size(spec)
    options = CorexAdmin.page_size_options(spec)
    {filters, cleared, defaults} = parse_filters(spec, params)

    %__MODULE__{
      page: parse_positive_int(params["page"], 1),
      page_size: parse_page_size(params["page_size"], page_size_default, options),
      page_size_default: page_size_default,
      sort: parse_sort(spec, params),
      sort_default: spec.default_sort,
      search: parse_search(params["q"]),
      search_fields: searchable_names(spec),
      filters: filters,
      filter_defaults: defaults,
      filter_fields: Map.new(spec.filters, &{&1.name, &1.field}),
      filters_cleared: cleared
    }
  end

  @doc "Query params that should be preserved on index patches."
  @spec to_params(t()) :: map()
  def to_params(%__MODULE__{} = opts) do
    %{}
    |> put_unless(opts.page == 1, "page", Integer.to_string(opts.page))
    |> put_unless(
      opts.page_size == opts.page_size_default,
      "page_size",
      Integer.to_string(opts.page_size)
    )
    |> put_sort(opts.sort, opts.sort_default)
    |> put_unless(blank?(opts.search), "q", opts.search)
    |> put_filters(opts)
  end

  @doc "Whether search or any filter is active."
  @spec filtered?(t()) :: boolean()
  def filtered?(%__MODULE__{search: search, filters: filters}) do
    not blank?(search) or filters != %{}
  end

  defp default_page_size(%Spec{} = spec) do
    options = CorexAdmin.page_size_options(spec)
    default = spec.page_size || CorexAdmin.default_page_size()

    cond do
      default in options -> default
      options != [] -> hd(options)
      true -> default
    end
  end

  defp parse_page_size(value, default, options) do
    parsed = parse_positive_int(value, default)

    cond do
      parsed in options -> parsed
      true -> default
    end
  end

  defp parse_positive_int(value, default) when is_binary(value) do
    case Integer.parse(value) do
      {int, ""} when int > 0 -> int
      _ -> default
    end
  end

  defp parse_positive_int(value, _default) when is_integer(value) and value > 0, do: value
  defp parse_positive_int(_value, default), do: default

  defp parse_search(value) when is_binary(value) do
    case String.trim(value) do
      "" -> nil
      trimmed -> String.slice(trimmed, 0, 200)
    end
  end

  defp parse_search(_), do: nil

  defp parse_sort(spec, params) do
    allowed = sortable_map(spec)
    sort_by = params["sort"] || params["sort_by"]
    dir = params["dir"] || params["sort_order"]

    case Map.fetch(allowed, sort_key(sort_by)) do
      {:ok, field} -> {field, parse_dir(dir)}
      :error -> spec.default_sort
    end
  end

  defp sort_key(value) when is_binary(value), do: value
  defp sort_key(_), do: ""

  defp parse_dir("desc"), do: :desc
  defp parse_dir(_), do: :asc

  defp parse_filters(%Spec{filters: filters} = spec, params) do
    raw = stringify_keys(params["filters"] || %{})
    defaults = parsed_defaults(spec)

    {acc, cleared} =
      Enum.reduce(filters, {%{}, MapSet.new()}, fn %Filter{} = filter, {acc, cleared} ->
        key = Atom.to_string(filter.name)

        if Map.has_key?(raw, key) do
          case parse_filter_value(filter, Map.get(raw, key)) do
            nil -> {acc, MapSet.put(cleared, filter.name)}
            parsed -> {Map.put(acc, filter.name, parsed), cleared}
          end
        else
          case Map.get(defaults, filter.name) do
            nil -> {acc, cleared}
            parsed -> {Map.put(acc, filter.name, parsed), cleared}
          end
        end
      end)

    {acc, cleared, defaults}
  end

  defp parsed_defaults(%Spec{} = spec) do
    raw = spec.default_filters

    Enum.reduce(spec.filters, %{}, fn %Filter{} = filter, acc ->
      value =
        Map.get(raw, filter.field) ||
          Map.get(raw, filter.name) ||
          Map.get(raw, Atom.to_string(filter.field)) ||
          Map.get(raw, Atom.to_string(filter.name))

      case parse_filter_value(filter, value) do
        nil -> acc
        parsed -> Map.put(acc, filter.name, parsed)
      end
    end)
  end

  defp parse_filter_value(_filter, nil), do: nil
  defp parse_filter_value(_filter, ""), do: nil

  defp parse_filter_value(%Filter{type: :multi_select} = filter, value) when not is_map(value) do
    allowed = option_values(filter)

    value
    |> List.wrap()
    |> Enum.flat_map(&split_multi/1)
    |> Enum.map(&to_string/1)
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.filter(&(&1 in allowed or allowed == []))
    |> case do
      [] -> nil
      list -> Enum.uniq(list)
    end
  end

  defp parse_filter_value(%Filter{type: :select} = filter, value) when is_list(value) do
    parse_filter_value(filter, List.first(value))
  end

  defp parse_filter_value(%Filter{type: :select} = filter, value) when is_binary(value) do
    trimmed = String.trim(value)
    allowed = option_values(filter)

    cond do
      trimmed == "" -> nil
      allowed == [] -> trimmed
      trimmed in allowed -> trimmed
      true -> nil
    end
  end

  defp parse_filter_value(%Filter{type: :boolean}, value) do
    case value_to_string(value) do
      "true" -> true
      "false" -> false
      "1" -> true
      "0" -> false
      "yes" -> true
      "no" -> false
      _ -> nil
    end
  end

  defp parse_filter_value(%Filter{type: :date_range}, value) do
    parse_range(value, :date)
  end

  defp parse_filter_value(%Filter{type: :datetime_range}, value) do
    parse_range(value, :datetime)
  end

  defp parse_filter_value(%Filter{type: :number_range}, value) do
    parse_number_range(value)
  end

  defp parse_filter_value(%Filter{type: :text} = filter, value) do
    parse_op_filter(filter, value, &parse_contains/1)
  end

  defp parse_filter_value(%Filter{type: :id} = filter, value) do
    parse_op_filter(filter, value, &parse_id_value/1)
  end

  defp parse_filter_value(%Filter{type: :number} = filter, value) do
    parse_op_filter(filter, value, &parse_number/1)
  end

  defp parse_filter_value(%Filter{type: :relative_date} = filter, value) do
    window = value_to_string(unwrap_filter_value(value))
    allowed = Enum.map(Filter.relative_windows(filter), &Atom.to_string/1)

    if window in allowed do
      %{relative: Filter.parse_atom(window)}
    else
      nil
    end
  end

  defp parse_filter_value(%Filter{type: :presence}, value) do
    case value_to_string(value) do
      "empty" -> :empty
      "set" -> :set
      "blank" -> :empty
      "present" -> :set
      _ -> nil
    end
  end

  defp parse_filter_value(%Filter{type: type} = filter, value)
       when type in [:select, :multi_select, :tags] do
    {op, inner} = split_op(filter, value)
    parsed = parse_membership_value(filter, inner)

    cond do
      is_nil(parsed) and op not in [nil, Filter.default_operator(filter)] ->
        %{op: op}

      is_nil(parsed) ->
        nil

      op in [:not_in] ->
        %{op: op, value: List.wrap(parsed)}

      true ->
        parsed
    end
  end

  defp parse_filter_value(_filter, value) when is_binary(value) do
    case String.trim(value) do
      "" -> nil
      trimmed -> trimmed
    end
  end

  defp parse_filter_value(_filter, _value), do: nil

  defp parse_membership_value(%Filter{type: :tags}, value) do
    value
    |> List.wrap()
    |> Enum.flat_map(&split_multi/1)
    |> Enum.map(&to_string/1)
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.uniq()
    |> case do
      [] -> nil
      list -> list
    end
  end

  defp parse_membership_value(%Filter{type: :multi_select} = filter, value) do
    allowed = option_values(filter)

    value
    |> List.wrap()
    |> Enum.flat_map(&split_multi/1)
    |> Enum.map(&to_string/1)
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.filter(&(&1 in allowed or allowed == []))
    |> case do
      [] -> nil
      list -> Enum.uniq(list)
    end
  end

  defp parse_membership_value(%Filter{type: :select} = filter, value) do
    value = if is_list(value), do: List.first(value), else: value

    case value do
      value when is_binary(value) ->
        trimmed = String.trim(value)
        allowed = option_values(filter)

        cond do
          trimmed == "" -> nil
          allowed == [] -> trimmed
          trimmed in allowed -> trimmed
          true -> nil
        end

      _ ->
        nil
    end
  end

  defp parse_op_filter(filter, value, parser) do
    {op, inner} = split_op(filter, value)
    parsed = parser.(inner)

    cond do
      is_nil(parsed) and op not in [nil, Filter.default_operator(filter)] ->
        %{op: op}

      is_nil(parsed) ->
        nil

      op in [nil, Filter.default_operator(filter)] and compact_default_op?(op) ->
        default_op_value(op, parsed)

      true ->
        %{op: op, value: parsed}
    end
  end

  defp compact_default_op?(op) when op in [:contains, :equals, :eq, :in, nil], do: true
  defp compact_default_op?(_), do: false

  defp default_op_value(:contains, text), do: %{contains: text}
  defp default_op_value(_, parsed), do: parsed

  defp split_op(filter, value) when is_map(value) do
    map = stringify_keys(value)
    op = allowed_op(filter, Map.get(map, "op"))
    inner = Map.get(map, "value", Map.get(map, "contains", Map.get(map, "q")))
    {op || Filter.default_operator(filter), inner}
  end

  defp split_op(filter, value) do
    {Filter.default_operator(filter), value}
  end

  defp allowed_op(filter, raw) do
    op = Filter.parse_atom(raw)
    if op in Filter.operators(filter), do: op, else: nil
  end

  defp unwrap_filter_value(%{value: value}), do: value
  defp unwrap_filter_value(%{"value" => value}), do: value
  defp unwrap_filter_value(%{relative: value}), do: value
  defp unwrap_filter_value(%{"relative" => value}), do: value
  defp unwrap_filter_value(value), do: value

  defp parse_id_value(value) do
    case parse_contains(value) do
      nil ->
        nil

      text ->
        case Integer.parse(text) do
          {int, ""} -> int
          _ -> text
        end
    end
  end

  defp parse_contains(%{contains: value}), do: parse_contains(value)
  defp parse_contains(%{value: value}), do: parse_contains(value)
  defp parse_contains(%{"contains" => value}), do: parse_contains(value)
  defp parse_contains(%{"value" => value}), do: parse_contains(value)

  defp parse_contains(value) when is_binary(value) do
    case String.trim(value) do
      "" -> nil
      trimmed -> trimmed
    end
  end

  defp parse_contains(_), do: nil

  defp split_multi(value) when is_binary(value) do
    if String.contains?(value, ","), do: String.split(value, ",", trim: true), else: [value]
  end

  defp split_multi(value), do: [value]

  defp parse_range(value, kind) when is_list(value) do
    parse_range(Enum.map_join(value, ",", &to_string/1), kind)
  end

  defp parse_range(value, kind) when is_binary(value) do
    case String.split(value, ",", trim: true) do
      [from, to] -> parse_range(%{"from" => from, "to" => to}, kind)
      [from] -> parse_range(%{"from" => from}, kind)
      _ -> nil
    end
  end

  defp parse_range(value, kind) when is_map(value) do
    map = stringify_keys(value)
    from = parse_bound(kind, Map.get(map, "from"))
    to = parse_bound(kind, Map.get(map, "to"))

    cond do
      is_nil(from) and is_nil(to) -> nil
      true -> %{from: from, to: to} |> reject_nil_bounds()
    end
  end

  defp parse_range(_value, _kind), do: nil

  defp reject_nil_bounds(map) do
    map
    |> Enum.reject(fn {_key, value} -> is_nil(value) end)
    |> Map.new()
    |> case do
      empty when empty == %{} -> nil
      kept -> kept
    end
  end

  defp parse_bound(:date, %Date{} = date), do: date

  defp parse_bound(:date, value) when is_binary(value) do
    case Date.from_iso8601(String.trim(value)) do
      {:ok, date} -> date
      _ -> nil
    end
  end

  defp parse_bound(:datetime, %DateTime{} = dt), do: dt
  defp parse_bound(:datetime, %NaiveDateTime{} = dt), do: DateTime.from_naive!(dt, "Etc/UTC")

  defp parse_bound(:datetime, value) when is_binary(value) do
    trimmed = value |> String.trim() |> String.replace(" ", "T")

    cond do
      dt = datetime_from_iso8601(trimmed) ->
        DateTime.truncate(dt, :second)

      ndt = naive_from_iso8601(padded_naive(trimmed)) ->
        DateTime.from_naive!(ndt, "Etc/UTC")

      date = date_from_iso8601(trimmed) ->
        DateTime.new!(date, ~T[00:00:00], "Etc/UTC")

      true ->
        nil
    end
  end

  defp parse_bound(_kind, _), do: nil

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

  defp padded_naive(value) do
    case String.split(value, "T") do
      [date, time] ->
        time =
          case String.split(time, ":") do
            [_h, _m] -> time <> ":00"
            _ -> time
          end

        date <> "T" <> time

      _ ->
        value
    end
  end

  defp parse_number_range(value) when is_map(value) do
    map = stringify_keys(value)
    min = parse_number(Map.get(map, "min"))
    max = parse_number(Map.get(map, "max"))

    cond do
      is_nil(min) and is_nil(max) -> nil
      true -> reject_nil_bounds(%{min: min, max: max})
    end
  end

  defp parse_number_range(_), do: nil

  defp parse_number(value) when is_integer(value), do: value
  defp parse_number(value) when is_float(value), do: value

  defp parse_number(value) when is_binary(value) do
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

  defp parse_number(_), do: nil

  defp option_values(%Filter{options: options}) when is_list(options) do
    Enum.map(options, fn
      {_label, value} -> to_string(value)
      value -> to_string(value)
    end)
  end

  defp option_values(_), do: []

  defp stringify_keys(map) when is_map(map) do
    Map.new(map, fn
      {key, value} when is_atom(key) -> {Atom.to_string(key), stringify_nested(value)}
      {key, value} when is_binary(key) -> {key, stringify_nested(value)}
      {key, value} -> {to_string(key), stringify_nested(value)}
    end)
  end

  defp stringify_keys(_), do: %{}

  defp stringify_nested(value) when is_map(value), do: stringify_keys(value)
  defp stringify_nested(value), do: value

  defp sortable_map(spec) do
    Map.new(
      for field <- spec.fields, field.sortable, do: {Atom.to_string(field.name), field.name}
    )
  end

  defp searchable_names(spec) do
    for field <- spec.fields, field.searchable, do: field.name
  end

  defp put_unless(map, true, _key, _value), do: map
  defp put_unless(map, false, key, value), do: Map.put(map, key, value)

  defp put_sort(map, nil, _default), do: map
  defp put_sort(map, sort, sort), do: map

  defp put_sort(map, {field, :asc}, _default) do
    Map.put(map, "sort", Atom.to_string(field))
  end

  defp put_sort(map, {field, :desc}, _default) do
    map
    |> Map.put("sort", Atom.to_string(field))
    |> Map.put("dir", "desc")
  end

  defp put_filters(map, %__MODULE__{} = opts) do
    nested =
      opts.filters
      |> Enum.reject(fn {field, value} ->
        values_equal?(value, Map.get(opts.filter_defaults, field))
      end)
      |> Map.new(fn {field, value} -> {Atom.to_string(field), encode_filter(value)} end)

    nested =
      Enum.reduce(opts.filters_cleared, nested, fn field, acc ->
        if Map.has_key?(opts.filter_defaults, field) do
          Map.put(acc, Atom.to_string(field), "")
        else
          acc
        end
      end)

    if nested == %{}, do: map, else: Map.put(map, "filters", nested)
  end

  defp values_equal?(left, right), do: normalize_eq(left) == normalize_eq(right)
  defp normalize_eq(list) when is_list(list), do: Enum.sort(list)
  defp normalize_eq(other), do: other

  defp encode_filter(value) when is_list(value), do: Enum.map(value, &to_string/1)

  defp encode_filter(%{from: _, to: _} = range), do: encode_map_bounds(range)
  defp encode_filter(%{from: _} = range), do: encode_map_bounds(range)
  defp encode_filter(%{to: _} = range), do: encode_map_bounds(range)
  defp encode_filter(%{min: _, max: _} = range), do: encode_map_bounds(range)
  defp encode_filter(%{min: _} = range), do: encode_map_bounds(range)
  defp encode_filter(%{max: _} = range), do: encode_map_bounds(range)
  defp encode_filter(%{op: :contains, value: value}), do: encode_filter(value)
  defp encode_filter(%{op: :in, value: value}), do: encode_filter(value)
  defp encode_filter(%{op: :eq, value: value}), do: encode_filter(value)
  defp encode_filter(%{op: :equals, value: value}), do: encode_filter(value)

  defp encode_filter(%{op: op, value: value}) do
    %{"op" => Atom.to_string(op), "value" => encode_filter(value)}
  end

  defp encode_filter(%{op: op}) when is_atom(op), do: %{"op" => Atom.to_string(op)}
  defp encode_filter(%{relative: window}), do: encode_filter(window)
  defp encode_filter(%{contains: value}), do: encode_filter(value)

  defp encode_filter(%Date{} = date), do: Date.to_iso8601(date)
  defp encode_filter(%DateTime{} = dt), do: DateTime.to_iso8601(dt)
  defp encode_filter(%NaiveDateTime{} = dt), do: NaiveDateTime.to_iso8601(dt)
  defp encode_filter(true), do: "true"
  defp encode_filter(false), do: "false"
  defp encode_filter(:empty), do: "empty"
  defp encode_filter(:set), do: "set"
  defp encode_filter(value), do: to_string(value)

  defp encode_map_bounds(map) do
    Map.new(map, fn {key, value} -> {to_string(key), encode_filter(value)} end)
  end

  defp value_to_string(value) when is_list(value), do: value_to_string(List.first(value))
  defp value_to_string(value) when is_binary(value), do: String.downcase(String.trim(value))
  defp value_to_string(true), do: "true"
  defp value_to_string(false), do: "false"
  defp value_to_string(_), do: ""

  defp blank?(nil), do: true
  defp blank?(""), do: true
  defp blank?(_), do: false
end
