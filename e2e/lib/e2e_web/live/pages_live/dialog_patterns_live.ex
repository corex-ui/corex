defmodule E2eWeb.DialogPatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:dialog_open, false)
      |> assign(:controlled_heex, E2eWeb.Demos.DialogDemo.patterns_controlled_heex())
      |> assign(:controlled_elixir, E2eWeb.Demos.DialogDemo.patterns_controlled_elixir())

    {:ok, socket}
  end

  @impl true
  def handle_event("patterns_dialog_open_changed", %{"open" => open}, socket) do
    {:noreply, assign(socket, :dialog_open, open)}
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
      <.demo_page
        id="dialog-patterns-page"
        title="Dialog · Pattern"
        subtitle={nil}
      >
        <.demo_section
          id="dialog-patterns-controlled"
          title="Controlled"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @controlled_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @controlled_elixir}
          ]}
        >
          <:preview>
            <.dialog
              id="patterns-controlled-dialog"
              class="dialog"
              controlled
              open={@dialog_open}
              on_open_change="patterns_dialog_open_changed"
            >
              <:trigger>Open dialog</:trigger>
              <:title>Controlled</:title>
              <:description>State lives on the LiveView.</:description>
              <:content>
                <p>Content</p>
              </:content>
              <:close_trigger>
                <.heroicon name="hero-x-mark" class="icon" />
              </:close_trigger>
            </.dialog>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
