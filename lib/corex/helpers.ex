defmodule Corex.Helpers do
  @moduledoc false

  def get_boolean(true), do: ""
  def get_boolean(false), do: nil
  def get_boolean(nil), do: nil

  def get_default_boolean(controlled, value) do
    if !controlled && value, do: "", else: nil
  end

  def get_boolean(controlled, value) do
    if controlled do
      if value, do: "", else: nil
    else
      nil
    end
  end

  def validate_value!([]), do: []

  def validate_value!(value) when is_list(value) do
    if Enum.all?(value, &is_binary/1) do
      value
    else
      raise ArgumentError, value_error(value)
    end
  end

  def validate_value!(value), do: raise(ArgumentError, value_error(value))

  def value_error(value), do: "value must be a list of strings, got: #{inspect(value)}"
end
