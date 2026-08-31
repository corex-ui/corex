defmodule E2eWeb.Demos.QrCodeDemo do
  use E2eWeb, :html

  def anatomy_minimal_code do
    ~S"""
    <.qr_code class="qr-code" />
    """
  end

  def anatomy_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <.qr_code id="qr-code-anatomy-minimal" class="qr-code" />
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <.qr_code id="qr-code-style-accent" class="qr-code ui-accent" />
    """
  end
end
