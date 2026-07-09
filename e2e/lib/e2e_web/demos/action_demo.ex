defmodule E2eWeb.Demos.ActionDemo do
  use E2eWeb, :html

  alias E2eWeb.DemoScales

  def anatomy_minimal_code do
    ~S"""
    <.action class="button">Text</.action>
    """
  end

  def anatomy_minimal_example(assigns) do
    ~H"""
    <.action class="button">Text</.action>
    """
  end

  def anatomy_with_icon_code do
    ~S"""
    <.action class="button">
      Text and icon <.heroicon name="hero-arrow-right" />
    </.action>
    """
  end

  def anatomy_with_icon_example(assigns) do
    ~H"""
    <.action class="button">
      Text and icon <.heroicon name="hero-arrow-right" />
    </.action>
    """
  end

  def anatomy_icon_only_code do
    ~S"""
    <.action class="button button--square" aria_label="Square icon button">
      <.heroicon name="hero-arrow-right" />
    </.action>
    <.action class="button button--circle" aria_label="Circle icon button">
      <.heroicon name="hero-arrow-right" />
    </.action>
    """
  end

  def anatomy_icon_only_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-center gap-space gap-2">
      <.action class="button button--square" aria_label="Square icon button">
        <.heroicon name="hero-arrow-right" />
      </.action>
      <.action class="button button--circle" aria_label="Circle icon button">
        <.heroicon name="hero-arrow-right" />
      </.action>
    </div>
    """
  end

  def patterns_type_code do
    ~S"""
    <.form for={%{}} as={:demo} phx-submit="noop">
      <.action class="button" type="button">Button</.action>
      <.action class="button button--accent" type="submit">Submit</.action>
      <.action class="button button--variant-ghost" type="reset">Reset</.action>
    </.form>
    """
  end

  def patterns_type_example(assigns) do
    ~H"""
    <.form
      for={%{}}
      as={:action_type_demo}
      phx-submit="noop"
      class="flex flex-wrap items-center gap-space gap-2"
    >
      <.action class="button" type="button">Button</.action>
      <.action class="button button--accent" type="submit">Submit</.action>
      <.action class="button button--variant-ghost" type="reset">Reset</.action>
    </.form>
    """
  end

  def patterns_phx_click_code do
    ~S"""
    <.action
      phx-click={
        Corex.Toast.create("layout-toast", "Clicked", "phx-click with Corex.Toast.create/5", :info,
          duration: 5000
        )
      }
      class="button button--sm"
    >
      Show toast
    </.action>
    """
  end

  def patterns_phx_click_example(assigns) do
    ~H"""
    <.action
      phx-click={
        Corex.Toast.create(
          "layout-toast",
          "Clicked",
          "phx-click with Corex.Toast.create/5",
          :info,
          duration: 5000
        )
      }
      class="button button--sm"
    >
      Show toast
    </.action>
    """
  end

  def patterns_phx_click_js_code do
    ~S"""
    <.action
      phx-click={Corex.Dialog.set_open("action-patterns-dialog", true)}
      class="button button--sm"
    >
      Open dialog
    </.action>

    <.dialog id="action-patterns-dialog" class="dialog">
      <:trigger class="hidden">Open</:trigger>
      <:title>Dialog</:title>
      <:content>
        <p>Opened from an action with phx-click and a Corex JS command.</p>
      </:content>
      <:close_trigger>
        <.heroicon name="hero-x-mark" />
      </:close_trigger>
    </.dialog>
    """
  end

  def patterns_phx_click_js_example(assigns) do
    ~H"""
    <.action
      phx-click={Corex.Dialog.set_open("action-patterns-dialog", true)}
      class="button button--sm"
    >
      Open dialog
    </.action>

    <.dialog id="action-patterns-dialog" class="dialog">
      <:trigger class="hidden">Open</:trigger>
      <:title>Dialog</:title>
      <:content>
        <p>Opened from an action with phx-click and a Corex JS command.</p>
      </:content>
      <:close_trigger>
        <.heroicon name="hero-x-mark" />
      </:close_trigger>
    </.dialog>
    """
  end

  def styling_color_code do
    ~S"""
    <.action class="button">Default</.action>
    <.action class="button button--accent">Accent</.action>
    <.action class="button button--brand">Brand</.action>
    <.action class="button button--alert">Alert</.action>
    <.action class="button button--info">Info</.action>
    <.action class="button button--success">Success</.action>
    """
  end

  def styling_color_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-center gap-space gap-2">
      <.action class="button">Default</.action>
      <.action class="button button--accent">Accent</.action>
      <.action class="button button--brand">Brand</.action>
      <.action class="button button--alert">Alert</.action>
      <.action class="button button--info">Info</.action>
      <.action class="button button--success">Success</.action>
    </div>
    """
  end

  def styling_variant_code do
    ~S"""
    <.action class="button">Subtle (default)</.action>
    <.action class="button button--variant-solid">Solid</.action>
    <.action class="button button--variant-ghost">Ghost</.action>
    <.action class="button button--variant-outline">Outline</.action>
    """
  end

  def styling_variant_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-center gap-space gap-2">
      <.action class="button">Subtle (default)</.action>
      <.action class="button button--variant-solid">Solid</.action>
      <.action class="button button--variant-ghost">Ghost</.action>
      <.action class="button button--variant-outline">Outline</.action>
    </div>
    """
  end

  def styling_variant_matrix_code do
    for semantic <- DemoScales.styling_semantic_axis_steps("button"),
        variant <- DemoScales.styling_variant_axis_steps("button") do
      class = DemoScales.join_matrix_modifiers("button", semantic.modifier, variant.modifier)

      ~s(<.action class="#{class}">#{semantic.label}</.action>)
    end
    |> DemoScales.join_code()
  end

  def styling_variant_matrix_example(assigns) do
    assigns =
      assigns
      |> assign(:matrix_semantics, DemoScales.styling_semantic_axis_steps("button"))
      |> assign(:matrix_variants, DemoScales.styling_variant_axis_steps("button"))

    ~H"""
    <div class="w-full overflow-x-auto scrollbar scrollbar--sm">
      <div class="grid grid-cols-4 gap-space gap-2 items-center min-w-max">
        <div :for={semantic <- @matrix_semantics} class="contents">
          <.action
            :for={variant <- @matrix_variants}
            class={DemoScales.join_matrix_modifiers("button", semantic.modifier, variant.modifier)}
          >
            {semantic.label}
          </.action>
        </div>
      </div>
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <.action class="button button--sm">Small</.action>
    <.action class="button">Medium</.action>
    <.action class="button button--lg">Large</.action>
    <.action class="button button--xl">XL</.action>
    """
  end

  def styling_size_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-center gap-space gap-2 items-center">
      <.action class="button button--sm">Small</.action>
      <.action class="button">Medium</.action>
      <.action class="button button--lg">Large</.action>
      <.action class="button button--xl">XLarge</.action>
    </div>
    """
  end

  def styling_rounded_code do
    ~S"""
    <.action class="button rounded-none">None</.action>
    <.action class="button rounded-sm">SM</.action>
    <.action class="button rounded-md">MD</.action>
    <.action class="button rounded-lg">LG</.action>
    <.action class="button rounded-xl">XL</.action>
    <.action class="button rounded-full">Full</.action>
    """
  end

  def styling_rounded_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-center gap-space gap-2 items-center flex-wrap">
      <.action class="button rounded-none">None</.action>
      <.action class="button rounded-sm">SM</.action>
      <.action class="button rounded-md">MD</.action>
      <.action class="button rounded-lg">LG</.action>
      <.action class="button rounded-xl">XL</.action>
      <.action class="button rounded-full">Full</.action>
    </div>
    """
  end

  def styling_width_code do
    label = DemoScales.block_demo_label()

    DemoScales.width_layout_variants("button")
    |> Enum.map(fn %{modifier: modifier} ->
      class = DemoScales.join_modifiers("button", modifier)

      """
      <.action class="#{class}">#{label}</.action>
      """
    end)
    |> DemoScales.join_code()
  end

  def styling_max_width_code do
    label = DemoScales.block_demo_label()

    DemoScales.max_width_variants("button")
    |> Enum.map(fn %{modifier: modifier} ->
      class = DemoScales.join_block_modifiers("button", modifier)

      """
      <.action class="#{class}">#{label}</.action>
      """
    end)
    |> DemoScales.join_code()
  end

  def styling_width_example(assigns) do
    assigns = assign(assigns, :width_variants, DemoScales.width_layout_variants("button"))

    ~H"""
    <div class={DemoScales.preview_scroll_class()}>
      <div :for={variant <- @width_variants} class="flex flex-col gap-2">
        <p class="typo typo--sm font-medium">{variant.label}</p>
        <.action class={DemoScales.join_modifiers("button", variant.modifier)}>
          {DemoScales.block_demo_label()}
        </.action>
      </div>
    </div>
    """
  end

  def styling_max_width_example(assigns) do
    assigns = assign(assigns, :max_width_variants, DemoScales.max_width_variants("button"))

    ~H"""
    <div class={DemoScales.preview_scroll_class()}>
      <div :for={variant <- @max_width_variants} class="flex flex-col gap-2">
        <p class="typo typo--sm font-medium">{variant.label}</p>
        <.action class={DemoScales.join_block_modifiers("button", variant.modifier)}>
          {DemoScales.block_demo_label()}
        </.action>
      </div>
    </div>
    """
  end

  def styling_shape_code do
    ~S"""
    <.action class="button button--square" aria_label="Square button">
      <.heroicon name="hero-arrow-right" />
    </.action>
    <.action class="button button--circle" aria_label="Circle button">
      <.heroicon name="hero-arrow-right" />
    </.action>
    """
  end

  def styling_shape_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-center gap-space gap-2 items-center">
      <.action class="button button--square" aria_label="Square button">
        <.heroicon name="hero-arrow-right" />
      </.action>
      <.action class="button button--circle" aria_label="Circle button">
        <.heroicon name="hero-arrow-right" />
      </.action>
      <.action class="button button--square" aria_label="Square letter">B</.action>
      <.action class="button button--circle" aria_label="Circle letter">B</.action>
    </div>
    """
  end

  def styling_disabled_code do
    ~S"""
    <.action class="button" disabled>Disabled</.action>
    <.action class="button button--accent" disabled>Disabled</.action>
    <.action class="button button--square" aria_label="Disabled" disabled>
      <.heroicon name="hero-arrow-right" />
    </.action>
    """
  end

  def styling_disabled_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-center gap-space gap-2 items-center">
      <.action class="button" disabled>Disabled</.action>
      <.action class="button button--accent" disabled>Disabled</.action>
      <.action class="button button--square" aria_label="Disabled" disabled>
        <.heroicon name="hero-arrow-right" />
      </.action>
    </div>
    """
  end
end
