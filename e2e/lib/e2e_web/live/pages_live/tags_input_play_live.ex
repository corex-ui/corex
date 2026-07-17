defmodule E2eWeb.TagsInputPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1]

  @impl true
  def mount(_params, _session, socket) do
    controls = %{
      disabled: false,
      editable: true,
      allow_duplicates: false,
      add_on_paste: false
    }

    {:ok, assign(socket, :controls, controls)}
  end

  @impl true
  def handle_event("control_changed", %{"checked" => checked, "id" => id}, socket) do
    {:noreply, update_control(socket, id, checked)}
  end

  defp update_control(socket, "disabled", v),
    do: update(socket, :controls, &Map.put(&1, :disabled, v))

  defp update_control(socket, "editable", v),
    do: update(socket, :controls, &Map.put(&1, :editable, v))

  defp update_control(socket, "allow_duplicates", v),
    do: update(socket, :controls, &Map.put(&1, :allow_duplicates, v))

  defp update_control(socket, "add_on_paste", v),
    do: update(socket, :controls, &Map.put(&1, :add_on_paste, v))

  defp update_control(socket, _, _), do: socket

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_playground path={@path} title="Tags input · Playground" heading_class="layout-heading">
        <:controls>
          <.switch
            class="switch ui-size-sm"
            id="disabled"
            checked={@controls.disabled}
            on_checked_change="control_changed"
          >
            <:label>Disabled</:label>
          </.switch>
          <.switch
            class="switch ui-size-sm"
            id="editable"
            checked={@controls.editable}
            on_checked_change="control_changed"
          >
            <:label>Editable</:label>
          </.switch>
          <.switch
            class="switch ui-size-sm"
            id="allow_duplicates"
            checked={@controls.allow_duplicates}
            on_checked_change="control_changed"
          >
            <:label>Allow duplicates</:label>
          </.switch>
          <.switch
            class="switch ui-size-sm"
            id="add_on_paste"
            checked={@controls.add_on_paste}
            on_checked_change="control_changed"
          >
            <:label>Add on paste</:label>
          </.switch>
        </:controls>
        <:canvas>
          <.tags_input
            id="tags-input-playground"
            class="tags-input"
            value={["alpha", "beta"]}
            disabled={@controls.disabled}
            editable={@controls.editable}
            allow_duplicates={@controls.allow_duplicates}
            add_on_paste={@controls.add_on_paste}
          >
            <:label>Tags</:label>
            <:close><.heroicon name="hero-x-mark" /></:close>
          </.tags_input>
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
