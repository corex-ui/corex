defmodule CorexAdmin.ListOpts do
  @moduledoc """
  Allowlisted list options parsed from URL query params.

  This is the value a context receives: page, page size, sort, search, and
  filters, all already checked against the resource. Unknown sort and filter
  keys are dropped, `page_size` must be one of the resource's
  `page_size_options`, and field names are resolved through the resource
  allowlist so user input never becomes an unbounded atom.

  Filters come only from the resource `filters do` block. Canonical filter
  shapes and the parse/encode rules live in `CorexAdmin.State.Filters`.
  """

  alias CorexAdmin.Params
  alias CorexAdmin.Resource.Filter
  alias CorexAdmin.Resource.Spec
  alias CorexAdmin.State.Filters

  @enforce_keys [:page, :page_size]
  defstruct page: 1,
            page_size: 25,
            page_size_default: 25,
            sort: nil,
            sort_default: nil,
            search: nil,
            search_fields: [],
            search_paths: %{},
            filters: %{},
            filter_defaults: %{},
            filter_fields: %{},
            filter_specs: %{},
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
          search_paths: %{optional(atom()) => [atom()]},
          filters: %{optional(atom()) => filter_value()},
          filter_defaults: %{optional(atom()) => filter_value()},
          filter_fields: %{optional(atom()) => atom()},
          filter_specs: %{optional(atom()) => Filter.t()},
          filters_cleared: MapSet.t(atom())
        }

  @doc "Builds list opts from a params map using the resource allowlist."
  @spec from_params(Spec.t(), map()) :: t()
  def from_params(%Spec{} = spec, params) when is_map(params) do
    params = Params.stringify(params)
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
      search_paths: searchable_paths(spec),
      filters: filters,
      filter_defaults: defaults,
      filter_fields: Map.new(spec.filters, &{&1.name, &1.field}),
      filter_specs: Map.new(spec.filters, &{&1.name, &1}),
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
    |> put_unless(Params.blank?(opts.search), "q", opts.search)
    |> put_filters(opts)
  end

  @doc "Whether search or any filter is active."
  @spec filtered?(t()) :: boolean()
  def filtered?(%__MODULE__{search: search, filters: filters}) do
    not Params.blank?(search) or filters != %{}
  end

  @doc "The resource filter behind a parsed filter name, when still known."
  @spec filter_spec(t(), atom()) :: Filter.t() | nil
  def filter_spec(%__MODULE__{filter_specs: specs}, name), do: Map.get(specs, name)

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
    if parsed in options, do: parsed, else: default
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
    raw = Params.stringify(params["filters"] || %{})
    defaults = parsed_defaults(spec)

    {acc, cleared} =
      Enum.reduce(filters, {%{}, MapSet.new()}, fn %Filter{} = filter, {acc, cleared} ->
        key = Atom.to_string(filter.name)

        if Map.has_key?(raw, key) do
          case Filters.parse(filter, Map.get(raw, key)) do
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

  # `default_filters` may key on either the filter name or the column it targets.
  defp parsed_defaults(%Spec{} = spec) do
    raw = spec.default_filters

    Enum.reduce(spec.filters, %{}, fn %Filter{} = filter, acc ->
      value =
        Map.get(raw, filter.field) ||
          Map.get(raw, filter.name) ||
          Map.get(raw, Atom.to_string(filter.field)) ||
          Map.get(raw, Atom.to_string(filter.name))

      case Filters.parse(filter, value) do
        nil -> acc
        parsed -> Map.put(acc, filter.name, parsed)
      end
    end)
  end

  defp sortable_map(spec) do
    Map.new(
      for field <- spec.fields, field.sortable, do: {Atom.to_string(field.name), field.name}
    )
  end

  defp searchable_names(spec) do
    for field <- spec.fields, field.searchable, do: field.name
  end

  defp searchable_paths(spec) do
    Map.new(
      for field <- spec.fields, field.searchable, is_list(field.path), do: {field.name, field.path}
    )
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
      |> Map.new(fn {field, value} -> {Atom.to_string(field), Filters.encode(value)} end)

    # A filter with a default needs an explicit empty value in the URL,
    # otherwise the default silently comes back on the next request.
    nested =
      Enum.reduce(opts.filters_cleared, nested, fn field, acc ->
        if Map.has_key?(opts.filter_defaults, field) do
          Map.put(acc, Atom.to_string(field), "")
        else
          acc
        end
      end)

    Filters.put_filters(nested, map)
  end

  defp values_equal?(left, right), do: normalize_eq(left) == normalize_eq(right)
  defp normalize_eq(list) when is_list(list), do: Enum.sort(list)
  defp normalize_eq(other), do: other
end
