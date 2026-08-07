defmodule Corex.Attrs do
  @moduledoc """
  Builders for the HTML attribute maps the Connect modules hand to templates.

  Presence attributes follow the HTML convention where the attribute's mere
  presence is the signal: `""` renders as a bare attribute and `nil` omits it.
  That is deliberately different from Checkable.Helpers, which emits the
  `"true" | "false" | "indeterminate"` enum a tri-state control needs, and from
  `Corex.FormField.dataset_default_boolean/1`, which always emits a string.
  """

  @spec presence_attr(boolean() | nil) :: String.t() | nil
  def presence_attr(state) when state not in [nil, false], do: ""
  def presence_attr(_state), do: nil

  @doc """
  Emits the presence attribute only for an uncontrolled component.

  A controlled component takes its state from the server on every render, so the
  default-state attribute the hook reads on mount must not be emitted.
  """
  @spec default_presence_attr(boolean() | nil, term()) :: String.t() | nil
  def default_presence_attr(controlled, value)
      when controlled in [nil, false] and value not in [nil, false],
      do: ""

  def default_presence_attr(_controlled, _value), do: nil

  @doc """
  Emits the presence attribute only for a controlled component.
  """
  @spec presence_attr(boolean() | nil, term()) :: String.t() | nil
  def presence_attr(controlled, value)
      when controlled not in [nil, false] and value not in [nil, false],
      do: ""

  def presence_attr(_controlled, _value), do: nil

  @spec data_state(term(), term(), term()) :: term()
  def data_state(state, true_val, _false_val) when state not in [nil, false], do: true_val
  def data_state(_state, _true_val, false_val), do: false_val

  @spec maybe_put(map(), term(), term()) :: map()
  def maybe_put(map, _key, nil), do: map
  def maybe_put(map, key, value), do: Map.put(map, key, value)

  @spec put_data_dir_attr(map(), String.t() | nil) :: map()
  def put_data_dir_attr(map, dir) when dir in ["ltr", "rtl"], do: Map.put(map, "data-dir", dir)
  def put_data_dir_attr(map, _dir), do: map

  @spec put_dir_attr(map(), String.t() | nil) :: map()
  def put_dir_attr(map, dir) when dir in ["ltr", "rtl"], do: Map.put(map, "dir", dir)
  def put_dir_attr(map, _dir), do: map

  @spec put_data_dir_attr_from_assigns(map(), map()) :: map()
  def put_data_dir_attr_from_assigns(map, assigns) when is_map(assigns),
    do: put_data_dir_attr(map, Map.get(assigns, :dir))

  @spec put_dir_attr_from_assigns(map(), map()) :: map()
  def put_dir_attr_from_assigns(map, assigns) when is_map(assigns),
    do: put_dir_attr(map, Map.get(assigns, :dir))

  @spec visually_hidden_style() :: String.t()
  def visually_hidden_style do
    "border:0;clip:rect(0 0 0 0);height:1px;margin:-1px;overflow:hidden;padding:0;position:absolute;width:1px;white-space:nowrap;word-wrap:normal;"
  end
end
