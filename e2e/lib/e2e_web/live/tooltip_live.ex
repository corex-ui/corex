defmodule E2eWeb.TooltipLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("set_open", %{"value" => "true"}, socket) do
    {:noreply, Corex.Tooltip.set_open(socket, "my-tooltip", true)}
  end

  def handle_event("set_open", %{"value" => "false"}, socket) do
    {:noreply, Corex.Tooltip.set_open(socket, "my-tooltip", false)}
  end

  def handle_event("tooltip_changed", %{"id" => _id, "open" => _open}, socket) do
    {:noreply, socket}
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
        <:title>Tooltip</:title>
        <:subtitle>Live View</:subtitle>
      </.layout_heading>

      <h3>Client API</h3>
        <div class="layout__row">
          <.action
            phx-click={Corex.Tooltip.set_open("my-tooltip", true)}
            class="button button--sm"
          >
            Open
          </.action>
          <.action
            phx-click={Corex.Tooltip.set_open("my-tooltip", false)}
            class="button button--sm"
          >
            Close
          </.action>
        </div>

      <h3>Server API</h3>
        <div class="layout__row">
          <.action phx-click="set_open" value="true" class="button button--sm">
            Open
          </.action>
          <.action phx-click="set_open" value="false" class="button button--sm">
            Close
          </.action>
        </div>

      <h3>Default open</h3>
        <div class="layout__row">
          <.tooltip id="my-tooltip" on_open_change="tooltip_changed" class="tooltip" open>
            <:trigger>Hover or focus (starts open)</:trigger>
            <:content>Tooltip content</:content>
          </.tooltip>
        </div>

      <h3>Placement</h3>
        <div class="layout__row">
          <.tooltip class="tooltip" placement="bottom">
            <:trigger>Bottom</:trigger>
            <:content>Tooltip below</:content>
          </.tooltip>
          <.tooltip class="tooltip" placement="top">
            <:trigger>Top</:trigger>
            <:content>Tooltip above</:content>
          </.tooltip>
          <.tooltip class="tooltip" placement="left">
            <:trigger>Left</:trigger>
            <:content>Tooltip on the left</:content>
          </.tooltip>
          <.tooltip class="tooltip" placement="right">
            <:trigger>Right</:trigger>
            <:content>Tooltip on the right</:content>
          </.tooltip>
          <.tooltip class="tooltip" placement="top-start">
            <:trigger>Top start</:trigger>
            <:content>Tooltip top-start</:content>
          </.tooltip>
          <.tooltip class="tooltip" placement="bottom-end">
            <:trigger>Bottom end</:trigger>
            <:content>Tooltip bottom-end</:content>
          </.tooltip>
        </div>

      <h3>Size and color</h3>
        <div class="layout__row">
          <.tooltip class="tooltip tooltip--sm" show_arrow>
            <:trigger>Small</:trigger>
            <:content>Small tooltip</:content>
          </.tooltip>
          <.tooltip class="tooltip" show_arrow>
            <:trigger>Default</:trigger>
            <:content>Default size and color</:content>
          </.tooltip>
          <.tooltip class="tooltip tooltip--lg" show_arrow>
            <:trigger>Large</:trigger>
            <:content>Large tooltip</:content>
          </.tooltip>
          <.tooltip class="tooltip tooltip--accent" show_arrow>
            <:trigger>Accent</:trigger>
            <:content>Accent color</:content>
          </.tooltip>
          <.tooltip class="tooltip tooltip--brand" show_arrow>
            <:trigger>Brand</:trigger>
            <:content>Brand color</:content>
          </.tooltip>
          <.tooltip class="tooltip tooltip--success" show_arrow>
            <:trigger>Success</:trigger>
            <:content>Success color</:content>
          </.tooltip>
          <.tooltip class="tooltip tooltip--info" show_arrow>
            <:trigger>Info</:trigger>
            <:content>Info color</:content>
          </.tooltip>
          <.tooltip class="tooltip tooltip--alert" show_arrow>
            <:trigger>Alert</:trigger>
            <:content>Alert color</:content>
          </.tooltip>
        </div>
    </Layouts.app>
    """
  end
end
