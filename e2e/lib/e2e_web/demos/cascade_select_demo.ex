defmodule E2eWeb.Demos.CascadeSelectDemo do
  use E2eWeb, :html

  def anatomy_minimal_code do
    ~S"""
    <.cascade_select class="cascade-select" />
    """
  end

  def anatomy_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <.cascade_select id="cascade-select-anatomy-minimal" class="cascade-select" />
    """
  end

  alias E2eWeb.DemoScales

  def styling_color_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.cascade_select class="cascade-select" />
    <.cascade_select class="cascade-select ui-accent" />
    <.cascade_select class="cascade-select ui-brand" />
    <.cascade_select class="cascade-select ui-alert" />
    <.cascade_select class="cascade-select ui-success" />
    <.cascade_select class="cascade-select ui-info" />
    </div>
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.cascade_select id="cascade-select-style-default" class="cascade-select" />
      <.cascade_select id="cascade-select-style-accent" class="cascade-select ui-accent" />
      <.cascade_select id="cascade-select-style-brand" class="cascade-select ui-brand" />
      <.cascade_select id="cascade-select-style-alert" class="cascade-select ui-alert" />
      <.cascade_select id="cascade-select-style-success" class="cascade-select ui-success" />
      <.cascade_select id="cascade-select-style-info" class="cascade-select ui-info" />
    </div>
    """
  end

  def styling_variant_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.cascade_select class="cascade-select" />
    <.cascade_select class="cascade-select ui-solid" />
    </div>
    """
  end

  def styling_variant_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.cascade_select id="cascade-select-style-subtle" class="cascade-select" />
      <.cascade_select id="cascade-select-style-solid" class="cascade-select ui-solid" />
    </div>
    """
  end

  def styling_variant_matrix_code do
    for semantic <- DemoScales.styling_semantic_axis_steps("cascade-select"),
        variant <- DemoScales.styling_variant_axis_steps("cascade-select") do
      class =
        DemoScales.join_matrix_modifiers("cascade-select", semantic.modifier, variant.modifier)

      ~s(<.cascade_select class="#{class}">)
    end
    |> DemoScales.join_code()
  end

  def styling_variant_matrix_example(assigns) do
    assigns =
      assigns
      |> assign(:matrix_semantics, DemoScales.styling_semantic_axis_steps("cascade-select"))
      |> assign(:matrix_variants, DemoScales.styling_variant_axis_steps("cascade-select"))

    ~H"""
    <div class="w-full overflow-x-auto scrollbar scrollbar--sm">
      <div class="grid grid-cols-4 gap-space items-start min-w-max">
        <div :for={semantic <- @matrix_semantics} class="contents">
          <.cascade_select
            :for={variant <- @matrix_variants}
            id={"cascade-select-mx-#{semantic.label}-#{variant.label}"}
            class={
              DemoScales.join_matrix_modifiers("cascade-select", semantic.modifier, variant.modifier)
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
    <.cascade_select class="cascade-select ui-size-sm" />
    <.cascade_select class="cascade-select ui-size-md" />
    <.cascade_select class="cascade-select ui-size-lg" />
    <.cascade_select class="cascade-select ui-size-xl" />
    </div>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.cascade_select id="cascade-select-style-size-sm" class="cascade-select ui-size-sm" />
      <.cascade_select id="cascade-select-style-size-md" class="cascade-select ui-size-md" />
      <.cascade_select id="cascade-select-style-size-lg" class="cascade-select ui-size-lg" />
      <.cascade_select id="cascade-select-style-size-xl" class="cascade-select ui-size-xl" />
    </div>
    """
  end

  def styling_rounded_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.cascade_select class="cascade-select ui-rounded-none" />
    <.cascade_select class="cascade-select ui-rounded-sm" />
    <.cascade_select class="cascade-select ui-rounded-md" />
    <.cascade_select class="cascade-select ui-rounded-lg" />
    <.cascade_select class="cascade-select ui-rounded-xl" />
    <.cascade_select class="cascade-select ui-rounded-full" />
    </div>
    """
  end

  def styling_rounded_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.cascade_select id="cascade-select-style-r-none" class="cascade-select ui-rounded-none" />
      <.cascade_select id="cascade-select-style-r-sm" class="cascade-select ui-rounded-sm" />
      <.cascade_select id="cascade-select-style-r-md" class="cascade-select ui-rounded-md" />
      <.cascade_select id="cascade-select-style-r-lg" class="cascade-select ui-rounded-lg" />
      <.cascade_select id="cascade-select-style-r-xl" class="cascade-select ui-rounded-xl" />
      <.cascade_select id="cascade-select-style-r-full" class="cascade-select ui-rounded-full" />
    </div>
    """
  end

  def styling_max_width_code do
    DemoScales.max_width_variants("cascade-select")
    |> Enum.take(4)
    |> Enum.map(fn %{id: _id, modifier: modifier} ->
      class = DemoScales.join_modifiers("cascade-select", modifier)
      ~s(<.cascade_select class="#{class}" />)
    end)
    |> DemoScales.join_code()
  end

  def styling_max_width_example(assigns) do
    assigns =
      assign(
        assigns,
        :max_width_variants,
        DemoScales.max_width_variants("cascade-select") |> Enum.take(4)
      )

    ~H"""
    <div class="flex flex-col gap-space">
      <.cascade_select
        :for={step <- @max_width_variants}
        class={DemoScales.join_modifiers("cascade-select", step.modifier)}
      />
    </div>
    """
  end
end
