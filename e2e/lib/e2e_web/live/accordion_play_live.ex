defmodule E2eWeb.AccordionPlayLive do
  use E2eWeb, :live_view

  @default_controls %{
    disabled: false,
    disabled_lorem: false,
    orientation: "vertical",
    collapsible: true,
    multiple: true,
    dir: "ltr"
  }

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, controls: @default_controls)}
  end

  @impl true
  def handle_event(
        "control_changed",
        %{"checked" => checked, "switch_id" => id},
        socket
      ) do
    {:noreply, update_control(socket, id, checked)}
  end

  def handle_event(
        "control_changed",
        %{"value" => [value], "toggle_group_id" => id},
        socket
      ) do
    {:noreply, update_control(socket, id, value)}
  end

  defp update_control(socket, "disabled", checked) do
    update(socket, :controls, &Map.put(&1, :disabled, checked))
  end

  defp update_control(socket, "disabled_lorem", checked) do
    update(socket, :controls, &Map.put(&1, :disabled_lorem, checked))
  end

  defp update_control(socket, "rtl", true) do
    update(socket, :controls, &Map.put(&1, :dir, "rtl"))
  end

  defp update_control(socket, "rtl", false) do
    update(socket, :controls, &Map.put(&1, :dir, "ltr"))
  end

  defp update_control(socket, "orientation", true) do
    update(socket, :controls, &Map.put(&1, :orientation, "horizontal"))
  end

  defp update_control(socket, "orientation", false) do
    update(socket, :controls, &Map.put(&1, :orientation, "vertical"))
  end

  defp update_control(socket, "dir", value) do
    update(socket, :controls, &Map.put(&1, :dir, value))
  end

  defp update_control(socket, _unknown, _checked), do: socket

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
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
        >
          <:item value="ltr">
            LTR
          </:item>

          <:item value="rtl">
            RTL
          </:item>
        </.toggle_group>

        <.switch
          class="switch"
          id="orientation"
          on_checked_change="control_changed"
        >
          <:label>Horizontal</:label>
        </.switch>
      </div>

      <.accordion
        id="my-accordion"
        class="accordion"
        disabled={@controls.disabled}
        collapsible={@controls.collapsible}
        multiple={@controls.multiple}
        orientation={@controls.orientation}
        dir={@controls.dir}
      >
        <:item :let={item} value="lorem" disabled={@controls.disabled_lorem}>
          <.accordion_trigger item={item}>
            Lorem ipsum dolor sit amet
          </.accordion_trigger>
          <.accordion_content item={item}>
            Consectetur adipiscing elit.
          </.accordion_content>
        </:item>

        <:item :let={item} value="ipsum">
          <.accordion_trigger item={item}>
            Duis dictum gravida odio ac pharetra?
          </.accordion_trigger>
          <.accordion_content item={item}>
            Nullam eget vestibulum ligula.
          </.accordion_content>
        </:item>

        <:item :let={item} value="dolor">
          <.accordion_trigger item={item}>
            Donec condimentum ex mi
          </.accordion_trigger>
          <.accordion_content item={item}>
            Congue molestie ipsum gravida a.
          </.accordion_content>
        </:item>
      </.accordion>
    </Layouts.app>
    """
  end
end
