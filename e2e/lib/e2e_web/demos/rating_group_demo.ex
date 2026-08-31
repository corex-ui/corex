defmodule E2eWeb.Demos.RatingGroupDemo do
  use E2eWeb, :html

  def anatomy_minimal_code do
    ~S"""
    <.rating_group class="rating-group" />
    """
  end

  def anatomy_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <.rating_group id="rating-group-anatomy-minimal" class="rating-group" />
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <.rating_group id="rating-group-style-accent" class="rating-group ui-accent" />
    """
  end
end
