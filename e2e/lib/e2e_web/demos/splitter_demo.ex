defmodule E2eWeb.Demos.SplitterDemo do
  use E2eWeb, :html

  def anatomy_minimal_code do
    ~S"""
    <.splitter class="splitter" />
    """
  end

  def anatomy_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <.splitter id="splitter-anatomy-minimal" class="splitter" />
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <.splitter id="splitter-style-accent" class="splitter ui-accent" />
    """
  end
end
