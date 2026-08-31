defmodule E2eWeb.Demos.PopoverDemo do
  use E2eWeb, :html

  def anatomy_minimal_code do
    ~S"""
    <.popover class="popover">
      <:trigger>Open</:trigger>
      <:content>Popover content</:content>
    </.popover>
    """
  end

  def anatomy_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <.popover id="popover-anatomy-minimal" class="popover">
      <:trigger>Open</:trigger>
      <:content>Popover content</:content>
    </.popover>
    """
  end

  def anatomy_with_title_code do
    ~S"""
    <.popover class="popover">
      <:trigger>Open</:trigger>
      <:title>Details</:title>
      <:content>Popover content</:content>
    </.popover>
    """
  end

  def anatomy_with_title_example(assigns) do
    _ = assigns

    ~H"""
    <.popover id="popover-anatomy-title" class="popover">
      <:trigger>Open</:trigger>
      <:title>Details</:title>
      <:content>Popover content</:content>
    </.popover>
    """
  end

  def anatomy_placement_code do
    ~S"""
    <.popover class="popover" positioning={%Corex.Positioning{placement: "bottom"}}>
      <:trigger>Bottom</:trigger>
      <:content>Anchored below</:content>
    </.popover>
    """
  end

  def anatomy_placement_example(assigns) do
    _ = assigns

    ~H"""
    <.popover
      id="popover-anatomy-placement"
      class="popover"
      positioning={%Corex.Positioning{placement: "bottom"}}
    >
      <:trigger>Bottom</:trigger>
      <:content>Anchored below</:content>
    </.popover>
    """
  end

  def api_set_open_client_binding_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap items-center gap-space-sm">
      <.action phx-click={Corex.Popover.set_open("popover-api-cb", true)} class="button ui-size-sm">
        Open
      </.action>
      <.popover id="popover-api-cb" class="popover">
        <:trigger>Target</:trigger>
        <:content>Opened from binding</:content>
      </.popover>
    </div>
    """
  end

  def api_set_open_server_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap items-center gap-space-sm">
      <.action phx-click="popover_api_open" class="button ui-size-sm">Open</.action>
      <.popover id="popover-api-srv" class="popover">
        <:trigger>Target</:trigger>
        <:content>Opened from server</:content>
      </.popover>
    </div>
    """
  end

  alias E2eWeb.DemoScales

  def styling_color_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.popover class="popover">
      <:trigger>Default</:trigger>
      <:content>Default</:content>
    </.popover>
    <.popover class="popover ui-accent">
      <:trigger>Accent</:trigger>
      <:content>Accent</:content>
    </.popover>
    <.popover class="popover ui-brand">
      <:trigger>Brand</:trigger>
      <:content>Brand</:content>
    </.popover>
    <.popover class="popover ui-alert">
      <:trigger>Alert</:trigger>
      <:content>Alert</:content>
    </.popover>
    <.popover class="popover ui-success">
      <:trigger>Success</:trigger>
      <:content>Success</:content>
    </.popover>
    <.popover class="popover ui-info">
      <:trigger>Info</:trigger>
      <:content>Info</:content>
    </.popover>
    </div>
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.popover id="popover-style-default" class="popover">
        <:trigger>Default</:trigger>
        <:content>Default</:content>
      </.popover>
      <.popover id="popover-style-accent" class="popover ui-accent">
        <:trigger>Accent</:trigger>
        <:content>Accent</:content>
      </.popover>
      <.popover id="popover-style-brand" class="popover ui-brand">
        <:trigger>Brand</:trigger>
        <:content>Brand</:content>
      </.popover>
      <.popover id="popover-style-alert" class="popover ui-alert">
        <:trigger>Alert</:trigger>
        <:content>Alert</:content>
      </.popover>
      <.popover id="popover-style-success" class="popover ui-success">
        <:trigger>Success</:trigger>
        <:content>Success</:content>
      </.popover>
      <.popover id="popover-style-info" class="popover ui-info">
        <:trigger>Info</:trigger>
        <:content>Info</:content>
      </.popover>
    </div>
    """
  end

  def styling_variant_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.popover class="popover">
      <:trigger>Subtle (default)</:trigger>
      <:content>Subtle (default)</:content>
    </.popover>
    <.popover class="popover ui-solid">
      <:trigger>Solid</:trigger>
      <:content>Solid</:content>
    </.popover>
    </div>
    """
  end

  def styling_variant_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.popover id="popover-style-subtle" class="popover">
        <:trigger>Subtle (default)</:trigger>
        <:content>Subtle (default)</:content>
      </.popover>
      <.popover id="popover-style-solid" class="popover ui-solid">
        <:trigger>Solid</:trigger>
        <:content>Solid</:content>
      </.popover>
    </div>
    """
  end

  def styling_variant_matrix_code do
    for semantic <- DemoScales.styling_semantic_axis_steps("popover"),
        variant <- DemoScales.styling_variant_axis_steps("popover") do
      class = DemoScales.join_matrix_modifiers("popover", semantic.modifier, variant.modifier)

      ~s(<.popover class="#{class}">)
    end
    |> DemoScales.join_code()
  end

  def styling_variant_matrix_example(assigns) do
    assigns =
      assigns
      |> assign(:matrix_semantics, DemoScales.styling_semantic_axis_steps("popover"))
      |> assign(:matrix_variants, DemoScales.styling_variant_axis_steps("popover"))

    ~H"""
    <div class="w-full overflow-x-auto scrollbar scrollbar--sm">
      <div class="grid grid-cols-4 gap-space items-start min-w-max">
        <div :for={semantic <- @matrix_semantics} class="contents">
          <.popover
            :for={variant <- @matrix_variants}
            id={"popover-mx-#{semantic.label}-#{variant.label}"}
            class={DemoScales.join_matrix_modifiers("popover", semantic.modifier, variant.modifier)}
          >
            <:trigger>{semantic.label}</:trigger>
            <:content>{semantic.label}</:content>
          </.popover>
        </div>
      </div>
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.popover class="popover ui-size-sm">
      <:trigger>SM</:trigger>
      <:content>SM</:content>
    </.popover>
    <.popover class="popover ui-size-md">
      <:trigger>MD</:trigger>
      <:content>MD</:content>
    </.popover>
    <.popover class="popover ui-size-lg">
      <:trigger>LG</:trigger>
      <:content>LG</:content>
    </.popover>
    <.popover class="popover ui-size-xl">
      <:trigger>XL</:trigger>
      <:content>XL</:content>
    </.popover>
    </div>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.popover id="popover-style-size-sm" class="popover ui-size-sm">
        <:trigger>SM</:trigger>
        <:content>SM</:content>
      </.popover>
      <.popover id="popover-style-size-md" class="popover ui-size-md">
        <:trigger>MD</:trigger>
        <:content>MD</:content>
      </.popover>
      <.popover id="popover-style-size-lg" class="popover ui-size-lg">
        <:trigger>LG</:trigger>
        <:content>LG</:content>
      </.popover>
      <.popover id="popover-style-size-xl" class="popover ui-size-xl">
        <:trigger>XL</:trigger>
        <:content>XL</:content>
      </.popover>
    </div>
    """
  end

  def styling_rounded_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.popover class="popover ui-rounded-none">
      <:trigger>NONE</:trigger>
      <:content>NONE</:content>
    </.popover>
    <.popover class="popover ui-rounded-sm">
      <:trigger>SM</:trigger>
      <:content>SM</:content>
    </.popover>
    <.popover class="popover ui-rounded-md">
      <:trigger>MD</:trigger>
      <:content>MD</:content>
    </.popover>
    <.popover class="popover ui-rounded-lg">
      <:trigger>LG</:trigger>
      <:content>LG</:content>
    </.popover>
    <.popover class="popover ui-rounded-xl">
      <:trigger>XL</:trigger>
      <:content>XL</:content>
    </.popover>
    <.popover class="popover ui-rounded-full">
      <:trigger>FULL</:trigger>
      <:content>FULL</:content>
    </.popover>
    </div>
    """
  end

  def styling_rounded_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.popover id="popover-style-r-none" class="popover ui-rounded-none">
        <:trigger>NONE</:trigger>
        <:content>NONE</:content>
      </.popover>
      <.popover id="popover-style-r-sm" class="popover ui-rounded-sm">
        <:trigger>SM</:trigger>
        <:content>SM</:content>
      </.popover>
      <.popover id="popover-style-r-md" class="popover ui-rounded-md">
        <:trigger>MD</:trigger>
        <:content>MD</:content>
      </.popover>
      <.popover id="popover-style-r-lg" class="popover ui-rounded-lg">
        <:trigger>LG</:trigger>
        <:content>LG</:content>
      </.popover>
      <.popover id="popover-style-r-xl" class="popover ui-rounded-xl">
        <:trigger>XL</:trigger>
        <:content>XL</:content>
      </.popover>
      <.popover id="popover-style-r-full" class="popover ui-rounded-full">
        <:trigger>FULL</:trigger>
        <:content>FULL</:content>
      </.popover>
    </div>
    """
  end
end
