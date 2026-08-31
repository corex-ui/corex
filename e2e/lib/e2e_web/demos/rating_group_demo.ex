defmodule E2eWeb.Demos.RatingGroupDemo do
  use E2eWeb, :html

  def anatomy_minimal_code do
    ~S"""
    <.rating_group class="rating-group" />
    """
  end

  def anatomy_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <.rating_group id="rating-group-anatomy-minimal" class="rating-group" />
    """
  end

  alias E2eWeb.DemoScales
  def styling_color_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.rating_group class="rating-group" value={3} />
    <.rating_group class="rating-group ui-accent" value={3} />
    <.rating_group class="rating-group ui-brand" value={3} />
    <.rating_group class="rating-group ui-alert" value={3} />
    <.rating_group class="rating-group ui-success" value={3} />
    <.rating_group class="rating-group ui-info" value={3} />
    </div>
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.rating_group id="rating-group-style-default" class="rating-group" value={3} />
    <.rating_group id="rating-group-style-accent" class="rating-group ui-accent" value={3} />
    <.rating_group id="rating-group-style-brand" class="rating-group ui-brand" value={3} />
    <.rating_group id="rating-group-style-alert" class="rating-group ui-alert" value={3} />
    <.rating_group id="rating-group-style-success" class="rating-group ui-success" value={3} />
    <.rating_group id="rating-group-style-info" class="rating-group ui-info" value={3} />
    </div>
    """
  end
  def styling_size_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.rating_group class="rating-group ui-size-sm" value={3} />
    <.rating_group class="rating-group ui-size-md" value={3} />
    <.rating_group class="rating-group ui-size-lg" value={3} />
    <.rating_group class="rating-group ui-size-xl" value={3} />
    </div>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.rating_group id="rating-group-style-size-sm" class="rating-group ui-size-sm" value={3} />
    <.rating_group id="rating-group-style-size-md" class="rating-group ui-size-md" value={3} />
    <.rating_group id="rating-group-style-size-lg" class="rating-group ui-size-lg" value={3} />
    <.rating_group id="rating-group-style-size-xl" class="rating-group ui-size-xl" value={3} />
    </div>
    """
  end
  def styling_rounded_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.rating_group class="rating-group ui-rounded-none" value={3} />
    <.rating_group class="rating-group ui-rounded-sm" value={3} />
    <.rating_group class="rating-group ui-rounded-md" value={3} />
    <.rating_group class="rating-group ui-rounded-lg" value={3} />
    <.rating_group class="rating-group ui-rounded-xl" value={3} />
    <.rating_group class="rating-group ui-rounded-full" value={3} />
    </div>
    """
  end

  def styling_rounded_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.rating_group id="rating-group-style-r-none" class="rating-group ui-rounded-none" value={3} />
    <.rating_group id="rating-group-style-r-sm" class="rating-group ui-rounded-sm" value={3} />
    <.rating_group id="rating-group-style-r-md" class="rating-group ui-rounded-md" value={3} />
    <.rating_group id="rating-group-style-r-lg" class="rating-group ui-rounded-lg" value={3} />
    <.rating_group id="rating-group-style-r-xl" class="rating-group ui-rounded-xl" value={3} />
    <.rating_group id="rating-group-style-r-full" class="rating-group ui-rounded-full" value={3} />
    </div>
    """
  end
  def styling_width_code do
    DemoScales.width_layout_variants("rating-group")
    |> Enum.map(fn %{id: _id, modifier: modifier} ->
      class = DemoScales.join_modifiers("rating-group", modifier)
      ~s(<.rating_group class="#{class}" value={3} />)
    end)
    |> DemoScales.join_code()
  end

  def styling_width_example(assigns) do
    assigns = assign(assigns, :width_variants, DemoScales.width_layout_variants("rating-group"))

    ~H"""
    <div class="flex flex-col gap-space">
      <.rating_group
        :for={step <- @width_variants}
        id={"rating-group-style-w-#{step.id}"}
        class={DemoScales.join_modifiers("rating-group", step.modifier)}
        value={3}
      />
    </div>
    """
  end
  def styling_max_width_code do
    DemoScales.max_width_variants("rating-group")
    |> Enum.take(4)
    |> Enum.map(fn %{id: _id, modifier: modifier} ->
      class = DemoScales.join_modifiers("rating-group", modifier)
      ~s(<.rating_group class="#{class}" value={3} />)
    end)
    |> DemoScales.join_code()
  end

  def styling_max_width_example(assigns) do
    assigns = assign(assigns, :max_width_variants, DemoScales.max_width_variants("rating-group") |> Enum.take(4))

    ~H"""
    <div class="flex flex-col gap-space">
      <.rating_group
        :for={step <- @max_width_variants}
        
        class={DemoScales.join_modifiers("rating-group", step.modifier)}
        value={3}
      />
    </div>
    """
  end

end
