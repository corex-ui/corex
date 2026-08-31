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
    <.drawer class="drawer" snap_points="0.45,0.75,1" default_snap_point="0.75">
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
      snap_points="0.45,0.75,1"
      default_snap_point="0.75"
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

  def api_set_open_client_js_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap items-center gap-space-sm">
      <button
        type="button"
        class="button ui-size-sm"
        onclick="document.getElementById('drawer-api-cjs')?.dispatchEvent(new CustomEvent('corex:drawer:set-open', {bubbles: false, detail: { open: true } }))"
      >
        Open
      </button>
      <.drawer id="drawer-api-cjs" class="drawer">
        <:trigger>Target</:trigger>
        <:content>Opened from client JS</:content>
      </.drawer>
    </div>
    """
  end

  def api_codes do
    %{
      set_open_client_binding: ~S"""
      <.action phx-click={Corex.Drawer.set_open("drawer-api-cb", true)} class="button ui-size-sm">Open</.action>
      <.drawer id="drawer-api-cb" class="drawer">
        <:trigger>Target</:trigger>
        <:content>Opened from binding</:content>
      </.drawer>
      """,
      set_open_client_js_heex: ~S"""
      <button type="button" class="button ui-size-sm" onclick="document.getElementById('drawer-api-cjs')?.dispatchEvent(new CustomEvent('corex:drawer:set-open', {bubbles: false, detail: { open: true } }))">Open</button>
      <.drawer id="drawer-api-cjs" class="drawer">
        <:trigger>Target</:trigger>
        <:content>Opened from client JS</:content>
      </.drawer>
      """,
      set_open_client_js: ~S"""
      document.getElementById("drawer-api-cjs")?.dispatchEvent(
        new CustomEvent("corex:drawer:set-open", { bubbles: false, detail: { open: true } })
      );
      """,
      set_open_client_ts: ~S"""
      document.getElementById("drawer-api-cjs")?.dispatchEvent(
        new CustomEvent("corex:drawer:set-open", { bubbles: false, detail: { open: true } })
      );
      """,
      set_open_server_heex: ~S"""
      <.action phx-click="drawer_api_open" class="button ui-size-sm">Open</.action>
      <.drawer id="drawer-api-srv" class="drawer">
        <:trigger>Target</:trigger>
        <:content>Opened from server</:content>
      </.drawer>
      """,
      set_open_server_elixir: ~S"""
      def handle_event("drawer_api_open", _params, socket) do
        {:noreply, Corex.Drawer.set_open(socket, "drawer-api-srv", true)}
      end
      """
    }
  end

  alias E2eWeb.DemoScales

  def styling_color_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.drawer class="drawer">
      <:trigger>Default</:trigger>
      <:content>Default</:content>
    </.drawer>
    <.drawer class="drawer ui-accent">
      <:trigger>Accent</:trigger>
      <:content>Accent</:content>
    </.drawer>
    <.drawer class="drawer ui-brand">
      <:trigger>Brand</:trigger>
      <:content>Brand</:content>
    </.drawer>
    <.drawer class="drawer ui-alert">
      <:trigger>Alert</:trigger>
      <:content>Alert</:content>
    </.drawer>
    <.drawer class="drawer ui-success">
      <:trigger>Success</:trigger>
      <:content>Success</:content>
    </.drawer>
    <.drawer class="drawer ui-info">
      <:trigger>Info</:trigger>
      <:content>Info</:content>
    </.drawer>
    </div>
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.drawer id="drawer-style-default" class="drawer">
        <:trigger>Default</:trigger>
        <:content>Default</:content>
      </.drawer>
      <.drawer id="drawer-style-accent" class="drawer ui-accent">
        <:trigger>Accent</:trigger>
        <:content>Accent</:content>
      </.drawer>
      <.drawer id="drawer-style-brand" class="drawer ui-brand">
        <:trigger>Brand</:trigger>
        <:content>Brand</:content>
      </.drawer>
      <.drawer id="drawer-style-alert" class="drawer ui-alert">
        <:trigger>Alert</:trigger>
        <:content>Alert</:content>
      </.drawer>
      <.drawer id="drawer-style-success" class="drawer ui-success">
        <:trigger>Success</:trigger>
        <:content>Success</:content>
      </.drawer>
      <.drawer id="drawer-style-info" class="drawer ui-info">
        <:trigger>Info</:trigger>
        <:content>Info</:content>
      </.drawer>
    </div>
    """
  end

  def styling_variant_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.drawer class="drawer">
      <:trigger>Subtle (default)</:trigger>
      <:content>Subtle (default)</:content>
    </.drawer>
    <.drawer class="drawer ui-solid">
      <:trigger>Solid</:trigger>
      <:content>Solid</:content>
    </.drawer>
    </div>
    """
  end

  def styling_variant_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.drawer id="drawer-style-subtle" class="drawer">
        <:trigger>Subtle (default)</:trigger>
        <:content>Subtle (default)</:content>
      </.drawer>
      <.drawer id="drawer-style-solid" class="drawer ui-solid">
        <:trigger>Solid</:trigger>
        <:content>Solid</:content>
      </.drawer>
    </div>
    """
  end

  def styling_variant_matrix_code do
    for semantic <- DemoScales.styling_semantic_axis_steps("drawer"),
        variant <- DemoScales.styling_variant_axis_steps("drawer") do
      class = DemoScales.join_matrix_modifiers("drawer", semantic.modifier, variant.modifier)

      ~s(<.drawer class="#{class}">)
    end
    |> DemoScales.join_code()
  end

  def styling_variant_matrix_example(assigns) do
    assigns =
      assigns
      |> assign(:matrix_semantics, DemoScales.styling_semantic_axis_steps("drawer"))
      |> assign(:matrix_variants, DemoScales.styling_variant_axis_steps("drawer"))

    ~H"""
    <div class="w-full overflow-x-auto scrollbar scrollbar--sm">
      <div class="grid grid-cols-4 gap-space items-start min-w-max">
        <div :for={semantic <- @matrix_semantics} class="contents">
          <.drawer
            :for={variant <- @matrix_variants}
            id={"drawer-mx-#{semantic.label}-#{variant.label}"}
            class={DemoScales.join_matrix_modifiers("drawer", semantic.modifier, variant.modifier)}
          >
            <:trigger>{semantic.label}</:trigger>
            <:content>{semantic.label}</:content>
          </.drawer>
        </div>
      </div>
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.drawer class="drawer ui-size-sm">
      <:trigger>SM</:trigger>
      <:content>SM</:content>
    </.drawer>
    <.drawer class="drawer ui-size-md">
      <:trigger>MD</:trigger>
      <:content>MD</:content>
    </.drawer>
    <.drawer class="drawer ui-size-lg">
      <:trigger>LG</:trigger>
      <:content>LG</:content>
    </.drawer>
    <.drawer class="drawer ui-size-xl">
      <:trigger>XL</:trigger>
      <:content>XL</:content>
    </.drawer>
    </div>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.drawer id="drawer-style-size-sm" class="drawer ui-size-sm">
        <:trigger>SM</:trigger>
        <:content>SM</:content>
      </.drawer>
      <.drawer id="drawer-style-size-md" class="drawer ui-size-md">
        <:trigger>MD</:trigger>
        <:content>MD</:content>
      </.drawer>
      <.drawer id="drawer-style-size-lg" class="drawer ui-size-lg">
        <:trigger>LG</:trigger>
        <:content>LG</:content>
      </.drawer>
      <.drawer id="drawer-style-size-xl" class="drawer ui-size-xl">
        <:trigger>XL</:trigger>
        <:content>XL</:content>
      </.drawer>
    </div>
    """
  end

  def styling_rounded_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.drawer class="drawer ui-rounded-none">
      <:trigger>NONE</:trigger>
      <:content>NONE</:content>
    </.drawer>
    <.drawer class="drawer ui-rounded-sm">
      <:trigger>SM</:trigger>
      <:content>SM</:content>
    </.drawer>
    <.drawer class="drawer ui-rounded-md">
      <:trigger>MD</:trigger>
      <:content>MD</:content>
    </.drawer>
    <.drawer class="drawer ui-rounded-lg">
      <:trigger>LG</:trigger>
      <:content>LG</:content>
    </.drawer>
    <.drawer class="drawer ui-rounded-xl">
      <:trigger>XL</:trigger>
      <:content>XL</:content>
    </.drawer>
    <.drawer class="drawer ui-rounded-full">
      <:trigger>FULL</:trigger>
      <:content>FULL</:content>
    </.drawer>
    </div>
    """
  end

  def styling_rounded_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.drawer id="drawer-style-r-none" class="drawer ui-rounded-none">
        <:trigger>NONE</:trigger>
        <:content>NONE</:content>
      </.drawer>
      <.drawer id="drawer-style-r-sm" class="drawer ui-rounded-sm">
        <:trigger>SM</:trigger>
        <:content>SM</:content>
      </.drawer>
      <.drawer id="drawer-style-r-md" class="drawer ui-rounded-md">
        <:trigger>MD</:trigger>
        <:content>MD</:content>
      </.drawer>
      <.drawer id="drawer-style-r-lg" class="drawer ui-rounded-lg">
        <:trigger>LG</:trigger>
        <:content>LG</:content>
      </.drawer>
      <.drawer id="drawer-style-r-xl" class="drawer ui-rounded-xl">
        <:trigger>XL</:trigger>
        <:content>XL</:content>
      </.drawer>
      <.drawer id="drawer-style-r-full" class="drawer ui-rounded-full">
        <:trigger>FULL</:trigger>
        <:content>FULL</:content>
      </.drawer>
    </div>
    """
  end
end
