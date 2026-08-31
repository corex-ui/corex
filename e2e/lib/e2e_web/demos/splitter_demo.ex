defmodule E2eWeb.Demos.SplitterDemo do
  use E2eWeb, :html

  def anatomy_minimal_code do
    ~S"""
    <.splitter class="splitter" />
    """
  end

  def anatomy_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <.splitter id="splitter-anatomy-minimal" class="splitter" />
    """
  end

  alias E2eWeb.DemoScales
  def styling_color_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.splitter class="splitter" />
    <.splitter class="splitter ui-accent" />
    <.splitter class="splitter ui-brand" />
    <.splitter class="splitter ui-alert" />
    <.splitter class="splitter ui-success" />
    <.splitter class="splitter ui-info" />
    </div>
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.splitter id="splitter-style-default" class="splitter" />
    <.splitter id="splitter-style-accent" class="splitter ui-accent" />
    <.splitter id="splitter-style-brand" class="splitter ui-brand" />
    <.splitter id="splitter-style-alert" class="splitter ui-alert" />
    <.splitter id="splitter-style-success" class="splitter ui-success" />
    <.splitter id="splitter-style-info" class="splitter ui-info" />
    </div>
    """
  end
  def styling_variant_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.splitter class="splitter" />
    <.splitter class="splitter ui-solid" />
    </div>
    """
  end

  def styling_variant_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.splitter id="splitter-style-subtle" class="splitter" />
    <.splitter id="splitter-style-solid" class="splitter ui-solid" />
    </div>
    """
  end

  def styling_variant_matrix_code do
    for semantic <- DemoScales.styling_semantic_axis_steps("splitter"),
        variant <- DemoScales.styling_variant_axis_steps("splitter") do
      class = DemoScales.join_matrix_modifiers("splitter", semantic.modifier, variant.modifier)

      ~s(<.splitter class="#{class}">)
    end
    |> DemoScales.join_code()
  end

  def styling_variant_matrix_example(assigns) do
    assigns =
      assigns
      |> assign(:matrix_semantics, DemoScales.styling_semantic_axis_steps("splitter"))
      |> assign(:matrix_variants, DemoScales.styling_variant_axis_steps("splitter"))

    ~H"""
    <div class="w-full overflow-x-auto scrollbar scrollbar--sm">
      <div class="grid grid-cols-4 gap-space items-start min-w-max">
        <div :for={semantic <- @matrix_semantics} class="contents">
          <.splitter
            :for={variant <- @matrix_variants}
            id={"splitter-mx-#{semantic.label}-#{variant.label}"}
            class={DemoScales.join_matrix_modifiers("splitter", semantic.modifier, variant.modifier)}
      />
        </div>
      </div>
    </div>
    """
  end
  def styling_size_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.splitter class="splitter ui-size-sm" />
    <.splitter class="splitter ui-size-md" />
    <.splitter class="splitter ui-size-lg" />
    <.splitter class="splitter ui-size-xl" />
    </div>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.splitter id="splitter-style-size-sm" class="splitter ui-size-sm" />
    <.splitter id="splitter-style-size-md" class="splitter ui-size-md" />
    <.splitter id="splitter-style-size-lg" class="splitter ui-size-lg" />
    <.splitter id="splitter-style-size-xl" class="splitter ui-size-xl" />
    </div>
    """
  end
  def styling_rounded_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.splitter class="splitter ui-rounded-none" />
    <.splitter class="splitter ui-rounded-sm" />
    <.splitter class="splitter ui-rounded-md" />
    <.splitter class="splitter ui-rounded-lg" />
    <.splitter class="splitter ui-rounded-xl" />
    <.splitter class="splitter ui-rounded-full" />
    </div>
    """
  end

  def styling_rounded_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.splitter id="splitter-style-r-none" class="splitter ui-rounded-none" />
    <.splitter id="splitter-style-r-sm" class="splitter ui-rounded-sm" />
    <.splitter id="splitter-style-r-md" class="splitter ui-rounded-md" />
    <.splitter id="splitter-style-r-lg" class="splitter ui-rounded-lg" />
    <.splitter id="splitter-style-r-xl" class="splitter ui-rounded-xl" />
    <.splitter id="splitter-style-r-full" class="splitter ui-rounded-full" />
    </div>
    """
  end
  def styling_max_width_code do
    DemoScales.max_width_variants("splitter")
    |> Enum.take(4)
    |> Enum.map(fn %{id: _id, modifier: modifier} ->
      class = DemoScales.join_modifiers("splitter", modifier)
      ~s(<.splitter class="#{class}" />)
    end)
    |> DemoScales.join_code()
  end

  def styling_max_width_example(assigns) do
    assigns = assign(assigns, :max_width_variants, DemoScales.max_width_variants("splitter") |> Enum.take(4))

    ~H"""
    <div class="flex flex-col gap-space">
      <.splitter
        :for={step <- @max_width_variants}
        
        class={DemoScales.join_modifiers("splitter", step.modifier)}
      />
    </div>
    """
  end

end
