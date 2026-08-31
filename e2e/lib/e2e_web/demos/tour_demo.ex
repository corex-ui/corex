defmodule E2eWeb.Demos.TourDemo do
  use E2eWeb, :html

  def anatomy_minimal_code do
    ~S"""
    <.action phx-click={Corex.Tour.start("tour-anatomy-minimal")} class="button">Start tour</.action>
    <button id="tour-target-nav" type="button" class="button ui-size-sm">Docs</button>
    <button id="tour-target-playground" type="button" class="button ui-size-sm">Playground</button>
    <.tour id="tour-anatomy-minimal" class="tour" />
    """
  end

  def anatomy_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-col gap-space items-center">
      <.action phx-click={Corex.Tour.start("tour-anatomy-minimal")} class="button">
        Start tour
      </.action>
      <div class="flex gap-space-sm">
        <button id="tour-target-nav" type="button" class="button ui-size-sm">Docs</button>
        <button id="tour-target-playground" type="button" class="button ui-size-sm">Playground</button>
      </div>
      <.tour id="tour-anatomy-minimal" class="tour" />
    </div>
    """
  end

  alias E2eWeb.DemoScales

  def styling_color_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.tour class="tour" />
    <.tour class="tour ui-accent" />
    <.tour class="tour ui-brand" />
    <.tour class="tour ui-alert" />
    <.tour class="tour ui-success" />
    <.tour class="tour ui-info" />
    </div>
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.tour id="tour-style-default" class="tour" />
      <.tour id="tour-style-accent" class="tour ui-accent" />
      <.tour id="tour-style-brand" class="tour ui-brand" />
      <.tour id="tour-style-alert" class="tour ui-alert" />
      <.tour id="tour-style-success" class="tour ui-success" />
      <.tour id="tour-style-info" class="tour ui-info" />
    </div>
    """
  end

  def styling_variant_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.tour class="tour" />
    <.tour class="tour ui-solid" />
    </div>
    """
  end

  def styling_variant_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.tour id="tour-style-subtle" class="tour" />
      <.tour id="tour-style-solid" class="tour ui-solid" />
    </div>
    """
  end

  def styling_variant_matrix_code do
    for semantic <- DemoScales.styling_semantic_axis_steps("tour"),
        variant <- DemoScales.styling_variant_axis_steps("tour") do
      class = DemoScales.join_matrix_modifiers("tour", semantic.modifier, variant.modifier)

      ~s(<.tour class="#{class}">)
    end
    |> DemoScales.join_code()
  end

  def styling_variant_matrix_example(assigns) do
    assigns =
      assigns
      |> assign(:matrix_semantics, DemoScales.styling_semantic_axis_steps("tour"))
      |> assign(:matrix_variants, DemoScales.styling_variant_axis_steps("tour"))

    ~H"""
    <div class="w-full overflow-x-auto scrollbar scrollbar--sm">
      <div class="grid grid-cols-4 gap-space items-start min-w-max">
        <div :for={semantic <- @matrix_semantics} class="contents">
          <.tour
            :for={variant <- @matrix_variants}
            id={"tour-mx-#{semantic.label}-#{variant.label}"}
            class={DemoScales.join_matrix_modifiers("tour", semantic.modifier, variant.modifier)}
          />
        </div>
      </div>
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.tour class="tour ui-size-sm" />
    <.tour class="tour ui-size-md" />
    <.tour class="tour ui-size-lg" />
    <.tour class="tour ui-size-xl" />
    </div>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.tour id="tour-style-size-sm" class="tour ui-size-sm" />
      <.tour id="tour-style-size-md" class="tour ui-size-md" />
      <.tour id="tour-style-size-lg" class="tour ui-size-lg" />
      <.tour id="tour-style-size-xl" class="tour ui-size-xl" />
    </div>
    """
  end

  def styling_rounded_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.tour class="tour ui-rounded-none" />
    <.tour class="tour ui-rounded-sm" />
    <.tour class="tour ui-rounded-md" />
    <.tour class="tour ui-rounded-lg" />
    <.tour class="tour ui-rounded-xl" />
    <.tour class="tour ui-rounded-full" />
    </div>
    """
  end

  def styling_rounded_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.tour id="tour-style-r-none" class="tour ui-rounded-none" />
      <.tour id="tour-style-r-sm" class="tour ui-rounded-sm" />
      <.tour id="tour-style-r-md" class="tour ui-rounded-md" />
      <.tour id="tour-style-r-lg" class="tour ui-rounded-lg" />
      <.tour id="tour-style-r-xl" class="tour ui-rounded-xl" />
      <.tour id="tour-style-r-full" class="tour ui-rounded-full" />
    </div>
    """
  end
end
