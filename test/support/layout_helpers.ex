defmodule CorexTest.LayoutHelpers do
  @moduledoc false

  use Phoenix.Component

  import Corex.Layout.Box
  import Corex.Layout.Stack
  import Corex.Layout.Row
  import Corex.Layout.Grid
  import Corex.Layout.Container
  import Corex.Layout.Spacer
  import Corex.Layout.Divider

  def render_box(assigns) do
    assigns = assign_new(assigns, :padding, fn -> "lg" end)

    ~H"""
    <.box padding={@padding}>boxed</.box>
    """
  end

  def render_row(assigns) do
    assigns =
      assigns
      |> assign_new(:gap, fn -> "lg" end)
      |> assign_new(:justify, fn -> "between" end)

    ~H"""
    <.row gap={@gap} justify={@justify}>
      <span>left</span>
      <span>right</span>
    </.row>
    """
  end

  def render_row_padding(assigns) do
    ~H"""
    <.row gap="md" padding_inline="xl" padding_block="md">
      <span>left</span>
    </.row>
    """
  end

  def render_stack(assigns) do
    assigns = assign_new(assigns, :gap, fn -> "md" end)

    ~H"""
    <.stack gap={@gap}>
      <span>one</span>
    </.stack>
    """
  end

  def render_grid(assigns) do
    assigns = assign_new(assigns, :columns, fn -> "3" end)

    ~H"""
    <.grid columns={@columns} gap="lg">
      <span>cell</span>
    </.grid>
    """
  end

  def render_container(assigns) do
    assigns = assign_new(assigns, :size, fn -> "lg" end)

    ~H"""
    <.container size={@size}>page</.container>
    """
  end

  def render_spacer(assigns) do
    ~H"""
    <.spacer />
    """
  end

  def render_divider(assigns) do
    assigns = assign_new(assigns, :orientation, fn -> "horizontal" end)

    ~H"""
    <.divider orientation={@orientation} />
    """
  end
end
