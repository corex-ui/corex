defmodule E2eWeb.Demos.ToggleGroupDemo do
  use E2eWeb, :html

  alias E2eWeb.DemoScales

  def anatomy_minimal_code do
    ~S"""
    <.toggle_group class="toggle-group">
      <:item value="lorem">Lorem</:item>
      <:item value="duis">Duis</:item>
      <:item value="donec">Donec</:item>
    </.toggle_group>
    """
  end

  def anatomy_single_selection_code do
    ~S"""
    <.toggle_group
      class="toggle-group"
      multiple={false}
      value={["duis"]}
    >
      <:item value="lorem">Lorem</:item>
      <:item value="duis">Duis</:item>
      <:item value="donec">Donec</:item>
    </.toggle_group>
    """
  end

  def anatomy_minimal_example(assigns) do
    ~H"""
    <.toggle_group id="toggle-group-anatomy-minimal" class="toggle-group">
      <:item value="lorem">Lorem</:item>
      <:item value="duis">Duis</:item>
      <:item value="donec">Donec</:item>
    </.toggle_group>
    """
  end

  def anatomy_indicator_code do
    ~S"""
    <.toggle_group class="toggle-group">
      <:item value="bold">
        <.heroicon name="hero-bold" />
        Bold
      </:item>
    </.toggle_group>

    <.toggle_group class="toggle-group">
      <:item value="bold" aria_label="Bold">
        <.heroicon name="hero-bold" />
        <span class="sr-only">Bold</span>
      </:item>
    </.toggle_group>
    """
  end

  def anatomy_indicator_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-6 items-center justify-center w-full max-w-4xl">
      <.toggle_group id="toggle-group-anatomy-indicator-label" class="toggle-group">
        <:item value="bold">
          <.heroicon name="hero-bold" /> Bold
        </:item>
      </.toggle_group>
      <.toggle_group id="toggle-group-anatomy-indicator-sr" class="toggle-group">
        <:item value="bold" aria_label="Bold">
          <.heroicon name="hero-bold" />
          <span class="sr-only">Bold</span>
        </:item>
      </.toggle_group>
    </div>
    """
  end

  def api_set_value_client_binding_heex do
    ~S"""
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click={Corex.ToggleGroup.set_value("toggle-group-api-cb", ["lorem"])} class="button ui-size-sm">Lorem</.action>
      <.action phx-click={Corex.ToggleGroup.set_value("toggle-group-api-cb", ["duis"])} class="button ui-size-sm">Duis</.action>
      <.action phx-click={Corex.ToggleGroup.set_value("toggle-group-api-cb", ["donec"])} class="button ui-size-sm">Donec</.action>
      <.action phx-click={Corex.ToggleGroup.set_value("toggle-group-api-cb", [])} class="button ui-size-sm">Clear</.action>
    </div>
    <.toggle_group id="toggle-group-api-cb" class="toggle-group" multiple value={["lorem"]}>
      <:item value="lorem">Lorem</:item>
      <:item value="duis">Duis</:item>
      <:item value="donec">Donec</:item>
    </.toggle_group>
    """
  end

  def api_set_value_client_binding_example(assigns) do
    _ = assigns

    ~H"""
    <div class="w-full max-w-4xl flex flex-col gap-4 items-center">
      <div class="flex flex-wrap items-center gap-space">
        <.action
          phx-click={Corex.ToggleGroup.set_value("toggle-group-api-cb", ["lorem"])}
          class="button ui-size-sm"
        >
          Lorem
        </.action>
        <.action
          phx-click={Corex.ToggleGroup.set_value("toggle-group-api-cb", ["duis"])}
          class="button ui-size-sm"
        >
          Duis
        </.action>
        <.action
          phx-click={Corex.ToggleGroup.set_value("toggle-group-api-cb", ["donec"])}
          class="button ui-size-sm"
        >
          Donec
        </.action>
        <.action
          phx-click={Corex.ToggleGroup.set_value("toggle-group-api-cb", [])}
          class="button ui-size-sm"
        >
          Clear
        </.action>
      </div>
      <.toggle_group id="toggle-group-api-cb" class="toggle-group" multiple value={["lorem"]}>
        <:item value="lorem">Lorem</:item>
        <:item value="duis">Duis</:item>
        <:item value="donec">Donec</:item>
      </.toggle_group>
    </div>
    """
  end

  def api_set_value_client_js_heex do
    ~S"""
    <div class="flex flex-wrap items-center gap-space">
      <.action
        class="button ui-size-sm"
        phx-click={
          Phoenix.LiveView.JS.dispatch("corex:toggle-group:set-value",
            to: "#toggle-group-api-cjs",
            detail: %{value: ["lorem"]},
            bubbles: false
          )
        }
      >
        Lorem
      </.action>
      <.action
        class="button ui-size-sm"
        phx-click={
          Phoenix.LiveView.JS.dispatch("corex:toggle-group:set-value",
            to: "#toggle-group-api-cjs",
            detail: %{value: ["duis"]},
            bubbles: false
          )
        }
      >
        Duis
      </.action>
      <.action
        class="button ui-size-sm"
        phx-click={
          Phoenix.LiveView.JS.dispatch("corex:toggle-group:set-value",
            to: "#toggle-group-api-cjs",
            detail: %{value: ["donec"]},
            bubbles: false
          )
        }
      >
        Donec
      </.action>
    </div>
    <.toggle_group id="toggle-group-api-cjs" class="toggle-group" multiple value={["donec"]}>
      <:item value="lorem">Lorem</:item>
      <:item value="duis">Duis</:item>
      <:item value="donec">Donec</:item>
    </.toggle_group>
    """
  end

  def api_set_value_client_js_js do
    ~S"""
    const el = document.getElementById("toggle-group-api-cjs");
    el?.dispatchEvent(
      new CustomEvent("corex:toggle-group:set-value", { bubbles: false, detail: { value: ["donec"] } })
    );
    """
  end

  def api_set_value_client_js_ts do
    ~S"""
    const el: HTMLElement | null = document.getElementById("toggle-group-api-cjs");
    el?.dispatchEvent(
      new CustomEvent("corex:toggle-group:set-value", {
        bubbles: false,
        detail: { value: ["donec"] },
      })
    );
    """
  end

  def api_set_value_client_js_example(assigns) do
    _ = assigns

    ~H"""
    <div class="w-full max-w-4xl flex flex-col gap-4 items-center">
      <div class="flex flex-wrap items-center gap-space">
        <.action
          class="button ui-size-sm"
          phx-click={
            Phoenix.LiveView.JS.dispatch("corex:toggle-group:set-value",
              to: "#toggle-group-api-cjs",
              detail: %{value: ["lorem"]},
              bubbles: false
            )
          }
        >
          Lorem
        </.action>
        <.action
          class="button ui-size-sm"
          phx-click={
            Phoenix.LiveView.JS.dispatch("corex:toggle-group:set-value",
              to: "#toggle-group-api-cjs",
              detail: %{value: ["duis"]},
              bubbles: false
            )
          }
        >
          Duis
        </.action>
        <.action
          class="button ui-size-sm"
          phx-click={
            Phoenix.LiveView.JS.dispatch("corex:toggle-group:set-value",
              to: "#toggle-group-api-cjs",
              detail: %{value: ["donec"]},
              bubbles: false
            )
          }
        >
          Donec
        </.action>
      </div>
      <.toggle_group id="toggle-group-api-cjs" class="toggle-group" multiple value={["donec"]}>
        <:item value="lorem">Lorem</:item>
        <:item value="duis">Duis</:item>
        <:item value="donec">Donec</:item>
      </.toggle_group>
    </div>
    """
  end

  def api_set_value_server_heex do
    ~S"""
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click="tg_api_lorem" class="button ui-size-sm">Lorem</.action>
      <.action phx-click="tg_api_duis" class="button ui-size-sm">Duis</.action>
      <.action phx-click="tg_api_donec" class="button ui-size-sm">Donec</.action>
      <.action phx-click="tg_api_clear" class="button ui-size-sm">Clear</.action>
    </div>
    <.toggle_group id="toggle-group-api-srv" class="toggle-group" multiple value={["lorem"]}>
      <:item value="lorem">Lorem</:item>
      <:item value="duis">Duis</:item>
      <:item value="donec">Donec</:item>
    </.toggle_group>
    """
  end

  def api_set_value_server_elixir do
    ~S"""
    def handle_event("tg_api_lorem", _params, socket) do
      {:noreply, Corex.ToggleGroup.set_value(socket, "toggle-group-api-srv", ["lorem"])}
    end

    def handle_event("tg_api_duis", _params, socket) do
      {:noreply, Corex.ToggleGroup.set_value(socket, "toggle-group-api-srv", ["duis"])}
    end

    def handle_event("tg_api_donec", _params, socket) do
      {:noreply, Corex.ToggleGroup.set_value(socket, "toggle-group-api-srv", ["donec"])}
    end

    def handle_event("tg_api_clear", _params, socket) do
      {:noreply, Corex.ToggleGroup.set_value(socket, "toggle-group-api-srv", [])}
    end
    """
  end

  def api_set_value_server_example(assigns) do
    _ = assigns

    ~H"""
    <div class="w-full max-w-4xl flex flex-col gap-4 items-center">
      <div class="flex flex-wrap items-center gap-space">
        <.action phx-click="tg_api_lorem" class="button ui-size-sm">Lorem</.action>
        <.action phx-click="tg_api_duis" class="button ui-size-sm">Duis</.action>
        <.action phx-click="tg_api_donec" class="button ui-size-sm">Donec</.action>
        <.action phx-click="tg_api_clear" class="button ui-size-sm">Clear</.action>
      </div>
      <.toggle_group id="toggle-group-api-srv" class="toggle-group" multiple value={["lorem"]}>
        <:item value="lorem">Lorem</:item>
        <:item value="duis">Duis</:item>
        <:item value="donec">Donec</:item>
      </.toggle_group>
    </div>
    """
  end

  def api_codes do
    %{
      set_value_client_binding: api_set_value_client_binding_heex(),
      set_value_client_js_heex: api_set_value_client_js_heex(),
      set_value_client_js: api_set_value_client_js_js(),
      set_value_client_ts: api_set_value_client_js_ts(),
      set_value_server_heex: api_set_value_server_heex(),
      set_value_server_elixir: api_set_value_server_elixir()
    }
  end

  def patterns_controlled_heex do
    ~S"""
    <.toggle_group
      class="toggle-group"
      value={@value}
      multiple
      controlled
      on_value_change="toggle_group_pattern"
    >
      <:item value="lorem">Lorem</:item>
      <:item value="duis">Duis</:item>
      <:item value="donec">Donec</:item>
    </.toggle_group>
    """
  end

  def patterns_controlled_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      {:ok, assign(socket, :value, ["lorem"])}
    end

    def handle_event("toggle_group_pattern", %{"value" => v}, socket) do
      {:noreply, assign(socket, :value, v || [])}
    end
    """
  end

  def patterns_controlled_example(assigns) do
    ~H"""
    <.toggle_group
      id="toggle-group-patterns-controlled"
      class="toggle-group"
      value={@value}
      multiple
      controlled
      on_value_change="toggle_group_pattern"
    >
      <:item value="lorem">Lorem</:item>
      <:item value="duis">Duis</:item>
      <:item value="donec">Donec</:item>
    </.toggle_group>
    """
  end

  def styling_color_code do
    ~S"""
    <.toggle_group class="toggle-group" value={["lorem"]}>
      <:item value="lorem">Lorem</:item>
      <:item value="duis">Duis</:item>
      <:item value="donec">Donec</:item>
    </.toggle_group>
    <.toggle_group class="toggle-group ui-accent" value={["lorem"]}>
      <:item value="lorem">Lorem</:item>
      <:item value="duis">Duis</:item>
      <:item value="donec">Donec</:item>
    </.toggle_group>
    <.toggle_group class="toggle-group ui-brand" value={["lorem"]}>
      <:item value="lorem">Lorem</:item>
      <:item value="duis">Duis</:item>
      <:item value="donec">Donec</:item>
    </.toggle_group>
    <.toggle_group class="toggle-group ui-alert" value={["lorem"]}>
      <:item value="lorem">Lorem</:item>
      <:item value="duis">Duis</:item>
      <:item value="donec">Donec</:item>
    </.toggle_group>
    <.toggle_group class="toggle-group ui-success" value={["lorem"]}>
      <:item value="lorem">Lorem</:item>
      <:item value="duis">Duis</:item>
      <:item value="donec">Donec</:item>
    </.toggle_group>
    <.toggle_group class="toggle-group ui-info" value={["lorem"]}>
      <:item value="lorem">Lorem</:item>
      <:item value="duis">Duis</:item>
      <:item value="donec">Donec</:item>
    </.toggle_group>
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-col gap-6 w-full max-w-4xl">
      <.toggle_group id="tg-style-c-default" class="toggle-group" value={["lorem"]}>
        <:item value="lorem">Lorem</:item>
        <:item value="duis">Duis</:item>
        <:item value="donec">Donec</:item>
      </.toggle_group>
      <.toggle_group
        id="tg-style-c-accent"
        class="toggle-group ui-accent"
        value={["lorem"]}
      >
        <:item value="lorem">Lorem</:item>
        <:item value="duis">Duis</:item>
        <:item value="donec">Donec</:item>
      </.toggle_group>
      <.toggle_group id="tg-style-c-brand" class="toggle-group ui-brand" value={["lorem"]}>
        <:item value="lorem">Lorem</:item>
        <:item value="duis">Duis</:item>
        <:item value="donec">Donec</:item>
      </.toggle_group>
      <.toggle_group id="tg-style-c-alert" class="toggle-group ui-alert" value={["lorem"]}>
        <:item value="lorem">Lorem</:item>
        <:item value="duis">Duis</:item>
        <:item value="donec">Donec</:item>
      </.toggle_group>
      <.toggle_group
        id="tg-style-c-success"
        class="toggle-group ui-success"
        value={["lorem"]}
      >
        <:item value="lorem">Lorem</:item>
        <:item value="duis">Duis</:item>
        <:item value="donec">Donec</:item>
      </.toggle_group>
      <.toggle_group id="tg-style-c-info" class="toggle-group ui-info" value={["lorem"]}>
        <:item value="lorem">Lorem</:item>
        <:item value="duis">Duis</:item>
        <:item value="donec">Donec</:item>
      </.toggle_group>
    </div>
    """
  end

  def styling_variant_code do
    ~S"""
    <.toggle_group class="toggle-group" value={["lorem"]}>
      <:item value="lorem">Lorem</:item>
      <:item value="duis">Duis</:item>
      <:item value="donec">Donec</:item>
    </.toggle_group>
    <.toggle_group class="toggle-group ui-solid" value={["lorem"]}>
      <:item value="lorem">Lorem</:item>
      <:item value="duis">Duis</:item>
      <:item value="donec">Donec</:item>
    </.toggle_group>

    """
  end

  def styling_variant_example(assigns) do
    ~H"""
    <div class="flex flex-col gap-6 w-full max-w-4xl">
      <.toggle_group id="tg-style-variant-subtle" class="toggle-group" value={["lorem"]}>
        <:item value="lorem">Lorem</:item>
        <:item value="duis">Duis</:item>
        <:item value="donec">Donec</:item>
      </.toggle_group>
      <.toggle_group
        id="tg-style-variant-solid"
        class="toggle-group ui-solid"
        value={["lorem"]}
      >
        <:item value="lorem">Lorem</:item>
        <:item value="duis">Duis</:item>
        <:item value="donec">Donec</:item>
      </.toggle_group>
    </div>
    """
  end

  def styling_variant_matrix_code do
    for semantic <- DemoScales.styling_semantic_axis_steps("toggle-group"),
        variant <- DemoScales.styling_variant_axis_steps("toggle-group") do
      class =
        DemoScales.join_matrix_modifiers("toggle-group", semantic.modifier, variant.modifier)

      ~s(<.toggle_group class="#{class}" value={["lorem"]}>
        <:item value="lorem">#{semantic.label}</:item>
      </.toggle_group>)
    end
    |> DemoScales.join_code()
  end

  def styling_variant_matrix_example(assigns) do
    assigns =
      assigns
      |> assign(:matrix_semantics, DemoScales.styling_semantic_axis_steps("toggle-group"))
      |> assign(:matrix_variants, DemoScales.styling_variant_axis_steps("toggle-group"))

    ~H"""
    <div class="w-full overflow-x-auto scrollbar scrollbar--sm">
      <div class="grid grid-cols-4 gap-space items-start min-w-max">
        <div :for={semantic <- @matrix_semantics} class="contents">
          <.toggle_group
            :for={variant <- @matrix_variants}
            class={
              DemoScales.join_matrix_modifiers("toggle-group", semantic.modifier, variant.modifier)
            }
            value={["lorem"]}
          >
            <:item value="lorem">{semantic.label}</:item>
          </.toggle_group>
        </div>
      </div>
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <.toggle_group class="toggle-group ui-size-sm" value={["lorem"]}>
      <:item value="lorem">SM</:item>
      <:item value="duis">SM</:item>
      <:item value="donec">SM</:item>
    </.toggle_group>
    <.toggle_group class="toggle-group ui-size-md" value={["lorem"]}>
      <:item value="lorem">MD</:item>
      <:item value="duis">MD</:item>
      <:item value="donec">MD</:item>
    </.toggle_group>
    <.toggle_group class="toggle-group ui-size-lg" value={["lorem"]}>
      <:item value="lorem">LG</:item>
      <:item value="duis">LG</:item>
      <:item value="donec">LG</:item>
    </.toggle_group>
    <.toggle_group class="toggle-group ui-size-xl" value={["lorem"]}>
      <:item value="lorem">XL</:item>
      <:item value="duis">XL</:item>
      <:item value="donec">XL</:item>
    </.toggle_group>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-col gap-6 w-full max-w-4xl">
      <.toggle_group id="tg-style-sm" class="toggle-group ui-size-sm" value={["lorem"]}>
        <:item value="lorem">SM</:item>
        <:item value="duis">SM</:item>
        <:item value="donec">SM</:item>
      </.toggle_group>
      <.toggle_group id="tg-style-md" class="toggle-group ui-size-md" value={["lorem"]}>
        <:item value="lorem">MD</:item>
        <:item value="duis">MD</:item>
        <:item value="donec">MD</:item>
      </.toggle_group>
      <.toggle_group id="tg-style-lg" class="toggle-group ui-size-lg" value={["lorem"]}>
        <:item value="lorem">LG</:item>
        <:item value="duis">LG</:item>
        <:item value="donec">LG</:item>
      </.toggle_group>
      <.toggle_group id="tg-style-xl" class="toggle-group ui-size-xl" value={["lorem"]}>
        <:item value="lorem">XL</:item>
        <:item value="duis">XL</:item>
        <:item value="donec">XL</:item>
      </.toggle_group>
    </div>
    """
  end

  def styling_radius_code do
    ~S"""
    <.toggle_group
      class="toggle-group ui-rounded-none"
      value={["lorem"]}
    >
      <:item value="lorem">None</:item>
      <:item value="duis">None</:item>
      <:item value="donec">None</:item>
    </.toggle_group>
    <.toggle_group class="toggle-group ui-rounded-sm" value={["lorem"]}>
      <:item value="lorem">SM</:item>
      <:item value="duis">SM</:item>
      <:item value="donec">SM</:item>
    </.toggle_group>
    <.toggle_group class="toggle-group ui-rounded-md" value={["lorem"]}>
      <:item value="lorem">MD</:item>
      <:item value="duis">MD</:item>
      <:item value="donec">MD</:item>
    </.toggle_group>
    <.toggle_group class="toggle-group ui-rounded-lg" value={["lorem"]}>
      <:item value="lorem">LG</:item>
      <:item value="duis">LG</:item>
      <:item value="donec">LG</:item>
    </.toggle_group>
    <.toggle_group class="toggle-group ui-rounded-xl" value={["lorem"]}>
      <:item value="lorem">XL</:item>
      <:item value="duis">XL</:item>
      <:item value="donec">XL</:item>
    </.toggle_group>
    <.toggle_group
      class="toggle-group ui-rounded-full"
      value={["lorem"]}
    >
      <:item value="lorem">Full</:item>
      <:item value="duis">Full</:item>
      <:item value="donec">Full</:item>
    </.toggle_group>
    """
  end

  def styling_radius_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-col gap-6 w-full max-w-4xl">
      <.toggle_group
        id="tg-style-radius-none"
        class="toggle-group ui-rounded-none"
        value={["lorem"]}
      >
        <:item value="lorem">None</:item>
        <:item value="duis">None</:item>
        <:item value="donec">None</:item>
      </.toggle_group>
      <.toggle_group
        id="tg-style-radius-sm"
        class="toggle-group ui-rounded-sm"
        value={["lorem"]}
      >
        <:item value="lorem">SM</:item>
        <:item value="duis">SM</:item>
        <:item value="donec">SM</:item>
      </.toggle_group>
      <.toggle_group
        id="tg-style-radius-md"
        class="toggle-group ui-rounded-md"
        value={["lorem"]}
      >
        <:item value="lorem">MD</:item>
        <:item value="duis">MD</:item>
        <:item value="donec">MD</:item>
      </.toggle_group>
      <.toggle_group
        id="tg-style-radius-lg"
        class="toggle-group ui-rounded-lg"
        value={["lorem"]}
      >
        <:item value="lorem">LG</:item>
        <:item value="duis">LG</:item>
        <:item value="donec">LG</:item>
      </.toggle_group>
      <.toggle_group
        id="tg-style-radius-xl"
        class="toggle-group ui-rounded-xl"
        value={["lorem"]}
      >
        <:item value="lorem">XL</:item>
        <:item value="duis">XL</:item>
        <:item value="donec">XL</:item>
      </.toggle_group>
      <.toggle_group
        id="tg-style-radius-full"
        class="toggle-group ui-rounded-full"
        value={["lorem"]}
      >
        <:item value="lorem">Full</:item>
        <:item value="duis">Full</:item>
        <:item value="donec">Full</:item>
      </.toggle_group>
    </div>
    """
  end

  defp styling_items_code do
    """
      <:item value="lorem">Lorem</:item>
      <:item value="duis">Duis</:item>
      <:item value="donec">Donec</:item>
    """
  end

  def styling_width_code do
    items = styling_items_code()

    DemoScales.width_layout_variants("toggle-group")
    |> Enum.map(fn %{modifier: modifier} ->
      class = DemoScales.join_modifiers("toggle-group", modifier)

      """
      <.toggle_group class="#{class}" value={["lorem"]}>
      #{items}
      </.toggle_group>
      """
    end)
    |> DemoScales.join_code()
  end

  def styling_max_width_code do
    items = styling_items_code()

    DemoScales.max_width_variants("toggle-group")
    |> Enum.map(fn %{modifier: modifier} ->
      class = DemoScales.join_modifiers("toggle-group", modifier)

      """
      <.toggle_group class="#{class}" value={["lorem"]}>
      #{items}
      </.toggle_group>
      """
    end)
    |> DemoScales.join_code()
  end

  def styling_width_example(assigns) do
    assigns = assign(assigns, :width_variants, DemoScales.width_layout_variants("toggle-group"))

    ~H"""
    <div class={DemoScales.preview_scroll_class()}>
      <div :for={variant <- @width_variants} class="flex flex-col gap-2">
        <p class="typo ui-size-sm font-medium">{variant.label}</p>
        <.toggle_group
          id={"toggle-group-style-width-#{variant.id}"}
          class={DemoScales.join_modifiers("toggle-group", variant.modifier)}
          value={["lorem"]}
        >
          <:item value="lorem">Lorem</:item>
          <:item value="duis">Duis</:item>
          <:item value="donec">Donec</:item>
        </.toggle_group>
      </div>
    </div>
    """
  end

  def styling_max_width_example(assigns) do
    assigns = assign(assigns, :max_width_variants, DemoScales.max_width_variants("toggle-group"))

    ~H"""
    <div class={DemoScales.preview_scroll_class()}>
      <div :for={variant <- @max_width_variants} class="flex flex-col gap-2">
        <p class="typo ui-size-sm font-medium">{variant.label}</p>
        <.toggle_group
          id={"toggle-group-style-max-#{variant.id}"}
          class={DemoScales.join_modifiers("toggle-group", variant.modifier)}
          value={["lorem"]}
        >
          <:item value="lorem">Lorem</:item>
          <:item value="duis">Duis</:item>
          <:item value="donec">Donec</:item>
        </.toggle_group>
      </div>
    </div>
    """
  end

  def styling_disabled_code do
    ~S"""
    <.toggle_group class="toggle-group" disabled value={["lorem"]}>
      <:item value="lorem">Lorem</:item>
      <:item value="duis">Duis</:item>
      <:item value="donec">Donec</:item>
    </.toggle_group>
    <.toggle_group
      class="toggle-group ui-accent"
      disabled
      value={["donec"]}
    >
      <:item value="lorem">Lorem</:item>
      <:item value="duis">Duis</:item>
      <:item value="donec">Donec</:item>
    </.toggle_group>
    """
  end

  def styling_disabled_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-col gap-6 w-full max-w-4xl">
      <.toggle_group id="tg-style-disabled" class="toggle-group" disabled value={["lorem"]}>
        <:item value="lorem">Lorem</:item>
        <:item value="duis">Duis</:item>
        <:item value="donec">Donec</:item>
      </.toggle_group>
      <.toggle_group
        id="tg-style-disabled-accent"
        class="toggle-group ui-accent"
        disabled
        value={["donec"]}
      >
        <:item value="lorem">Lorem</:item>
        <:item value="duis">Duis</:item>
        <:item value="donec">Donec</:item>
      </.toggle_group>
    </div>
    """
  end

  def events_server_heex do
    ~S"""
    <.toggle_group
      class="toggle-group"
      on_value_change="toggle_group_changed"
      multiple
    >
      <:item value="lorem">Lorem</:item>
      <:item value="duis">Duis</:item>
      <:item value="donec">Donec</:item>
    </.toggle_group>
    """
  end

  def events_server_elixir do
    E2eWeb.Demos.DocExamples.event_handler_snippet(
      "toggle_group_changed",
      ~S|%{"id" => id, "value" => value} = params|
    )
  end

  def events_client_heex do
    ~S"""
    <.toggle_group
      id="toggle-group-events-client"
      class="toggle-group"
      on_value_change_client="toggle-group-changed"
      multiple
    >
      <:item value="lorem">Lorem</:item>
      <:item value="duis">Duis</:item>
      <:item value="donec">Donec</:item>
    </.toggle_group>
    """
  end

  def events_client_js do
    ~S"""
    const el = document.getElementById("toggle-group-events-client");
    el?.addEventListener("toggle-group-changed", (event) => console.log(event.detail));
    """
  end

  def events_client_ts do
    ~S"""
    const el = document.getElementById("toggle-group-events-client");
    el?.addEventListener("toggle-group-changed", (event: Event) =>
      console.log((event as CustomEvent<unknown>).detail)
    );
    """
  end
end
