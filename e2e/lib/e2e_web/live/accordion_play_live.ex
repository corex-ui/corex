defmodule E2eWeb.AccordionPlayLive do
  use E2eWeb, :live_view

  defp accordion_items(controls) do
    all_disabled = Map.get(controls, :disabled, false)

    Corex.Content.new([
      [
        id: "lorem",
        trigger: "Lorem ipsum dolor sit amet",
        content: "Consectetur adipiscing elit.",
        disabled: all_disabled || Map.get(controls, :disabled_lorem, false)
      ],
      [
        id: "ipsum",
        trigger: "Duis dictum gravida odio ac pharetra?",
        content: "Nullam eget vestibulum ligula.",
        disabled: all_disabled
      ],
      [
        id: "dolor",
        trigger: "Donec condimentum ex mi",
        content: "Congue molestie ipsum gravida a.",
        disabled: all_disabled
      ]
    ])
  end

  @impl true
  def mount(_params, _session, socket) do
    controls = %{
      disabled: false,
      disabled_lorem: false,
      orientation: "vertical",
      collapsible: true,
      multiple: true,
      dir: "ltr"
    }

    socket =
      socket
      |> assign(:controls, controls)
      |> assign(:items, accordion_items(controls))

    {:ok, socket}
  end

  @impl true
  def handle_event(
        "control_changed",
        %{"checked" => checked, "id" => id},
        socket
      ) do
    {:noreply, update_control(socket, id, checked)}
  end

  def handle_event(
        "control_changed",
        %{"value" => [value], "id" => id},
        socket
      ) do
    {:noreply, update_control(socket, id, value)}
  end

  defp update_control(socket, "disabled", checked) do
    new_controls = Map.put(socket.assigns.controls, :disabled, checked)

    socket
    |> assign(:controls, new_controls)
    |> assign(:items, accordion_items(new_controls))
  end

  defp update_control(socket, "disabled_lorem", checked) do
    new_controls = Map.put(socket.assigns.controls, :disabled_lorem, checked)

    socket
    |> assign(:controls, new_controls)
    |> assign(:items, accordion_items(new_controls))
  end

  defp update_control(socket, "orientation", value) do
    update(socket, :controls, &Map.put(&1, :orientation, value))
  end

  defp update_control(socket, "dir", value) do
    update(socket, :controls, &Map.put(&1, :dir, value))
  end

  defp update_control(socket, _unknown, _checked), do: socket

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} locale={@locale} current_path={@current_path}>
      <div class="layout__row">
        <h1>Accordion</h1>
        <h2>Playground</h2>
      </div>

      <div class="flex flex-col gap-ui-gap">
        <.switch
          class="switch"
          id="disabled"
          on_checked_change="control_changed"
        >
          <:label>Disable All</:label>
        </.switch>

        <.switch
          class="switch"
          id="disabled_lorem"
          on_checked_change="control_changed"
        >
          <:label>Disable “Lorem” Item</:label>
        </.switch>

        <.toggle_group
          class="toggle-group"
          id="dir"
          on_value_change="control_changed"
          multiple={false}
          deselectable={false}
          value={[@controls.dir]}
        >
          <:item value="ltr">
            LTR
          </:item>

          <:item value="rtl">
            RTL
          </:item>
        </.toggle_group>

        <.toggle_group
          class="toggle-group"
          id="orientation"
          on_value_change="control_changed"
          multiple={false}
          deselectable={false}
          value={["vertical"]}
        >
          <:item value="horizontal">
            <.icon name="hero-arrows-right-left" />
          </:item>

          <:item value="vertical">
            <.icon name="hero-arrows-up-down" />
          </:item>
        </.toggle_group>
      </div>

      <.accordion
        id="my-accordion"
        class="accordion"
        items={@items}
        multiple
        orientation={@controls.orientation}
        dir={@controls.dir}
      >
        <:indicator :let={_item}>
          <.icon name="hero-chevron-right" />
        </:indicator>
      </.accordion>
    </Layouts.app>
    """
  end
end
