defmodule E2eWeb.Demos.ActionDemo do
  use E2eWeb, :html

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
    <div class="layout__row gap-2">
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
      <.action class="button button--ghost" type="reset">Reset</.action>
    </.form>
    """
  end

  def patterns_type_example(assigns) do
    ~H"""
    <.form for={%{}} as={:action_type_demo} phx-submit="noop" class="layout__row gap-2">
      <.action class="button" type="button">Button</.action>
      <.action class="button button--accent" type="submit">Submit</.action>
      <.action class="button button--ghost" type="reset">Reset</.action>
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
    <div class="layout__row gap-2">
      <.action class="button">Default</.action>
      <.action class="button button--accent">Accent</.action>
      <.action class="button button--brand">Brand</.action>
      <.action class="button button--alert">Alert</.action>
      <.action class="button button--info">Info</.action>
      <.action class="button button--success">Success</.action>
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
    <div class="layout__row gap-2 items-center">
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
    <div class="layout__row gap-2 items-center flex-wrap">
      <.action class="button rounded-none">None</.action>
      <.action class="button rounded-sm">SM</.action>
      <.action class="button rounded-md">MD</.action>
      <.action class="button rounded-lg">LG</.action>
      <.action class="button rounded-xl">XL</.action>
      <.action class="button rounded-full">Full</.action>
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
    <div class="layout__row gap-2 items-center">
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
    <div class="layout__row gap-2 items-center">
      <.action class="button" disabled>Disabled</.action>
      <.action class="button button--accent" disabled>Disabled</.action>
      <.action class="button button--square" aria_label="Disabled" disabled>
        <.heroicon name="hero-arrow-right" />
      </.action>
    </div>
    """
  end
end
