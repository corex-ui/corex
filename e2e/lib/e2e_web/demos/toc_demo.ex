defmodule E2eWeb.Demos.TocDemo do
  use E2eWeb, :html

  def anatomy_minimal_code do
    ~S"""
    <.toc class="toc" />
    """
  end

  def anatomy_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <.toc id="toc-anatomy-minimal" class="toc" />
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <.toc id="toc-style-accent" class="toc ui-accent" />
    """
  end
end
