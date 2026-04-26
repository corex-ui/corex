defmodule E2eWeb.Demos.ClipboardDemo do
  use E2eWeb, :html

  def minimal_code do
    ~S"""
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
    <.action phx-click={Corex.Clipboard.copy("clipboard-events")} class="button button--sm">
      Copy
    </.action>

    <.clipboard
      id="clipboard-events"
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
    ~S"""
    def handle_event("clipboard_copied", %{"value" => value, "id" => id}, socket) do
      {:noreply, stream_insert(socket, :logs, %{id: id, value: inspect(value), time: DateTime.utc_now()}, at: 0)}
    end
    """
  end

  def api_client_binding_code do
    ~S"""
    <div class="layout__row">
      <.action phx-click={Corex.Clipboard.set_value("clipboard-api", "Hello, World!")} class="button button--sm">
        Set to "Hello, World!"
      </.action>
      <.action phx-click={Corex.Clipboard.set_value("clipboard-api", "info@netoum.com")} class="button button--sm">
        Set to "info@netoum.com"
      </.action>
      <.action phx-click={Corex.Clipboard.copy("clipboard-api")} class="button button--sm">
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
    <div class="layout__row">
      <.action
        phx-click={Corex.Clipboard.set_value("clipboard-api", "Hello, World!")}
        class="button button--sm"
      >
        Set to "Hello, World!"
      </.action>
      <.action
        phx-click={Corex.Clipboard.set_value("clipboard-api", "info@netoum.com")}
        class="button button--sm"
      >
        Set to "info@netoum.com"
      </.action>
      <.action phx-click={Corex.Clipboard.copy("clipboard-api")} class="button button--sm">
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
    <.action phx-click="clipboard_api_server_copy" class="button button--sm">Push copy</.action>
    <.action phx-click="clipboard_api_server_set" class="button button--sm">Push set value</.action>
    <.clipboard id="clipboard-api-server" class="clipboard" value="server-push@example.com">
      <:copy><.heroicon name="hero-clipboard" /></:copy>
      <:copied><.heroicon name="hero-check" /></:copied>
    </.clipboard>
    """
  end

  def api_dispatch_heex do
    ~S"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={Corex.Clipboard.copy("clipboard-api-dispatch")} class="button button--sm">
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
      <.action phx-click={Corex.Clipboard.copy("clipboard-api-dispatch")} class="button button--sm">
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

  def styling_size_code do
    ~S"""
    <.clipboard class="clipboard clipboard--sm" value="small@example.com">
      <:copy><.heroicon name="hero-clipboard" /></:copy>
      <:copied><.heroicon name="hero-check" /></:copied>
    </.clipboard>
    <.clipboard class="clipboard" value="default@example.com">
      <:copy><.heroicon name="hero-clipboard" /></:copy>
      <:copied><.heroicon name="hero-check" /></:copied>
    </.clipboard>
    <.clipboard class="clipboard clipboard--lg" value="large@example.com">
      <:copy><.heroicon name="hero-clipboard" /></:copy>
      <:copied><.heroicon name="hero-check" /></:copied>
    </.clipboard>
    <.clipboard class="clipboard clipboard--xl" value="xlarge@example.com">
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
        class="clipboard clipboard--sm"
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
        class="clipboard clipboard--lg"
        value="large@example.com"
        input_aria_label="Value to copy (lg)"
      >
        <:copy><.heroicon name="hero-clipboard" /></:copy>
        <:copied><.heroicon name="hero-check" /></:copied>
      </.clipboard>
      <.clipboard
        id="clipboard-style-xl"
        class="clipboard clipboard--lg"
        value="xlarge@example.com"
        input_aria_label="Value to copy (xl)"
      >
        <:copy><.heroicon name="hero-clipboard" /></:copy>
        <:copied><.heroicon name="hero-check" /></:copied>
      </.clipboard>
    </div>
    """
  end
end
