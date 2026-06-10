defmodule E2eWeb.Demos.NumberInputDemo do
  use E2eWeb, :html

  alias E2eWeb.Demos.StylingAxes

  def styling_axis_values(axis), do: StylingAxes.styling_axis_values(axis)

  def minimal_code do
    ~S"""
    <.number_input
      
      min={0.0}
      max={100.0}
      step={5.0}
      value="10"
    >
      <:label>Amount</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
    </.number_input>
    """
  end

  def anatomy_minimal_quantity_code do
    ~S"""
    <.number_input >
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
    </.number_input>
    """
  end

  def minimal_example(assigns) do
    ~H"""
    <.number_input id="number-input-anatomy-minimal">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
    </.number_input>
    """
  end

  def min_max_default_code do
    ~S"""
    <.number_input
      
      min={0.0}
      max={100.0}
      step={5.0}
      value="10"
    >
      <:label>Amount</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
    </.number_input>
    """
  end

  def min_max_default_example(assigns) do
    ~H"""
    <.number_input
      id="number-input-anatomy-bounds"
      min={0.0}
      max={100.0}
      step={5.0}
      value="10"
    >
      <:label>Amount</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
    </.number_input>
    """
  end

  def with_triggers_code, do: minimal_code()
  def with_triggers_example(assigns), do: minimal_example(assigns)

  defp styling_triggers_code do
    """
      <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
    """
  end

  def styling_semantic_code do
    triggers = styling_triggers_code()

    """
    <.number_input  value="1">
      <:label>Default</:label>
    #{triggers}
    </.number_input>
    <.number_input class="number-input number-input--semantic-accent" value="1">
      <:label>Accent</:label>
    #{triggers}
    </.number_input>
    <.number_input class="number-input number-input--semantic-brand" value="1">
      <:label>Brand</:label>
    #{triggers}
    </.number_input>
    <.number_input class="number-input number-input--semantic-alert" value="1">
      <:label>Alert</:label>
    #{triggers}
    </.number_input>
    <.number_input class="number-input number-input--semantic-info" value="1">
      <:label>Info</:label>
    #{triggers}
    </.number_input>
    <.number_input class="number-input number-input--semantic-success" value="1">
      <:label>Success</:label>
    #{triggers}
    </.number_input>
    """
  end

  def styling_semantic_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-6 items-start">
      <.number_input id="number-input-style-color-default" value="1">
        <:label>Default</:label>
        <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
        <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
      </.number_input>
      <.number_input
        id="number-input-style-color-accent"
        class="number-input number-input--semantic-accent"
        value="1"
      >
        <:label>Accent</:label>
        <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
        <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
      </.number_input>
      <.number_input
        id="number-input-style-color-brand"
        class="number-input number-input--semantic-brand"
        value="1"
      >
        <:label>Brand</:label>
        <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
        <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
      </.number_input>
      <.number_input
        id="number-input-style-color-alert"
        class="number-input number-input--semantic-alert"
        value="1"
      >
        <:label>Alert</:label>
        <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
        <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
      </.number_input>
      <.number_input
        id="number-input-style-color-info"
        class="number-input number-input--semantic-info"
        value="1"
      >
        <:label>Info</:label>
        <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
        <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
      </.number_input>
      <.number_input
        id="number-input-style-color-success"
        class="number-input number-input--semantic-success"
        value="1"
      >
        <:label>Success</:label>
        <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
        <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
      </.number_input>
    </div>
    """
  end

  def styling_size_code do
    triggers = styling_triggers_code()

    """
    <.number_input class="number-input number-input--size-sm" value="1">
      <:label>SM</:label>
    #{triggers}
    </.number_input>
    <.number_input class="number-input number-input--size-md" value="1">
      <:label>MD</:label>
    #{triggers}
    </.number_input>
    <.number_input class="number-input number-input--size-lg" value="1">
      <:label>LG</:label>
    #{triggers}
    </.number_input>
    <.number_input class="number-input number-input--size-xl" value="1">
      <:label>XL</:label>
    #{triggers}
    </.number_input>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-col gap-4 max-w-md">
      <.number_input id="number-input-style-sm" class="number-input number-input--size-sm w-full" value="1">
        <:label>SM</:label>
        <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
        <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
      </.number_input>
      <.number_input id="number-input-style-md" class="number-input number-input--size-md w-full" value="1">
        <:label>MD</:label>
        <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
        <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
      </.number_input>
      <.number_input id="number-input-style-lg" class="number-input number-input--size-lg w-full" value="1">
        <:label>LG</:label>
        <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
        <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
      </.number_input>
      <.number_input id="number-input-style-xl" class="number-input number-input--size-xl w-full" value="1">
        <:label>XL</:label>
        <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
        <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
      </.number_input>
    </div>
    """
  end

  def styling_max_width_code do
    triggers = styling_triggers_code()

    """
    <.number_input class="number-input number-input--max-w-2xs" value="1">
      <:label>2xs</:label>
    #{triggers}
    </.number_input>
    <.number_input class="number-input number-input--max-w-md" value="1">
      <:label>MD</:label>
    #{triggers}
    </.number_input>
    <.number_input class="number-input number-input--max-w-xl" value="1">
      <:label>XL</:label>
    #{triggers}
    </.number_input>
    <.number_input class="number-input number-input--max-w-2xl" value="1">
      <:label>2XL</:label>
    #{triggers}
    </.number_input>
    """
  end

  def styling_max_width_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-col gap-4 items-stretch w-full">
      <.number_input
        id="number-input-style-max-2xs"
        class="number-input number-input--max-w-2xs w-full"
        value="1"
      >
        <:label>2xs</:label>
        <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
        <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
      </.number_input>
      <.number_input
        id="number-input-style-max-md"
        class="number-input number-input--max-w-md w-full"
        value="1"
      >
        <:label>MD</:label>
        <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
        <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
      </.number_input>
      <.number_input
        id="number-input-style-max-xl"
        class="number-input number-input--max-w-xl w-full"
        value="1"
      >
        <:label>XL</:label>
        <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
        <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
      </.number_input>
      <.number_input
        id="number-input-style-max-2xl"
        class="number-input number-input--max-w-2xl w-full"
        value="1"
      >
        <:label>2XL</:label>
        <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
        <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
      </.number_input>
    </div>
    """
  end

  def api_binding_heex do
    ~S"""
    <.number_input
      
      on_value_change="number_input_api_binding"
    >
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_binding_elixir do
    ~S"""
    def handle_event("number_input_api_binding", %{"id" => id, "value" => value} = payload, socket) do
      n = payload["valueAsNumber"]
      {:noreply, socket}
    end
    """
  end

  def api_binding_example(assigns) do
    ~H"""
    <.number_input
      id="number-input-api-binding"
      on_value_change="number_input_api_binding"
    >
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_client_heex do
    ~S"""
    <.number_input
      
      on_value_change_client="number-input-api-client-changed"
    >
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_client_js do
    ~S"""
    const el = document.getElementById("number-input-api-client");
    el?.addEventListener("number-input-api-client-changed", (event) => {
      console.log(event.detail);
    });
    """
  end

  def api_client_ts do
    ~S"""
    const el = document.getElementById("number-input-api-client");
    el?.addEventListener("number-input-api-client-changed", (event: Event) => {
      console.log((event as CustomEvent<{ value?: string; valueAsNumber?: number }>).detail);
    });
    """
  end

  def api_client_example(assigns) do
    ~H"""
    <.number_input
      id="number-input-api-client"
      on_value_change_client="number-input-api-client-changed"
    >
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_server_note_heex do
    ~S"""
    <.number_input  value="1">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_server_note_elixir do
    ~S"""
    # Initial value: uncontrolled value sets data-default-value for Zag defaultValue.
    """
  end

  def api_server_note_example(assigns) do
    ~H"""
    <.number_input id="number-input-api-server-note" value="1">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_overview_code, do: api_binding_heex()
  def api_overview_example(assigns), do: api_binding_example(assigns)

  def api_set_value_client_binding_code do
    ~S"""
    <.action phx-click={Corex.NumberInput.set_value("number-input-api-set-client", 42)} size="sm">
      Set 42
    </.action>
    <.number_input  value="1">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_set_value_server_heex do
    ~S"""
    <.action phx-click="api_number_set_value_server" size="sm">
      Set 99
    </.action>
    <.number_input  value="1">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_set_value_server_elixir do
    ~S"""
    def handle_event("api_number_set_value_server", _params, socket) do
      {:noreply, Corex.NumberInput.set_value(socket, "number-input-api-set-server", 99)}
    end
    """
  end

  def api_set_value_js_heex do
    ~S"""
    <.action
      phx-click={JS.dispatch("corex:number-input:set-value",
        to: "#number-input-api-set-js",
        detail: %{value: 7},
        bubbles: false
      )}
      size="sm"
    >
      Set 7
    </.action>
    <.number_input  value="1">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_set_value_js_js do
    ~S"""
    const el = document.getElementById("number-input-api-set-js");
    el?.dispatchEvent(
      new CustomEvent("corex:number-input:set-value", {
        bubbles: false,
        detail: { value: 7 },
      })
    );
    """
  end

  def api_set_value_js_ts do
    ~S"""
    const el: HTMLElement | null = document.getElementById("number-input-api-set-js");
    el?.dispatchEvent(
      new CustomEvent<{ value: number }>("corex:number-input:set-value", {
        bubbles: false,
        detail: { value: 7 },
      })
    );
    """
  end

  def api_set_value_client_binding_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={Corex.NumberInput.set_value(@id, 42)} size="sm">
        Set 42
      </.action>
    </div>
    <.number_input id={@id} value="1">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_set_value_server_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click="api_number_set_value_server" size="sm">
        Set 99
      </.action>
    </div>
    <.number_input id={@id} value="1">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_set_value_client_js_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action
        phx-click={
          JS.dispatch("corex:number-input:set-value",
            to: "##{@id}",
            detail: %{value: 7},
            bubbles: false
          )
        }
        size="sm"
      >
        Set 7
      </.action>
    </div>
    <.number_input id={@id} value="1">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_clear_client_binding_code do
    ~S"""
    <.action phx-click={Corex.NumberInput.clear_value("number-input-api-clear-client")} size="sm">
      Clear
    </.action>
    <.number_input  value="10">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_clear_server_heex do
    ~S"""
    <.action phx-click="api_number_clear_server" size="sm">
      Clear
    </.action>
    <.number_input  value="10">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_clear_server_elixir do
    ~S"""
    def handle_event("api_number_clear_server", _params, socket) do
      {:noreply, Corex.NumberInput.clear_value(socket, "number-input-api-clear-server")}
    end
    """
  end

  def api_clear_client_binding_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={Corex.NumberInput.clear_value(@id)} size="sm">
        Clear
      </.action>
    </div>
    <.number_input id={@id} value="10">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_clear_server_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click="api_number_clear_server" size="sm">
        Clear
      </.action>
    </div>
    <.number_input id={@id} value="10">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_commands_client_binding_code do
    ~S"""
    <.action phx-click={Corex.NumberInput.increment("number-input-api-cmd-client")} size="sm">+</.action>
    <.action phx-click={Corex.NumberInput.decrement("number-input-api-cmd-client")} size="sm">−</.action>
    <.action phx-click={Corex.NumberInput.set_to_min("number-input-api-cmd-client")} size="sm">Min</.action>
    <.action phx-click={Corex.NumberInput.set_to_max("number-input-api-cmd-client")} size="sm">Max</.action>
    <.action phx-click={Corex.NumberInput.focus("number-input-api-cmd-client")} size="sm">Focus</.action>
    <.number_input  min={0.0} max={10.0} step={1.0} value="5">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_commands_client_binding_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={Corex.NumberInput.increment(@id)} size="sm">+</.action>
      <.action phx-click={Corex.NumberInput.decrement(@id)} size="sm">−</.action>
      <.action phx-click={Corex.NumberInput.set_to_min(@id)} size="sm">Min</.action>
      <.action phx-click={Corex.NumberInput.set_to_max(@id)} size="sm">Max</.action>
      <.action phx-click={Corex.NumberInput.focus(@id)} size="sm">Focus</.action>
    </div>
    <.number_input
      id={@id}
      min={0.0}
      max={10.0}
      step={1.0}
      value="5"
    >
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_state_client_binding_code do
    ~S"""
    <.action phx-click={Corex.NumberInput.state("number-input-api-state-client")} size="sm">
      Read state
    </.action>
    <.number_input  value="3">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_state_server_heex do
    ~S"""
    <.action phx-click="api_number_state_server" size="sm">
      Read state
    </.action>
    <.number_input  value="8">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_state_server_elixir do
    ~S"""
    def handle_event("api_number_state_server", _params, socket) do
      {:noreply, Corex.NumberInput.state(socket, "number-input-api-state-server")}
    end
    """
  end

  def api_state_client_js_heex do
    ~S"""
    <.action
      phx-click={JS.dispatch("corex:number-input:state", to: "#number-input-api-state-js", detail: %{}, bubbles: false)}
      size="sm"
    >
      Read state
    </.action>
    <.number_input  value="4">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_state_client_js_js do
    ~S"""
    const el = document.getElementById("number-input-api-state-js");
    el?.dispatchEvent(new CustomEvent("corex:number-input:state", { bubbles: false, detail: {} }));
    """
  end

  def api_state_client_js_ts do
    ~S"""
    const el = document.getElementById("number-input-api-state-js");
    el?.addEventListener("number-input-state", (event: Event) => {
      const d = (event as CustomEvent<{
        focused?: boolean;
        invalid?: boolean;
        empty?: boolean;
        value?: string;
        valueAsNumber?: number;
      }>).detail;
      console.log(d);
    });
    el?.dispatchEvent(new CustomEvent("corex:number-input:state", { bubbles: false, detail: {} }));
    """
  end

  def api_state_client_binding_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={Corex.NumberInput.state(@id)} size="sm">
        Read state
      </.action>
    </div>
    <.number_input id={@id} value="3">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_state_server_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click="api_number_state_server" size="sm">
        Read state
      </.action>
    </div>
    <.number_input id={@id} value="8">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_state_client_js_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action
        phx-click={
          JS.dispatch("corex:number-input:state", to: "##{@id}", detail: %{}, bubbles: false)
        }
        size="sm"
      >
        Read state
      </.action>
    </div>
    <.number_input id={@id} value="4">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
    </.number_input>
    """
  end

  def events_server_heex do
    ~S"""
    <.number_input
      
      on_value_change="number_input_changed"
    >
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
    </.number_input>
    """
  end

  def events_server_elixir do
    E2eWeb.Demos.DocExamples.event_handler_snippet(
      "number_input_changed",
      ~S|%{"id" => id, "value" => value} = params|
    )
  end

  def events_client_heex do
    ~S"""
    <.number_input
      
      on_value_change_client="number-input-changed"
    >
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
    </.number_input>
    """
  end

  def events_client_js do
    ~S"""
    const el = document.getElementById("number-input-events-client");
    el?.addEventListener("number-input-changed", (event) => console.log(event.detail));
    """
  end

  def events_client_ts do
    ~S"""
    const el = document.getElementById("number-input-events-client");
    el?.addEventListener("number-input-changed", (event: Event) =>
      console.log((event as CustomEvent<unknown>).detail)
    );
    """
  end

  def form_code, do: form_doc_controller_changeset_heex()

  def form_ecto do
    ~S"""
    defmodule MyApp.Forms.NumberInputForm do
      use Ecto.Schema
      import Ecto.Changeset

      embedded_schema do
        field :value, :float
      end

      def changeset(form, attrs \\ %{}) do
        form
        |> cast(attrs, [:value])
        |> validate_required([:value])
      end

      def changeset_validate(form, attrs \\ %{}) do
        form
        |> cast(attrs, [:value])
        |> validate_required([:value])
        |> validate_number(:value, greater_than_or_equal_to: 1.0, less_than_or_equal_to: 9999.0)
      end
    end
    """
  end

  def form_changeset_heex, do: form_doc_controller_changeset_heex()
  def form_changeset_elixir, do: form_doc_controller_changeset_elixir()
  def form_validate_heex, do: form_doc_controller_validate_heex()
  def form_validate_elixir, do: form_doc_controller_validate_elixir()
  def form_native_heex, do: form_doc_native_heex()

  def form_doc_controller_phoenix_heex do
    ~S"""
    <.form
      for={@form}
      action={~p"/number-input/form"}
      method="post"
    >
      <.number_input field={@form[:value]} >
        <:label>Value</:label>
        <:decrement_trigger>
          <.heroicon name="hero-chevron-down" />
        </:decrement_trigger>
        <:increment_trigger>
          <.heroicon name="hero-chevron-up" />
        </:increment_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.number_input>
      <.action type="submit" semantic="accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_controller_phoenix_elixir do
    ~S"""
    def number_input_form_page(conn, _params) do
      phoenix_form =
        Phoenix.Component.to_form(%{"value" => "1234"}, as: :number_input_phoenix, id: "number-input-form-phoenix")

      render(conn, :number_input_form_page, phoenix_form: phoenix_form)
    end

    def number_input_form_submit(conn, params) do
      if is_map(params["number_input_phoenix"]) do
        value = params["number_input_phoenix"]["value"] || ""

        conn
        |> put_flash(:info, "Submitted: value=#{inspect(value)}")
        |> redirect(to: ~p"/number-input/form#number-input-form-phoenix")
      end
    end
    """
  end

  def form_doc_live_phoenix_heex do
    ~S"""
    <.form for={@form} phx-submit="save_phoenix">
      <.number_input field={@form[:value]} >
        <:label>Value</:label>
        <:decrement_trigger>
          <.heroicon name="hero-chevron-down" />
        </:decrement_trigger>
        <:increment_trigger>
          <.heroicon name="hero-chevron-up" />
        </:increment_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.number_input>
      <.action type="submit" semantic="accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_controller_changeset_heex do
    ~S"""
    <.form
      for={@form}
      action={~p"/number-input/form"}
      method="post"
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.number_input field={@form[:value]} >
        <:label>Value</:label>
        <:decrement_trigger>
          <.heroicon name="hero-chevron-down" />
        </:decrement_trigger>
        <:increment_trigger>
          <.heroicon name="hero-chevron-up" />
        </:increment_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.number_input>
      <.action type="submit" semantic="accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_controller_changeset_elixir do
    ~S"""
    def number_input_form_page(conn, _params) do
      form =
        MyApp.Forms.NumberInputForm.changeset(%MyApp.Forms.NumberInputForm{}, %{})
        |> Phoenix.Component.to_form(as: :number_input_changeset, id: "number-input-changeset-form")

      validate_form =
        MyApp.Forms.NumberInputForm.changeset_validate(%MyApp.Forms.NumberInputForm{}, %{})
        |> Phoenix.Component.to_form(as: :number_input_validate, id: "number-input-validate-form")

      render(conn, :number_input_form_page, form: form, validate_form: validate_form)
    end

    def number_input_form_create(conn, %{"number_input_changeset" => params}) do
      case MyApp.Forms.NumberInputForm.changeset(%MyApp.Forms.NumberInputForm{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          _data = Ecto.Changeset.apply_changes(changeset)
          conn
          |> put_flash(:info, "Saved")
          |> redirect(to: ~p"/number-input/form#number-input-changeset-form")

        changeset ->
          changeset = Map.put(changeset, :action, :insert)

          form =
            Phoenix.Component.to_form(changeset,
              as: :number_input_changeset,
              id: "number-input-changeset-form"
            )

          validate_form =
            MyApp.Forms.NumberInputForm.changeset_validate(%MyApp.Forms.NumberInputForm{}, %{})
            |> Phoenix.Component.to_form(as: :number_input_validate, id: "number-input-validate-form")

          render(conn, :number_input_form_page, form: form, validate_form: validate_form)
      end
    end
    """
  end

  def form_doc_controller_validate_heex do
    form_doc_controller_changeset_heex()
    |> String.replace("number-input-changeset", "number-input-validate")
  end

  def form_doc_controller_validate_elixir do
    ~S"""
    def number_input_form_strict_create(conn, %{"number_input_validate" => params}) do
      case MyApp.Forms.NumberInputForm.changeset_validate(%MyApp.Forms.NumberInputForm{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          _data = Ecto.Changeset.apply_changes(changeset)
          conn
          |> put_flash(:info, "Saved (strict)")
          |> redirect(to: ~p"/number-input/form#number-input-validate-form")

        changeset ->
          changeset = Map.put(changeset, :action, :insert)

          validate_form =
            Phoenix.Component.to_form(changeset,
              as: :number_input_validate,
              id: "number-input-validate-form"
            )

          form =
            MyApp.Forms.NumberInputForm.changeset(%MyApp.Forms.NumberInputForm{}, %{})
            |> Phoenix.Component.to_form(as: :number_input_changeset, id: "number-input-changeset-form")

          render(conn, :number_input_form_page, form: form, validate_form: validate_form)
      end
    end
    """
  end

  def form_doc_native_heex do
    ~S"""
    <form
      action={~p"/number-input/form"}
      method="post"
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.number_input name="value" value="1234" >
        <:label>Value</:label>
        <:decrement_trigger>
          <.heroicon name="hero-chevron-down" />
        </:decrement_trigger>
        <:increment_trigger>
          <.heroicon name="hero-chevron-up" />
        </:increment_trigger>
      </.number_input>
      <.action type="submit" semantic="accent">
        Submit
      </.action>
    </form>
    """
  end

  def form_doc_controller_native_elixir do
    ~S"""
    def number_input_form_submit(conn, %{"value" => value}) do
      conn
      |> put_flash(:info, "Submitted: value=#{value}")
      |> redirect(to: ~p"/number-input/form#number-input-form-native")
    end
    """
  end

  def form_native_elixir, do: form_doc_controller_native_elixir()

  def form_preview_controller_changeset(assigns) do
    ~H"""
    <.form
      :let={f}
      for={@form}
      action={~p"/number-input/form"}
      method="post"
    >
      <.number_input
        field={f[:value]}
        id="number-input-changeset-field"
      >
        <:label>Value</:label>
        <:decrement_trigger>
          <.heroicon name="hero-chevron-down" />
        </:decrement_trigger>
        <:increment_trigger>
          <.heroicon name="hero-chevron-up" />
        </:increment_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.number_input>
      <.action type="submit" id="number-input-changeset-submit" semantic="accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_preview_controller_validate(assigns) do
    ~H"""
    <.form
      :let={f}
      for={@form}
      action={~p"/number-input/form"}
      method="post"
    >
      <.number_input
        field={f[:value]}
        id="number-input-validate-field"
      >
        <:label>Value (1–9999)</:label>
        <:decrement_trigger>
          <.heroicon name="hero-chevron-down" />
        </:decrement_trigger>
        <:increment_trigger>
          <.heroicon name="hero-chevron-up" />
        </:increment_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.number_input>
      <.action type="submit" id="number-input-validate-submit" semantic="accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_preview_controller_native(assigns) do
    _ = assigns

    ~H"""
    <form
      action={~p"/number-input/form"}
      method="post"
      id="number-input-plain-form"
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.number_input
        name="value"
        value="1234"
        id="number-input-plain-value"
      >
        <:label>Value</:label>
        <:decrement_trigger>
          <.heroicon name="hero-chevron-down" />
        </:decrement_trigger>
        <:increment_trigger>
          <.heroicon name="hero-chevron-up" />
        </:increment_trigger>
      </.number_input>
      <.action type="submit" id="number-input-plain-submit" semantic="accent">
        Submit
      </.action>
    </form>
    """
  end

  def form_doc_live_changeset_heex do
    ~S"""
    <.form for={@form} phx-change="validate" phx-submit="save">
      <.number_input field={@form[:value]} >
        <:label>Value</:label>
        <:decrement_trigger>
          <.heroicon name="hero-chevron-down" />
        </:decrement_trigger>
        <:increment_trigger>
          <.heroicon name="hero-chevron-up" />
        </:increment_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.number_input>
      <.action type="submit" semantic="accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_live_changeset_elixir do
    ~S"""
    def handle_event("validate", %{"number_input_changeset" => params}, socket) do
      changeset =
        %MyApp.Forms.NumberInputForm{}
        |> MyApp.Forms.NumberInputForm.changeset(params)
        |> Map.put(:action, :validate)

      {:noreply,
       assign(socket, :form, Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :number_input_changeset,
         id: "number-input-live-changeset-form"
       ))}
    end

    def handle_event("save", %{"number_input_changeset" => params}, socket) do
      case MyApp.Forms.NumberInputForm.changeset(%MyApp.Forms.NumberInputForm{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          data = Ecto.Changeset.apply_changes(changeset)
          {:noreply, put_flash(socket, :info, "Submitted: #{inspect(data.value)}")}

        %Ecto.Changeset{} = changeset ->
          {:noreply,
           assign(socket, :form, Phoenix.Component.to_form(changeset,
             action: :insert,
             as: :number_input_changeset,
             id: "number-input-live-changeset-form"
           ))}
      end
    end
    """
  end

  def form_doc_live_validate_heex do
    ~S"""
    <.form
      for={@form}
     
      phx-change="validate_strict"
      phx-submit="save_strict"
    >
      <.number_input field={@form[:value]} >
        <:label>Value (1–9999)</:label>
        <:decrement_trigger>
          <.heroicon name="hero-chevron-down" />
        </:decrement_trigger>
        <:increment_trigger>
          <.heroicon name="hero-chevron-up" />
        </:increment_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.number_input>
      <.action type="submit" semantic="accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_live_validate_elixir do
    ~S"""
    def handle_event("validate_strict", %{"number_input_validate" => params}, socket) do
      changeset =
        %MyApp.Forms.NumberInputForm{}
        |> MyApp.Forms.NumberInputForm.changeset_validate(params)
        |> Map.put(:action, :validate)

      {:noreply,
       assign(socket, :strict_form, Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :number_input_validate,
         id: "number-input-live-validate-form"
       ))}
    end

    def handle_event("save_strict", %{"number_input_validate" => params}, socket) do
      case MyApp.Forms.NumberInputForm.changeset_validate(%MyApp.Forms.NumberInputForm{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          data = Ecto.Changeset.apply_changes(changeset)
          {:noreply, put_flash(socket, :info, "Submitted (strict): #{inspect(data.value)}")}

        %Ecto.Changeset{} = changeset ->
          {:noreply,
           assign(socket, :strict_form, Phoenix.Component.to_form(changeset,
             action: :insert,
             as: :number_input_validate,
             id: "number-input-live-validate-form"
           ))}
      end
    end
    """
  end

  def form_preview_live_changeset(assigns) do
    ~H"""
    <.form
      for={@form}
      phx-change="validate"
      phx-submit="save"
    >
      <.number_input
        field={@form[:value]}
        id="number-input-live-changeset-field"
      >
        <:label>Value</:label>
        <:decrement_trigger>
          <.heroicon name="hero-chevron-down" />
        </:decrement_trigger>
        <:increment_trigger>
          <.heroicon name="hero-chevron-up" />
        </:increment_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.number_input>
      <.action
        type="submit"
        id="number-input-form-live-changeset-submit"
        semantic="accent"
      >
        Submit
      </.action>
    </.form>
    """
  end

  def form_preview_live_validate(assigns) do
    ~H"""
    <.form
      for={@form}
      phx-change="validate"
      phx-submit="save"
    >
      <.number_input
        field={@form[:value]}
        id="number-input-live-validate-field"
      >
        <:label>Value (1–9999)</:label>
        <:decrement_trigger>
          <.heroicon name="hero-chevron-down" />
        </:decrement_trigger>
        <:increment_trigger>
          <.heroicon name="hero-chevron-up" />
        </:increment_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" />
          {msg}
        </:error>
      </.number_input>
      <.action type="submit" id="number-input-form-live-validate-submit" semantic="accent">
        Submit
      </.action>
    </.form>
    """
  end

  attr(:form, :any, required: true)

  def form_preview_controller_phoenix(assigns) do
    ~H"""
    <.form
      :let={f}
      for={@form}
      action={~p"/number-input/form"}
      method="post"
    >
      <.number_input field={f[:value]}>
        <:label>Value</:label>
        <:decrement_trigger>
          <.heroicon name="hero-chevron-down" />
        </:decrement_trigger>
        <:increment_trigger>
          <.heroicon name="hero-chevron-up" />
        </:increment_trigger>
      </.number_input>
      <.action type="submit" semantic="accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_preview_controller_ecto(assigns), do: form_preview_controller_validate(assigns)
  def form_phoenix_heex, do: form_doc_controller_phoenix_heex()
  def form_phoenix_elixir, do: form_doc_controller_phoenix_elixir()
  def form_ecto_heex, do: form_validate_heex()
  def form_ecto_elixir, do: form_validate_elixir()
  def form_doc_live_ecto_heex, do: form_doc_live_validate_heex()

  attr(:form, :any, required: true)

  def form_preview_live_phoenix(assigns) do
    ~H"""
    <.form for={@form} phx-change="change_phoenix" phx-submit="save_phoenix">
      <.number_input
        field={@form[:value]}
        id="number-input-live-form-phoenix-field"
      >
        <:label>Value</:label>
        <:decrement_trigger>
          <.heroicon name="hero-chevron-down" />
        </:decrement_trigger>
        <:increment_trigger>
          <.heroicon name="hero-chevron-up" />
        </:increment_trigger>
      </.number_input>
      <.action type="submit" id="number-input-live-form-phoenix-submit" semantic="accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_preview_live_ecto(assigns), do: form_preview_live_validate(assigns)

  def form_doc_live_phoenix_elixir do
    ~S"""
    defmodule MyAppWeb.NumberInputFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        phoenix_form =
          Phoenix.Component.to_form(%{"value" => "1234"}, as: :number_input_phoenix, id: "number-input-live-form-phoenix")

        {:ok, assign(socket, :phoenix_form, phoenix_form)}
      end

      def handle_event("save_phoenix", %{"number_input_phoenix" => params}, socket) do
        value = params["value"] || ""

        {:noreply,
         assign(
           socket,
           :phoenix_form,
           Phoenix.Component.to_form(%{"value" => value}, as: :number_input_phoenix, id: "number-input-live-form-phoenix")
         )}
      end
    end
    """
  end

  def form_doc_live_ecto_elixir do
    ~S"""
    defmodule MyAppWeb.NumberInputFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        ecto_form =
          %MyApp.Forms.NumberInputForm{}
          |> MyApp.Forms.NumberInputForm.changeset_validate(%{})
          |> Phoenix.Component.to_form(as: :number_input_ecto, id: "number-input-live-form-ecto")

        {:ok, assign(socket, :ecto_form, ecto_form)}
      end

      def handle_event("validate", %{"number_input_ecto" => params}, socket) do
        changeset =
          %MyApp.Forms.NumberInputForm{}
          |> MyApp.Forms.NumberInputForm.changeset_validate(params)
          |> Map.put(:action, :validate)

        {:noreply,
         assign(
           socket,
           :ecto_form,
           Phoenix.Component.to_form(changeset,
             action: :validate,
             as: :number_input_ecto,
             id: "number-input-live-form-ecto"
           )
         )}
      end

      def handle_event("save", %{"number_input_ecto" => params}, socket) do
        case MyApp.Forms.NumberInputForm.changeset_validate(%MyApp.Forms.NumberInputForm{}, params) do
          %Ecto.Changeset{valid?: true} = changeset ->
            _data = Ecto.Changeset.apply_changes(changeset)

            {:noreply,
             assign(
               socket,
               :ecto_form,
               Phoenix.Component.to_form(
                 MyApp.Forms.NumberInputForm.changeset_validate(%MyApp.Forms.NumberInputForm{}, params),
                 as: :number_input_ecto,
                 id: "number-input-live-form-ecto"
               )
             )}

          changeset ->
            {:noreply,
             assign(
               socket,
               :ecto_form,
               Phoenix.Component.to_form(changeset,
                 action: :insert,
                 as: :number_input_ecto,
                 id: "number-input-live-form-ecto"
               )
             )}
        end
      end
    end
    """
  end

  def style_preview(assigns), do: E2eWeb.Demos.StylePreview.preview(:number_input, assigns)
  def style_playground(assigns), do: style_preview(assigns)

end
