defmodule Corex.NativeAccordion.State do
  @moduledoc false

  @doc """
  Compute the next open-value list after toggling `item`.

  Options:
  - `:multiple` (default `true`)
  - `:collapsible` (default `true`) — when false, the last open item cannot close
  """
  @spec toggle(list(String.t()), String.t(), keyword()) :: list(String.t())
  def toggle(values, item, opts \\ []) when is_list(values) and is_binary(item) do
    multiple? = Keyword.get(opts, :multiple, true)
    collapsible? = Keyword.get(opts, :collapsible, true)
    open? = item in values

    cond do
      multiple? and open? and collapsible? ->
        List.delete(values, item)

      multiple? and open? and not collapsible? ->
        values

      multiple? ->
        values ++ [item]

      open? and collapsible? ->
        []

      open? and not collapsible? ->
        values

      true ->
        [item]
    end
  end

  @doc """
  Normalize `value` attr to a list of strings.
  """
  @spec value_list(term()) :: list(String.t())
  def value_list(nil), do: []
  def value_list(v) when is_binary(v), do: [v]
  def value_list(v) when is_list(v), do: Enum.filter(v, &is_binary/1)
  def value_list(_), do: []

  @doc """
  Next enabled item value for vertical keyboard navigation.
  """
  @spec next_item(list(String.t()), String.t(), list(String.t()), atom()) :: String.t() | nil
  def next_item(item_values, current, disabled \\ [], direction)
      when is_list(item_values) and is_binary(current) and is_list(disabled) do
    enabled = Enum.reject(item_values, &(&1 in disabled))

    case Enum.find_index(enabled, &(&1 == current)) do
      nil ->
        List.first(enabled)

      idx ->
        case direction do
          :next -> Enum.at(enabled, rem(idx + 1, length(enabled)))
          :prev -> Enum.at(enabled, rem(idx - 1 + length(enabled), length(enabled)))
          :first -> List.first(enabled)
          :last -> List.last(enabled)
        end
    end
  end
end
