defmodule E2eWeb.Demos.NavigateDemo do
  use E2eWeb, :html

  alias E2eWeb.Demos.StylingAxes

  def styling_axis_values(axis), do: StylingAxes.styling_axis_values(axis)

  def anatomy_minimal_code do
    ~S"""
    <.navigate to="#"  >Internal Link</.navigate>
    """
  end

  def anatomy_minimal_example(assigns) do
    ~H"""
    <.navigate to="#">Internal Link</.navigate>
    """
  end

  def anatomy_with_icon_code do
    ~S"""
    <.navigate to="#"  >
      Internal Link
      <span aria-hidden="true"><.heroicon name="hero-arrow-right" /></span>
    </.navigate>
    """
  end

  def anatomy_with_icon_example(assigns) do
    ~H"""
    <.navigate to="#">
      Internal Link <span aria-hidden="true"><.heroicon name="hero-arrow-right" /></span>
    </.navigate>
    """
  end

  def anatomy_icon_only_code do
    ~S"""
    <.navigate to="#"   aria_label="Internal link icon only">
      <span aria-hidden="true"><.heroicon name="hero-arrow-right" /></span>
    </.navigate>
    """
  end

  def anatomy_icon_only_example(assigns) do
    ~H"""
    <.navigate to="#" aria_label="Internal link icon only">
      <span aria-hidden="true"><.heroicon name="hero-arrow-right" /></span>
    </.navigate>
    """
  end

  def patterns_href_code do
    ~S"""
    <.navigate to="#"  >Default href</.navigate>
    <.navigate to="#"   type="href">Explicit href</.navigate>
    """
  end

  def patterns_href_example(assigns) do
    ~H"""
    <div class="layout__row gap-2">
      <.navigate to="#">Default href</.navigate>
      <.navigate to="#" type="href">Explicit href</.navigate>
    </div>
    """
  end

  def patterns_navigate_code do
    ~S"""
    <.navigate to={~p"/navigate/patterns"} type="navigate"  >
      LiveView navigate
    </.navigate>
    """
  end

  def patterns_navigate_example(assigns) do
    ~H"""
    <.navigate to={~p"/navigate/patterns"} type="navigate">
      LiveView navigate
    </.navigate>
    """
  end

  def patterns_patch_code do
    ~S"""
    <.navigate to={~p"/navigate/patterns?tab=demo"} type="patch"  >
      LiveView patch
    </.navigate>
    """
  end

  def patterns_patch_example(assigns) do
    ~H"""
    <.navigate to={~p"/navigate/patterns?tab=demo"} type="patch">
      LiveView patch
    </.navigate>
    """
  end

  def patterns_external_and_download_code do
    ~S"""
    <.navigate to="https://example.com"   external>
      External Link
      <.heroicon name="hero-arrow-top-right-on-square" />
    </.navigate>
    <.navigate to="#"   download="report.pdf">
      Download Link
      <.heroicon name="hero-arrow-down-tray" />
    </.navigate>
    """
  end

  def patterns_external_and_download_example(assigns) do
    ~H"""
    <div class="layout__row gap-2">
      <.navigate to="https://example.com" external>
        External Link <.heroicon name="hero-arrow-top-right-on-square" />
      </.navigate>
      <.navigate to="#" download="report.pdf">
        Download Link <.heroicon name="hero-arrow-down-tray" />
      </.navigate>
    </div>
    """
  end

  def styling_semantic_code do
    ~S"""
    <div class="layout__row gap-2">
      <.navigate to="#" semantic="accent" >Accent</.navigate>
      <.navigate to="#" semantic="brand" >Brand</.navigate>
      <.navigate to="#" semantic="alert" >Alert</.navigate>
      <.navigate to="#" semantic="info" >Info</.navigate>
      <.navigate to="#" semantic="success" >Success</.navigate>
    </div>
    """
  end

  def styling_semantic_example(assigns) do
    ~H"""
    <div class="layout__row gap-2">
      <.navigate to="#" semantic="accent">Accent</.navigate>
      <.navigate to="#" semantic="brand">Brand</.navigate>
      <.navigate to="#" semantic="alert">Alert</.navigate>
      <.navigate to="#" semantic="info">Info</.navigate>
      <.navigate to="#" semantic="success">Success</.navigate>
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <div class="layout__row gap-2 items-center">
      <.navigate to="#" size="sm" >Small</.navigate>
      <.navigate to="#" size="md" >Medium</.navigate>
      <.navigate to="#" size="lg" >Large</.navigate>
      <.navigate to="#" size="xl" >XL</.navigate>
    </div>
    """
  end

  def styling_size_example(assigns) do
    ~H"""
    <div class="layout__row gap-2 items-center">
      <.navigate to="#" size="sm">Small</.navigate>
      <.navigate to="#" size="md">Medium</.navigate>
      <.navigate to="#" size="lg">Large</.navigate>
      <.navigate to="#" size="xl">XL</.navigate>
    </div>
    """
  end

  def styling_button_cta_code do
    ~S"""
    <div class="layout__row gap-2 flex-wrap">
      <.navigate
        to={~p"/accordion/playground"}
        as="button"
        variant="solid"
        semantic="brand"
        size="lg"
        radius="full"
      >
        Browse components
        <.heroicon name="hero-arrow-right" />
      </.navigate>
      <.navigate
        to="https://hexdocs.pm/corex/installation.html"
        as="button"
        variant="ghost"
        size="lg"
        radius="full"
        external
      >
        Visit Hexdocs
        <.heroicon name="hero-arrow-top-right-on-square" />
      </.navigate>
    </div>
    """
  end

  attr :primary_to, :string, required: true
  attr :secondary_to, :string, required: true
  attr :primary_label, :string, required: true
  attr :secondary_label, :string, required: true
  attr :class, :string, default: "layout__row gap-2 flex-wrap"

  def styling_button_cta_example(assigns) do
    ~H"""
    <div class={@class}>
      <.navigate
        to={@primary_to}
        as="button"
        variant="solid"
        semantic="brand"
        size="lg"
        radius="full"
      >
        {@primary_label}
        <.heroicon name="hero-arrow-right" />
      </.navigate>
      <.navigate
        to={@secondary_to}
        as="button"
        variant="ghost"
        size="lg"
        radius="full"
        external
      >
        {@secondary_label}
        <.heroicon name="hero-arrow-top-right-on-square" />
      </.navigate>
    </div>
    """
  end

  def style_preview(assigns), do: E2eWeb.Demos.StylePreview.preview(:navigate, assigns)
  def style_playground(assigns), do: style_preview(assigns)

end
