defmodule CorexAdmin.State.Filters do
  @moduledoc """
  The single owner of index filter state.

  Filter values make three trips and every one of them lives here:

    * **parse** — URL/event params into the canonical shape a context receives
      (`parse/2`)
    * **encode** — canonical shape back into URL params (`encode/1`)
    * **merge** — a widget event folded into the current params (`merge_event/3`)

  `CorexAdmin.ListOpts` calls `parse/2` and `encode/1`; the index controller
  calls `merge_event/3`. Nothing else may reimplement a filter shape, because
  the canonical shapes are also the contract `CorexAdmin.Query` dispatches on.

  ## Canonical shapes

  | Shape | Meaning |
  | ----- | ------- |
  | `"text"` / number / `true` / `false` | equality |
  | `["a", "b"]` | membership (`in`) |
  | `%{contains: "term"}` | case-insensitive substring |
  | `%{op: op, value: value}` | explicit operator |
  | `%{from: bound, to: bound}` | date/datetime range |
  | `%{min: n, max: n}` | number range |
  | `%{relative: window}` | named rolling window |
  | `:empty` / `:set` | presence |
  """

  alias CorexAdmin.Params
  alias CorexAdmin.Resource.Filter
  alias CorexAdmin.Resource.Spec

  @doc """
  Canonical value for `filter` from a raw URL or event value.

  Returns `nil` when the value carries no constraint, which callers treat as
  "filter not applied".
  """
  @spec parse(Filter.t(), term()) :: term() | nil
  def parse(%Filter{} = filter, value) do
    Filter.module(filter).parse(filter, value)
  end

  @doc "URL-safe params value for a canonical filter value."
  @spec encode(term()) :: term()
  def encode(value) when is_list(value), do: Enum.map(value, &encode/1)

  def encode(%Date{} = date), do: Date.to_iso8601(date)
  def encode(%DateTime{} = dt), do: DateTime.to_iso8601(dt)
  def encode(%NaiveDateTime{} = dt), do: NaiveDateTime.to_iso8601(dt)

  def encode(%{op: op, value: value}) when op in [:contains, :in, :eq, :equals] do
    encode(value)
  end

  def encode(%{op: op, value: value}) do
    %{"op" => Atom.to_string(op), "value" => encode(value)}
  end

  def encode(%{op: op}) when is_atom(op), do: %{"op" => Atom.to_string(op)}
  def encode(%{relative: window}), do: encode(window)
  def encode(%{contains: value}), do: encode(value)

  def encode(map) when is_map(map) and not is_struct(map) do
    Map.new(map, fn {key, value} -> {to_string(key), encode(value)} end)
  end

  def encode(true), do: "true"
  def encode(false), do: "false"
  def encode(:empty), do: "empty"
  def encode(:set), do: "set"
  def encode(value), do: to_string(value)

  @doc """
  Folds a filter widget event into `params`.

  Returns `:ignore` when the event does not change the query — an unrecognized
  control id, or a range with only one bound picked so far. Callers must not
  patch on `:ignore`, otherwise a half-picked date range would reload the list.
  """
  @spec merge_event(Spec.t(), map(), map()) :: map() | :ignore
  def merge_event(%Spec{} = spec, params, event) when is_map(params) and is_map(event) do
    id = to_string(Map.get(event, "id") || "")
    value = Map.get(event, "value")
    filters = Map.get(params, "filters", %{})

    case parse_control_id(id) do
      {:value, name} -> merge_value(spec, params, filters, name, value)
      {:op, name} -> merge_op(spec, params, filters, name, value)
      {:range, name, bound} -> merge_bound(spec, params, filters, name, bound, value)
      :error -> :ignore
    end
  end

  @doc """
  Drops range filters that are not fully picked yet.

  Form `phx-change` payloads include every control, so a range mid-selection
  would otherwise be parsed as a one-sided bound and narrow the list.
  """
  @spec reject_incomplete_ranges(Spec.t(), map()) :: map()
  def reject_incomplete_ranges(%Spec{} = spec, params) when is_map(params) do
    filters = Map.get(params, "filters")

    if is_map(filters) do
      spec.filters
      |> Enum.filter(&(&1.type in [:date_range, :datetime_range]))
      |> Enum.reduce(filters, fn filter, acc ->
        name = Atom.to_string(filter.name)

        case complete_range(Map.get(acc, name)) do
          :incomplete -> Map.delete(acc, name)
          nil -> Map.delete(acc, name)
          normalized -> Map.put(acc, name, normalized)
        end
      end)
      |> put_filters(params)
    else
      params
    end
  end

  @doc "Params with `filters` set, or the key removed when empty."
  @spec put_filters(map(), map()) :: map()
  def put_filters(filters, params) when is_map(filters) and is_map(params) do
    if filters == %{} do
      Map.delete(params, "filters")
    else
      Map.put(params, "filters", filters)
    end
  end

  @doc "Params with the filter under `name` cleared, keeping an explicit empty when it has a default."
  @spec clear(Spec.t(), map(), term()) :: map()
  def clear(%Spec{} = spec, params, name) do
    filters = params |> Map.get("filters", %{}) |> put_or_clear(spec, name, nil)
    put_filters(filters, params)
  end

  @doc "Params with the filter under `name` removed entirely, so its default applies again."
  @spec reset(map(), term()) :: map()
  def reset(params, name) do
    filters = params |> Map.get("filters", %{}) |> Map.delete(to_string(name))
    put_filters(filters, params)
  end

  @doc "DOM id for a filter control, matched by `parse_control_id/1`."
  @spec control_id(String.t(), Filter.t() | atom(), atom() | nil) :: String.t()
  def control_id(prefix, filter, part \\ nil)

  def control_id(prefix, %Filter{name: name}, part), do: control_id(prefix, name, part)

  def control_id(prefix, name, nil), do: "#{prefix}-filter-#{name}"
  def control_id(prefix, name, part), do: "#{prefix}-filter-#{name}-#{part}"

  @doc """
  Which filter and which part of it a control id addresses.

  The id suffix is the wire protocol between a rendered control and
  `merge_event/3`; both sides must agree, so both live in this module.
  """
  @spec parse_control_id(String.t()) ::
          {:value, String.t()} | {:op, String.t()} | {:range, String.t(), String.t()} | :error
  def parse_control_id(id) when is_binary(id) do
    case String.split(id, "-filter-", parts: 2) do
      [_, rest] -> parse_control_part(rest)
      _ -> :error
    end
  end

  def parse_control_id(_), do: :error

  @doc "Inclusive `{from, to}` dates for a named preset, or `:error`."
  @spec preset_bounds(term()) :: {Date.t(), Date.t()} | :error
  def preset_bounds(preset), do: Filter.relative_bounds(preset)

  @doc "Params with `name` set to a preset's date bounds."
  @spec apply_preset(map(), term(), term()) :: map() | :error
  def apply_preset(params, name, preset) do
    case preset_bounds(preset) do
      {from, to} ->
        bounds = %{"from" => Date.to_iso8601(from), "to" => Date.to_iso8601(to)}
        filters = params |> Map.get("filters", %{}) |> Map.put(to_string(name), bounds)
        put_filters(filters, params)

      :error ->
        :error
    end
  end

  @doc """
  Whether a canonical value constrains the query.

  A value carrying only an operator (`%{op: :contains}`) is inactive: the user
  chose how to compare but has not said what to compare against.
  """
  @spec active?(term()) :: boolean()
  def active?(value) do
    case value do
      nil -> false
      "" -> false
      [] -> false
      %{op: _, value: inner} -> active?(inner)
      %{op: _} -> false
      %{contains: inner} -> active?(inner)
      %{relative: window} when window not in [nil, ""] -> true
      map when is_map(map) and not is_struct(map) -> map != %{}
      _ -> true
    end
  end

  @doc "Operator currently chosen for `filter`, falling back to its default."
  @spec operator(Filter.t(), term()) :: atom() | nil
  def operator(%Filter{} = filter, value) do
    case value do
      %{op: op} when is_atom(op) and not is_nil(op) -> op
      %{contains: _} -> :contains
      _ -> Filter.default_operator(filter)
    end
  end

  @doc """
  Scalar the user typed or picked, with any operator wrapper removed.

  Controls bind to this so switching operators does not clear the value.
  """
  @spec inner_value(term()) :: term()
  def inner_value(%{op: _, value: value}), do: value
  def inner_value(%{contains: value}), do: value
  def inner_value(%{relative: window}), do: window
  def inner_value(%{op: _}), do: nil
  def inner_value(value), do: value

  defp parse_control_part(rest) do
    cond do
      String.ends_with?(rest, "-min") -> {:range, String.trim_trailing(rest, "-min"), "min"}
      String.ends_with?(rest, "-max") -> {:range, String.trim_trailing(rest, "-max"), "max"}
      String.ends_with?(rest, "-from") -> {:range, String.trim_trailing(rest, "-from"), "from"}
      String.ends_with?(rest, "-to") -> {:range, String.trim_trailing(rest, "-to"), "to"}
      String.ends_with?(rest, "-slider") -> {:value, String.trim_trailing(rest, "-slider")}
      String.ends_with?(rest, "-op") -> {:op, String.trim_trailing(rest, "-op")}
      true -> {:value, rest}
    end
  end

  defp merge_value(spec, params, filters, name, value) do
    case find_filter(spec, name) do
      %Filter{type: type} when type in [:date_range, :datetime_range] ->
        case complete_range(value) do
          :incomplete -> :ignore
          normalized -> commit(spec, params, filters, name, normalized)
        end

      %Filter{type: :number_range} ->
        commit(spec, params, filters, name, normalize_number_range(value))

      _ ->
        merged = merge_into_value(Map.get(filters, name), Params.normalize(value))
        commit(spec, params, filters, name, merged)
    end
  end

  defp merge_op(spec, params, filters, name, value) do
    merged = merge_into_op(Map.get(filters, name), Params.normalize(value))
    commit(spec, params, filters, name, merged)
  end

  defp merge_bound(spec, params, filters, name, bound, value) do
    nested =
      filters
      |> Map.get(name, %{})
      |> Params.stringify()
      |> Params.put_or_delete(bound, Params.normalize(value))

    commit(spec, params, filters, name, if(nested == %{}, do: nil, else: nested))
  end

  defp commit(spec, params, filters, name, value) do
    filters
    |> put_or_clear(spec, name, value)
    |> put_filters(params)
  end

  # A filter with a default cannot simply be dropped from the URL: the default
  # would be re-applied. An explicit empty value means "any".
  defp put_or_clear(filters, spec, name, nil) do
    if has_default?(spec, name) do
      Map.put(filters, to_string(name), "")
    else
      Map.delete(filters, to_string(name))
    end
  end

  defp put_or_clear(filters, _spec, name, value), do: Map.put(filters, to_string(name), value)

  defp has_default?(%Spec{default_filters: defaults}, name) do
    key = to_string(name)
    Enum.any?(Map.keys(defaults), &(to_string(&1) == key))
  end

  defp find_filter(%Spec{filters: filters}, name) do
    key = to_string(name)
    Enum.find(filters, &(Atom.to_string(&1.name) == key))
  end

  defp merge_into_value(existing, nil), do: keep_op_only(existing)

  defp merge_into_value(existing, value) when is_map(existing) and not is_struct(existing) do
    existing = Params.stringify(existing)

    if Map.has_key?(existing, "op") do
      Map.put(existing, "value", value)
    else
      value
    end
  end

  defp merge_into_value(_existing, value), do: value

  defp merge_into_op(existing, nil), do: existing

  defp merge_into_op(existing, op) do
    op = to_string(op)

    case existing do
      map when is_map(map) and not is_struct(map) ->
        case Map.get(Params.stringify(map), "value") do
          inner when inner not in [nil, "", []] -> %{"op" => op, "value" => inner}
          _ -> %{"op" => op}
        end

      value when value not in [nil, "", []] ->
        %{"op" => op, "value" => value}

      _ ->
        %{"op" => op}
    end
  end

  defp keep_op_only(existing) when is_map(existing) and not is_struct(existing) do
    case Map.get(Params.stringify(existing), "op") do
      op when op not in [nil, ""] -> %{"op" => op}
      _ -> nil
    end
  end

  defp keep_op_only(_), do: nil

  defp normalize_number_range(value) do
    case Params.normalize(value) do
      [min, max] -> %{"min" => min, "max" => max}
      %{} = map -> Params.stringify(map)
      other -> other
    end
  end

  # Both bounds must be present before a range is worth querying.
  defp complete_range(value) do
    case Params.normalize(value) do
      nil ->
        nil

      value when is_binary(value) ->
        case String.split(value, ",", trim: true) do
          [_from, _to] -> value
          _ -> :incomplete
        end

      value when is_list(value) ->
        case Enum.reject(value, &Params.blank?/1) do
          [from, to] -> Enum.join([from, to], ",")
          _ -> :incomplete
        end

      value when is_map(value) and not is_struct(value) ->
        map = Params.stringify(value)
        from = Params.normalize(Map.get(map, "from"))
        to = Params.normalize(Map.get(map, "to"))

        if is_nil(from) or is_nil(to), do: :incomplete, else: map

      other ->
        other
    end
  end
end
