defmodule E2eWeb.Demos.ToggleGroupDemo do
  use E2eWeb, :html

  def anatomy_basic_code do
    ~S"""
    <.toggle_group id="toggle-group-anatomy" class="toggle-group">
      <:item value="lorem">Lorem</:item>
      <:item value="duis">Duis</:item>
      <:item value="donec">Donec</:item>
    </.toggle_group>
    """
  end

  def anatomy_basic_example(assigns) do
    ~H"""
    <.toggle_group id="toggle-group-anatomy" class="toggle-group">
      <:item value="lorem">Lorem</:item>
      <:item value="duis">Duis</:item>
      <:item value="donec">Donec</:item>
    </.toggle_group>
    """
  end

  def api_set_value_client_binding_heex do
    ~S"""
    <div class="layout__row">
      <.action phx-click={Corex.ToggleGroup.set_value("toggle-group-api-cb", ["lorem"])} class="button button--sm">Lorem</.action>
      <.action phx-click={Corex.ToggleGroup.set_value("toggle-group-api-cb", ["lorem", "donec"])} class="button button--sm">Lorem+Donec</.action>
      <.action phx-click={Corex.ToggleGroup.set_value("toggle-group-api-cb", [])} class="button button--sm">Clear</.action>
    </div>
    <.toggle_group id="toggle-group-api-cb" class="toggle-group" multiple>
      <:item value="lorem">Lorem</:item>
      <:item value="duis">Duis</:item>
      <:item value="donec">Donec</:item>
    </.toggle_group>
    """
  end

  def api_set_value_client_binding_example(assigns) do
    _ = assigns

    ~H"""
    <div class="w-full max-w-4xl flex flex-col gap-4">
      <div class="layout__row">
        <.action
          phx-click={Corex.ToggleGroup.set_value("toggle-group-api-cb", ["lorem"])}
          class="button button--sm"
        >
          Lorem
        </.action>
        <.action
          phx-click={Corex.ToggleGroup.set_value("toggle-group-api-cb", ["lorem", "donec"])}
          class="button button--sm"
        >
          Lorem+Donec
        </.action>
        <.action
          phx-click={Corex.ToggleGroup.set_value("toggle-group-api-cb", [])}
          class="button button--sm"
        >
          Clear
        </.action>
      </div>
      <.toggle_group id="toggle-group-api-cb" class="toggle-group" multiple>
        <:item value="lorem">Lorem</:item>
        <:item value="duis">Duis</:item>
        <:item value="donec">Donec</:item>
      </.toggle_group>
    </div>
    """
  end

  def api_set_value_client_js_heex do
    ~S"""
    <button
      type="button"
      class="button button--sm"
      onclick="document.getElementById('toggle-group-api-cjs')?.dispatchEvent(new CustomEvent('corex:toggle-group:set-value', {bubbles: false, detail: { value: ['lorem'] } }))"
    >
      Set (client JS)
    </button>
    <.toggle_group id="toggle-group-api-cjs" class="toggle-group" multiple>
      <:item value="lorem">Lorem</:item>
      <:item value="duis">Duis</:item>
    </.toggle_group>
    """
  end

  def api_set_value_client_js_js do
    ~S"""
    const el = document.getElementById("toggle-group-api-cjs");
    el?.dispatchEvent(
      new CustomEvent("corex:toggle-group:set-value", { bubbles: false, detail: { value: ["lorem"] } })
    );
    """
  end

  def api_set_value_client_js_ts do
    api_set_value_client_js_js()
  end

  def api_set_value_client_js_example(assigns) do
    _ = assigns

    ~H"""
    <div class="w-full max-w-4xl flex flex-col gap-4">
      <div class="layout__row">
        <button
          type="button"
          class="button button--sm"
          onclick="document.getElementById('toggle-group-api-cjs')?.dispatchEvent(new CustomEvent('corex:toggle-group:set-value', {bubbles: false, detail: { value: ['lorem'] } }))"
        >
          Set (client JS)
        </button>
      </div>
      <.toggle_group id="toggle-group-api-cjs" class="toggle-group" multiple>
        <:item value="lorem">Lorem</:item>
        <:item value="duis">Duis</:item>
      </.toggle_group>
    </div>
    """
  end

  def api_set_value_server_heex do
    ~S"""
    <div class="layout__row">
      <.action phx-click="tg_api_lorem" class="button button--sm">Lorem</.action>
      <.action phx-click="tg_api_clear" class="button button--sm">Clear</.action>
    </div>
    <.toggle_group id="toggle-group-api-srv" class="toggle-group" multiple>
      <:item value="lorem">Lorem</:item>
      <:item value="duis">Duis</:item>
    </.toggle_group>
    """
  end

  def api_set_value_server_elixir do
    ~S"""
    def handle_event("tg_api_lorem", _params, socket) do
      {:noreply, Corex.ToggleGroup.set_value(socket, "toggle-group-api-srv", ["lorem"])}
    end

    def handle_event("tg_api_clear", _params, socket) do
      {:noreply, Corex.ToggleGroup.set_value(socket, "toggle-group-api-srv", [])}
    end
    """
  end

  def api_set_value_server_example(assigns) do
    _ = assigns

    ~H"""
    <div class="w-full max-w-4xl flex flex-col gap-4">
      <div class="layout__row">
        <.action phx-click="tg_api_lorem" class="button button--sm">Lorem</.action>
        <.action phx-click="tg_api_clear" class="button button--sm">Clear</.action>
      </div>
      <.toggle_group id="toggle-group-api-srv" class="toggle-group" multiple>
        <:item value="lorem">Lorem</:item>
        <:item value="duis">Duis</:item>
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

  def api_client_binding_code, do: api_set_value_client_binding_heex()

  def api_client_binding_example(assigns), do: api_set_value_client_binding_example(assigns)

  def patterns_controlled_heex do
    ~S"""
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
    </.toggle_group>
    """
  end

  def styling_duo_code do
    ~S"""
    <.toggle_group id="tg-style-duo" class="toggle-group toggle-group--duo" multiple>
      <:item value="a">A</:item>
      <:item value="b">B</:item>
    </.toggle_group>
    <.toggle_group
      id="tg-style-circle"
      class="toggle-group toggle-group--circle"
      multiple={false}
      value={["x"]}
    >
      <:item value="x">X</:item>
      <:item value="y">Y</:item>
    </.toggle_group>
    """
  end

  def styling_duo_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-col gap-8 w-full max-w-4xl">
      <.toggle_group id="tg-style-duo" class="toggle-group toggle-group--duo" multiple>
        <:item value="a">A</:item>
        <:item value="b">B</:item>
      </.toggle_group>
      <.toggle_group
        id="tg-style-circle"
        class="toggle-group toggle-group--circle"
        multiple={false}
        value={["x"]}
      >
        <:item value="x">X</:item>
        <:item value="y">Y</:item>
      </.toggle_group>
    </div>
    """
  end

  def events_server_heex do
    ~S"""
    <.toggle_group
      id="toggle-group-events-server"
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
    ~S"""
    def handle_event("toggle_group_changed", %{"id" => id, "value" => value}, socket) do
      log = %{time: "12:00:00", source: "server", value: inspect(value)}
      {:noreply, stream_insert(socket, :server_logs, log, at: 0)}
    end
    """
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
