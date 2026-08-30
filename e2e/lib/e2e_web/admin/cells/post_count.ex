defmodule E2eWeb.Admin.Cells.PostCount do
  @moduledoc """
  Computed column: how many posts an author has.

  Declared with `column/3`, so it is read-only and never appears on the form.
  The value comes from the preload the context already did, not a query here.
  """

  @behaviour CorexAdmin.Field

  use Phoenix.Component
  use Corex

  @impl true
  def input(assigns) do
    ~H"""
    <span class="admin-cell">{count(@record)}</span>
    """
  end

  @impl true
  def display(assigns) do
    assigns = assign(assigns, :count, count(assigns.record))

    ~H"""
    <span class="admin-cell">{@count}</span>
    """
  end

  @impl true
  def export(_field, record), do: count(record)

  @impl true
  def text(_field, record), do: to_string(count(record))

  defp count(record) do
    case Map.get(record, :posts) do
      list when is_list(list) -> length(list)
      _ -> 0
    end
  end
end
