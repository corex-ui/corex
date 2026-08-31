defmodule E2eWeb.Demos.ScrollAreaDemo do
  use E2eWeb, :html

  def anatomy_minimal_code do
    ~S"""
    <.scroll_area class="scroll-area" />
    """
  end

  def anatomy_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <.scroll_area id="scroll-area-anatomy-minimal" class="scroll-area" />
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <.scroll_area id="scroll-area-style-accent" class="scroll-area ui-accent" />
    """
  end
end
