defmodule Corex.ValueBinding do
  @moduledoc false

  @spec encode_list(list()) :: String.t() | nil
  def encode_list([]), do: nil

  def encode_list(values) when is_list(values) do
    Corex.Dataset.encode_json(Enum.map(values, &to_string/1))
  end

  @spec list_pair(list() | nil, boolean()) :: {String.t() | nil, String.t() | nil}
  def list_pair(values, true) do
    case values || [] do
      [] -> controlled_dataset_values(true, "[]")
      list -> controlled_dataset_values(true, encode_list(list))
    end
  end

  def list_pair(values, false) do
    case values || [] do
      [] -> {nil, nil}
      list -> controlled_dataset_values(false, encode_list(list))
    end
  end

  @spec string_pair(String.t() | nil, boolean()) :: {String.t() | nil, String.t() | nil}
  def string_pair(value, controlled?) do
    controlled_string_value(controlled?, value)
  end

  def controlled_dataset_values(true, joined) when is_binary(joined), do: {joined, nil}
  def controlled_dataset_values(false, joined) when is_binary(joined), do: {nil, joined}
  def controlled_dataset_values(_controlled, _joined), do: {nil, nil}

  def controlled_string_value(true, value) when is_binary(value), do: {value, nil}
  def controlled_string_value(false, value) when is_binary(value), do: {nil, value}
  def controlled_string_value(_controlled, _value), do: {nil, nil}
end
