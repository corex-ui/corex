defmodule E2eWeb.Demos.ClipboardDemo do
  use E2eWeb, :html

  alias E2eWeb.DemoScales

  def trigger_only_code do
    ~S"""
    <.clipboard
      class="clipboard"
      value="https://example.com/share"
      input={false}
      trigger_aria_label="Copy link"
    >
      <:copy>
        <.heroicon name="hero-clipboard" />
      </:copy>
      <:copied>
        <.heroicon name="hero-check" />
      </:copied>
    </.clipboard>
    """
  end

  def minimal_code do
    ~S"""
    <.clipboard class="clipboard" value="hello@example.com">
      <:label>Email</:label>
      <:copy>
        <.heroicon name="hero-clipboard" />
      </:copy>
      <:copied>
        <.heroicon name="hero-check" />
      </:copied>
    </.clipboard>
    """
  end

  def minimal_example(assigns) do
    ~H"""
    <.clipboard id="clipboard-anatomy-min" class="clipboard" value="hello@example.com">
      <:label>Email</:label>
      <:copy>
        <.heroicon name="hero-clipboard" />
      </:copy>
      <:copied>
        <.heroicon name="hero-check" />
      </:copied>
    </.clipboard>
    """
  end

  def input_false_code do
    ~S"""
    <.clipboard
      class="clipboard"
      value="https://example.com/share"
      input={false}
      trigger_aria_label="Copy link"
    >
      <:copy>
        <.heroicon name="hero-clipboard" />
      </:copy>
      <:copied>
        <.heroicon name="hero-check" />
      </:copied>
    </.clipboard>
    """
  end

  def input_false_example(assigns) do
    ~H"""
    <.clipboard
      id="clipboard-anatomy-trigger-only"
      class="clipboard"
      value="https://example.com/share"
      input={false}
      trigger_aria_label="Copy link"
    >
      <:copy>
        <.heroicon name="hero-clipboard" />
      </:copy>
      <:copied>
        <.heroicon name="hero-check" />
      </:copied>
    </.clipboard>
    """
  end

  def events_server_heex do
    ~S"""
    <.action phx-click={Corex.Clipboard.copy("clipboard-events")} class="button ui-size-sm">
      Copy
    </.action>

    <.clipboard
      class="clipboard"
      value="info@netoum.com"
      trigger_aria_label="Copy to clipboard"
      input_aria_label="Value to copy"
      on_copy="clipboard_copied"
      on_copy_client="clipboard-copied"
    >
      <:label>Copy</:label>
      <:copy>
        <.heroicon name="hero-clipboard" />
      </:copy>
      <:copied>
        <.heroicon name="hero-check" />
      </:copied>
    </.clipboard>
    """
  end

  def events_server_elixir do
    E2eWeb.Demos.DocExamples.event_handler_snippet(
      "clipboard_copied",
      ~S|%{"value" => value, "id" => id} = params|
    )
  end

  def api_client_binding_code do
    ~S"""
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click={Corex.Clipboard.set_value("clipboard-api", "Hello, World!")} class="button ui-size-sm">
        Set to "Hello, World!"
      </.action>
      <.action phx-click={Corex.Clipboard.set_value("clipboard-api", "info@netoum.com")} class="button ui-size-sm">
        Set to "info@netoum.com"
      </.action>
      <.action phx-click={Corex.Clipboard.copy("clipboard-api")} class="button ui-size-sm">
        Copy
      </.action>
    </div>

    <.clipboard
      id="clipboard-api"
      value="info@netoum.com"
      trigger_aria_label="Copy to clipboard"
      input_aria_label="Value to copy"
      class="clipboard"
    >
      <:copy>
        <.heroicon name="hero-clipboard" />
      </:copy>
      <:copied>
        <.heroicon name="hero-check" />
      </:copied>
    </.clipboard>
    """
  end

  def api_client_binding_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-center gap-space">
      <.action
        phx-click={Corex.Clipboard.set_value("clipboard-api", "Hello, World!")}
        class="button ui-size-sm"
      >
        Set to "Hello, World!"
      </.action>
      <.action
        phx-click={Corex.Clipboard.set_value("clipboard-api", "info@netoum.com")}
        class="button ui-size-sm"
      >
        Set to "info@netoum.com"
      </.action>
      <.action phx-click={Corex.Clipboard.copy("clipboard-api")} class="button ui-size-sm">
        Copy
      </.action>
    </div>

    <.clipboard
      id="clipboard-api"
      value="info@netoum.com"
      trigger_aria_label="Copy to clipboard"
      input_aria_label="Value to copy"
      class="clipboard"
    >
      <:copy>
        <.heroicon name="hero-clipboard" />
      </:copy>
      <:copied>
        <.heroicon name="hero-check" />
      </:copied>
    </.clipboard>
    """
  end

  def api_server_copy_elixir do
    ~S"""
    def handle_event("api_clipboard_copy", _params, socket) do
      {:noreply, Corex.Clipboard.copy(socket, "clipboard-api-server")}
    end
    """
  end

  def api_server_set_value_elixir do
    ~S"""
    def handle_event("api_clipboard_set", _params, socket) do
      {:noreply, Corex.Clipboard.set_value(socket, "clipboard-api-server", "pasted-value")}
    end
    """
  end

  def api_client_elixir_note do
    ~S"""
    # Optional: handle on_copy (id + value from the hook)
    def handle_event("clipboard_copied", %{"id" => id, "value" => value}, socket) do
      {:noreply, socket}
    end
    """
  end

  def api_server_elixir_combo do
    api_server_copy_elixir() <> "\n\n" <> api_server_set_value_elixir()
  end

  def api_server_preview_heex do
    ~S"""
    <.action phx-click="clipboard_api_server_copy" class="button ui-size-sm">Push copy</.action>
    <.action phx-click="clipboard_api_server_set" class="button ui-size-sm">Push set value</.action>
    <.clipboard id="clipboard-api-server" class="clipboard" value="server-push@example.com">
      <:copy><.heroicon name="hero-clipboard" /></:copy>
      <:copied><.heroicon name="hero-check" /></:copied>
    </.clipboard>
    """
  end

  def api_dispatch_heex do
    ~S"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={Corex.Clipboard.copy("clipboard-api-dispatch")} class="button ui-size-sm">
        Copy
      </.action>
    </div>
    <.clipboard
      id="clipboard-api-dispatch"
      class="clipboard"
      value="dispatch@example.com"
      trigger_aria_label="Copy"
      input_aria_label="Value"
    >
      <:copy>
        <.heroicon name="hero-clipboard" />
      </:copy>
      <:copied>
        <.heroicon name="hero-check" />
      </:copied>
    </.clipboard>
    """
  end

  def api_dispatch_js do
    ~S"""
    document.getElementById("clipboard-api-dispatch")?.dispatchEvent(
      new CustomEvent("corex:clipboard:copy", { bubbles: true })
    );
    """
  end

  def api_dispatch_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={Corex.Clipboard.copy("clipboard-api-dispatch")} class="button ui-size-sm">
        Copy
      </.action>
    </div>
    <.clipboard
      id="clipboard-api-dispatch"
      class="clipboard"
      value="dispatch@example.com"
      trigger_aria_label="Copy"
      input_aria_label="Value"
    >
      <:copy>
        <.heroicon name="hero-clipboard" />
      </:copy>
      <:copied>
        <.heroicon name="hero-check" />
      </:copied>
    </.clipboard>
    """
  end

  def styling_semantic_code do
    ~S"""
    <.clipboard class="clipboard" value="default@example.com">
      <:copy><.heroicon name="hero-clipboard" /></:copy>
      <:copied><.heroicon name="hero-check" /></:copied>
    </.clipboard>
    <.clipboard class="clipboard ui-accent" value="accent@example.com">
      <:copy><.heroicon name="hero-clipboard" /></:copy>
      <:copied><.heroicon name="hero-check" /></:copied>
    </.clipboard>
    <.clipboard class="clipboard ui-brand" value="brand@example.com">
      <:copy><.heroicon name="hero-clipboard" /></:copy>
      <:copied><.heroicon name="hero-check" /></:copied>
    </.clipboard>
    """
  end

  def styling_semantic_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-6 items-start">
      <.clipboard
        id="clipboard-style-semantic-default"
        class="clipboard"
        value="default@example.com"
        input_aria_label="Default copied feedback"
        trigger_aria_label="Copy default"
      >
        <:copy><.heroicon name="hero-clipboard" /></:copy>
        <:copied><.heroicon name="hero-check" /></:copied>
      </.clipboard>
      <.clipboard
        id="clipboard-style-semantic-accent"
        class="clipboard ui-accent"
        value="accent@example.com"
        input_aria_label="Accent copied feedback"
        trigger_aria_label="Copy accent"
      >
        <:copy><.heroicon name="hero-clipboard" /></:copy>
        <:copied><.heroicon name="hero-check" /></:copied>
      </.clipboard>
      <.clipboard
        id="clipboard-style-semantic-brand"
        class="clipboard ui-brand"
        value="brand@example.com"
        input_aria_label="Brand copied feedback"
        trigger_aria_label="Copy brand"
      >
        <:copy><.heroicon name="hero-clipboard" /></:copy>
        <:copied><.heroicon name="hero-check" /></:copied>
      </.clipboard>
      <.clipboard
        id="clipboard-style-semantic-alert"
        class="clipboard ui-alert"
        value="alert@example.com"
        input_aria_label="Alert copied feedback"
        trigger_aria_label="Copy alert"
      >
        <:copy><.heroicon name="hero-clipboard" /></:copy>
        <:copied><.heroicon name="hero-check" /></:copied>
      </.clipboard>
      <.clipboard
        id="clipboard-style-semantic-info"
        class="clipboard ui-info"
        value="info@example.com"
        input_aria_label="Info copied feedback"
        trigger_aria_label="Copy info"
      >
        <:copy><.heroicon name="hero-clipboard" /></:copy>
        <:copied><.heroicon name="hero-check" /></:copied>
      </.clipboard>
      <.clipboard
        id="clipboard-style-semantic-success"
        class="clipboard ui-success"
        value="success@example.com"
        input_aria_label="Success copied feedback"
        trigger_aria_label="Copy success"
      >
        <:copy><.heroicon name="hero-clipboard" /></:copy>
        <:copied><.heroicon name="hero-check" /></:copied>
      </.clipboard>
    </div>
    """
  end

  def styling_variant_code do
    ~S"""
    <.clipboard class="clipboard" value="default@example.com">
      <:copy><.heroicon name="hero-clipboard" /></:copy>
      <:copied><.heroicon name="hero-check" /></:copied>
    </.clipboard>
    <.clipboard class="clipboard ui-solid" value="solid@example.com">
      <:copy><.heroicon name="hero-clipboard" /></:copy>
      <:copied><.heroicon name="hero-check" /></:copied>
    </.clipboard>

    """
  end

  def styling_variant_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-6 items-start">
      <.clipboard
        id="clipboard-style-variant-subtle"
        class="clipboard"
        value="default@example.com"
        input_aria_label="Subtle copied feedback"
        trigger_aria_label="Copy subtle"
      >
        <:copy><.heroicon name="hero-clipboard" /></:copy>
        <:copied><.heroicon name="hero-check" /></:copied>
      </.clipboard>
      <.clipboard
        id="clipboard-style-variant-solid"
        class="clipboard ui-solid"
        value="solid@example.com"
        input_aria_label="Solid copied feedback"
        trigger_aria_label="Copy solid"
      >
        <:copy><.heroicon name="hero-clipboard" /></:copy>
        <:copied><.heroicon name="hero-check" /></:copied>
      </.clipboard>
    </div>
    """
  end

  def styling_variant_matrix_code do
    for semantic <- DemoScales.styling_semantic_axis_steps("clipboard"),
        variant <- DemoScales.styling_variant_axis_steps("clipboard") do
      class = DemoScales.join_matrix_modifiers("clipboard", semantic.modifier, variant.modifier)

      ~s(<.clipboard class="#{class}" value="#{String.downcase(semantic.label)}@example.com">
      <:copy><.heroicon name="hero-clipboard" /></:copy>
      <:copied><.heroicon name="hero-check" /></:copied>
    </.clipboard>)
    end
    |> DemoScales.join_code()
  end

  def styling_variant_matrix_example(assigns) do
    assigns =
      assigns
      |> assign(:matrix_semantics, DemoScales.styling_semantic_axis_steps("clipboard"))
      |> assign(:matrix_variants, DemoScales.styling_variant_axis_steps("clipboard"))

    ~H"""
    <div class="w-full overflow-x-auto scrollbar scrollbar--sm">
      <div class="grid grid-cols-4 gap-space items-start min-w-max">
        <div :for={semantic <- @matrix_semantics} class="contents">
          <.clipboard
            :for={variant <- @matrix_variants}
            class={DemoScales.join_matrix_modifiers("clipboard", semantic.modifier, variant.modifier)}
            value={"#{String.downcase(semantic.label)}@example.com"}
            input_aria_label={"#{semantic.label} copied feedback"}
            trigger_aria_label={"Copy #{semantic.label}"}
          >
            <:copy><.heroicon name="hero-clipboard" /></:copy>
            <:copied><.heroicon name="hero-check" /></:copied>
          </.clipboard>
        </div>
      </div>
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <.clipboard class="clipboard ui-size-sm" value="small@example.com">
      <:copy><.heroicon name="hero-clipboard" /></:copy>
      <:copied><.heroicon name="hero-check" /></:copied>
    </.clipboard>
    <.clipboard class="clipboard" value="default@example.com">
      <:copy><.heroicon name="hero-clipboard" /></:copy>
      <:copied><.heroicon name="hero-check" /></:copied>
    </.clipboard>
    <.clipboard class="clipboard ui-size-lg" value="large@example.com">
      <:copy><.heroicon name="hero-clipboard" /></:copy>
      <:copied><.heroicon name="hero-check" /></:copied>
    </.clipboard>
    <.clipboard class="clipboard ui-size-xl" value="xlarge@example.com">
      <:copy><.heroicon name="hero-clipboard" /></:copy>
      <:copied><.heroicon name="hero-check" /></:copied>
    </.clipboard>
    """
  end

  def styling_size_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-6 items-start">
      <.clipboard
        id="clipboard-style-sm"
        class="clipboard ui-size-sm"
        value="small@example.com"
        input_aria_label="Value to copy (sm)"
      >
        <:copy><.heroicon name="hero-clipboard" /></:copy>
        <:copied><.heroicon name="hero-check" /></:copied>
      </.clipboard>
      <.clipboard
        id="clipboard-style-md"
        class="clipboard"
        value="default@example.com"
        input_aria_label="Value to copy (md)"
      >
        <:copy><.heroicon name="hero-clipboard" /></:copy>
        <:copied><.heroicon name="hero-check" /></:copied>
      </.clipboard>
      <.clipboard
        id="clipboard-style-lg"
        class="clipboard ui-size-lg"
        value="large@example.com"
        input_aria_label="Value to copy (lg)"
      >
        <:copy><.heroicon name="hero-clipboard" /></:copy>
        <:copied><.heroicon name="hero-check" /></:copied>
      </.clipboard>
      <.clipboard
        id="clipboard-style-xl"
        class="clipboard ui-size-xl"
        value="xlarge@example.com"
        input_aria_label="Value to copy (xl)"
      >
        <:copy><.heroicon name="hero-clipboard" /></:copy>
        <:copied><.heroicon name="hero-check" /></:copied>
      </.clipboard>
    </div>
    """
  end

  def styling_rounded_code do
    ~S"""
    <.clipboard class="clipboard ui-rounded-none" value="none@example.com">
      <:copy><.heroicon name="hero-clipboard" /></:copy>
      <:copied><.heroicon name="hero-check" /></:copied>
    </.clipboard>
    <.clipboard class="clipboard ui-rounded-sm" value="sm@example.com">
      <:copy><.heroicon name="hero-clipboard" /></:copy>
      <:copied><.heroicon name="hero-check" /></:copied>
    </.clipboard>
    <.clipboard class="clipboard ui-rounded-md" value="md@example.com">
      <:copy><.heroicon name="hero-clipboard" /></:copy>
      <:copied><.heroicon name="hero-check" /></:copied>
    </.clipboard>
    <.clipboard class="clipboard ui-rounded-lg" value="lg@example.com">
      <:copy><.heroicon name="hero-clipboard" /></:copy>
      <:copied><.heroicon name="hero-check" /></:copied>
    </.clipboard>
    <.clipboard class="clipboard ui-rounded-xl" value="xl@example.com">
      <:copy><.heroicon name="hero-clipboard" /></:copy>
      <:copied><.heroicon name="hero-check" /></:copied>
    </.clipboard>
    <.clipboard class="clipboard ui-rounded-full" value="full@example.com">
      <:copy><.heroicon name="hero-clipboard" /></:copy>
      <:copied><.heroicon name="hero-check" /></:copied>
    </.clipboard>
    """
  end

  def styling_rounded_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-6 items-start">
      <.clipboard
        id="clipboard-style-rounded-none"
        class="clipboard ui-rounded-none"
        value="none@example.com"
        input_aria_label="Value to copy (rounded none)"
        trigger_aria_label="Copy rounded none"
      >
        <:copy><.heroicon name="hero-clipboard" /></:copy>
        <:copied><.heroicon name="hero-check" /></:copied>
      </.clipboard>
      <.clipboard
        id="clipboard-style-rounded-sm"
        class="clipboard ui-rounded-sm"
        value="sm@example.com"
        input_aria_label="Value to copy (rounded sm)"
        trigger_aria_label="Copy rounded sm"
      >
        <:copy><.heroicon name="hero-clipboard" /></:copy>
        <:copied><.heroicon name="hero-check" /></:copied>
      </.clipboard>
      <.clipboard
        id="clipboard-style-rounded-md"
        class="clipboard ui-rounded-md"
        value="md@example.com"
        input_aria_label="Value to copy (rounded md)"
        trigger_aria_label="Copy rounded md"
      >
        <:copy><.heroicon name="hero-clipboard" /></:copy>
        <:copied><.heroicon name="hero-check" /></:copied>
      </.clipboard>
      <.clipboard
        id="clipboard-style-rounded-lg"
        class="clipboard ui-rounded-lg"
        value="lg@example.com"
        input_aria_label="Value to copy (rounded lg)"
        trigger_aria_label="Copy rounded lg"
      >
        <:copy><.heroicon name="hero-clipboard" /></:copy>
        <:copied><.heroicon name="hero-check" /></:copied>
      </.clipboard>
      <.clipboard
        id="clipboard-style-rounded-xl"
        class="clipboard ui-rounded-xl"
        value="xl@example.com"
        input_aria_label="Value to copy (rounded xl)"
        trigger_aria_label="Copy rounded xl"
      >
        <:copy><.heroicon name="hero-clipboard" /></:copy>
        <:copied><.heroicon name="hero-check" /></:copied>
      </.clipboard>
      <.clipboard
        id="clipboard-style-rounded-full"
        class="clipboard ui-rounded-full"
        value="full@example.com"
        input_aria_label="Value to copy (rounded full)"
        trigger_aria_label="Copy rounded full"
      >
        <:copy><.heroicon name="hero-clipboard" /></:copy>
        <:copied><.heroicon name="hero-check" /></:copied>
      </.clipboard>
    </div>
    """
  end

  defp styling_slots_code do
    """
      <:copy><.heroicon name="hero-clipboard" /></:copy>
      <:copied><.heroicon name="hero-check" /></:copied>
    """
  end

  def styling_width_code do
    slots = styling_slots_code()
    value = DemoScales.block_demo_value()

    DemoScales.width_layout_variants("clipboard")
    |> Enum.map(fn %{modifier: modifier} ->
      class = DemoScales.join_modifiers("clipboard", modifier)

      """
      <.clipboard class="#{class}" value="#{value}">
      #{slots}
      </.clipboard>
      """
    end)
    |> DemoScales.join_code()
  end

  def styling_max_width_code do
    slots = styling_slots_code()
    value = DemoScales.block_demo_value()

    DemoScales.max_width_variants("clipboard")
    |> Enum.map(fn %{modifier: modifier} ->
      class = DemoScales.join_block_modifiers("clipboard", modifier)

      """
      <.clipboard class="#{class}" value="#{value}">
      #{slots}
      </.clipboard>
      """
    end)
    |> DemoScales.join_code()
  end

  def styling_width_example(assigns) do
    assigns = assign(assigns, :width_variants, DemoScales.width_layout_variants("clipboard"))

    ~H"""
    <div class={DemoScales.preview_scroll_class()}>
      <div :for={variant <- @width_variants} class="flex flex-col gap-2">
        <p class="typo ui-size-sm font-medium">{variant.label}</p>
        <.clipboard
          id={"clipboard-style-width-#{variant.id}"}
          class={DemoScales.join_modifiers("clipboard", variant.modifier)}
          value={DemoScales.block_demo_value()}
          input_aria_label="Value to copy"
          trigger_aria_label="Copy"
        >
          <:copy><.heroicon name="hero-clipboard" /></:copy>
          <:copied><.heroicon name="hero-check" /></:copied>
        </.clipboard>
      </div>
    </div>
    """
  end

  def styling_max_width_example(assigns) do
    assigns = assign(assigns, :max_width_variants, DemoScales.max_width_variants("clipboard"))

    ~H"""
    <div class={DemoScales.preview_scroll_class()}>
      <div :for={variant <- @max_width_variants} class="flex flex-col gap-2">
        <p class="typo ui-size-sm font-medium">{variant.label}</p>
        <.clipboard
          id={"clipboard-style-max-#{variant.id}"}
          class={DemoScales.join_block_modifiers("clipboard", variant.modifier)}
          value={DemoScales.block_demo_value()}
          input_aria_label="Value to copy"
          trigger_aria_label="Copy"
        >
          <:copy><.heroicon name="hero-clipboard" /></:copy>
          <:copied><.heroicon name="hero-check" /></:copied>
        </.clipboard>
      </div>
    </div>
    """
  end
end
