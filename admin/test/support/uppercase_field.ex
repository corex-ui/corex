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
    assigns = assign(assigns, :value, assigns.record |> source(assigns.field) |> String.upcase())

    ~H"""
    <span class="admin-cell">{@value}</span>
    """
  end

  # Used both as a normal field and as a computed column, where the record has
  # no key of its own.
  defp source(record, %Field{name: name}) do
    (Map.get(record, name) || Map.get(record, :title)) |> to_string()
  end

  @impl true
  def export(%Field{} = field, record), do: Map.get(record, field.name)
end
