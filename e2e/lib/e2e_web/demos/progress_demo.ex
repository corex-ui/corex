defmodule E2eWeb.Demos.ProgressDemo do
  use E2eWeb, :html

  def anatomy_minimal_code do
    ~S"""
    <.progress class="progress" />
    """
  end

  def anatomy_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <.progress id="progress-anatomy-minimal" class="progress" />
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <.progress id="progress-style-accent" class="progress ui-accent" />
    """
  end
end
