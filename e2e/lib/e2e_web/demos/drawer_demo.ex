defmodule E2eWeb.Demos.DrawerDemo do
  use E2eWeb, :html

  def anatomy_minimal_code do
    ~S"""
    <.drawer class="drawer">
      <:trigger>Open</:trigger>
      <:content>
        <p>Sheet content.</p>
      </:content>
    </.drawer>
    """
  end

  def anatomy_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <.drawer id="drawer-anatomy-minimal" class="drawer">
      <:trigger>Open</:trigger>
      <:content>
        <p>Sheet content.</p>
      </:content>
    </.drawer>
    """
  end

  def anatomy_with_title_code do
    ~S"""
    <.drawer class="drawer">
      <:trigger>Open</:trigger>
      <:title>Details</:title>
      <:content>
        <p>Sheet content.</p>
      </:content>
    </.drawer>
    """
  end

  def anatomy_with_title_example(assigns) do
    _ = assigns

    ~H"""
    <.drawer id="drawer-anatomy-title" class="drawer">
      <:trigger>Open</:trigger>
      <:title>Details</:title>
      <:content>
        <p>Sheet content.</p>
      </:content>
    </.drawer>
    """
  end

  def anatomy_snap_points_code do
    ~S"""
    <.drawer class="drawer" snap_points="0.3,0.6,1" default_snap_point="0.6">
      <:trigger>Open</:trigger>
      <:content>
        <p>Drag between snap points.</p>
      </:content>
    </.drawer>
    """
  end

  def anatomy_snap_points_example(assigns) do
    _ = assigns

    ~H"""
    <.drawer
      id="drawer-anatomy-snap"
      class="drawer"
      snap_points="0.3,0.6,1"
      default_snap_point="0.6"
    >
      <:trigger>Open</:trigger>
      <:content>
        <p>Drag between snap points.</p>
      </:content>
    </.drawer>
    """
  end

  def api_set_open_client_binding_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap items-center gap-space-sm">
      <.action phx-click={Corex.Drawer.set_open("drawer-api-cb", true)} class="button ui-size-sm">
        Open
      </.action>
      <.drawer id="drawer-api-cb" class="drawer">
        <:trigger>Target</:trigger>
        <:content>Opened from binding</:content>
      </.drawer>
    </div>
    """
  end

  def api_set_open_server_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap items-center gap-space-sm">
      <.action phx-click="drawer_api_open" class="button ui-size-sm">Open</.action>
      <.drawer id="drawer-api-srv" class="drawer">
        <:trigger>Target</:trigger>
        <:content>Opened from server</:content>
      </.drawer>
    </div>
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <.drawer id="drawer-style-accent" class="drawer ui-accent">
      <:trigger>Accent</:trigger>
      <:content>Accent sheet</:content>
    </.drawer>
    """
  end
end
