defmodule E2eWeb.Demos.ListboxDemo do
  use E2eWeb, :html

  def items_minimal do
    Corex.List.new([
      %{label: "France", value: "fra"},
      %{label: "Belgium", value: "bel"},
      %{label: "Germany", value: "deu"},
      %{label: "Netherlands", value: "nld"},
      %{label: "Switzerland", value: "che"},
      %{label: "Austria", value: "aut"}
    ])
  end

  def items_grouped do
    Corex.List.new([
      %{label: "France", value: "fra", group: "Europe"},
      %{label: "Belgium", value: "bel", group: "Europe"},
      %{label: "Germany", value: "deu", group: "Europe"},
      %{label: "Japan", value: "jpn", group: "Asia"},
      %{label: "China", value: "chn", group: "Asia"},
      %{label: "USA", value: "usa", group: "North America"}
    ])
  end

  def items_extended do
    items_minimal()
  end

  def items_extended_grouped do
    Corex.List.new([
      %{label: "France", value: "fra", group: "Europe"},
      %{label: "Belgium", value: "bel", group: "Europe"},
      %{label: "Germany", value: "deu", group: "Europe"},
      %{label: "Japan", value: "jpn", group: "Asia"},
      %{label: "China", value: "chn", group: "Asia"},
      %{label: "South Korea", value: "kor", group: "Asia"}
    ])
  end

  def anatomy_minimal_code do
    ~S"""
    <.listbox id="listbox-anatomy-minimal" class="listbox" items={
      Corex.List.new([
        %{label: "France", value: "fra"},
        %{label: "Belgium", value: "bel"},
        %{label: "Germany", value: "deu"},
        %{label: "Netherlands", value: "nld"},
        %{label: "Switzerland", value: "che"},
        %{label: "Austria", value: "aut"}
      ])
    }>
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
    <.listbox id="listbox-anatomy-indicator" class="listbox" items={
      Corex.List.new([
        %{label: "France", value: "fra"},
        %{label: "Belgium", value: "bel"},
        %{label: "Germany", value: "deu"},
        %{label: "Netherlands", value: "nld"},
        %{label: "Switzerland", value: "che"},
        %{label: "Austria", value: "aut"}
      ])
    }>
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
    <.listbox id="listbox-anatomy-grouped" class="listbox" items={
      Corex.List.new([
        %{label: "France", value: "fra", group: "Europe"},
        %{label: "Belgium", value: "bel", group: "Europe"},
        %{label: "Germany", value: "deu", group: "Europe"},
        %{label: "Japan", value: "jpn", group: "Asia"},
        %{label: "China", value: "chn", group: "Asia"},
        %{label: "USA", value: "usa", group: "North America"}
      ])
    }>
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
    <.listbox id="listbox-anatomy-extended" class="listbox" items={
      Corex.List.new([
        %{label: "France", value: "fra"},
        %{label: "Belgium", value: "bel"},
        %{label: "Germany", value: "deu"},
        %{label: "Netherlands", value: "nld"},
        %{label: "Switzerland", value: "che"},
        %{label: "Austria", value: "aut"}
      ])
    }>
      <:label>Country of residence</:label>
      <:item :let={%{item: entry}}>
        <Flagpack.flag name={String.to_atom(entry.value)} />
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
        <Flagpack.flag name={String.to_atom(entry.value)} />
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
      items={
        Corex.List.new([
          %{label: "France", value: "fra", group: "Europe"},
          %{label: "Belgium", value: "bel", group: "Europe"},
          %{label: "Germany", value: "deu", group: "Europe"},
          %{label: "Japan", value: "jpn", group: "Asia"},
          %{label: "China", value: "chn", group: "Asia"},
          %{label: "South Korea", value: "kor", group: "Asia"}
        ])
      }
    >
      <:item :let={%{item: entry}}>
        <Flagpack.flag name={String.to_atom(entry.value)} />
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
        <Flagpack.flag name={String.to_atom(entry.value)} />
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

  def patterns_stream_elixir do
    ~S'''
    defmodule MyAppWeb.ListboxStreamDemoLive do
      use MyAppWeb, :live_view

      @impl true
      def mount(_params, _session, socket) do
        initial = [
          %{value: "1", label: "Apple"},
          %{value: "2", label: "Banana"},
          %{value: "3", label: "Cherry"}
        ]

        socket =
          socket
          |> stream_configure(:items, dom_id: &("listbox:stream-listbox:item:" <> to_string(&1.value)))
          |> stream(:items, initial)
          |> assign(:items_list, initial)
          |> assign(:next_id, 4)

        if connected?(socket) do
          Process.send_after(self(), :add_timestamp_item, 3_000)
        end

        {:ok, socket}
      end

      @impl true
      def handle_info(:add_timestamp_item, socket) do
        Process.send_after(self(), :add_timestamp_item, 10_000)
        id = to_string(socket.assigns.next_id)

        time =
          DateTime.utc_now()
          |> DateTime.truncate(:second)
          |> DateTime.to_time()
          |> Time.to_string()

        item = %{value: id, label: "Item " <> id <> " @ " <> time}

        {:noreply,
         socket
         |> stream_insert(:items, item)
         |> assign(:items_list, socket.assigns.items_list ++ [item])
         |> assign(:next_id, socket.assigns.next_id + 1)}
      end

      @impl true
      def handle_event("add_item", _params, socket) do
        id = to_string(socket.assigns.next_id)
        item = %{value: id, label: "Item " <> id}

        {:noreply,
         socket
         |> stream_insert(:items, item)
         |> assign(:items_list, socket.assigns.items_list ++ [item])
         |> assign(:next_id, socket.assigns.next_id + 1)}
      end

      @impl true
      def handle_event("reset", _params, socket) do
        initial = [
          %{value: "1", label: "Apple"},
          %{value: "2", label: "Banana"},
          %{value: "3", label: "Cherry"}
        ]

        {:noreply,
         socket
         |> stream(:items, initial, reset: true)
         |> assign(:items_list, initial)
         |> assign(:next_id, 4)}
      end

      @impl true
      def render(assigns) do
        ~H"""
        <Layouts.app
          flash={@flash}
          path={@path}
          mode={@mode}
          theme={@theme}
          locale={@locale}
        >
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
        </Layouts.app>
        """
      end
    end
    '''
  end

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

  def patterns_stream_grouped_elixir do
    ~S'''
    defmodule MyAppWeb.ListboxStreamGroupedDemoLive do
      use MyAppWeb, :live_view

      @impl true
      def mount(_params, _session, socket) do
        initial = [
          %{value: "g1", label: "France", group: "Europe"},
          %{value: "g2", label: "Japan", group: "Asia"},
          %{value: "g3", label: "Germany", group: "Europe"}
        ]

        socket =
          socket
          |> stream_configure(:grouped_items, dom_id: &("listbox:stream-grouped-listbox:item:" <> to_string(&1.value)))
          |> stream(:grouped_items, initial)
          |> assign(:grouped_items_list, initial)
          |> assign(:next_grouped_id, 4)

        {:ok, socket}
      end

      @impl true
      def handle_event("add_to_group", %{"group" => group}, socket) do
        n = socket.assigns.next_grouped_id
        id = "g" <> Integer.to_string(n)
        item = %{value: id, label: "Item " <> Integer.to_string(n), group: group}

        {:noreply,
         socket
         |> stream_insert(:grouped_items, item)
         |> assign(:grouped_items_list, socket.assigns.grouped_items_list ++ [item])
         |> assign(:next_grouped_id, n + 1)}
      end

      @impl true
      def handle_event("reset_grouped", _params, socket) do
        initial = [
          %{value: "g1", label: "France", group: "Europe"},
          %{value: "g2", label: "Japan", group: "Asia"},
          %{value: "g3", label: "Germany", group: "Europe"}
        ]

        {:noreply,
         socket
         |> stream(:grouped_items, initial, reset: true)
         |> assign(:grouped_items_list, initial)
         |> assign(:next_grouped_id, 4)}
      end

      @impl true
      def render(assigns) do
        ~H"""
        <Layouts.app
          flash={@flash}
          path={@path}
          mode={@mode}
          theme={@theme}
          locale={@locale}
        >
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
        </Layouts.app>
        """
      end
    end
    '''
  end

  def patterns_controlled_heex do
    ~S"""
    <.listbox
      id="listbox-patterns-controlled-field"
      class="listbox"
      items={
        Corex.List.new([
          %{label: "France", value: "fra"},
          %{label: "Belgium", value: "bel"},
          %{label: "Germany", value: "deu"},
          %{label: "Netherlands", value: "nld"},
          %{label: "Switzerland", value: "che"},
          %{label: "Austria", value: "aut"}
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
    ~S'''
    defmodule MyAppWeb.ListboxControlledDemoLive do
      use MyAppWeb, :live_view

      @impl true
      def mount(_params, _session, socket) do
        {:ok, assign(socket, :listbox_controlled_value, ["fra", "bel"])}
      end

      @impl true
      def handle_event("listbox_patterns_controlled_value", %{"value" => value}, socket)
          when is_list(value) do
        {:noreply, assign(socket, :listbox_controlled_value, value)}
      end

      @impl true
      def render(assigns) do
        ~H"""
        <Layouts.app
          flash={@flash}
          path={@path}
          mode={@mode}
          theme={@theme}
          locale={@locale}
        >
          <div class="flex flex-col gap-3 max-w-xl w-full">
            <.listbox
              id="listbox-patterns-controlled-field"
              class="listbox"
              items={
                Corex.List.new([
                  %{label: "France", value: "fra"},
                  %{label: "Belgium", value: "bel"},
                  %{label: "Germany", value: "deu"},
                  %{label: "Netherlands", value: "nld"},
                  %{label: "Switzerland", value: "che"},
                  %{label: "Austria", value: "aut"}
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
          </div>
        </Layouts.app>
        """
      end
    end
    '''
  end

  def api_set_value_client_binding_code do
    ~S"""
    <.action phx-click={Corex.Listbox.set_value("listbox-api-sv-client", ["bel"])}>Belgium</.action>
    <.action phx-click={Corex.Listbox.set_value("listbox-api-sv-client", [])}>Clear</.action>
    <.listbox id="listbox-api-sv-client" class="listbox" items={
      Corex.List.new([
        %{label: "France", value: "fra"},
        %{label: "Belgium", value: "bel"},
        %{label: "Germany", value: "deu"},
        %{label: "Netherlands", value: "nld"},
        %{label: "Switzerland", value: "che"},
        %{label: "Austria", value: "aut"}
      ])
    }>
      <:label>Choose a country</:label>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.listbox>
    """
  end

  def api_set_value_server_heex do
    ~S"""
    <.action phx-click="listbox_api_set_value">Belgium</.action>
    <.listbox id="listbox-api-sv-server" class="listbox" items={
      Corex.List.new([
        %{label: "France", value: "fra"},
        %{label: "Belgium", value: "bel"},
        %{label: "Germany", value: "deu"},
        %{label: "Netherlands", value: "nld"},
        %{label: "Switzerland", value: "che"},
        %{label: "Austria", value: "aut"}
      ])
    }>
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
    <.listbox id="listbox-api-val-client" class="listbox" items={
      Corex.List.new([
        %{label: "France", value: "fra"},
        %{label: "Belgium", value: "bel"},
        %{label: "Germany", value: "deu"},
        %{label: "Netherlands", value: "nld"},
        %{label: "Switzerland", value: "che"},
        %{label: "Austria", value: "aut"}
      ])
    }>
      <:label>Choose a country</:label>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.listbox>
    """
  end

  def api_value_server_heex do
    ~S"""
    <.action phx-click="listbox_api_value_server">Read selection</.action>
    <.listbox id="listbox-api-val-server" class="listbox" items={
      Corex.List.new([
        %{label: "France", value: "fra"},
        %{label: "Belgium", value: "bel"},
        %{label: "Germany", value: "deu"},
        %{label: "Netherlands", value: "nld"},
        %{label: "Switzerland", value: "che"},
        %{label: "Austria", value: "aut"}
      ])
    }>
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

    def handle_event("listbox_value_response", _params, socket) do
      {:noreply, socket}
    end
    """
  end

  def events_server_heex do
    ~S"""
    <.listbox
      id="listbox-events-server"
      class="listbox"
      items={
        Corex.List.new([
          %{label: "France", value: "fra"},
          %{label: "Belgium", value: "bel"},
          %{label: "Germany", value: "deu"},
          %{label: "Netherlands", value: "nld"},
          %{label: "Switzerland", value: "che"},
          %{label: "Austria", value: "aut"}
        ])
      }
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
      items={
        Corex.List.new([
          %{label: "France", value: "fra"},
          %{label: "Belgium", value: "bel"},
          %{label: "Germany", value: "deu"},
          %{label: "Netherlands", value: "nld"},
          %{label: "Switzerland", value: "che"},
          %{label: "Austria", value: "aut"}
        ])
      }
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
