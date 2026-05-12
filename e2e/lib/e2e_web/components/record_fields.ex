defmodule E2eWeb.RecordFields do
  use Phoenix.Component

  alias E2eWeb.SignaturePaths

  attr(:record, :any, required: true)
  attr(:field, :atom, required: true)

  def record_field_value(assigns) do
    value = get_value(assigns.record, assigns.field)
    assigns = assign(assigns, :value, value)

    ~H"""
    <%= case @field do %>
      <% :signature -> %>
        <.signature_preview signature={@value} />
      <% _ -> %>
        {format_value(@value)}
    <% end %>
    """
  end

  attr(:signature, :string, default: nil)

  def signature_preview(assigns) do
    path_d_values = SignaturePaths.path_d_list(assigns.signature)
    assigns = assign(assigns, :path_d_values, path_d_values)

    ~H"""
    <span :if={@path_d_values == []} class="text-muted"> - </span>
    <svg
      :if={@path_d_values != []}
      viewBox="0 0 200 100"
      class="inline-block w-12 h-6 border border-muted rounded"
      aria-hidden="true"
    >
      <g
        fill="none"
        stroke="currentColor"
        stroke-width="1.5"
        stroke-linecap="round"
        stroke-linejoin="round"
      >
        <path :for={d <- @path_d_values} d={d} />
      </g>
    </svg>
    """
  end

  def fields(nil), do: []

  def fields(%_{} = record) do
    record
    |> Map.from_struct()
    |> Map.delete(:__meta__)
    |> Map.keys()
    |> Enum.sort()
  end

  def fields(record) when is_map(record) do
    record
    |> Map.keys()
    |> Enum.reject(&(&1 in [:__struct__, :__meta__]))
    |> Enum.sort()
  end

  def label(field) when is_atom(field) do
    field
    |> Atom.to_string()
    |> Phoenix.Naming.humanize()
  end

  defp get_value(%_{} = record, field) do
    record
    |> Map.from_struct()
    |> Map.get(field)
  end

  defp get_value(record, field) when is_map(record), do: Map.get(record, field)
  defp get_value(_record, _field), do: nil

  defp format_value(nil), do: " - "
  defp format_value(true), do: "Yes"
  defp format_value(false), do: "No"
  defp format_value(%Date{} = date), do: Calendar.strftime(date, "%d %b %Y")

  defp format_value(%NaiveDateTime{} = dt),
    do: Calendar.strftime(dt, "%d %b %Y %H:%M:%S")

  defp format_value(%DateTime{} = dt),
    do: Calendar.strftime(dt, "%d %b %Y %H:%M:%S")

  defp format_value(value) when is_binary(value) do
    if value == "" do
      " - "
    else
      value
    end
  end

  defp format_value(value) when is_list(value) do
    value
    |> Enum.map(&format_value/1)
    |> Enum.join(", ")
  end

  defp format_value(value) when is_map(value) do
    inspect(value, pretty: true, limit: 50, printable_limit: 2_000)
  end

  defp format_value(value) do
    inspect(value, pretty: true, limit: 50, printable_limit: 2_000)
  end
end
