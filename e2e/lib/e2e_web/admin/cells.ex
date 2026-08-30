defmodule E2eWeb.Admin.Cells do
  @moduledoc """
  Per-field cell overrides for the admin demo.

  A resource names these with `render: {E2eWeb.Admin.Cells, :status}` when only
  the cell needs to change. Writing a whole field module would be the wrong size
  of tool for a badge.
  """

  use Phoenix.Component
  use Corex

  @doc "Status as a semantic badge instead of bare text."
  def status(assigns) do
    assigns = assign(assigns, :semantic, semantic(assigns.value))

    ~H"""
    <span class={["badge ui-size-sm", @semantic]}>{@value}</span>
    """
  end

  defp semantic("published"), do: "ui-success"
  defp semantic("done"), do: "ui-success"
  defp semantic("open"), do: "ui-info"
  defp semantic("scheduled"), do: "ui-info"
  defp semantic("pending"), do: "ui-accent"
  defp semantic("draft"), do: "ui-accent"
  defp semantic(_), do: ""
end
