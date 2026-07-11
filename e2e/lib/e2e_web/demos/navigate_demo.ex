defmodule E2eWeb.Demos.NavigateDemo do
  use E2eWeb, :html

  alias E2eWeb.DemoScales

  def anatomy_minimal_code do
    ~S"""
    <.navigate to="#" class="link">Internal Link</.navigate>
    """
  end

  def anatomy_minimal_example(assigns) do
    ~H"""
    <.navigate to="#" class="link">Internal Link</.navigate>
    """
  end

  def anatomy_with_icon_code do
    ~S"""
    <.navigate to="#" class="link">
      Internal Link
      <span aria-hidden="true"><.heroicon name="hero-arrow-right" class="icon" /></span>
    </.navigate>
    """
  end

  def anatomy_with_icon_example(assigns) do
    ~H"""
    <.navigate to="#" class="link">
      Internal Link <span aria-hidden="true"><.heroicon name="hero-arrow-right" class="icon" /></span>
    </.navigate>
    """
  end

  def anatomy_icon_only_code do
    ~S"""
    <.navigate to="#" class="link" aria_label="Internal link icon only">
      <span aria-hidden="true"><.heroicon name="hero-arrow-right" class="icon" /></span>
    </.navigate>
    """
  end

  def anatomy_icon_only_example(assigns) do
    ~H"""
    <.navigate to="#" class="link" aria_label="Internal link icon only">
      <span aria-hidden="true"><.heroicon name="hero-arrow-right" class="icon" /></span>
    </.navigate>
    """
  end

  def patterns_href_code do
    ~S"""
    <.navigate to="#" class="link">Default href</.navigate>
    <.navigate to="#" class="link" type="href">Explicit href</.navigate>
    """
  end

  def patterns_href_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-center gap-space gap-2">
      <.navigate to="#" class="link">Default href</.navigate>
      <.navigate to="#" class="link" type="href">Explicit href</.navigate>
    </div>
    """
  end

  def patterns_navigate_code do
    ~S"""
    <.navigate to={~p"/navigate/patterns"} type="navigate" class="link">
      LiveView navigate
    </.navigate>
    """
  end

  def patterns_navigate_example(assigns) do
    ~H"""
    <.navigate to={~p"/navigate/patterns"} type="navigate" class="link">
      LiveView navigate
    </.navigate>
    """
  end

  def patterns_patch_code do
    ~S"""
    <.navigate to={~p"/navigate/patterns?tab=demo"} type="patch" class="link">
      LiveView patch
    </.navigate>
    """
  end

  def patterns_patch_example(assigns) do
    ~H"""
    <.navigate to={~p"/navigate/patterns?tab=demo"} type="patch" class="link">
      LiveView patch
    </.navigate>
    """
  end

  def patterns_external_and_download_code do
    ~S"""
    <.navigate to="https://example.com" class="link" external>
      External Link
      <.heroicon name="hero-arrow-top-right-on-square" class="icon" />
    </.navigate>
    <.navigate to="#" class="link" download="report.pdf">
      Download Link
      <.heroicon name="hero-arrow-down-tray" class="icon" />
    </.navigate>
    """
  end

  def patterns_external_and_download_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-center gap-space gap-2">
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
    <div class="flex flex-wrap items-center gap-space gap-2">
      <.navigate to="#" class="link ui-accent">Accent</.navigate>
      <.navigate to="#" class="link ui-brand">Brand</.navigate>
      <.navigate to="#" class="link ui-alert">Alert</.navigate>
      <.navigate to="#" class="link ui-info">Info</.navigate>
      <.navigate to="#" class="link ui-success">Success</.navigate>
    </div>
    """
  end

  def styling_color_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-center gap-space gap-2">
      <.navigate to="#" class="link ui-accent">Accent</.navigate>
      <.navigate to="#" class="link ui-brand">Brand</.navigate>
      <.navigate to="#" class="link ui-alert">Alert</.navigate>
      <.navigate to="#" class="link ui-info">Info</.navigate>
      <.navigate to="#" class="link ui-success">Success</.navigate>
    </div>
    """
  end

  def styling_variant_code do
    ~S"""
    <.navigate class="link" to="#">Subtle (default)</.navigate>
    <.navigate class="link ui-solid" to="#">Solid</.navigate>
    """
  end

  def styling_variant_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap items-center gap-space gap-2">
      <.navigate id="navigate-style-variant-subtle" class="link" to="#">Subtle (default)</.navigate>
      <.navigate id="navigate-style-variant-solid" class="link ui-solid" to="#">
        Solid
      </.navigate>
    </div>
    """
  end

  def styling_variant_matrix_code do
    for semantic <- DemoScales.styling_semantic_axis_steps("link"),
        variant <- DemoScales.styling_variant_axis_steps("link") do
      class = DemoScales.join_matrix_modifiers("link", semantic.modifier, variant.modifier)

      ~s(<.navigate class="#{class}" to="#">#{semantic.label}</.navigate>)
    end
    |> DemoScales.join_code()
  end

  def styling_variant_matrix_example(assigns) do
    assigns =
      assigns
      |> assign(:matrix_semantics, DemoScales.styling_semantic_axis_steps("link"))
      |> assign(:matrix_variants, DemoScales.styling_variant_axis_steps("link"))

    ~H"""
    <div class="w-full overflow-x-auto scrollbar scrollbar--sm">
      <div class="grid grid-cols-4 gap-space gap-2 items-center min-w-max">
        <div :for={semantic <- @matrix_semantics} class="contents">
          <.navigate
            :for={variant <- @matrix_variants}
            class={DemoScales.join_matrix_modifiers("link", semantic.modifier, variant.modifier)}
            to="#"
          >
            {semantic.label}
          </.navigate>
        </div>
      </div>
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <div class="flex flex-wrap items-center gap-space gap-2">
      <.navigate to="#" class="link ui-size-sm">Small</.navigate>
      <.navigate to="#" class="link ui-size-md">Medium</.navigate>
      <.navigate to="#" class="link ui-size-lg">Large</.navigate>
      <.navigate to="#" class="link ui-size-xl">XL</.navigate>
    </div>
    """
  end

  def styling_size_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-center gap-space gap-2">
      <.navigate to="#" class="link ui-size-sm">Small</.navigate>
      <.navigate to="#" class="link ui-size-md">Medium</.navigate>
      <.navigate to="#" class="link ui-size-lg">Large</.navigate>
      <.navigate to="#" class="link ui-size-xl">XL</.navigate>
    </div>
    """
  end
end
