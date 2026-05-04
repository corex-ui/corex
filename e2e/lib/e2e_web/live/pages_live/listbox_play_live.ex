defmodule E2eWeb.ListboxPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1, playground_dir_toggle: 1]

  alias Corex.Listbox

  @listbox_id "listbox-play"

  defp country_rows do
    [
      {"fra", "France"},
      {"bel", "Belgium"},
      {"deu", "Germany"},
      {"nld", "Netherlands"},
      {"che", "Switzerland"},
      {"aut", "Austria"}
    ]
  end

  defp listbox_items(controls) do
    disabled = Map.get(controls, :disabled_items, [])

    Corex.List.new(
      for {id, label} <- country_rows() do
        %{id: id, label: label, disabled: id in disabled}
      end
    )
  end

  defp disabled_select_items do
    for {id, label} <- country_rows(), do: %{label: label, id: id}
  end

  defp playground_listbox_reset_value(controls) do
    disabled = Map.get(controls, :disabled_items, [])

    case Enum.find(country_rows(), fn {id, _} -> id not in disabled end) do
      nil -> []
      {id, _} -> [id]
    end
  end

  @impl true
  def mount(_params, _session, socket) do
    controls = %{
      disabled_items: [],
      orientation: "vertical",
      dir: "ltr"
    }

    socket =
      socket
      |> assign(:controls, controls)
      |> assign(:disabled_select_items, disabled_select_items())
      |> assign(:items, listbox_items(controls))
      |> assign(:playground_listbox_id, @listbox_id)

    {:ok, socket}
  end

  @impl true
  def handle_event("control_changed", %{"value" => [value], "id" => id}, socket) do
    {:noreply, update_control(socket, control_id(id), value)}
  end

  def handle_event("disabled_items_changed", %{"value" => value}, socket) when is_list(value) do
    {:noreply,
     socket
     |> update(:controls, &%{&1 | disabled_items: value})
     |> sync_items()
     |> push_playground_listbox_value()}
  end

  def handle_event("disabled_items_changed", _params, socket) do
    {:noreply,
     socket
     |> update(:controls, &%{&1 | disabled_items: []})
     |> sync_items()
     |> push_playground_listbox_value()}
  end

  defp update_control(socket, "orientation", value) do
    socket
    |> update(:controls, &%{&1 | orientation: value})
    |> sync_items()
  end

  defp update_control(socket, "dir", value) do
    update(socket, :controls, &%{&1 | dir: value})
  end

  defp update_control(socket, _unknown, _value), do: socket

  defp control_id("dir"), do: "dir"
  defp control_id("orientation"), do: "orientation"
  defp control_id(id), do: id

  defp sync_items(socket) do
    assign(socket, :items, listbox_items(socket.assigns.controls))
  end

  defp push_playground_listbox_value(socket) do
    Listbox.set_value(
      socket,
      @listbox_id,
      playground_listbox_reset_value(socket.assigns.controls)
    )
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_playground
        id="listbox-playground-page"
        title="Listbox · Playground"
        heading_class="layout-heading"
      >
        <:controls>
          <.playground_dir_toggle
            id="dir"
            on_value_change="control_changed"
            value={[@controls.dir]}
          />

          <.toggle_group
            class="toggle-group toggle-group--sm max-w-7xs"
            id="orientation"
            on_value_change="control_changed"
            multiple={false}
            deselectable={false}
            value={[@controls.orientation]}
          >
            <:item value="vertical" aria_label="Vertical orientation">
              <.heroicon name="hero-arrows-up-down" class="icon icon--lg" />
            </:item>
            <:item value="horizontal" aria_label="Horizontal orientation">
              <.heroicon name="hero-arrows-right-left" class="icon icon--lg" />
            </:item>
          </.toggle_group>

          <.select
            id="playground-disabled-items"
            class="select select--accent w-4xs"
            positioning={%Corex.Positioning{same_width: true}}
            multiple
            deselectable={true}
            close_on_select={false}
            value={@controls.disabled_items}
            items={@disabled_select_items}
            on_value_change="disabled_items_changed"
            translation={%Corex.Select.Translation{placeholder: "Select items"}}
          >
            <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
            <:label>Disabled items</:label>
          </.select>
        </:controls>
        <:canvas>
          <.listbox
            id={@playground_listbox_id}
            class="listbox"
            items={@items}
            orientation={@controls.orientation}
            dir={@controls.dir}
          >
            <:label>Choose a country</:label>
            <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
          </.listbox>
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
