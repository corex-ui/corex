defmodule E2eWeb.Demos.StepsDemo do
  use E2eWeb, :html

  def anatomy_minimal_code do
    ~S"""
    <.steps class="steps" />
    """
  end

  def anatomy_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <.steps id="steps-anatomy-minimal" class="steps" />
    """
  end

  def anatomy_locked_code do
    ~S"""
    <.steps class="steps" linear>
      <:content index={0}>
        <label class="flex gap-space-sm items-center">
          <input type="checkbox" data-step-gate />
          I agree to the terms
        </label>
      </:content>
    </.steps>
    """
  end

  def anatomy_locked_example(assigns) do
    _ = assigns

    ~H"""
    <.steps id="steps-anatomy-locked" class="steps" linear>
      <:content index={0}>
        <label class="flex gap-space-sm items-center">
          <input type="checkbox" data-step-gate /> I agree to the terms before continuing
        </label>
      </:content>
    </.steps>
    """
  end

  def styling_color_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.steps class="steps" />
    <.steps class="steps ui-accent" />
    <.steps class="steps ui-brand" />
    <.steps class="steps ui-alert" />
    <.steps class="steps ui-success" />
    <.steps class="steps ui-info" />
    </div>
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.steps id="steps-style-default" class="steps" />
      <.steps id="steps-style-accent" class="steps ui-accent" />
      <.steps id="steps-style-brand" class="steps ui-brand" />
      <.steps id="steps-style-alert" class="steps ui-alert" />
      <.steps id="steps-style-success" class="steps ui-success" />
      <.steps id="steps-style-info" class="steps ui-info" />
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.steps class="steps ui-size-sm" />
    <.steps class="steps ui-size-md" />
    <.steps class="steps ui-size-lg" />
    <.steps class="steps ui-size-xl" />
    </div>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.steps id="steps-style-size-sm" class="steps ui-size-sm" />
      <.steps id="steps-style-size-md" class="steps ui-size-md" />
      <.steps id="steps-style-size-lg" class="steps ui-size-lg" />
      <.steps id="steps-style-size-xl" class="steps ui-size-xl" />
    </div>
    """
  end

  def styling_rounded_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.steps class="steps ui-rounded-none" />
    <.steps class="steps ui-rounded-sm" />
    <.steps class="steps ui-rounded-md" />
    <.steps class="steps ui-rounded-lg" />
    <.steps class="steps ui-rounded-xl" />
    <.steps class="steps ui-rounded-full" />
    </div>
    """
  end

  def styling_rounded_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.steps id="steps-style-r-none" class="steps ui-rounded-none" />
      <.steps id="steps-style-r-sm" class="steps ui-rounded-sm" />
      <.steps id="steps-style-r-md" class="steps ui-rounded-md" />
      <.steps id="steps-style-r-lg" class="steps ui-rounded-lg" />
      <.steps id="steps-style-r-xl" class="steps ui-rounded-xl" />
      <.steps id="steps-style-r-full" class="steps ui-rounded-full" />
    </div>
    """
  end

  def styling_max_width_code do
    DemoScales.max_width_variants("steps")
    |> Enum.take(4)
    |> Enum.map(fn %{id: _id, modifier: modifier} ->
      class = DemoScales.join_modifiers("steps", modifier)
      ~s(<.steps class="#{class}" />)
    end)
    |> DemoScales.join_code()
  end

  def styling_max_width_example(assigns) do
    assigns =
      assign(assigns, :max_width_variants, DemoScales.max_width_variants("steps") |> Enum.take(4))

    ~H"""
    <div class="flex flex-col gap-space">
      <.steps
        :for={step <- @max_width_variants}
        class={DemoScales.join_modifiers("steps", step.modifier)}
      />
    </div>
    """
  end
end
