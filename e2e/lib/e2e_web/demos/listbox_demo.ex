defmodule E2eWeb.Demos.ListboxDemo do
  use E2eWeb, :html

  @pattern_snippets Path.join(__DIR__, "listbox_pattern_snippets")

  def items_minimal do
    Corex.List.new([
      %{label: "France", id: "fra"},
      %{label: "Belgium", id: "bel"},
      %{label: "Germany", id: "deu"},
      %{label: "Netherlands", id: "nld"},
      %{label: "Switzerland", id: "che"},
      %{label: "Austria", id: "aut"}
    ])
  end

  def items_grouped do
    Corex.List.new([
      %{label: "France", id: "fra", group: "Europe"},
      %{label: "Belgium", id: "bel", group: "Europe"},
      %{label: "Germany", id: "deu", group: "Europe"},
      %{label: "Japan", id: "jpn", group: "Asia"},
      %{label: "China", id: "chn", group: "Asia"},
      %{label: "USA", id: "usa", group: "North America"}
    ])
  end

  def items_extended do
    items_minimal()
  end

  def items_extended_grouped do
    Corex.List.new([
      %{label: "France", id: "fra", group: "Europe"},
      %{label: "Belgium", id: "bel", group: "Europe"},
      %{label: "Germany", id: "deu", group: "Europe"},
      %{label: "Japan", id: "jpn", group: "Asia"},
      %{label: "China", id: "chn", group: "Asia"},
      %{label: "South Korea", id: "kor", group: "Asia"}
    ])
  end

  def anatomy_minimal_code do
    ~S"""
    <.listbox id="listbox-anatomy-minimal" class="listbox" items={items_minimal()}>
      <:label>Choose a country</:label>
    </.listbox>
    """
  end

  def anatomy_minimal_example(assigns) do
    assigns = assign(assigns, :items, items_minimal())

    ~H"""
    <.listbox id="listbox-anatomy-minimal" class="listbox" items={@items}>
      <:label>Choose a country</:label>
    </.listbox>
    """
  end

  def anatomy_with_indicator_code do
    ~S"""
    <.listbox id="listbox-anatomy-indicator" class="listbox" items={items_minimal()}>
      <:label>Choose a country</:label>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.listbox>
    """
  end

  def anatomy_with_indicator_example(assigns) do
    assigns = assign(assigns, :items, items_minimal())

    ~H"""
    <.listbox id="listbox-anatomy-indicator" class="listbox" items={@items}>
      <:label>Choose a country</:label>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.listbox>
    """
  end

  def anatomy_grouped_code do
    ~S"""
    <.listbox id="listbox-anatomy-grouped" class="listbox" items={items_grouped()}>
      <:label>Choose a country</:label>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.listbox>
    """
  end

  def anatomy_grouped_example(assigns) do
    assigns = assign(assigns, :items, items_grouped())

    ~H"""
    <.listbox id="listbox-anatomy-grouped" class="listbox" items={@items}>
      <:label>Choose a country</:label>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.listbox>
    """
  end

  def anatomy_extended_code do
    ~S"""
    <.listbox id="listbox-anatomy-extended" class="listbox" items={items_extended()}>
      <:label>Country of residence</:label>
      <:item :let={%{item: entry}}>
        <Flagpack.flag name={String.to_atom(entry.id)} />
        {entry.label}
      </:item>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.listbox>
    """
  end

  def anatomy_extended_example(assigns) do
    assigns = assign(assigns, :items, items_extended())

    ~H"""
    <.listbox id="listbox-anatomy-extended" class="listbox" items={@items}>
      <:label>Country of residence</:label>
      <:item :let={%{item: entry}}>
        <Flagpack.flag name={String.to_atom(entry.id)} />
        {entry.label}
      </:item>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.listbox>
    """
  end

  def anatomy_extended_grouped_code do
    ~S"""
    <.listbox
      id="listbox-anatomy-extended-grouped"
      class="listbox"
      aria_label="Extended grouped countries"
      items={items_extended_grouped()}
    >
      <:item :let={%{item: entry}}>
        <Flagpack.flag name={String.to_atom(entry.id)} />
        {entry.label}
      </:item>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.listbox>
    """
  end

  def anatomy_extended_grouped_example(assigns) do
    assigns = assign(assigns, :items, items_extended_grouped())

    ~H"""
    <.listbox
      id="listbox-anatomy-extended-grouped"
      class="listbox"
      aria_label="Extended grouped countries"
      items={@items}
    >
      <:item :let={%{item: entry}}>
        <Flagpack.flag name={String.to_atom(entry.id)} />
        {entry.label}
      </:item>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.listbox>
    """
  end

  def patterns_stream_demo_heex do
    ~S"""
    <div class="flex flex-col gap-3 w-full max-w-xl">
      <div class="flex flex-wrap gap-2">
        <.action phx-click="add_item" class="button button--sm button--accent">
          <.heroicon name="hero-plus" /> Add item
        </.action>
        <.action phx-click="reset" class="button button--sm button--alert">
          Reset
        </.action>
      </div>
      <.listbox id="stream-listbox" class="listbox" items={Corex.List.new(@items_list)}>
        <:label>Choose an item</:label>
        <:empty>No items</:empty>
        <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
      </.listbox>
    </div>
    """
  end

  def patterns_stream_my_app, do: read_pattern_snippet("patterns_stream_my_app.txt")

  def patterns_stream_grouped_demo_heex do
    ~S"""
    <div class="flex flex-col gap-3 w-full max-w-xl">
      <div class="flex flex-wrap gap-2">
        <.action
          phx-click="add_to_group"
          phx-value-group="Europe"
          class="button button--sm button--accent"
        >
          <.heroicon name="hero-plus" /> Add to Europe
        </.action>
        <.action
          phx-click="add_to_group"
          phx-value-group="Asia"
          class="button button--sm button--accent"
        >
          <.heroicon name="hero-plus" /> Add to Asia
        </.action>
        <.action phx-click="reset_grouped" class="button button--sm button--alert">
          Reset
        </.action>
      </div>
      <.listbox
        id="stream-grouped-listbox"
        class="listbox"
        items={Corex.List.new(@grouped_items_list)}
      >
        <:label>Choose a country</:label>
        <:empty>No items</:empty>
        <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
      </.listbox>
    </div>
    """
  end

  def patterns_stream_grouped_my_app,
    do: read_pattern_snippet("patterns_stream_grouped_my_app.txt")

  def patterns_controlled_heex do
    ~S"""
    <.listbox
      id="listbox-patterns-controlled-field"
      class="listbox"
      items={
        Corex.List.new([
          %{label: "France", id: "fra"},
          %{label: "Belgium", id: "bel"},
          %{label: "Germany", id: "deu"},
          %{label: "Netherlands", id: "nld"},
          %{label: "Switzerland", id: "che"},
          %{label: "Austria", id: "aut"}
        ])
      }
      selection_mode="multiple"
      controlled
      value={@listbox_controlled_value}
      on_value_change="listbox_patterns_controlled_value"
    >
      <:label>Choose countries</:label>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.listbox>
    <p class="text-sm text-ink-muted font-mono" id="listbox-patterns-controlled-state">
      value: {inspect(@listbox_controlled_value)}
    </p>
    """
  end

  def patterns_controlled_elixir do
    patterns_controlled_my_app()
  end

  def patterns_controlled_my_app, do: read_pattern_snippet("patterns_controlled_my_app.txt")

  defp read_pattern_snippet(name), do: File.read!(Path.join(@pattern_snippets, name))

  def api_set_value_client_binding_code do
    ~S"""
    <.action phx-click={Corex.Listbox.set_value("listbox-api-sv-client", ["bel"])}>Belgium</.action>
    <.action phx-click={Corex.Listbox.set_value("listbox-api-sv-client", [])}>Clear</.action>
    <.listbox id="listbox-api-sv-client" class="listbox" items={items_minimal()}>
      <:label>Choose a country</:label>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.listbox>
    """
  end

  def api_set_value_server_heex do
    ~S"""
    <.action phx-click="listbox_api_set_value">Belgium</.action>
    <.listbox id="listbox-api-sv-server" class="listbox" items={items_minimal()}>
      <:label>Choose a country</:label>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.listbox>
    """
  end

  def api_set_value_server_elixir do
    ~S"""
    def handle_event("listbox_api_set_value", _params, socket) do
      {:noreply, Corex.Listbox.set_value(socket, "listbox-api-sv-server", ["bel"])}
    end
    """
  end

  def api_set_value_client_js do
    ~S"""
    const el = document.getElementById("listbox-api-sv-js");
    el?.dispatchEvent(
      new CustomEvent("corex:listbox:set-value", {
        bubbles: false,
        detail: { value: ["deu"] },
      })
    );
    """
  end

  def api_value_client_binding_code do
    ~S"""
    <.action phx-click={Corex.Listbox.value("listbox-api-val-client")}>Read selection</.action>
    <.listbox id="listbox-api-val-client" class="listbox" items={items_minimal()}>
      <:label>Choose a country</:label>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.listbox>
    """
  end

  def api_value_server_heex do
    ~S"""
    <.action phx-click="listbox_api_value_server">Read selection</.action>
    <.listbox id="listbox-api-val-server" class="listbox" items={items_minimal()}>
      <:label>Choose a country</:label>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.listbox>
    """
  end

  def api_value_server_elixir do
    ~S"""
    def handle_event("listbox_api_value_server", _params, socket) do
      {:noreply, Corex.Listbox.value(socket, "listbox-api-val-server")}
    end

    def handle_event("listbox_value_response", %{"id" => id, "value" => value}, socket) do
      # e.g. Corex.Toast.push_toast(...)
      {:noreply, socket}
    end
    """
  end

  def events_server_heex do
    ~S"""
    <.listbox
      id="listbox-events-server"
      class="listbox"
      items={items_minimal()}
      on_value_change="listbox_value_changed"
    >
      <:label>Choose a country</:label>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.listbox>
    """
  end

  def events_server_elixir do
    ~S"""
    def handle_event("listbox_value_changed", %{"id" => id, "value" => value}, socket) do
      log = %{time: "12:00:00", source: "server", value: inspect(value)}
      {:noreply, stream_insert(socket, :server_logs, log, at: 0)}
    end
    """
  end

  def events_client_heex do
    ~S"""
    <.listbox
      id="listbox-events-client"
      class="listbox"
      items={items_minimal()}
      on_value_change_client="listbox-value-changed"
    >
      <:label>Choose a country</:label>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.listbox>
    """
  end

  def events_client_js do
    ~S"""
    const el = document.getElementById("listbox-events-client");
    el?.addEventListener("listbox-value-changed", (event) => {
      const { id, value, items } = event.detail ?? {};
      console.log({ id, value, items });
    });
    """
  end

  def events_client_ts do
    ~S"""
    const el = document.getElementById("listbox-events-client");
    type Detail = { id?: string; value?: string[]; items?: unknown[] };
    el?.addEventListener("listbox-value-changed", (event: Event) => {
      const d = (event as CustomEvent<Detail>).detail ?? {};
      console.log({ id: d.id, value: d.value, items: d.items });
    });
    """
  end
end
