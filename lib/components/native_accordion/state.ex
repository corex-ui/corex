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
        case direction do
          :next -> Enum.at(enabled, rem(idx + 1, length(enabled)))
          :prev -> Enum.at(enabled, rem(idx - 1 + length(enabled), length(enabled)))
          :first -> List.first(enabled)
          :last -> List.last(enabled)
        end
    end
  end

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
    rtl? = dir == "rtl"

    case {orientation, key} do
      {_, "Home"} -> :first
      {_, "End"} -> :last
      {"vertical", "ArrowDown"} -> :next
      {"vertical", "ArrowUp"} -> :prev
      {"horizontal", "ArrowRight"} -> if(rtl?, do: :prev, else: :next)
      {"horizontal", "ArrowLeft"} -> if(rtl?, do: :next, else: :prev)
      _ -> nil
    end
  end

  @doc """
  Resolve the next focused item from a keydown payload.

  Payload keys: `"item"`, `"key"`, `"orientation"`, `"dir"`, `"item_values"`, `"disabled_values"`.
  """
  @spec focus_target(map()) :: String.t() | nil
  def focus_target(params) when is_map(params) do
    item = params["item"] || params[:item]
    key = params["key"] || params[:key]
    orientation = params["orientation"] || params[:orientation] || "vertical"
    dir = params["dir"] || params[:dir]
    item_values = List.wrap(params["item_values"] || params[:item_values] || [])
    disabled = List.wrap(params["disabled_values"] || params[:disabled_values] || [])

    if is_binary(item) and is_binary(key) do
      case key_direction(key, orientation, dir) do
        nil -> nil
        direction -> next_item(item_values, item, disabled, direction)
      end
    else
      nil
    end
  end
end