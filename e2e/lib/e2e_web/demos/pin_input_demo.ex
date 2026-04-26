defmodule E2eWeb.Demos.PinInputDemo do
  use E2eWeb, :html

  def minimal_code do
    ~S"""
    <.pin_input id="pin-input-anatomy-minimal" count={4} class="pin-input">
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def minimal_example(assigns) do
    ~H"""
    <.pin_input id="pin-input-anatomy-minimal" count={4} class="pin-input">
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def with_default_code do
    ~S"""
    <.pin_input
      id="pin-input-anatomy-default"
      count={4}
      class="pin-input"
      value={["1", "2", "3", "4"]}
    >
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def with_default_example(assigns) do
    ~H"""
    <.pin_input
      id="pin-input-anatomy-default"
      count={4}
      class="pin-input"
      value={["1", "2", "3", "4"]}
    >
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def events_server_heex do
    ~S"""
    <.pin_input
      id="pin-input-events-server"
      count={4}
      class="pin-input"
      on_value_change="pin_input_changed"
    >
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def events_server_elixir do
    ~S"""
    def handle_event("pin_input_changed", %{"id" => id, "value" => value}, socket) do
      log = %{time: "12:00:00", source: "server", value: inspect(value)}
      {:noreply, stream_insert(socket, :server_logs, log, at: 0)}
    end
    """
  end

  def events_client_heex do
    ~S"""
    <.pin_input
      id="pin-input-events-client"
      count={4}
      class="pin-input"
      on_value_change_client="pin-input-changed"
    >
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def events_client_js do
    ~S"""
    const el = document.getElementById("pin-input-events-client");
    el?.addEventListener("pin-input-changed", (event) => console.log(event.detail));
    """
  end

  def events_client_ts do
    ~S"""
    const el = document.getElementById("pin-input-events-client");
    el?.addEventListener("pin-input-changed", (event: Event) =>
      console.log((event as CustomEvent<unknown>).detail)
    );
    """
  end

  def form_code do
    ~S"""
    <form action={~p"/pin-input/form"} method="post" id="pin-input-plain-form">
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.pin_input
        name="pin_input_form[pin]"
        id="pin-input-form-pin"
        count={4}
        class="pin-input"
      >
        <:label>Code</:label>
      </.pin_input>
      <.action type="submit" id="pin-input-form-submit" class="button button--accent">
        Submit
      </.action>
    </form>
    """
  end

  def api_set_value_client_binding_code do
    ~S"""
    <.action phx-click={Corex.PinInput.set_value("pin-api-set-client", ["1", "2", "3", "4"])} class="button button--sm">
      Fill
    </.action>
    <.pin_input id="pin-api-set-client" count={4} class="pin-input">
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def api_set_value_server_heex do
    ~S"""
    <.action phx-click="api_pin_set_value_server" class="button button--sm">
      Fill from server
    </.action>
    <.pin_input id="pin-api-set-server" count={4} class="pin-input">
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def api_set_value_server_elixir do
    ~S"""
    def handle_event("api_pin_set_value_server", _params, socket) do
      {:noreply,
       Corex.PinInput.set_value(socket, "pin-api-set-server", ["1", "2", "3", "4"])}
    end
    """
  end

  def api_set_value_js_heex do
    ~S"""
    <.action
      phx-click={JS.dispatch("corex:pin-input:set-value",
        to: "#pin-api-set-js",
        detail: %{value: ["1", "2", "3", "4"]},
        bubbles: false
      )}
      class="button button--sm"
    >
      Fill via dispatch
    </.action>
    <.pin_input id="pin-api-set-js" count={4} class="pin-input">
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def api_set_value_js_js do
    ~S"""
    const el = document.getElementById("pin-api-set-js");
    el?.dispatchEvent(
      new CustomEvent("corex:pin-input:set-value", {
        bubbles: false,
        detail: { value: ["1", "2", "3", "4"] },
      })
    );
    """
  end

  def api_set_value_js_ts do
    ~S"""
    const el = document.getElementById("pin-api-set-js");
    el?.dispatchEvent(
      new CustomEvent("corex:pin-input:set-value", {
        bubbles: false,
        detail: { value: ["1", "2", "3", "4"] },
      })
    );
    """
  end

  def api_set_value_client_js_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action
        phx-click={
          JS.dispatch("corex:pin-input:set-value",
            to: "##{@id}",
            detail: %{value: ["1", "2", "3", "4"]},
            bubbles: false
          )
        }
        class="button button--sm"
      >
        Fill via dispatch
      </.action>
    </div>
    <.pin_input id={@id} count={4} class="pin-input">
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def api_set_value_server_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click="api_pin_set_value_server" class="button button--sm">
        Fill from server
      </.action>
    </div>
    <.pin_input id={@id} count={4} class="pin-input">
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def api_value_client_binding_code do
    ~S"""
    <.action phx-click={Corex.PinInput.value("pin-api-val-client")} class="button button--sm">
      Read value
    </.action>
    <.pin_input id="pin-api-val-client" count={4} class="pin-input" value={["1", "2", "", ""]}>
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def api_value_server_heex do
    ~S"""
    <.action phx-click="api_pin_value_server" class="button button--sm">
      Read value (server)
    </.action>
    <.pin_input id="pin-api-val-server" count={4} class="pin-input" value={["5", "6", "7", "8"]}>
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def api_value_server_elixir do
    ~S"""
    def handle_event("api_pin_value_server", _params, socket) do
      {:noreply, Corex.PinInput.value(socket, "pin-api-val-server")}
    end
    """
  end

  def api_value_client_js_heex do
    ~S"""
    <.action
      phx-click={JS.dispatch("corex:pin-input:value", to: "#pin-api-val-js", detail: %{}, bubbles: false)}
      class="button button--sm"
    >
      Read via dispatch
    </.action>
    <.pin_input id="pin-api-val-js" count={4} class="pin-input" value={["1", "0", "0", "0"]}>
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def api_value_client_js_js do
    ~S"""
    const el = document.getElementById("pin-api-val-js");
    el?.dispatchEvent(new CustomEvent("corex:pin-input:value", { bubbles: false, detail: {} }));
    """
  end

  def api_value_client_js_ts do
    ~S"""
    const el = document.getElementById("pin-api-val-js");
    el?.dispatchEvent(new CustomEvent("corex:pin-input:value", { bubbles: false, detail: {} }));
    """
  end

  def api_value_client_js_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action
        phx-click={JS.dispatch("corex:pin-input:value", to: "##{@id}", detail: %{}, bubbles: false)}
        class="button button--sm"
      >
        Read via dispatch
      </.action>
    </div>
    <.pin_input id={@id} count={4} class="pin-input" value={["1", "0", "0", "0"]}>
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def api_clear_client_binding_code do
    ~S"""
    <.action phx-click={Corex.PinInput.clear("pin-api-clear-client")} class="button button--sm">
      Clear
    </.action>
    <.pin_input id="pin-api-clear-client" count={4} class="pin-input" value={["9", "9", "9", "9"]}>
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def api_clear_server_heex do
    ~S"""
    <.action phx-click="api_pin_clear_server" class="button button--sm">
      Clear from server
    </.action>
    <.pin_input id="pin-api-clear-server" count={4} class="pin-input" value={["1", "1", "1", "1"]}>
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def api_clear_server_elixir do
    ~S"""
    def handle_event("api_pin_clear_server", _params, socket) do
      {:noreply, Corex.PinInput.clear(socket, "pin-api-clear-server")}
    end
    """
  end

  def api_set_value_client_binding_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action
        phx-click={Corex.PinInput.set_value(@id, ["1", "2", "3", "4"])}
        class="button button--sm"
      >
        Fill
      </.action>
    </div>
    <.pin_input id={@id} count={4} class="pin-input">
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def api_value_client_binding_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={Corex.PinInput.value(@id)} class="button button--sm">Value</.action>
      <.action phx-click={Corex.PinInput.value(@id, respond_to: :client)} class="button button--sm">
        Value (client only)
      </.action>
    </div>
    <.pin_input id={@id} count={4} class="pin-input" value={["1", "2", "", ""]}>
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def api_clear_client_binding_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={Corex.PinInput.clear(@id)} class="button button--sm">Clear</.action>
    </div>
    <.pin_input id={@id} count={4} class="pin-input" value={["9", "9", "9", "9"]}>
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def api_value_server_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click="api_pin_value_server" class="button button--sm">Read from server</.action>
    </div>
    <.pin_input id={@id} count={4} class="pin-input" value={["5", "6", "7", "8"]}>
      <:label>Code</:label>
    </.pin_input>
    """
  end

  def api_clear_server_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click="api_pin_clear_server" class="button button--sm">Clear from server</.action>
    </div>
    <.pin_input id={@id} count={4} class="pin-input" value={["1", "1", "1", "1"]}>
      <:label>Code</:label>
    </.pin_input>
    """
  end
end
