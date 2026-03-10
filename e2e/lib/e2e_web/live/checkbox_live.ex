defmodule E2eWeb.CheckboxLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("set_checked", %{"checked" => checked}, socket) do
    {:noreply, Corex.Checkbox.set_checked(socket, "my-checkbox", checked == "true")}
  end

  def handle_event("toggle_checked", _params, socket) do
    {:noreply, Corex.Checkbox.toggle_checked(socket, "my-checkbox")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      locale={@locale}
      current_path={@current_path}
    >
      <.layout_heading>
        <:title>Checkbox</:title>
        <:subtitle>Live View</:subtitle>
      </.layout_heading>
      <h3>Client Api</h3>
      <div class="layout__row">
        <.action
          phx-click={Corex.Checkbox.set_checked("my-checkbox", true)}
          class="button button--sm"
        >
          Set checked
        </.action>
        <.action
          phx-click={Corex.Checkbox.set_checked("my-checkbox", false)}
          class="button button--sm"
        >
          Set unchecked
        </.action>
        <.action
          phx-click={Corex.Checkbox.toggle_checked("my-checkbox")}
          class="button button--sm"
        >
          Toggle checked
        </.action>
      </div>

      <h3>Server Api</h3>
      <div class="layout__row">
        <.action
          phx-click="set_checked"
          phx-value-checked="true"
          class="button button--sm"
        >
          Set checked
        </.action>
        <.action
          phx-click="set_checked"
          phx-value-checked="false"
          class="button button--sm"
        >
          Set unchecked
        </.action>
        <.action phx-click="toggle_checked" class="button button--sm">
          Toggle checked
        </.action>
      </div>

      <.checkbox id="my-checkbox" class="checkbox">
        <:label>
          Accept the terms
        </:label>
        <:indicator>
          <.heroicon name="hero-check" class="data-checked" />
        </:indicator>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.checkbox>
    </Layouts.app>
    """
  end
end
