defmodule E2eWeb.SignaturePlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1, playground_dir_toggle: 1]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :controls, %{dir: "ltr"})}
  end

  @impl true
  def handle_event(
        "control_changed",
        %{"value" => [value], "id" => "signature-playground-dir"},
        socket
      ) do
    {:noreply, update(socket, :controls, &%{&1 | dir: value})}
  end

  @impl true
  def handle_event("draw_end", _payload, socket) do
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
      <.demo_playground title="Signature Pad · Playground" heading_class="layout-heading">
        <:controls>
          <.playground_dir_toggle
            id="signature-playground-dir"
            on_value_change="control_changed"
            value={[@controls.dir]}
          />
        </:controls>
        <:canvas>
          <.signature_pad
            id="signature-playground"
            class="signature-pad"
            on_draw_end="draw_end"
            dir={@controls.dir}
          >
            <:label>Sign here</:label>
            <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
          </.signature_pad>
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
