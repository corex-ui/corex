defmodule E2eWeb.Demos.PresenceDemo do
  use E2eWeb, :html

  def anatomy_minimal_code do
    ~S"""
    <.presence class="presence" />
    """
  end

  def anatomy_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <.presence id="presence-anatomy-minimal" class="presence" />
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <.presence id="presence-style-accent" class="presence ui-accent" />
    """
  end
end
