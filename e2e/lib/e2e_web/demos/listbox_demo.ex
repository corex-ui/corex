defmodule E2eWeb.Demos.ListboxDemo do
  use E2eWeb, :html

  alias E2eWeb.DemoScales

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
    <.listbox class="listbox" items={
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
    <.listbox class="listbox" items={
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
    <.listbox class="listbox" items={
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
    <.listbox class="listbox" items={
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
        <Flagpack.flag name={String.to_existing_atom(to_string(entry.value))} />
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
        <Flagpack.flag name={String.to_existing_atom(to_string(entry.value))} />
        {entry.label}
      </:item>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.listbox>
    """
  end

  def anatomy_extended_grouped_code do
    ~S"""
    <.listbox
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
        <Flagpack.flag name={String.to_existing_atom(to_string(entry.value))} />
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
        <Flagpack.flag name={String.to_existing_atom(to_string(entry.value))} />
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
        <.action phx-click="add_item" class="button ui-size-sm ui-accent">
          <.heroicon name="hero-plus" /> Add item
        </.action>
        <.action phx-click="reset" class="button ui-size-sm ui-alert">
          Reset
        </.action>
      </div>
      <.listbox class="listbox" items={Corex.List.new(@items_list)}>
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
        <div class="flex flex-col gap-3 w-full max-w-xl">
            <div class="flex flex-wrap gap-2">
              <.action phx-click="add_item" class="button ui-size-sm ui-accent">
                <.heroicon name="hero-plus" /> Add item
              </.action>
              <.action phx-click="reset" class="button ui-size-sm ui-alert">
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
          class="button ui-size-sm ui-accent"
        >
          <.heroicon name="hero-plus" /> Add to Europe
        </.action>
        <.action
          phx-click="add_to_group"
          phx-value-group="Asia"
          class="button ui-size-sm ui-accent"
        >
          <.heroicon name="hero-plus" /> Add to Asia
        </.action>
        <.action phx-click="reset_grouped" class="button ui-size-sm ui-alert">
          Reset
        </.action>
      </div>
      <.listbox
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
        <div class="flex flex-col gap-3 w-full max-w-xl">
            <div class="flex flex-wrap gap-2">
              <.action
                phx-click="add_to_group"
                phx-value-group="Europe"
                class="button ui-size-sm ui-accent"
              >
                <.heroicon name="hero-plus" /> Add to Europe
              </.action>
              <.action
                phx-click="add_to_group"
                phx-value-group="Asia"
                class="button ui-size-sm ui-accent"
              >
                <.heroicon name="hero-plus" /> Add to Asia
              </.action>
              <.action phx-click="reset_grouped" class="button ui-size-sm ui-alert">
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
    end
    '''
  end

  def patterns_controlled_heex do
    ~S"""
    <.listbox
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
    <div class="w-full min-w-0">
      <p class="text-sm text-ink-muted font-mono break-all text-center">
        value: {inspect(@listbox_controlled_value)}
      </p>
    </div>
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
        <div class="flex flex-col gap-3 w-full items-center">
          <div class="w-full max-w-md">
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
          </div>
          <div class="w-full min-w-0" id="listbox-patterns-controlled-state">
            <p class="text-sm text-ink-muted font-mono break-all text-center">
              value: {inspect(@listbox_controlled_value)}
            </p>
          </div>
        </div>
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
    E2eWeb.Demos.DocExamples.event_handler_snippet(
      "listbox_value_changed",
      ~S|%{"id" => id, "value" => value} = params|
    )
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

  defp styling_items_attr do
    ~S|items={Corex.List.new([%{label: "France", value: "fra"}, %{label: "Belgium", value: "bel"}, %{label: "Germany", value: "deu"}, %{label: "Netherlands", value: "nld"}])}|
  end

  defp styling_value_attr do
    ~S|value={["fra"]}|
  end

  def styling_color_code do
    items = styling_items_attr()
    value = styling_value_attr()

    """
    <.listbox class="listbox" #{items} #{value}>
      <:label>Default</:label>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.listbox>
    <.listbox class="listbox ui-accent" #{items} #{value}>
      <:label>Accent</:label>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.listbox>
    <.listbox class="listbox ui-brand" #{items} #{value}>
      <:label>Brand</:label>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.listbox>
    <.listbox class="listbox ui-alert" #{items} #{value}>
      <:label>Alert</:label>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.listbox>
    <.listbox class="listbox ui-info" #{items} #{value}>
      <:label>Info</:label>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.listbox>
    <.listbox class="listbox ui-success" #{items} #{value}>
      <:label>Success</:label>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.listbox>
    """
  end

  def styling_color_example(assigns) do
    assigns =
      assigns
      |> assign(:items, items_minimal())
      |> assign(:value, ["fra"])

    ~H"""
    <div class="flex flex-col gap-4 w-full max-w-md">
      <.listbox id="listbox-style-color-default" class="listbox" items={@items} value={@value}>
        <:label>Default</:label>
        <:item_indicator><.heroicon name="hero-check" class="icon" /></:item_indicator>
      </.listbox>
      <.listbox
        id="listbox-style-color-accent"
        class="listbox ui-accent"
        items={@items}
        value={@value}
      >
        <:label>Accent</:label>
        <:item_indicator><.heroicon name="hero-check" class="icon" /></:item_indicator>
      </.listbox>
      <.listbox
        id="listbox-style-color-brand"
        class="listbox ui-brand"
        items={@items}
        value={@value}
      >
        <:label>Brand</:label>
        <:item_indicator><.heroicon name="hero-check" class="icon" /></:item_indicator>
      </.listbox>
      <.listbox
        id="listbox-style-color-alert"
        class="listbox ui-alert"
        items={@items}
        value={@value}
      >
        <:label>Alert</:label>
        <:item_indicator><.heroicon name="hero-check" class="icon" /></:item_indicator>
      </.listbox>
      <.listbox
        id="listbox-style-color-info"
        class="listbox ui-info"
        items={@items}
        value={@value}
      >
        <:label>Info</:label>
        <:item_indicator><.heroicon name="hero-check" class="icon" /></:item_indicator>
      </.listbox>
      <.listbox
        id="listbox-style-color-success"
        class="listbox ui-success"
        items={@items}
        value={@value}
      >
        <:label>Success</:label>
        <:item_indicator><.heroicon name="hero-check" class="icon" /></:item_indicator>
      </.listbox>
    </div>
    """
  end

  def styling_variant_code do
    items = styling_items_attr()
    value = styling_value_attr()

    """
    <.listbox class="listbox" #{items} #{value}>
      <:label>Subtle (default)</:label>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.listbox>
    <.listbox class="listbox ui-solid" #{items} #{value}>
      <:label>Solid</:label>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.listbox>

    """
  end

  def styling_variant_example(assigns) do
    assigns =
      assigns
      |> assign(:items, items_minimal())
      |> assign(:value, ["fra"])

    ~H"""
    <div class="flex flex-wrap gap-6 items-start w-full max-w-4xl">
      <.listbox id="listbox-style-variant-subtle" class="listbox" items={@items} value={@value}>
        <:label>Subtle (default)</:label>
        <:item_indicator><.heroicon name="hero-check" class="icon" /></:item_indicator>
      </.listbox>
      <.listbox
        id="listbox-style-variant-solid"
        class="listbox ui-solid"
        items={@items}
        value={@value}
      >
        <:label>Solid</:label>
        <:item_indicator><.heroicon name="hero-check" class="icon" /></:item_indicator>
      </.listbox>
    </div>
    """
  end

  def styling_variant_matrix_code do
    items = styling_items_attr()
    value = styling_value_attr()

    for semantic <- DemoScales.styling_semantic_axis_steps("listbox"),
        variant <- DemoScales.styling_variant_axis_steps("listbox") do
      class = DemoScales.join_matrix_modifiers("listbox", semantic.modifier, variant.modifier)

      """
      <.listbox class="#{class}" #{items} #{value}>
        <:label>#{semantic.label}</:label>
        <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
      </.listbox>
      """
    end
    |> DemoScales.join_code()
  end

  def styling_variant_matrix_example(assigns) do
    assigns =
      assigns
      |> assign(:items, items_minimal())
      |> assign(:value, ["fra"])
      |> assign(:matrix_semantics, DemoScales.styling_semantic_axis_steps("listbox"))
      |> assign(:matrix_variants, DemoScales.styling_variant_axis_steps("listbox"))

    ~H"""
    <div class="w-full overflow-x-auto scrollbar scrollbar--sm">
      <div class="grid grid-cols-4 gap-space items-start min-w-max">
        <div :for={semantic <- @matrix_semantics} class="contents">
          <.listbox
            :for={variant <- @matrix_variants}
            class={DemoScales.join_matrix_modifiers("listbox", semantic.modifier, variant.modifier)}
            items={@items}
            value={@value}
          >
            <:label>{semantic.label}</:label>
            <:item_indicator><.heroicon name="hero-check" class="icon" /></:item_indicator>
          </.listbox>
        </div>
      </div>
    </div>
    """
  end

  def styling_size_code do
    items = styling_items_attr()

    """
    <.listbox class="listbox ui-size-sm" #{items}>
      <:label>SM</:label>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.listbox>
    <.listbox class="listbox ui-size-md" #{items}>
      <:label>MD</:label>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.listbox>
    <.listbox class="listbox ui-size-lg" #{items}>
      <:label>LG</:label>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.listbox>
    <.listbox class="listbox ui-size-xl" #{items}>
      <:label>XL</:label>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.listbox>
    """
  end

  def styling_size_example(assigns) do
    assigns = assign(assigns, :items, items_minimal())

    ~H"""
    <div class="flex flex-col gap-4 w-full max-w-md">
      <.listbox id="listbox-style-size-sm" class="listbox ui-size-sm" items={@items}>
        <:label>SM</:label>
        <:item_indicator><.heroicon name="hero-check" class="icon" /></:item_indicator>
      </.listbox>
      <.listbox id="listbox-style-size-md" class="listbox ui-size-md" items={@items}>
        <:label>MD</:label>
        <:item_indicator><.heroicon name="hero-check" class="icon" /></:item_indicator>
      </.listbox>
      <.listbox id="listbox-style-size-lg" class="listbox ui-size-lg" items={@items}>
        <:label>LG</:label>
        <:item_indicator><.heroicon name="hero-check" class="icon" /></:item_indicator>
      </.listbox>
      <.listbox id="listbox-style-size-xl" class="listbox ui-size-xl" items={@items}>
        <:label>XL</:label>
        <:item_indicator><.heroicon name="hero-check" class="icon" /></:item_indicator>
      </.listbox>
    </div>
    """
  end

  def styling_max_width_code do
    items = styling_items_attr()
    value = styling_value_attr()

    slots = """
      <:label>Label</:label>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    """

    DemoScales.max_width_variants("listbox")
    |> Enum.map(fn %{modifier: modifier} ->
      class = DemoScales.join_modifiers("listbox", modifier)

      """
      <.listbox class="#{class}" #{items} #{value}>
      #{slots}
      </.listbox>
      """
    end)
    |> DemoScales.join_code()
  end

  def styling_max_width_example(assigns) do
    assigns =
      assigns
      |> assign(:items, items_minimal())
      |> assign(:value, ["fra"])
      |> assign(:max_width_variants, DemoScales.max_width_variants("listbox"))

    ~H"""
    <div class={DemoScales.preview_scroll_class()}>
      <div :for={variant <- @max_width_variants} class="flex flex-col gap-2">
        <p class="typo ui-size-sm font-medium">{variant.label}</p>
        <.listbox
          id={"listbox-style-max-#{variant.id}"}
          class={DemoScales.join_modifiers("listbox", variant.modifier)}
          items={@items}
          value={@value}
        >
          <:label>{variant.label}</:label>
          <:item_indicator><.heroicon name="hero-check" class="icon" /></:item_indicator>
        </.listbox>
      </div>
    </div>
    """
  end

  def styling_rounded_code do
    items = styling_items_attr()

    """
    <.listbox class="listbox ui-rounded-none" #{items}>
      <:label>None</:label>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.listbox>
    <.listbox class="listbox ui-rounded-md" #{items}>
      <:label>MD</:label>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.listbox>
    <.listbox class="listbox ui-rounded-lg" #{items}>
      <:label>LG</:label>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.listbox>
    <.listbox class="listbox ui-rounded-xl" #{items}>
      <:label>XL</:label>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.listbox>
    <.listbox class="listbox ui-rounded-full" #{items}>
      <:label>Full</:label>
      <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
    </.listbox>
    """
  end

  def styling_rounded_example(assigns) do
    assigns = assign(assigns, :items, items_minimal())

    ~H"""
    <div class="flex flex-col gap-4 w-full max-w-md">
      <.listbox id="listbox-style-rounded-none" class="listbox ui-rounded-none" items={@items}>
        <:label>None</:label>
        <:item_indicator><.heroicon name="hero-check" class="icon" /></:item_indicator>
      </.listbox>
      <.listbox id="listbox-style-rounded-md" class="listbox ui-rounded-md" items={@items}>
        <:label>MD</:label>
        <:item_indicator><.heroicon name="hero-check" class="icon" /></:item_indicator>
      </.listbox>
      <.listbox id="listbox-style-rounded-lg" class="listbox ui-rounded-lg" items={@items}>
        <:label>LG</:label>
        <:item_indicator><.heroicon name="hero-check" class="icon" /></:item_indicator>
      </.listbox>
      <.listbox id="listbox-style-rounded-xl" class="listbox ui-rounded-xl" items={@items}>
        <:label>XL</:label>
        <:item_indicator><.heroicon name="hero-check" class="icon" /></:item_indicator>
      </.listbox>
      <.listbox id="listbox-style-rounded-full" class="listbox ui-rounded-full" items={@items}>
        <:label>Full</:label>
        <:item_indicator><.heroicon name="hero-check" class="icon" /></:item_indicator>
      </.listbox>
    </div>
    """
  end
end
