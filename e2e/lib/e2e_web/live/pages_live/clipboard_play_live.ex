defmodule E2eWeb.ClipboardPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1, playground_dir_toggle: 1]

  alias Corex.Clipboard

  @impl true
  def mount(_params, _session, socket) do
    controls = %{dir: "ltr", orientation: "horizontal"}

    {:ok,
     socket
     |> assign(:controls, controls)
     |> assign(:clipboard_value, "info@netoum.com")}
  end

  @impl true
  def handle_event("control_changed", %{"value" => [value], "id" => id}, socket) do
    {:noreply, update_control(socket, id, value)}
  end

  @impl true
  def handle_event("clipboard_play_changed", params, socket) do
    v = string_param(params, "clipboard_value", socket.assigns.clipboard_value)
    socket = assign(socket, :clipboard_value, v)

    {:noreply, Clipboard.set_value(socket, "clipboard-playground", v)}
  end

  defp string_param(params, key, default) do
    case Map.get(params, key) do
      v when is_binary(v) -> v
      _ -> default
    end
  end

  defp update_control(socket, "dir", value),
    do: update(socket, :controls, &%{&1 | dir: value})

  defp update_control(socket, "orientation", value),
    do: update(socket, :controls, &%{&1 | orientation: value})

  defp update_control(socket, _, _), do: socket

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_playground path={@path} title="Clipboard · Playground" heading_class="layout-heading">
        <:controls>
          <.playground_dir_toggle
            id="dir"
            on_value_change="control_changed"
            value={[@controls.dir]}
          />

          <.toggle_group
            class="toggle-group toggle-group--sm toggle--max-w-7xs"
            id="orientation"
            on_value_change="control_changed"
            multiple={false}
            deselectable={false}
            value={[@controls.orientation]}
          >
            <:item value="vertical" aria_label="Vertical orientation">
              <.heroicon name="hero-arrows-up-down" />
            </:item>
            <:item value="horizontal" aria_label="Horizontal orientation">
              <.heroicon name="hero-arrows-right-left" />
            </:item>
          </.toggle_group>

          <form
            phx-change="clipboard_play_changed"
            phx-submit="clipboard_play_changed"
            id="clipboard-play-form"
            class="flex flex-col gap-4 w-full max-w-md"
          >
            <.native_input
              type="text"
              id="clipboard-play-value"
              name="clipboard_value"
              value={@clipboard_value}
              class="native-input native-input--sm w-full"
            >
              <:label>Value to copy</:label>
            </.native_input>
          </form>
        </:controls>
        <:canvas>
          <.clipboard
            id="clipboard-playground"
            value={@clipboard_value}
            trigger_aria_label="Copy to clipboard"
            input_aria_label="Value to copy"
            dir={@controls.dir}
            orientation={@controls.orientation}
          >
            <:label>Copy</:label>
            <:copy>
              <.heroicon name="hero-clipboard" />
            </:copy>
            <:copied>
              <.heroicon name="hero-check" />
            </:copied>
          </.clipboard>
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
