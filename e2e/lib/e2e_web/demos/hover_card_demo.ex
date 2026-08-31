defmodule E2eWeb.Demos.HoverCardDemo do
  use E2eWeb, :html

  def anatomy_minimal_code do
    ~S"""
    <.hover_card class="hover-card" show_arrow={false}>
      <:trigger>corex-ui</:trigger>
      <:content>
        <div class="flex gap-space items-start">
          <.avatar class="avatar ui-size-lg">
            <:fallback>Cx</:fallback>
          </.avatar>
          <div>
            <p class="font-semibold">corex-ui/corex</p>
            <p>Phoenix LiveView components with Zag.js behavior.</p>
            <p>Elixir · TypeScript · 1.2k stars</p>
          </div>
        </div>
      </:content>
    </.hover_card>
    """
  end

  def anatomy_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <.hover_card id="hover-card-anatomy-minimal" class="hover-card" show_arrow={false}>
      <:trigger>corex-ui</:trigger>
      <:content>
        <div class="flex gap-space items-start">
          <.avatar class="avatar ui-size-lg">
            <:fallback>Cx</:fallback>
          </.avatar>
          <div>
            <p class="font-semibold">corex-ui/corex</p>
            <p>Phoenix LiveView components with Zag.js behavior.</p>
            <p>Elixir · TypeScript · 1.2k stars</p>
          </div>
        </div>
      </:content>
    </.hover_card>
    """
  end

  def anatomy_with_arrow_code do
    ~S"""
    <.hover_card class="hover-card">
      <:trigger>Hover me</:trigger>
      <:content>Preview content</:content>
    </.hover_card>
    """
  end

  def anatomy_with_arrow_example(assigns) do
    _ = assigns

    ~H"""
    <.hover_card id="hover-card-anatomy-arrow" class="hover-card">
      <:trigger>Hover me</:trigger>
      <:content>Preview content</:content>
    </.hover_card>
    """
  end

  def anatomy_placement_code do
    ~S"""
    <.hover_card class="hover-card" positioning={%Corex.Positioning{placement: "bottom"}}>
      <:trigger>Bottom</:trigger>
      <:content>Card below</:content>
    </.hover_card>
    """
  end

  def anatomy_placement_example(assigns) do
    _ = assigns

    ~H"""
    <.hover_card
      id="hover-card-anatomy-placement"
      class="hover-card"
      positioning={%Corex.Positioning{placement: "bottom"}}
    >
      <:trigger>Bottom</:trigger>
      <:content>Card below</:content>
    </.hover_card>
    """
  end

  def api_set_open_client_binding_heex do
    ~S"""
    <.action phx-click={Corex.HoverCard.set_open("hover-card-api-cb", true)} class="button ui-size-sm">Open</.action>
    <.hover_card id="hover-card-api-cb" class="hover-card">
      <:trigger>Target</:trigger>
      <:content>Opened from binding</:content>
    </.hover_card>
    """
  end

  def api_set_open_client_binding_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap items-center gap-space-sm">
      <.action
        phx-click={Corex.HoverCard.set_open("hover-card-api-cb", true)}
        class="button ui-size-sm"
      >
        Open
      </.action>
      <.hover_card id="hover-card-api-cb" class="hover-card">
        <:trigger>Target</:trigger>
        <:content>Opened from binding</:content>
      </.hover_card>
    </div>
    """
  end

  def api_set_open_client_js_heex do
    ~S"""
    <button type="button" class="button ui-size-sm" onclick="document.getElementById('hover-card-api-cjs')?.dispatchEvent(new CustomEvent('corex:hover-card:set-open', {bubbles: false, detail: { open: true } }))">Open</button>
    <.hover_card id="hover-card-api-cjs" class="hover-card">
      <:trigger>Target</:trigger>
      <:content>Opened from JS</:content>
    </.hover_card>
    """
  end

  def api_set_open_client_js_js do
    ~S"""
    document.getElementById("hover-card-api-cjs")?.dispatchEvent(
      new CustomEvent("corex:hover-card:set-open", { bubbles: false, detail: { open: true } })
    );
    """
  end

  def api_set_open_client_js_ts, do: api_set_open_client_js_js()

  def api_set_open_client_js_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap items-center gap-space-sm">
      <button
        type="button"
        class="button ui-size-sm"
        onclick="document.getElementById('hover-card-api-cjs')?.dispatchEvent(new CustomEvent('corex:hover-card:set-open', {bubbles: false, detail: { open: true } }))"
      >
        Open
      </button>
      <.hover_card id="hover-card-api-cjs" class="hover-card">
        <:trigger>Target</:trigger>
        <:content>Opened from JS</:content>
      </.hover_card>
    </div>
    """
  end

  def api_set_open_server_heex do
    ~S"""
    <.action phx-click="hover_card_api_open" class="button ui-size-sm">Open</.action>
    <.hover_card id="hover-card-api-srv" class="hover-card">
      <:trigger>Target</:trigger>
      <:content>Opened from server</:content>
    </.hover_card>
    """
  end

  def api_set_open_server_elixir do
    ~S"""
    def handle_event("hover_card_api_open", _params, socket) do
      {:noreply, Corex.HoverCard.set_open(socket, "hover-card-api-srv", true)}
    end
    """
  end

  def api_set_open_server_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap items-center gap-space-sm">
      <.action phx-click="hover_card_api_open" class="button ui-size-sm">Open</.action>
      <.hover_card id="hover-card-api-srv" class="hover-card">
        <:trigger>Target</:trigger>
        <:content>Opened from server</:content>
      </.hover_card>
    </div>
    """
  end

  def api_codes do
    %{
      set_open_client_binding: api_set_open_client_binding_heex(),
      set_open_client_js_heex: api_set_open_client_js_heex(),
      set_open_client_js: api_set_open_client_js_js(),
      set_open_client_ts: api_set_open_client_js_ts(),
      set_open_server_heex: api_set_open_server_heex(),
      set_open_server_elixir: api_set_open_server_elixir()
    }
  end

  alias E2eWeb.DemoScales

  def styling_color_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.hover_card class="hover-card">
      <:trigger>Default</:trigger>
      <:content>Default</:content>
    </.hover_card>
    <.hover_card class="hover-card ui-accent">
      <:trigger>Accent</:trigger>
      <:content>Accent</:content>
    </.hover_card>
    <.hover_card class="hover-card ui-brand">
      <:trigger>Brand</:trigger>
      <:content>Brand</:content>
    </.hover_card>
    <.hover_card class="hover-card ui-alert">
      <:trigger>Alert</:trigger>
      <:content>Alert</:content>
    </.hover_card>
    <.hover_card class="hover-card ui-success">
      <:trigger>Success</:trigger>
      <:content>Success</:content>
    </.hover_card>
    <.hover_card class="hover-card ui-info">
      <:trigger>Info</:trigger>
      <:content>Info</:content>
    </.hover_card>
    </div>
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.hover_card id="hover-card-style-default" class="hover-card">
        <:trigger>Default</:trigger>
        <:content>Default</:content>
      </.hover_card>
      <.hover_card id="hover-card-style-accent" class="hover-card ui-accent">
        <:trigger>Accent</:trigger>
        <:content>Accent</:content>
      </.hover_card>
      <.hover_card id="hover-card-style-brand" class="hover-card ui-brand">
        <:trigger>Brand</:trigger>
        <:content>Brand</:content>
      </.hover_card>
      <.hover_card id="hover-card-style-alert" class="hover-card ui-alert">
        <:trigger>Alert</:trigger>
        <:content>Alert</:content>
      </.hover_card>
      <.hover_card id="hover-card-style-success" class="hover-card ui-success">
        <:trigger>Success</:trigger>
        <:content>Success</:content>
      </.hover_card>
      <.hover_card id="hover-card-style-info" class="hover-card ui-info">
        <:trigger>Info</:trigger>
        <:content>Info</:content>
      </.hover_card>
    </div>
    """
  end

  def styling_variant_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.hover_card class="hover-card">
      <:trigger>Subtle (default)</:trigger>
      <:content>Subtle (default)</:content>
    </.hover_card>
    <.hover_card class="hover-card ui-solid">
      <:trigger>Solid</:trigger>
      <:content>Solid</:content>
    </.hover_card>
    </div>
    """
  end

  def styling_variant_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.hover_card id="hover-card-style-subtle" class="hover-card">
        <:trigger>Subtle (default)</:trigger>
        <:content>Subtle (default)</:content>
      </.hover_card>
      <.hover_card id="hover-card-style-solid" class="hover-card ui-solid">
        <:trigger>Solid</:trigger>
        <:content>Solid</:content>
      </.hover_card>
    </div>
    """
  end

  def styling_variant_matrix_code do
    for semantic <- DemoScales.styling_semantic_axis_steps("hover-card"),
        variant <- DemoScales.styling_variant_axis_steps("hover-card") do
      class = DemoScales.join_matrix_modifiers("hover-card", semantic.modifier, variant.modifier)

      ~s(<.hover_card class="#{class}">)
    end
    |> DemoScales.join_code()
  end

  def styling_variant_matrix_example(assigns) do
    assigns =
      assigns
      |> assign(:matrix_semantics, DemoScales.styling_semantic_axis_steps("hover-card"))
      |> assign(:matrix_variants, DemoScales.styling_variant_axis_steps("hover-card"))

    ~H"""
    <div class="w-full overflow-x-auto scrollbar scrollbar--sm" tabindex="0">
      <div class="grid grid-cols-4 gap-space items-start min-w-max">
        <div :for={{semantic, semantic_index} <- Enum.with_index(@matrix_semantics)} class="contents">
          <.hover_card
            :for={{variant, variant_index} <- Enum.with_index(@matrix_variants)}
            id={"hover-card-matrix-#{semantic_index}-#{variant_index}"}
            class={
              DemoScales.join_matrix_modifiers("hover-card", semantic.modifier, variant.modifier)
            }
          >
            <:trigger>{semantic.label}</:trigger>
            <:content>{semantic.label}</:content>
          </.hover_card>
        </div>
      </div>
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.hover_card class="hover-card ui-size-sm">
      <:trigger>SM</:trigger>
      <:content>SM</:content>
    </.hover_card>
    <.hover_card class="hover-card ui-size-md">
      <:trigger>MD</:trigger>
      <:content>MD</:content>
    </.hover_card>
    <.hover_card class="hover-card ui-size-lg">
      <:trigger>LG</:trigger>
      <:content>LG</:content>
    </.hover_card>
    <.hover_card class="hover-card ui-size-xl">
      <:trigger>XL</:trigger>
      <:content>XL</:content>
    </.hover_card>
    </div>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.hover_card id="hover-card-style-size-sm" class="hover-card ui-size-sm">
        <:trigger>SM</:trigger>
        <:content>SM</:content>
      </.hover_card>
      <.hover_card id="hover-card-style-size-md" class="hover-card ui-size-md">
        <:trigger>MD</:trigger>
        <:content>MD</:content>
      </.hover_card>
      <.hover_card id="hover-card-style-size-lg" class="hover-card ui-size-lg">
        <:trigger>LG</:trigger>
        <:content>LG</:content>
      </.hover_card>
      <.hover_card id="hover-card-style-size-xl" class="hover-card ui-size-xl">
        <:trigger>XL</:trigger>
        <:content>XL</:content>
      </.hover_card>
    </div>
    """
  end

  def styling_rounded_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.hover_card class="hover-card ui-rounded-none">
      <:trigger>NONE</:trigger>
      <:content>NONE</:content>
    </.hover_card>
    <.hover_card class="hover-card ui-rounded-sm">
      <:trigger>SM</:trigger>
      <:content>SM</:content>
    </.hover_card>
    <.hover_card class="hover-card ui-rounded-md">
      <:trigger>MD</:trigger>
      <:content>MD</:content>
    </.hover_card>
    <.hover_card class="hover-card ui-rounded-lg">
      <:trigger>LG</:trigger>
      <:content>LG</:content>
    </.hover_card>
    <.hover_card class="hover-card ui-rounded-xl">
      <:trigger>XL</:trigger>
      <:content>XL</:content>
    </.hover_card>
    <.hover_card class="hover-card ui-rounded-full">
      <:trigger>FULL</:trigger>
      <:content>FULL</:content>
    </.hover_card>
    </div>
    """
  end

  def styling_rounded_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.hover_card id="hover-card-style-r-none" class="hover-card ui-rounded-none">
        <:trigger>NONE</:trigger>
        <:content>NONE</:content>
      </.hover_card>
      <.hover_card id="hover-card-style-r-sm" class="hover-card ui-rounded-sm">
        <:trigger>SM</:trigger>
        <:content>SM</:content>
      </.hover_card>
      <.hover_card id="hover-card-style-r-md" class="hover-card ui-rounded-md">
        <:trigger>MD</:trigger>
        <:content>MD</:content>
      </.hover_card>
      <.hover_card id="hover-card-style-r-lg" class="hover-card ui-rounded-lg">
        <:trigger>LG</:trigger>
        <:content>LG</:content>
      </.hover_card>
      <.hover_card id="hover-card-style-r-xl" class="hover-card ui-rounded-xl">
        <:trigger>XL</:trigger>
        <:content>XL</:content>
      </.hover_card>
      <.hover_card id="hover-card-style-r-full" class="hover-card ui-rounded-full">
        <:trigger>FULL</:trigger>
        <:content>FULL</:content>
      </.hover_card>
    </div>
    """
  end
end
