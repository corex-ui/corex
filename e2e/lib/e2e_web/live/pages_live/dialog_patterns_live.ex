defmodule E2eWeb.DialogPatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.DialogDemo

  @id_controlled "patterns-dialog-controlled"

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:id_controlled, @id_controlled)
     |> assign(:open, false)
     |> assign(:controlled_heex, DialogDemo.patterns_controlled_heex())
     |> assign(:controlled_elixir, DialogDemo.patterns_controlled_elixir())}
  end

  def handle_event("patterns_dialog_open_changed", %{"open" => open}, socket) do
    {:noreply, assign(socket, :open, open)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_page
        path={@path}
        id="dialog-patterns-page"
        title={~t"Dialog · Pattern"}
      >
        <.demo_section
          id="dialog-patterns-controlled"
          title={~t"Controlled (LiveView)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @controlled_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @controlled_elixir}
          ]}
        >
          <:preview>
            <.dialog
              id={@id_controlled}
              class="dialog"
              controlled
              open={@open}
              on_open_change="patterns_dialog_open_changed"
            >
              <:trigger>Open</:trigger>
              <:content>
                <p>LiveView owns open state.</p>
              </:content>
              <:close_trigger>
                <.heroicon name="hero-x-mark" />
              </:close_trigger>
            </.dialog>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
