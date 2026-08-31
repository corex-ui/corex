defmodule E2eWeb.Demos.TocDemo do
  use E2eWeb, :html

  def anatomy_minimal_code do
    ~S"""
    <.toc class="toc" />
    """
  end

  def anatomy_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <.toc id="toc-anatomy-minimal" class="toc" />
    """
  end

  alias E2eWeb.DemoScales
  def styling_color_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.toc class="toc" />
    <.toc class="toc ui-accent" />
    <.toc class="toc ui-brand" />
    <.toc class="toc ui-alert" />
    <.toc class="toc ui-success" />
    <.toc class="toc ui-info" />
    </div>
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.toc id="toc-style-default" class="toc" />
    <.toc id="toc-style-accent" class="toc ui-accent" />
    <.toc id="toc-style-brand" class="toc ui-brand" />
    <.toc id="toc-style-alert" class="toc ui-alert" />
    <.toc id="toc-style-success" class="toc ui-success" />
    <.toc id="toc-style-info" class="toc ui-info" />
    </div>
    """
  end
  def styling_size_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.toc class="toc ui-size-sm" />
    <.toc class="toc ui-size-md" />
    <.toc class="toc ui-size-lg" />
    <.toc class="toc ui-size-xl" />
    </div>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.toc id="toc-style-size-sm" class="toc ui-size-sm" />
    <.toc id="toc-style-size-md" class="toc ui-size-md" />
    <.toc id="toc-style-size-lg" class="toc ui-size-lg" />
    <.toc id="toc-style-size-xl" class="toc ui-size-xl" />
    </div>
    """
  end
  def styling_rounded_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.toc class="toc ui-rounded-none" />
    <.toc class="toc ui-rounded-sm" />
    <.toc class="toc ui-rounded-md" />
    <.toc class="toc ui-rounded-lg" />
    <.toc class="toc ui-rounded-xl" />
    <.toc class="toc ui-rounded-full" />
    </div>
    """
  end

  def styling_rounded_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.toc id="toc-style-r-none" class="toc ui-rounded-none" />
    <.toc id="toc-style-r-sm" class="toc ui-rounded-sm" />
    <.toc id="toc-style-r-md" class="toc ui-rounded-md" />
    <.toc id="toc-style-r-lg" class="toc ui-rounded-lg" />
    <.toc id="toc-style-r-xl" class="toc ui-rounded-xl" />
    <.toc id="toc-style-r-full" class="toc ui-rounded-full" />
    </div>
    """
  end
  def styling_width_code do
    DemoScales.width_layout_variants("toc")
    |> Enum.map(fn %{id: _id, modifier: modifier} ->
      class = DemoScales.join_modifiers("toc", modifier)
      ~s(<.toc class="#{class}" />)
    end)
    |> DemoScales.join_code()
  end

  def styling_width_example(assigns) do
    assigns = assign(assigns, :width_variants, DemoScales.width_layout_variants("toc"))

    ~H"""
    <div class="flex flex-col gap-space">
      <.toc
        :for={step <- @width_variants}
        id={"toc-style-w-#{step.id}"}
        class={DemoScales.join_modifiers("toc", step.modifier)}
      />
    </div>
    """
  end
  def styling_max_width_code do
    DemoScales.max_width_variants("toc")
    |> Enum.take(4)
    |> Enum.map(fn %{id: _id, modifier: modifier} ->
      class = DemoScales.join_modifiers("toc", modifier)
      ~s(<.toc class="#{class}" />)
    end)
    |> DemoScales.join_code()
  end

  def styling_max_width_example(assigns) do
    assigns = assign(assigns, :max_width_variants, DemoScales.max_width_variants("toc") |> Enum.take(4))

    ~H"""
    <div class="flex flex-col gap-space">
      <.toc
        :for={step <- @max_width_variants}
        
        class={DemoScales.join_modifiers("toc", step.modifier)}
      />
    </div>
    """
  end

end
