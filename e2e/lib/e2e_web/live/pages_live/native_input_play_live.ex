defmodule E2eWeb.NativeInputPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1, playground_dir_toggle: 1]
  import E2eWeb.Demos.NativeInputFormFields, only: [anatomy_all_fields: 1]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :dir, "ltr")}
  end

  @impl true
  def handle_event("control_changed", %{"value" => [value], "id" => "dir"}, socket) do
    {:noreply, assign(socket, :dir, value)}
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
        id="native-input-playground"
        path={@path}
        title="Native Input · Playground"
        heading_class="layout-heading"
      >
        <:controls>
          <.playground_dir_toggle
            id="dir"
            on_value_change="control_changed"
            value={[@dir]}
          />
        </:controls>
        <:canvas>
          <div class="w-full max-w-lg max-h-[70vh] overflow-y-auto scrollbar scrollbar--size-sm">
            <.anatomy_all_fields
              id_prefix="native-input-playground"
              input_class="native-input native-input--max-w-md w-full"
              dir={@dir}
            />
          </div>
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
