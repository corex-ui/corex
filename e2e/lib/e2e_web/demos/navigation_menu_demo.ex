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

  alias E2eWeb.DemoScales

  def styling_color_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.navigation_menu class="navigation-menu" />
    <.navigation_menu class="navigation-menu ui-accent" />
    <.navigation_menu class="navigation-menu ui-brand" />
    <.navigation_menu class="navigation-menu ui-alert" />
    <.navigation_menu class="navigation-menu ui-success" />
    <.navigation_menu class="navigation-menu ui-info" />
    </div>
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.navigation_menu id="navigation-menu-style-default" class="navigation-menu" />
      <.navigation_menu id="navigation-menu-style-accent" class="navigation-menu ui-accent" />
      <.navigation_menu id="navigation-menu-style-brand" class="navigation-menu ui-brand" />
      <.navigation_menu id="navigation-menu-style-alert" class="navigation-menu ui-alert" />
      <.navigation_menu id="navigation-menu-style-success" class="navigation-menu ui-success" />
      <.navigation_menu id="navigation-menu-style-info" class="navigation-menu ui-info" />
    </div>
    """
  end

  def styling_variant_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.navigation_menu class="navigation-menu" />
    <.navigation_menu class="navigation-menu ui-solid" />
    </div>
    """
  end

  def styling_variant_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.navigation_menu id="navigation-menu-style-subtle" class="navigation-menu" />
      <.navigation_menu id="navigation-menu-style-solid" class="navigation-menu ui-solid" />
    </div>
    """
  end

  def styling_variant_matrix_code do
    for semantic <- DemoScales.styling_semantic_axis_steps("navigation-menu"),
        variant <- DemoScales.styling_variant_axis_steps("navigation-menu") do
      class =
        DemoScales.join_matrix_modifiers("navigation-menu", semantic.modifier, variant.modifier)

      ~s(<.navigation_menu class="#{class}">)
    end
    |> DemoScales.join_code()
  end

  def styling_variant_matrix_example(assigns) do
    assigns =
      assigns
      |> assign(:matrix_semantics, DemoScales.styling_semantic_axis_steps("navigation-menu"))
      |> assign(:matrix_variants, DemoScales.styling_variant_axis_steps("navigation-menu"))

    ~H"""
    <div class="w-full overflow-x-auto scrollbar scrollbar--sm">
      <div class="grid grid-cols-4 gap-space items-start min-w-max">
        <div :for={semantic <- @matrix_semantics} class="contents">
          <.navigation_menu
            :for={variant <- @matrix_variants}
            id={"navigation-menu-mx-#{semantic.label}-#{variant.label}"}
            class={
              DemoScales.join_matrix_modifiers("navigation-menu", semantic.modifier, variant.modifier)
            }
          />
        </div>
      </div>
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.navigation_menu class="navigation-menu ui-size-sm" />
    <.navigation_menu class="navigation-menu ui-size-md" />
    <.navigation_menu class="navigation-menu ui-size-lg" />
    <.navigation_menu class="navigation-menu ui-size-xl" />
    </div>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.navigation_menu id="navigation-menu-style-size-sm" class="navigation-menu ui-size-sm" />
      <.navigation_menu id="navigation-menu-style-size-md" class="navigation-menu ui-size-md" />
      <.navigation_menu id="navigation-menu-style-size-lg" class="navigation-menu ui-size-lg" />
      <.navigation_menu id="navigation-menu-style-size-xl" class="navigation-menu ui-size-xl" />
    </div>
    """
  end

  def styling_rounded_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.navigation_menu class="navigation-menu ui-rounded-none" />
    <.navigation_menu class="navigation-menu ui-rounded-sm" />
    <.navigation_menu class="navigation-menu ui-rounded-md" />
    <.navigation_menu class="navigation-menu ui-rounded-lg" />
    <.navigation_menu class="navigation-menu ui-rounded-xl" />
    <.navigation_menu class="navigation-menu ui-rounded-full" />
    </div>
    """
  end

  def styling_rounded_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.navigation_menu id="navigation-menu-style-r-none" class="navigation-menu ui-rounded-none" />
      <.navigation_menu id="navigation-menu-style-r-sm" class="navigation-menu ui-rounded-sm" />
      <.navigation_menu id="navigation-menu-style-r-md" class="navigation-menu ui-rounded-md" />
      <.navigation_menu id="navigation-menu-style-r-lg" class="navigation-menu ui-rounded-lg" />
      <.navigation_menu id="navigation-menu-style-r-xl" class="navigation-menu ui-rounded-xl" />
      <.navigation_menu id="navigation-menu-style-r-full" class="navigation-menu ui-rounded-full" />
    </div>
    """
  end

  def styling_max_width_code do
    DemoScales.max_width_variants("navigation-menu")
    |> Enum.take(4)
    |> Enum.map(fn %{id: _id, modifier: modifier} ->
      class = DemoScales.join_modifiers("navigation-menu", modifier)
      ~s(<.navigation_menu class="#{class}" />)
    end)
    |> DemoScales.join_code()
  end

  def styling_max_width_example(assigns) do
    assigns =
      assign(
        assigns,
        :max_width_variants,
        DemoScales.max_width_variants("navigation-menu") |> Enum.take(4)
      )

    ~H"""
    <div class="flex flex-col gap-space">
      <.navigation_menu
        :for={step <- @max_width_variants}
        class={DemoScales.join_modifiers("navigation-menu", step.modifier)}
      />
    </div>
    """
  end
end
