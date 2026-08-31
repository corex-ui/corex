defmodule E2eWeb.Demos.ImageCropperDemo do
  use E2eWeb, :html

  def anatomy_minimal_code do
    ~S"""
    <.image_cropper class="image-cropper" />
    """
  end

  def anatomy_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <.image_cropper id="image-cropper-anatomy-minimal" class="image-cropper" />
    """
  end

  alias E2eWeb.DemoScales

  def styling_color_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.image_cropper class="image-cropper" src="/images/tech/elixir.svg" />
    <.image_cropper class="image-cropper ui-accent" src="/images/tech/elixir.svg" />
    <.image_cropper class="image-cropper ui-brand" src="/images/tech/elixir.svg" />
    <.image_cropper class="image-cropper ui-alert" src="/images/tech/elixir.svg" />
    <.image_cropper class="image-cropper ui-success" src="/images/tech/elixir.svg" />
    <.image_cropper class="image-cropper ui-info" src="/images/tech/elixir.svg" />
    </div>
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.image_cropper
        id="image-cropper-style-default"
        class="image-cropper"
        src="/images/tech/elixir.svg"
      />
      <.image_cropper
        id="image-cropper-style-accent"
        class="image-cropper ui-accent"
        src="/images/tech/elixir.svg"
      />
      <.image_cropper
        id="image-cropper-style-brand"
        class="image-cropper ui-brand"
        src="/images/tech/elixir.svg"
      />
      <.image_cropper
        id="image-cropper-style-alert"
        class="image-cropper ui-alert"
        src="/images/tech/elixir.svg"
      />
      <.image_cropper
        id="image-cropper-style-success"
        class="image-cropper ui-success"
        src="/images/tech/elixir.svg"
      />
      <.image_cropper
        id="image-cropper-style-info"
        class="image-cropper ui-info"
        src="/images/tech/elixir.svg"
      />
    </div>
    """
  end

  def styling_variant_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.image_cropper class="image-cropper" src="/images/tech/elixir.svg" />
    <.image_cropper class="image-cropper ui-solid" src="/images/tech/elixir.svg" />
    </div>
    """
  end

  def styling_variant_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.image_cropper
        id="image-cropper-style-subtle"
        class="image-cropper"
        src="/images/tech/elixir.svg"
      />
      <.image_cropper
        id="image-cropper-style-solid"
        class="image-cropper ui-solid"
        src="/images/tech/elixir.svg"
      />
    </div>
    """
  end

  def styling_variant_matrix_code do
    for semantic <- DemoScales.styling_semantic_axis_steps("image-cropper"),
        variant <- DemoScales.styling_variant_axis_steps("image-cropper") do
      class =
        DemoScales.join_matrix_modifiers("image-cropper", semantic.modifier, variant.modifier)

      ~s(<.image_cropper class="#{class}" src="/images/tech/elixir.svg">)
    end
    |> DemoScales.join_code()
  end

  def styling_variant_matrix_example(assigns) do
    assigns =
      assigns
      |> assign(:matrix_semantics, DemoScales.styling_semantic_axis_steps("image-cropper"))
      |> assign(:matrix_variants, DemoScales.styling_variant_axis_steps("image-cropper"))

    ~H"""
    <div class="w-full overflow-x-auto scrollbar scrollbar--sm">
      <div class="grid grid-cols-4 gap-space items-start min-w-max">
        <div :for={semantic <- @matrix_semantics} class="contents">
          <.image_cropper
            :for={variant <- @matrix_variants}
            id={"image-cropper-mx-#{semantic.label}-#{variant.label}"}
            class={
              DemoScales.join_matrix_modifiers("image-cropper", semantic.modifier, variant.modifier)
            }
            src="/images/tech/elixir.svg"
          />
        </div>
      </div>
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.image_cropper class="image-cropper ui-size-sm" src="/images/tech/elixir.svg" />
    <.image_cropper class="image-cropper ui-size-md" src="/images/tech/elixir.svg" />
    <.image_cropper class="image-cropper ui-size-lg" src="/images/tech/elixir.svg" />
    <.image_cropper class="image-cropper ui-size-xl" src="/images/tech/elixir.svg" />
    </div>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.image_cropper
        id="image-cropper-style-size-sm"
        class="image-cropper ui-size-sm"
        src="/images/tech/elixir.svg"
      />
      <.image_cropper
        id="image-cropper-style-size-md"
        class="image-cropper ui-size-md"
        src="/images/tech/elixir.svg"
      />
      <.image_cropper
        id="image-cropper-style-size-lg"
        class="image-cropper ui-size-lg"
        src="/images/tech/elixir.svg"
      />
      <.image_cropper
        id="image-cropper-style-size-xl"
        class="image-cropper ui-size-xl"
        src="/images/tech/elixir.svg"
      />
    </div>
    """
  end

  def styling_rounded_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.image_cropper class="image-cropper ui-rounded-none" src="/images/tech/elixir.svg" />
    <.image_cropper class="image-cropper ui-rounded-sm" src="/images/tech/elixir.svg" />
    <.image_cropper class="image-cropper ui-rounded-md" src="/images/tech/elixir.svg" />
    <.image_cropper class="image-cropper ui-rounded-lg" src="/images/tech/elixir.svg" />
    <.image_cropper class="image-cropper ui-rounded-xl" src="/images/tech/elixir.svg" />
    <.image_cropper class="image-cropper ui-rounded-full" src="/images/tech/elixir.svg" />
    </div>
    """
  end

  def styling_rounded_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.image_cropper
        id="image-cropper-style-r-none"
        class="image-cropper ui-rounded-none"
        src="/images/tech/elixir.svg"
      />
      <.image_cropper
        id="image-cropper-style-r-sm"
        class="image-cropper ui-rounded-sm"
        src="/images/tech/elixir.svg"
      />
      <.image_cropper
        id="image-cropper-style-r-md"
        class="image-cropper ui-rounded-md"
        src="/images/tech/elixir.svg"
      />
      <.image_cropper
        id="image-cropper-style-r-lg"
        class="image-cropper ui-rounded-lg"
        src="/images/tech/elixir.svg"
      />
      <.image_cropper
        id="image-cropper-style-r-xl"
        class="image-cropper ui-rounded-xl"
        src="/images/tech/elixir.svg"
      />
      <.image_cropper
        id="image-cropper-style-r-full"
        class="image-cropper ui-rounded-full"
        src="/images/tech/elixir.svg"
      />
    </div>
    """
  end

  def styling_max_width_code do
    DemoScales.max_width_variants("image-cropper")
    |> Enum.take(4)
    |> Enum.map(fn %{id: _id, modifier: modifier} ->
      class = DemoScales.join_modifiers("image-cropper", modifier)
      ~s(<.image_cropper class="#{class}" src="/images/tech/elixir.svg" />)
    end)
    |> DemoScales.join_code()
  end

  def styling_max_width_example(assigns) do
    assigns =
      assign(
        assigns,
        :max_width_variants,
        DemoScales.max_width_variants("image-cropper") |> Enum.take(4)
      )

    ~H"""
    <div class="flex flex-col gap-space">
      <.image_cropper
        :for={step <- @max_width_variants}
        class={DemoScales.join_modifiers("image-cropper", step.modifier)}
        src="/images/tech/elixir.svg"
      />
    </div>
    """
  end
end
