defmodule E2eWeb.TabsPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1, playground_dir_toggle: 1]

  alias Corex.Tabs

  @tabs_id "tabs-playground"

  defp item_values, do: ~W(lorem duis donec)

  defp tab_items(disabled_items) do
    Corex.Content.new([
      %{
        value: "lorem",
        label: "Lorem",
        content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique.",
        disabled: "lorem" in disabled_items
      },
      %{
        value: "duis",
        label: "Duis",
        content: "Nullam eget vestibulum ligula, at interdum tellus.",
        disabled: "duis" in disabled_items
      },
      %{
        value: "donec",
        label: "Donec",
        content: "Congue molestie ipsum gravida a. Sed ac eros luctus.",
        disabled: "donec" in disabled_items
      }
    ])
  end

  @impl true
  def mount(_params, _session, socket) do
    disabled_items = []

    {:ok,
     socket
     |> assign(:vertical, false)
     |> assign(:dir, "ltr")
     |> assign(:disabled_items, disabled_items)
     |> assign(:disabled_select_items, disabled_select_items())
     |> assign(:tab_value, "lorem")
     |> assign(:items, tab_items(disabled_items))}
  end

  @impl true
  def handle_event("control_changed", %{"value" => [value], "id" => "dir"}, socket)
      when is_binary(value) do
    {:noreply, assign(socket, :dir, value)}
  end

  @impl true
  def handle_event("control_changed", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("vertical_changed", %{"checked" => checked, "id" => _}, socket) do
    {:noreply, assign(socket, :vertical, checked == true or checked == "true")}
  end

  @impl true
  def handle_event("disabled_items_changed", %{"value" => value}, socket) when is_list(value) do
    {:noreply, sync_items(socket, value)}
  end

  @impl true
  def handle_event("disabled_items_changed", _params, socket) do
    {:noreply, sync_items(socket, [])}
  end

  @impl true
  def handle_event("tab_value_changed", %{"value" => value}, socket) when is_binary(value) do
    {:noreply, assign(socket, :tab_value, value)}
  end

  defp sync_items(socket, disabled_items) do
    current = socket.assigns.tab_value

    next_value =
      if current in disabled_items do
        Enum.find(item_values(), &(&1 not in disabled_items)) || hd(item_values())
      else
        current
      end

    socket =
      socket
      |> assign(:disabled_items, disabled_items)
      |> assign(:items, tab_items(disabled_items))
      |> assign(:tab_value, next_value)

    if next_value != current do
      Tabs.set_value(socket, @tabs_id, next_value)
    else
      socket
    end
  end

  defp disabled_select_items do
    [
      %{label: "Lorem", value: "lorem"},
      %{label: "Duis", value: "duis"},
      %{label: "Donec", value: "donec"}
    ]
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
      <.demo_playground path={@path} title="Tabs · Playground" heading_class="layout-heading">
        <:controls>
          <.playground_dir_toggle id="dir" on_value_change="control_changed" value={[@dir]} />
          <.switch
            class="switch switch--sm"
            id="playground-tabs-vertical"
            checked={@vertical}
            on_checked_change="vertical_changed"
          >
            <:label>Vertical</:label>
          </.switch>
          <.select
            id="playground-disabled-items"
            class="select select--sm w-4xs"
            multiple
            deselectable={true}
            close_on_select={false}
            value={@disabled_items}
            items={@disabled_select_items}
            on_value_change="disabled_items_changed"
            translation={%Corex.Select.Translation{placeholder: "Select items"}}
            positioning={%Corex.Positioning{same_width: true}}
          >
            <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
            <:label>Disabled items</:label>
          </.select>
        </:controls>
        <:canvas>
          <.tabs
            id="tabs-playground"
            class="tabs w-full"
            controlled
            value={@tab_value}
            on_value_change="tab_value_changed"
            dir={@dir}
            orientation={if(@vertical, do: "vertical", else: "horizontal")}
            items={@items}
          />
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
