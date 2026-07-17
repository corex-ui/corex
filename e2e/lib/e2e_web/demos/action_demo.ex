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
    <.action class="button ui-trigger--square" aria_label="Square icon button">
      <.heroicon name="hero-arrow-right" />
    </.action>
    <.action class="button ui-trigger--circle" aria_label="Circle icon button">
      <.heroicon name="hero-arrow-right" />
    </.action>
    """
  end

  def anatomy_icon_only_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-center gap-space">
      <.action class="button ui-trigger--square" aria_label="Square icon button">
        <.heroicon name="hero-arrow-right" />
      </.action>
      <.action class="button ui-trigger--circle" aria_label="Circle icon button">
        <.heroicon name="hero-arrow-right" />
      </.action>
    </div>
    """
  end

  def patterns_type_code do
    ~S"""
    <.form for={%{}} as={:demo} phx-submit="noop">
      <.action class="button" type="button">Button</.action>
      <.action class="button ui-accent" type="submit">Submit</.action>
      <.action class="button" type="reset">Reset</.action>
    </.form>
    """
  end

  def patterns_type_example(assigns) do
    ~H"""
    <.form
      for={%{}}
      as={:action_type_demo}
      phx-submit="noop"
      class="flex flex-wrap items-center gap-space"
    >
      <.action class="button" type="button">Button</.action>
      <.action class="button ui-accent" type="submit">Submit</.action>
      <.action class="button" type="reset">Reset</.action>
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
      class="button ui-size-sm"
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
      class="button ui-size-sm"
    >
      Show toast
    </.action>
    """
  end

  def patterns_phx_click_js_code do
    ~S"""
    <.action
      phx-click={Corex.Dialog.set_open("action-patterns-dialog", true)}
      class="button ui-size-sm"
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
      class="button ui-size-sm"
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
    <.action class="button ui-accent">Accent</.action>
    <.action class="button ui-brand">Brand</.action>
    <.action class="button ui-alert">Alert</.action>
    <.action class="button ui-info">Info</.action>
    <.action class="button ui-success">Success</.action>
    """
  end

  def styling_color_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-center gap-space">
      <.action class="button">Default</.action>
      <.action class="button ui-accent">Accent</.action>
      <.action class="button ui-brand">Brand</.action>
      <.action class="button ui-alert">Alert</.action>
      <.action class="button ui-info">Info</.action>
      <.action class="button ui-success">Success</.action>
    </div>
    """
  end

  def styling_variant_code do
    ~S"""
    <.action class="button">Subtle (default)</.action>
    <.action class="button ui-solid">Solid</.action>
    """
  end

  def styling_variant_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-center gap-space">
      <.action class="button">Subtle (default)</.action>
      <.action class="button ui-solid">Solid</.action>
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
    <div class="w-full grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-space items-center">
      <div :for={semantic <- @matrix_semantics} class="contents">
        <.action
          :for={variant <- @matrix_variants}
          class={DemoScales.join_matrix_modifiers("button", semantic.modifier, variant.modifier)}
        >
          {semantic.label}
        </.action>
      </div>
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <.action class="button ui-size-sm">Small</.action>
    <.action class="button">Medium</.action>
    <.action class="button ui-size-lg">Large</.action>
    <.action class="button ui-size-xl">XL</.action>
    """
  end

  def styling_size_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-end gap-space">
      <.action class="button ui-size-sm">Small</.action>
      <.action class="button">Medium</.action>
      <.action class="button ui-size-lg">Large</.action>
      <.action class="button ui-size-xl">XLarge</.action>
    </div>
    """
  end

  def styling_rounded_code do
    ~S"""
    <.action class="button ui-rounded-none">None</.action>
    <.action class="button ui-rounded-sm">SM</.action>
    <.action class="button ui-rounded-md">MD</.action>
    <.action class="button ui-rounded-lg">LG</.action>
    <.action class="button ui-rounded-xl">XL</.action>
    <.action class="button ui-rounded-full">Full</.action>
    """
  end

  def styling_rounded_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-center gap-space">
      <.action class="button ui-rounded-none">None</.action>
      <.action class="button ui-rounded-sm">SM</.action>
      <.action class="button ui-rounded-md">MD</.action>
      <.action class="button ui-rounded-lg">LG</.action>
      <.action class="button ui-rounded-xl">XL</.action>
      <.action class="button ui-rounded-full">Full</.action>
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
    <div {DemoScales.preview_scroll_attrs()}>
      <div :for={variant <- @width_variants} class="flex flex-col gap-2">
        <p class="typo ui-size-sm font-medium">{variant.label}</p>
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
    <div {DemoScales.preview_scroll_attrs()}>
      <div :for={variant <- @max_width_variants} class="flex flex-col gap-2">
        <p class="typo ui-size-sm font-medium">{variant.label}</p>
        <.action class={DemoScales.join_block_modifiers("button", variant.modifier)}>
          {DemoScales.block_demo_label()}
        </.action>
      </div>
    </div>
    """
  end

  def styling_shape_code do
    ~S"""
    <.action class="button ui-trigger--square" aria_label="Square button">
      <.heroicon name="hero-arrow-right" />
    </.action>
    <.action class="button ui-trigger--circle" aria_label="Circle button">
      <.heroicon name="hero-arrow-right" />
    </.action>
    """
  end

  def styling_shape_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-center gap-space">
      <.action class="button ui-trigger--square" aria_label="Square button">
        <.heroicon name="hero-arrow-right" />
      </.action>
      <.action class="button ui-trigger--circle" aria_label="Circle button">
        <.heroicon name="hero-arrow-right" />
      </.action>
      <.action class="button ui-trigger--square" aria_label="Square letter">B</.action>
      <.action class="button ui-trigger--circle" aria_label="Circle letter">B</.action>
    </div>
    """
  end

  def styling_disabled_code do
    ~S"""
    <.action class="button" disabled>Disabled</.action>
    <.action class="button ui-accent" disabled>Disabled</.action>
    <.action class="button ui-trigger--square" aria_label="Disabled" disabled>
      <.heroicon name="hero-arrow-right" />
    </.action>
    """
  end

  def styling_disabled_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-center gap-space">
      <.action class="button" disabled>Disabled</.action>
      <.action class="button ui-accent" disabled>Disabled</.action>
      <.action class="button ui-trigger--square" aria_label="Disabled" disabled>
        <.heroicon name="hero-arrow-right" />
      </.action>
    </div>
    """
  end
end
