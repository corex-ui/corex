defmodule E2eWeb.Demos.DateInputDemo do
  use E2eWeb, :html

  def anatomy_minimal_code do
    ~S"""
    <.date_input class="date-input" />
    """
  end

  def anatomy_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <.date_input id="date-input-anatomy-minimal" class="date-input" />
    """
  end

  alias E2eWeb.DemoScales
  def styling_color_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.date_input class="date-input" />
    <.date_input class="date-input ui-accent" />
    <.date_input class="date-input ui-brand" />
    <.date_input class="date-input ui-alert" />
    <.date_input class="date-input ui-success" />
    <.date_input class="date-input ui-info" />
    </div>
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.date_input id="date-input-style-default" class="date-input" />
    <.date_input id="date-input-style-accent" class="date-input ui-accent" />
    <.date_input id="date-input-style-brand" class="date-input ui-brand" />
    <.date_input id="date-input-style-alert" class="date-input ui-alert" />
    <.date_input id="date-input-style-success" class="date-input ui-success" />
    <.date_input id="date-input-style-info" class="date-input ui-info" />
    </div>
    """
  end
  def styling_size_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.date_input class="date-input ui-size-sm" />
    <.date_input class="date-input ui-size-md" />
    <.date_input class="date-input ui-size-lg" />
    <.date_input class="date-input ui-size-xl" />
    </div>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.date_input id="date-input-style-size-sm" class="date-input ui-size-sm" />
    <.date_input id="date-input-style-size-md" class="date-input ui-size-md" />
    <.date_input id="date-input-style-size-lg" class="date-input ui-size-lg" />
    <.date_input id="date-input-style-size-xl" class="date-input ui-size-xl" />
    </div>
    """
  end
  def styling_rounded_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.date_input class="date-input ui-rounded-none" />
    <.date_input class="date-input ui-rounded-sm" />
    <.date_input class="date-input ui-rounded-md" />
    <.date_input class="date-input ui-rounded-lg" />
    <.date_input class="date-input ui-rounded-xl" />
    <.date_input class="date-input ui-rounded-full" />
    </div>
    """
  end

  def styling_rounded_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.date_input id="date-input-style-r-none" class="date-input ui-rounded-none" />
    <.date_input id="date-input-style-r-sm" class="date-input ui-rounded-sm" />
    <.date_input id="date-input-style-r-md" class="date-input ui-rounded-md" />
    <.date_input id="date-input-style-r-lg" class="date-input ui-rounded-lg" />
    <.date_input id="date-input-style-r-xl" class="date-input ui-rounded-xl" />
    <.date_input id="date-input-style-r-full" class="date-input ui-rounded-full" />
    </div>
    """
  end
  def styling_width_code do
    DemoScales.width_layout_variants("date-input")
    |> Enum.map(fn %{id: _id, modifier: modifier} ->
      class = DemoScales.join_modifiers("date-input", modifier)
      ~s(<.date_input class="#{class}" />)
    end)
    |> DemoScales.join_code()
  end

  def styling_width_example(assigns) do
    assigns = assign(assigns, :width_variants, DemoScales.width_layout_variants("date-input"))

    ~H"""
    <div class="flex flex-col gap-space">
      <.date_input
        :for={step <- @width_variants}
        id={"date-input-style-w-#{step.id}"}
        class={DemoScales.join_modifiers("date-input", step.modifier)}
      />
    </div>
    """
  end
  def styling_max_width_code do
    DemoScales.max_width_variants("date-input")
    |> Enum.take(4)
    |> Enum.map(fn %{id: _id, modifier: modifier} ->
      class = DemoScales.join_modifiers("date-input", modifier)
      ~s(<.date_input class="#{class}" />)
    end)
    |> DemoScales.join_code()
  end

  def styling_max_width_example(assigns) do
    assigns = assign(assigns, :max_width_variants, DemoScales.max_width_variants("date-input") |> Enum.take(4))

    ~H"""
    <div class="flex flex-col gap-space">
      <.date_input
        :for={step <- @max_width_variants}
        
        class={DemoScales.join_modifiers("date-input", step.modifier)}
      />
    </div>
    """
  end

end
