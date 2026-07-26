defmodule E2eWeb.ListboxPatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.ListboxDemo, as: Demo

  @initial_items [
    %{value: "1", label: "Apple"},
    %{value: "2", label: "Banana"},
    %{value: "3", label: "Cherry"}
  ]

  @initial_grouped_items [
    %{value: "g1", label: "France", group: "Europe"},
    %{value: "g2", label: "Japan", group: "Asia"},
    %{value: "g3", label: "Germany", group: "Europe"}
  ]

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:items, @initial_items)
     |> assign(:grouped_items, @initial_grouped_items)
     |> assign(:next_id, 4)
     |> assign(:next_grouped_id, 4)
     |> assign(:listbox_controlled_value, ["fra", "bel"])}
  end

  def handle_event("add_item", _params, socket) do
    id = to_string(socket.assigns.next_id)
    item = %{value: id, label: "Item #{id}"}

    {:noreply,
     socket
     |> assign(:items, socket.assigns.items ++ [item])
     |> assign(:next_id, socket.assigns.next_id + 1)}
  end

  def handle_event("reset", _params, socket) do
    {:noreply, socket |> assign(:items, @initial_items) |> assign(:next_id, 4)}
  end

  def handle_event("add_to_group", %{"group" => group}, socket) do
    id = "g#{socket.assigns.next_grouped_id}"
    item = %{value: id, label: "Item #{socket.assigns.next_grouped_id}", group: group}

    {:noreply,
     socket
     |> assign(:grouped_items, socket.assigns.grouped_items ++ [item])
     |> assign(:next_grouped_id, socket.assigns.next_grouped_id + 1)}
  end

  def handle_event("reset_grouped", _params, socket) do
    {:noreply,
     socket
     |> assign(:grouped_items, @initial_grouped_items)
     |> assign(:next_grouped_id, 4)}
  end

  def handle_event("listbox_patterns_controlled_value", %{"value" => value}, socket)
      when is_list(value) do
    {:noreply, assign(socket, :listbox_controlled_value, value)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_page
        path={@path}
        id="listbox-patterns-page"
        title={~t"Listbox · Patterns"}
        subtitle={~t"Dynamic items and server-controlled selection."}
      >
        <.demo_section
          id="listbox-patterns-dynamic"
          title={~t"Dynamic items"}
          code_tabs={[
            %{
              value: "heex",
              label: ~t"Heex",
              language: :heex,
              code: Demo.patterns_dynamic_demo_heex()
            },
            %{
              value: "elixir",
              label: ~t"Elixir",
              language: :elixir,
              code: Demo.patterns_dynamic_elixir()
            }
          ]}
        >
          <:preview>
            <div class="flex flex-wrap gap-2 items-center w-full justify-center">
              <.action phx-click="add_item" class="button ui-size-sm ui-accent">
                <.heroicon name="hero-plus" /> Add item
              </.action>
              <.action phx-click="reset" class="button ui-size-sm ui-alert">
                Reset
              </.action>
            </div>
            <.listbox id="patterns-dynamic" class="listbox" items={Corex.List.new(@items)}>
              <:label>Choose an item</:label>
              <:empty>No items</:empty>
              <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
            </.listbox>
          </:preview>
        </.demo_section>

        <.demo_section
          id="listbox-patterns-dynamic-grouped"
          title={~t"Dynamic grouped"}
          code_tabs={[
            %{
              value: "heex",
              label: ~t"Heex",
              language: :heex,
              code: Demo.patterns_dynamic_grouped_demo_heex()
            },
            %{
              value: "elixir",
              label: ~t"Elixir",
              language: :elixir,
              code: Demo.patterns_dynamic_grouped_elixir()
            }
          ]}
        >
          <:preview>
            <div class="flex flex-wrap gap-2 items-center w-full justify-center">
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
              id="patterns-dynamic-grouped"
              class="listbox"
              items={Corex.List.new(@grouped_items)}
            >
              <:label>Choose a country</:label>
              <:empty>No items</:empty>
              <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
            </.listbox>
          </:preview>
        </.demo_section>

        <.demo_section
          id="listbox-patterns-controlled"
          title={~t"Controlled (value)"}
          code_tabs={[
            %{
              value: "heex",
              label: ~t"Heex",
              language: :heex,
              code: Demo.patterns_controlled_heex()
            },
            %{
              value: "elixir",
              label: ~t"Elixir",
              language: :elixir,
              code: Demo.patterns_controlled_elixir()
            }
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-3 w-full items-center">
              <div class="w-full max-w-md">
                <.listbox
                  id="listbox-patterns-controlled-field"
                  class="listbox"
                  items={Demo.items_minimal()}
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
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
