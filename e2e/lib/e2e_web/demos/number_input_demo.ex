defmodule E2eWeb.Demos.NumberInputDemo do
  use E2eWeb, :html

  def minimal_code do
    ~S"""
    <.number_input class="number-input">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
    </.number_input>
    """
  end

  def minimal_example(assigns) do
    ~H"""
    <.number_input id="number-input-anatomy-minimal" class="number-input">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
    </.number_input>
    """
  end

  def min_max_default_code do
    ~S"""
    <.number_input
      class="number-input"
      min={0.0}
      max={100.0}
      step={5.0}
      value="10"
    >
      <:label>Amount</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
    </.number_input>
    """
  end

  def min_max_default_example(assigns) do
    ~H"""
    <.number_input
      id="number-input-anatomy-bounds"
      class="number-input"
      min={0.0}
      max={100.0}
      step={5.0}
      value="10"
    >
      <:label>Amount</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
    </.number_input>
    """
  end

  def with_triggers_code, do: minimal_code()
  def with_triggers_example(assigns), do: minimal_example(assigns)

  def styling_color_code do
    ~S"""
    <.number_input class="number-input" value="1">
      <:label>Default</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
    </.number_input>
    <.number_input class="number-input number-input--accent" value="1">
      <:label>Accent</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
    </.number_input>
    <.number_input class="number-input number-input--brand" value="1">
      <:label>Brand</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
    </.number_input>
    """
  end

  def styling_color_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-6 items-start w-full max-w-4xl">
      <.number_input id="number-input-style-color-default" class="number-input" value="1">
        <:label>Default</:label>
        <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
        <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
      </.number_input>
      <.number_input
        id="number-input-style-color-accent"
        class="number-input number-input--accent"
        value="1"
      >
        <:label>Accent</:label>
        <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
        <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
      </.number_input>
      <.number_input
        id="number-input-style-color-brand"
        class="number-input number-input--brand"
        value="1"
      >
        <:label>Brand</:label>
        <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
        <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
      </.number_input>
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <.number_input class="number-input number-input--sm">
      <:label>SM</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
    </.number_input>
    <.number_input class="number-input number-input--lg">
      <:label>LG</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
    </.number_input>
    """
  end

  def styling_size_example(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 w-full max-w-xs">
      <.number_input id="number-input-style-sm" class="number-input number-input--sm">
        <:label>SM</:label>
        <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
        <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
      </.number_input>
      <.number_input id="number-input-style-lg" class="number-input number-input--lg">
        <:label>LG</:label>
        <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
        <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
      </.number_input>
    </div>
    """
  end

  def api_binding_heex do
    ~S"""
    <.number_input
      id="number-input-api-binding"
      class="number-input"
      on_value_change="number_input_api_binding"
    >
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
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
      class="number-input"
      on_value_change="number_input_api_binding"
    >
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_client_heex do
    ~S"""
    <.number_input
      id="number-input-api-client"
      class="number-input"
      on_value_change_client="number-input-api-client-changed"
    >
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
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
      class="number-input"
      on_value_change_client="number-input-api-client-changed"
    >
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_server_note_heex do
    ~S"""
    <.number_input id="qty" class="number-input" value="1">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
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
    <.number_input id="number-input-api-server-note" class="number-input" value="1">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_overview_code, do: api_binding_heex()
  def api_overview_example(assigns), do: api_binding_example(assigns)

  def api_set_value_client_binding_code do
    ~S"""
    <.action phx-click={Corex.NumberInput.set_value("number-input-api-set-client", 42)} class="button button--sm">
      Set 42
    </.action>
    <.number_input id="number-input-api-set-client" class="number-input" value="1">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_set_value_server_heex do
    ~S"""
    <.action phx-click="api_number_set_value_server" class="button button--sm">
      Set 99
    </.action>
    <.number_input id="number-input-api-set-server" class="number-input" value="1">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
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
      class="button button--sm"
    >
      Set 7
    </.action>
    <.number_input id="number-input-api-set-js" class="number-input" value="1">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
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
      <.action phx-click={Corex.NumberInput.set_value(@id, 42)} class="button button--sm">
        Set 42
      </.action>
    </div>
    <.number_input id={@id} class="number-input" value="1">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_set_value_server_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click="api_number_set_value_server" class="button button--sm">
        Set 99
      </.action>
    </div>
    <.number_input id={@id} class="number-input" value="1">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
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
        class="button button--sm"
      >
        Set 7
      </.action>
    </div>
    <.number_input id={@id} class="number-input" value="1">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_clear_client_binding_code do
    ~S"""
    <.action phx-click={Corex.NumberInput.clear_value("number-input-api-clear-client")} class="button button--sm">
      Clear
    </.action>
    <.number_input id="number-input-api-clear-client" class="number-input" value="10">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_clear_server_heex do
    ~S"""
    <.action phx-click="api_number_clear_server" class="button button--sm">
      Clear
    </.action>
    <.number_input id="number-input-api-clear-server" class="number-input" value="10">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
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
      <.action phx-click={Corex.NumberInput.clear_value(@id)} class="button button--sm">
        Clear
      </.action>
    </div>
    <.number_input id={@id} class="number-input" value="10">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_clear_server_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click="api_number_clear_server" class="button button--sm">
        Clear
      </.action>
    </div>
    <.number_input id={@id} class="number-input" value="10">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_commands_client_binding_code do
    ~S"""
    <.action phx-click={Corex.NumberInput.increment("number-input-api-cmd-client")} class="button button--sm">+</.action>
    <.action phx-click={Corex.NumberInput.decrement("number-input-api-cmd-client")} class="button button--sm">−</.action>
    <.action phx-click={Corex.NumberInput.set_to_min("number-input-api-cmd-client")} class="button button--sm">Min</.action>
    <.action phx-click={Corex.NumberInput.set_to_max("number-input-api-cmd-client")} class="button button--sm">Max</.action>
    <.action phx-click={Corex.NumberInput.focus("number-input-api-cmd-client")} class="button button--sm">Focus</.action>
    <.number_input id="number-input-api-cmd-client" class="number-input" min={0.0} max={10.0} step={1.0} value="5">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_commands_client_binding_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={Corex.NumberInput.increment(@id)} class="button button--sm">+</.action>
      <.action phx-click={Corex.NumberInput.decrement(@id)} class="button button--sm">−</.action>
      <.action phx-click={Corex.NumberInput.set_to_min(@id)} class="button button--sm">Min</.action>
      <.action phx-click={Corex.NumberInput.set_to_max(@id)} class="button button--sm">Max</.action>
      <.action phx-click={Corex.NumberInput.focus(@id)} class="button button--sm">Focus</.action>
    </div>
    <.number_input
      id={@id}
      class="number-input"
      min={0.0}
      max={10.0}
      step={1.0}
      value="5"
    >
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_state_client_binding_code do
    ~S"""
    <.action phx-click={Corex.NumberInput.state("number-input-api-state-client")} class="button button--sm">
      Read state
    </.action>
    <.number_input id="number-input-api-state-client" class="number-input" value="3">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_state_server_heex do
    ~S"""
    <.action phx-click="api_number_state_server" class="button button--sm">
      Read state
    </.action>
    <.number_input id="number-input-api-state-server" class="number-input" value="8">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
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
      class="button button--sm"
    >
      Read state
    </.action>
    <.number_input id="number-input-api-state-js" class="number-input" value="4">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
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
      <.action phx-click={Corex.NumberInput.state(@id)} class="button button--sm">
        Read state
      </.action>
    </div>
    <.number_input id={@id} class="number-input" value="3">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
    </.number_input>
    """
  end

  def api_state_server_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click="api_number_state_server" class="button button--sm">
        Read state
      </.action>
    </div>
    <.number_input id={@id} class="number-input" value="8">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
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
        class="button button--sm"
      >
        Read state
      </.action>
    </div>
    <.number_input id={@id} class="number-input" value="4">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
    </.number_input>
    """
  end

  def events_server_heex do
    ~S"""
    <.number_input
      class="number-input"
      on_value_change="number_input_changed"
    >
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
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
      id="number-input-events-client"
      class="number-input"
      on_value_change_client="number-input-changed"
    >
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
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
      :let={f}
      for={@phoenix_form}
      action={~p"/number-input/form"}
      method="post"
      id={@phoenix_form.id}
    >
      <.number_input field={f[:value]} class="number-input">
        <:label>Value</:label>
        <:decrement_trigger>
          <.heroicon name="hero-chevron-down" class="icon" />
        </:decrement_trigger>
        <:increment_trigger>
          <.heroicon name="hero-chevron-up" class="icon" />
        </:increment_trigger>
      </.number_input>
      <.action type="submit" class="button button--accent">
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
    <.form for={@phoenix_form} id={@phoenix_form.id} phx-submit="save_phoenix">
      <.number_input field={@phoenix_form[:value]} class="number-input" id="number-input-live-form-phoenix-field">
        <:label>Value</:label>
        <:decrement_trigger>
          <.heroicon name="hero-chevron-down" class="icon" />
        </:decrement_trigger>
        <:increment_trigger>
          <.heroicon name="hero-chevron-up" class="icon" />
        </:increment_trigger>
      </.number_input>
      <.action type="submit" id="number-input-live-form-phoenix-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_controller_changeset_heex do
    ~S"""
    <.form
      :let={f}
      for={@form}
      action={~p"/number-input/form"}
      method="post"
      id={@form.id}
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.number_input field={f[:value]} class="number-input">
        <:label>Value</:label>
        <:decrement_trigger>
          <.heroicon name="hero-chevron-down" class="icon" />
        </:decrement_trigger>
        <:increment_trigger>
          <.heroicon name="hero-chevron-up" class="icon" />
        </:increment_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.number_input>
      <.action type="submit" class="button button--accent">
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
      <.number_input name="value" value="1234" class="number-input">
        <:label>Value</:label>
        <:decrement_trigger>
          <.heroicon name="hero-chevron-down" class="icon" />
        </:decrement_trigger>
        <:increment_trigger>
          <.heroicon name="hero-chevron-up" class="icon" />
        </:increment_trigger>
      </.number_input>
      <.action type="submit" class="button button--accent">
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
      id={@form.id}
    >
      <.number_input
        field={f[:value]}
        id="number-input-changeset-field"
        class="number-input"
      >
        <:label>Value</:label>
        <:decrement_trigger>
          <.heroicon name="hero-chevron-down" class="icon" />
        </:decrement_trigger>
        <:increment_trigger>
          <.heroicon name="hero-chevron-up" class="icon" />
        </:increment_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.number_input>
      <.action type="submit" id="number-input-changeset-submit" class="button button--accent">
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
      id={@form.id}
    >
      <.number_input
        field={f[:value]}
        id="number-input-validate-field"
        class="number-input"
      >
        <:label>Value (1–9999)</:label>
        <:decrement_trigger>
          <.heroicon name="hero-chevron-down" class="icon" />
        </:decrement_trigger>
        <:increment_trigger>
          <.heroicon name="hero-chevron-up" class="icon" />
        </:increment_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.number_input>
      <.action type="submit" id="number-input-validate-submit" class="button button--accent">
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
        class="number-input"
      >
        <:label>Value</:label>
        <:decrement_trigger>
          <.heroicon name="hero-chevron-down" class="icon" />
        </:decrement_trigger>
        <:increment_trigger>
          <.heroicon name="hero-chevron-up" class="icon" />
        </:increment_trigger>
      </.number_input>
      <.action type="submit" id="number-input-plain-submit" class="button button--accent">
        Submit
      </.action>
    </form>
    """
  end

  def form_doc_live_changeset_heex do
    ~S"""
    <.form for={@form} id={@form.id} phx-change="validate" phx-submit="save">
      <.number_input field={@form[:value]} class="number-input">
        <:label>Value</:label>
        <:decrement_trigger>
          <.heroicon name="hero-chevron-down" class="icon" />
        </:decrement_trigger>
        <:increment_trigger>
          <.heroicon name="hero-chevron-up" class="icon" />
        </:increment_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.number_input>
      <.action type="submit" class="button button--accent">
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
      id={@form.id}
      phx-change="validate_strict"
      phx-submit="save_strict"
    >
      <.number_input field={@form[:value]} class="number-input">
        <:label>Value (1–9999)</:label>
        <:decrement_trigger>
          <.heroicon name="hero-chevron-down" class="icon" />
        </:decrement_trigger>
        <:increment_trigger>
          <.heroicon name="hero-chevron-up" class="icon" />
        </:increment_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.number_input>
      <.action type="submit" class="button button--accent">
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
      id={@form.id}
      phx-change="validate"
      phx-submit="save"
    >
      <.number_input
        field={@form[:value]}
        id="number-input-live-changeset-field"
        class="number-input"
      >
        <:label>Value</:label>
        <:decrement_trigger>
          <.heroicon name="hero-chevron-down" class="icon" />
        </:decrement_trigger>
        <:increment_trigger>
          <.heroicon name="hero-chevron-up" class="icon" />
        </:increment_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.number_input>
      <.action
        type="submit"
        id="number-input-form-live-changeset-submit"
        class="button button--accent"
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
      id={@form.id}
      phx-change="validate"
      phx-submit="save"
    >
      <.number_input
        field={@form[:value]}
        id="number-input-live-validate-field"
        class="number-input"
      >
        <:label>Value (1–9999)</:label>
        <:decrement_trigger>
          <.heroicon name="hero-chevron-down" class="icon" />
        </:decrement_trigger>
        <:increment_trigger>
          <.heroicon name="hero-chevron-up" class="icon" />
        </:increment_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.number_input>
      <.action type="submit" id="number-input-form-live-validate-submit" class="button button--accent">
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
      id={@form.id}
    >
      <.number_input field={f[:value]} class="number-input">
        <:label>Value</:label>
        <:decrement_trigger>
          <.heroicon name="hero-chevron-down" class="icon" />
        </:decrement_trigger>
        <:increment_trigger>
          <.heroicon name="hero-chevron-up" class="icon" />
        </:increment_trigger>
      </.number_input>
      <.action type="submit" class="button button--accent">
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
    <.form for={@form} id={@form.id} phx-submit="save_phoenix">
      <.number_input
        field={@form[:value]}
        class="number-input"
        id="number-input-live-form-phoenix-field"
      >
        <:label>Value</:label>
        <:decrement_trigger>
          <.heroicon name="hero-chevron-down" class="icon" />
        </:decrement_trigger>
        <:increment_trigger>
          <.heroicon name="hero-chevron-up" class="icon" />
        </:increment_trigger>
      </.number_input>
      <.action type="submit" id="number-input-live-form-phoenix-submit" class="button button--accent">
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
end
