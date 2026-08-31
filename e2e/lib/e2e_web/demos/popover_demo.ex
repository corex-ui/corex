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

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <.popover id="popover-style-accent" class="popover ui-accent">
      <:trigger>Accent</:trigger>
      <:content>Accent panel</:content>
    </.popover>
    """
  end
end
