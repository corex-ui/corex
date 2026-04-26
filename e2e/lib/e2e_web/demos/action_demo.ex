defmodule E2eWeb.Demos.ActionDemo do
  use E2eWeb, :html

  def anatomy_basic_code do
    ~S"""
    <.action class="button">Text</.action>
    <.action class="button">
      Text and icon <.heroicon name="hero-arrow-right" />
    </.action>
    """
  end

  def anatomy_basic_example(assigns) do
    ~H"""
    <div class="layout__row gap-2">
      <.action class="button">Text</.action>
      <.action class="button">
        Text and icon <.heroicon name="hero-arrow-right" />
      </.action>
    </div>
    """
  end

  def anatomy_icon_only_code do
    ~S"""
    <.action class="button button--square" aria_label="Icon button">
      <.heroicon name="hero-arrow-right" />
    </.action>
    <.action class="button button--circle" aria_label="Icon button">
      <.heroicon name="hero-arrow-right" />
    </.action>
    """
  end

  def anatomy_icon_only_example(assigns) do
    ~H"""
    <div class="layout__row gap-2">
      <.action class="button button--square" aria_label="Icon button">
        <.heroicon name="hero-arrow-right" />
      </.action>
      <.action class="button button--circle" aria_label="Icon button">
        <.heroicon name="hero-arrow-right" />
      </.action>
    </div>
    """
  end

  def styling_color_code do
    ~S"""
    <.action class="button">Default</.action>
    <.action class="button button--accent">Accent</.action>
    <.action class="button button--brand">Brand</.action>
    <.action class="button button--alert">Alert</.action>
    <.action class="button button--info">Info</.action>
    <.action class="button button--success">Success</.action>
    """
  end

  def styling_color_example(assigns) do
    ~H"""
    <div class="layout__row gap-2">
      <.action class="button">Default</.action>
      <.action class="button button--accent">Accent</.action>
      <.action class="button button--brand">Brand</.action>
      <.action class="button button--alert">Alert</.action>
      <.action class="button button--info">Info</.action>
      <.action class="button button--success">Success</.action>
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <.action class="button button--sm">Small</.action>
    <.action class="button">Medium</.action>
    <.action class="button button--lg">Large</.action>
    <.action class="button button--xl">XL</.action>
    """
  end

  def styling_size_example(assigns) do
    ~H"""
    <div class="layout__row gap-2 items-center">
      <.action class="button button--sm">Small</.action>
      <.action class="button">Medium</.action>
      <.action class="button button--lg">Large</.action>
      <.action class="button button--xl">XLarge</.action>
    </div>
    """
  end

  def styling_shape_code do
    ~S"""
    <.action class="button button--square" aria_label="Square button">
      <.heroicon name="hero-arrow-right" />
    </.action>
    <.action class="button button--circle" aria_label="Circle button">
      <.heroicon name="hero-arrow-right" />
    </.action>
    """
  end

  def styling_shape_example(assigns) do
    ~H"""
    <div class="layout__row gap-2 items-center">
      <.action class="button button--square" aria_label="Square button">
        <.heroicon name="hero-arrow-right" />
      </.action>
      <.action class="button button--circle" aria_label="Circle button">
        <.heroicon name="hero-arrow-right" />
      </.action>
    </div>
    """
  end

  def styling_disabled_code do
    ~S"""
    <.action class="button" disabled>Disabled</.action>
    <.action class="button button--accent" disabled>Disabled</.action>
    <.action class="button button--square" aria_label="Disabled" disabled>
      <.heroicon name="hero-arrow-right" />
    </.action>
    """
  end

  def styling_disabled_example(assigns) do
    ~H"""
    <div class="layout__row gap-2 items-center">
      <.action class="button" disabled>Disabled</.action>
      <.action class="button button--accent" disabled>Disabled</.action>
      <.action class="button button--square" aria_label="Disabled" disabled>
        <.heroicon name="hero-arrow-right" />
      </.action>
    </div>
    """
  end
end
