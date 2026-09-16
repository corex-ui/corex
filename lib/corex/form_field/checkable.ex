defmodule Corex.FormField.Checkable do
  @moduledoc false

  alias Corex.Checkable.Helpers, as: CheckableHelpers

  @spec dataset_default_boolean(boolean() | :indeterminate) :: String.t()
  def dataset_default_boolean(checked) do
    CheckableHelpers.checked_form_field_default_attr(checked)
  end
end
