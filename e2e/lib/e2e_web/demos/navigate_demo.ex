defmodule E2eWeb.Demos.NavigateDemo do
  use E2eWeb, :html

  def anatomy_basic_code do
    ~S"""
    <div class="layout__row gap-2">
      <.navigate to="#" class="link">Internal Link</.navigate>
      <.navigate to="#" class="link">
        Internal Link
        <span aria-hidden="true"><.heroicon name="hero-arrow-right" class="icon" /></span>
      </.navigate>
      <.navigate to="#" class="link" aria_label="Internal link icon only">
        <span aria-hidden="true"><.heroicon name="hero-arrow-right" class="icon" /></span>
      </.navigate>
    </div>
    """
  end

  def anatomy_basic_example(assigns) do
    ~H"""
    <div class="layout__row gap-2">
      <.navigate to="#" class="link">Internal Link</.navigate>
      <.navigate to="#" class="link">
        Internal Link
        <span aria-hidden="true"><.heroicon name="hero-arrow-right" class="icon" /></span>
      </.navigate>
      <.navigate to="#" class="link" aria_label="Internal link icon only">
        <span aria-hidden="true"><.heroicon name="hero-arrow-right" class="icon" /></span>
      </.navigate>
    </div>
    """
  end

  def anatomy_external_and_download_code do
    ~S"""
    <div class="layout__row gap-2">
      <.navigate to="https://example.com" class="link" external>
        External Link
        <.heroicon name="hero-arrow-top-right-on-square" class="icon" />
      </.navigate>
      <.navigate to="#" class="link" download="report.pdf">
        Download Link
        <.heroicon name="hero-arrow-down-tray" class="icon" />
      </.navigate>
    </div>
    """
  end

  def anatomy_external_and_download_example(assigns) do
    ~H"""
    <div class="layout__row gap-2">
      <.navigate to="https://example.com" class="link" external>
        External Link <.heroicon name="hero-arrow-top-right-on-square" class="icon" />
      </.navigate>
      <.navigate to="#" class="link" download="report.pdf">
        Download Link <.heroicon name="hero-arrow-down-tray" class="icon" />
      </.navigate>
    </div>
    """
  end

  def styling_color_code do
    ~S"""
    <div class="layout__row gap-2">
      <.navigate to="#" class="link link--accent">Accent</.navigate>
      <.navigate to="#" class="link link--brand">Brand</.navigate>
      <.navigate to="#" class="link link--alert">Alert</.navigate>
      <.navigate to="#" class="link link--info">Info</.navigate>
      <.navigate to="#" class="link link--success">Success</.navigate>
    </div>
    """
  end

  def styling_color_example(assigns) do
    ~H"""
    <div class="layout__row gap-2">
      <.navigate to="#" class="link link--accent">Accent</.navigate>
      <.navigate to="#" class="link link--brand">Brand</.navigate>
      <.navigate to="#" class="link link--alert">Alert</.navigate>
      <.navigate to="#" class="link link--info">Info</.navigate>
      <.navigate to="#" class="link link--success">Success</.navigate>
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <div class="layout__row gap-2 items-center">
      <.navigate to="#" class="link link--sm">Small</.navigate>
      <.navigate to="#" class="link link--md">Medium</.navigate>
      <.navigate to="#" class="link link--lg">Large</.navigate>
      <.navigate to="#" class="link link--xl">XL</.navigate>
    </div>
    """
  end

  def styling_size_example(assigns) do
    ~H"""
    <div class="layout__row gap-2 items-center">
      <.navigate to="#" class="link link--sm">Small</.navigate>
      <.navigate to="#" class="link link--md">Medium</.navigate>
      <.navigate to="#" class="link link--lg">Large</.navigate>
      <.navigate to="#" class="link link--xl">XL</.navigate>
    </div>
    """
  end
end
