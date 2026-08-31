defmodule E2eWeb.Demos.DateInputDemo do
  use E2eWeb, :html

  def anatomy_minimal_code do
    ~S"""
    <.date_input class="date-input" />
    """
  end

  def anatomy_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <.date_input id="date-input-anatomy-minimal" class="date-input" />
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <.date_input id="date-input-style-accent" class="date-input ui-accent" />
    """
  end
end
