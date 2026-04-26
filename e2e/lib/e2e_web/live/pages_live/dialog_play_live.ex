defmodule E2eWeb.DialogPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1, playground_dir_toggle: 1]

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:close_on_escape, true)
      |> assign(:prevent_scroll, false)
      |> assign(:dir, "ltr")
      |> assign(:dir_select, ["ltr"])

    {:ok, socket}
  end

  @impl true
  def handle_event("close_on_escape_changed", %{"checked" => checked, "id" => _}, socket) do
    {:noreply, assign(socket, :close_on_escape, checked == true or checked == "true")}
  end

  @impl true
  def handle_event("prevent_scroll_changed", %{"checked" => checked, "id" => _}, socket) do
    {:noreply, assign(socket, :prevent_scroll, checked == true or checked == "true")}
  end

  @impl true
  def handle_event("dir_changed", %{"value" => value}, socket) when is_list(value) do
    v = List.first(value) || "ltr"
    {:noreply, socket |> assign(:dir, v) |> assign(:dir_select, [v])}
  end

  @impl true
  def handle_event("dir_changed", _params, socket) do
    {:noreply, socket}
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
      <.demo_playground title="Dialog · Playground" heading_class="layout-heading">
        <:controls>
          <.playground_dir_toggle
            id="dialog-playground-dir"
            on_value_change="dir_changed"
            value={@dir_select}
          />
          <.switch
            class="switch"
            id="close_on_escape"
            checked={@close_on_escape}
            on_checked_change="close_on_escape_changed"
          >
            <:label>Close on escape</:label>
          </.switch>
          <.switch
            class="switch"
            id="prevent_scroll"
            checked={@prevent_scroll}
            on_checked_change="prevent_scroll_changed"
          >
            <:label>Prevent scroll</:label>
          </.switch>
        </:controls>
        <:canvas>
          <.dialog
            id="dialog-playground"
            class="dialog"
            dir={@dir}
            close_on_escape={@close_on_escape}
            prevent_scroll={@prevent_scroll}
          >
            <:trigger>Open Dialog</:trigger>
            <:title>Dialog Title</:title>
            <:description>Dialog description.</:description>
            <:content>
              <p>Dialog content</p>
            </:content>
            <:close_trigger>
              <.heroicon name="hero-x-mark" class="icon" />
            </:close_trigger>
          </.dialog>
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
