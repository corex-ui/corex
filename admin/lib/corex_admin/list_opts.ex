defmodule CorexAdmin.ListOpts do
  @moduledoc """
  Allowlisted list options parsed from URL query params.

  Unknown sort/filter keys are dropped. `page_size` is capped. Field names are
  resolved through the resource allowlist — user input is never turned into an
  unbounded atom.
  """

  alias CorexAdmin.Resource.Spec

  @enforce_keys [:page, :page_size]
  defstruct page: 1,
            page_size: 25,
            sort: nil,
            search: nil,
            search_fields: [],
            filters: %{}

  @type t :: %__MODULE__{
          page: pos_integer(),
          page_size: pos_integer(),
          sort: {atom(), :asc | :desc} | nil,
          search: String.t() | nil,
          search_fields: [atom()],
          filters: %{optional(atom()) => term()}
        }

  @doc "Builds list opts from a params map using the resource allowlist."
  @spec from_params(struct(), map()) :: t()
  def from_params(%Spec{} = spec, params) when is_map(params) do
    params = stringify_keys(params)
    page_size_default = spec.page_size || CorexAdmin.default_page_size()
    max_page_size = CorexAdmin.max_page_size()

    %__MODULE__{
      page: parse_positive_int(params["page"], 1),
      page_size:
        params["page_size"]
        |> parse_positive_int(page_size_default)
        |> min(max_page_size),
      sort: parse_sort(spec, params),
      search: parse_search(params["q"]),
      search_fields: searchable_names(spec),
      filters: parse_filters(spec, params)
    }
  end

  @doc "Query params that should be preserved on index patches."
  @spec to_params(t()) :: map()
  def to_params(%__MODULE__{} = opts) do
    %{}
    |> put_unless(opts.page == 1, "page", Integer.to_string(opts.page))
    |> put_unless(
      opts.page_size == CorexAdmin.default_page_size(),
      "page_size",
      Integer.to_string(opts.page_size)
    )
    |> put_sort(opts.sort)
    |> put_unless(blank?(opts.search), "q", opts.search)
    |> put_filters(opts.filters)
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
      :error -> nil
    end
  end

  defp sort_key(value) when is_binary(value), do: value
  defp sort_key(_), do: ""

  defp parse_dir("desc"), do: :desc
  defp parse_dir(_), do: :asc

  defp parse_filters(spec, params) do
    allowed = filterable_map(spec)
    raw = stringify_keys(params["filters"] || %{})

    Enum.reduce(allowed, %{}, fn {name, atom}, acc ->
      value = Map.get(raw, name) || Map.get(params, "filter_#{name}")

      cond do
        is_nil(value) -> acc
        is_binary(value) and String.trim(value) == "" -> acc
        true -> Map.put(acc, atom, value)
      end
    end)
  end

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

  defp filterable_map(spec) do
    from_fields =
      for field <- spec.fields, field.filterable, do: {Atom.to_string(field.name), field.name}

    from_filters =
      for filter <- spec.filters, do: {Atom.to_string(filter.name), filter.name}

    Map.new(from_fields ++ from_filters)
  end

  defp searchable_names(spec) do
    for field <- spec.fields, field.searchable, do: field.name
  end

  defp put_unless(map, true, _key, _value), do: map
  defp put_unless(map, false, key, value), do: Map.put(map, key, value)

  defp put_sort(map, nil), do: map

  defp put_sort(map, {field, :asc}) do
    Map.put(map, "sort", Atom.to_string(field))
  end

  defp put_sort(map, {field, :desc}) do
    map
    |> Map.put("sort", Atom.to_string(field))
    |> Map.put("dir", "desc")
  end

  defp put_filters(map, filters) when filters == %{}, do: map

  defp put_filters(map, filters) do
    nested = Map.new(filters, fn {key, value} -> {Atom.to_string(key), to_string(value)} end)
    Map.put(map, "filters", nested)
  end

  defp blank?(nil), do: true
  defp blank?(""), do: true
  defp blank?(_), do: false
end
