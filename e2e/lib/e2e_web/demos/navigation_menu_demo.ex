defmodule E2eWeb.Demos.NavigationMenuDemo do
  use E2eWeb, :html

  def anatomy_minimal_code do
    ~S"""
    <.navigation_menu class="navigation-menu" />
    """
  end

  def anatomy_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <.navigation_menu id="navigation-menu-anatomy-minimal" class="navigation-menu" />
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <.navigation_menu id="navigation-menu-style-accent" class="navigation-menu ui-accent" />
    """
  end
end
