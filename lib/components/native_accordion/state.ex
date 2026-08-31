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
    do_toggle(values, item, multiple?, collapsible?)
  end

  defp do_toggle(values, item, true, collapsible?) do
    open? = item in values

    cond do
      open? and collapsible? -> List.delete(values, item)
      open? -> values
      true -> values ++ [item]
    end
  end

  defp do_toggle(values, item, false, collapsible?) do
    open? = item in values

    cond do
      open? and collapsible? -> []
      open? -> values
      true -> [item]
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
  Next enabled item value for keyboard navigation.
  """
  @spec next_item(list(String.t()), String.t(), list(String.t()), atom()) :: String.t() | nil
  def next_item(item_values, current, disabled \\ [], direction)
      when is_list(item_values) and is_binary(current) and is_list(disabled) do
    enabled = Enum.reject(item_values, &(&1 in disabled))

    case Enum.find_index(enabled, &(&1 == current)) do
      nil ->
        List.first(enabled)

      idx ->
        step_item(enabled, idx, direction)
    end
  end

  defp step_item(enabled, idx, :next), do: Enum.at(enabled, rem(idx + 1, length(enabled)))

  defp step_item(enabled, idx, :prev),
    do: Enum.at(enabled, rem(idx - 1 + length(enabled), length(enabled)))

  defp step_item(enabled, _idx, :first), do: List.first(enabled)

  defp step_item(enabled, _idx, :last) do
    case enabled do
      [] -> nil
      list -> Enum.at(list, -1)
    end
  end

  defp step_item(_enabled, _idx, _direction), do: nil

  @doc """
  Map a keyboard event to a navigation direction.

  Vertical: ArrowDown → :next, ArrowUp → :prev.
  Horizontal: ArrowRight → :next, ArrowLeft → :prev (swapped when `dir` is `"rtl"`).
  Home → :first, End → :last. Unknown keys → `nil`.
  """
  @spec key_direction(String.t(), String.t(), String.t() | nil) ::
          :next | :prev | :first | :last | nil
  def key_direction(key, orientation, dir \\ nil)
      when is_binary(key) and is_binary(orientation) do
    case key do
      "Home" -> :first
      "End" -> :last
      _ -> arrow_direction(key, orientation, dir == "rtl")
    end
  end

  defp arrow_direction("ArrowDown", "vertical", _rtl?), do: :next
  defp arrow_direction("ArrowUp", "vertical", _rtl?), do: :prev
  defp arrow_direction("ArrowRight", "horizontal", false), do: :next
  defp arrow_direction("ArrowRight", "horizontal", true), do: :prev
  defp arrow_direction("ArrowLeft", "horizontal", false), do: :prev
  defp arrow_direction("ArrowLeft", "horizontal", true), do: :next
  defp arrow_direction(_key, _orientation, _rtl?), do: nil
end
