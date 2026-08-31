defmodule E2eWeb.Demos.StepsDemo do
  use E2eWeb, :html

  def anatomy_minimal_code do
    ~S"""
    <.steps class="steps" />
    """
  end

  def anatomy_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <.steps id="steps-anatomy-minimal" class="steps" />
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <.steps id="steps-style-accent" class="steps ui-accent" />
    """
  end
end
