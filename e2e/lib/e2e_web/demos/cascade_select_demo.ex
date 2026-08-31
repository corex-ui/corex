defmodule E2eWeb.Demos.CascadeSelectDemo do
  use E2eWeb, :html

  def anatomy_minimal_code do
    ~S"""
    <.cascade_select class="cascade-select" />
    """
  end

  def anatomy_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <.cascade_select id="cascade-select-anatomy-minimal" class="cascade-select" />
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <.cascade_select id="cascade-select-style-accent" class="cascade-select ui-accent" />
    """
  end
end
