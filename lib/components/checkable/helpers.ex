defmodule Corex.Checkable.Helpers do
  @moduledoc false

  def normalize_checked(true), do: true
  def normalize_checked(false), do: false
  def normalize_checked(:indeterminate), do: :indeterminate
  def normalize_checked("indeterminate"), do: :indeterminate
  def normalize_checked("true"), do: true
  def normalize_checked("false"), do: false
  def normalize_checked(nil), do: false
  def normalize_checked(_), do: false

  def checked_attr_value(true), do: "true"
  def checked_attr_value(false), do: "false"
  def checked_attr_value(:indeterminate), do: "indeterminate"

  def checked_controlled_attr(controlled, checked) do
    if controlled, do: checked_attr_value(normalize_checked(checked)), else: nil
  end

  def checked_default_attr(controlled, checked) do
    c = normalize_checked(checked)

    if controlled do
      nil
    else
      if c == false, do: nil, else: checked_attr_value(c)
    end
  end

  def native_checked(checked) do
    normalize_checked(checked) == true
  end

  def visual_state(checked) do
    case normalize_checked(checked) do
      true -> "checked"
      false -> "unchecked"
      :indeterminate -> "indeterminate"
    end
  end
end
