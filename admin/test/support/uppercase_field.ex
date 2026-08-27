defmodule CorexAdmin.Test.Fields.Uppercase do
  @moduledoc false
  @behaviour CorexAdmin.Field

  use Phoenix.Component
  use Corex

  alias CorexAdmin.Resource.Field

  @impl true
  def input(assigns) do
    ~H"""
    <.native_input type="text" field={@form[@field.name]} class="native-input">
      <:label>{@field.label}</:label>
    </.native_input>
    """
  end

  @impl true
  def display(assigns) do
    value = assigns.record |> Map.get(assigns.field.name) |> to_string() |> String.upcase()

    assigns = assign(assigns, :value, value)

    ~H"""
    <span class="admin-cell">{@value}</span>
    """
  end

  @impl true
  def export(%Field{} = field, record), do: Map.get(record, field.name)
end
