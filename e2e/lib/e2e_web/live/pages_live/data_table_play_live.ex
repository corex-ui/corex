defmodule E2eWeb.DataTablePlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1, playground_dir_toggle: 1]

  alias E2eWeb.Demos.DataTableDemo, as: Demo

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:controls, %{dir: "ltr"})
     |> assign(:rows, Demo.playground_rows())}
  end

  @impl true
  def handle_event("control_changed", %{"value" => [value], "id" => id}, socket) do
    {:noreply, update_control(socket, control_id(id), value)}
  end

  defp update_control(socket, "dir", value) do
    update(socket, :controls, &%{&1 | dir: value})
  end

  defp update_control(socket, _id, _value), do: socket

  defp control_id("dir"), do: "dir"
  defp control_id(_), do: nil

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
        path={@path}
        id="data-table-playground"
        title="Data Table · Playground"
        heading_class="layout-heading"
      >
        <:controls>
          <.playground_dir_toggle
            id="dir"
            on_value_change="control_changed"
            value={[@controls.dir]}
          />
        </:controls>
        <:canvas>
          <.data_table
            id="data-table-playground-table"
            class="data-table max-w-none"
            dir={@controls.dir}
            rows={@rows}
          >
            <:col :let={row} label="ID">{row.id}</:col>
            <:col :let={row} label="Name">{row.name}</:col>
            <:col :let={row} label="Role">{row.role}</:col>
            <:col :let={row} label="Email">{row.email}</:col>
            <:action :let={row}>
              <.action class="button ui-size-sm" aria-label={"Edit #{row.name}"}>
                <.heroicon name="hero-pencil-square" />
              </.action>
            </:action>
          </.data_table>
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
