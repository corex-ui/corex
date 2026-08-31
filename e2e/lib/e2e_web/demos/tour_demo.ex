defmodule E2eWeb.Demos.TourDemo do
  use E2eWeb, :html

  def anatomy_minimal_code do
    ~S"""
    <.tour class="tour" />
    """
  end

  def anatomy_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <.tour id="tour-anatomy-minimal" class="tour" />
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <.tour id="tour-style-accent" class="tour ui-accent" />
    """
  end
end
