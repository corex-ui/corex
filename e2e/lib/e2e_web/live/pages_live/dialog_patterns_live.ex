defmodule E2eWeb.DialogPatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.DialogDemo

  @id_controlled "patterns-dialog-controlled"
  @id_alert "patterns-dialog-alert"

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:id_controlled, @id_controlled)
     |> assign(:id_alert, @id_alert)
     |> assign(:open, false)
     |> assign(:controlled_heex, DialogDemo.patterns_controlled_heex())
     |> assign(:controlled_elixir, DialogDemo.patterns_controlled_elixir())
     |> assign(:alert_heex, DialogDemo.patterns_alert_heex())
     |> assign(:alert_elixir, DialogDemo.patterns_alert_elixir())}
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
              <:title>Controlled dialog</:title>
              <:content>
                <p>LiveView owns open state.</p>
              </:content>
              <:close_trigger>
                <.heroicon name="hero-x-mark" />
              </:close_trigger>
            </.dialog>
          </:preview>
        </.demo_section>

        <.demo_section
          id="dialog-patterns-alert"
          title={~t"Alert dialog"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @alert_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @alert_elixir}
          ]}
        >
          <:preview>
            <.dialog
              id={@id_alert}
              class="dialog"
              role="alertdialog"
              modal
              close_on_interact_outside={false}
              initial_focus="patterns-dialog-alert-cancel"
              final_focus="dialog:patterns-dialog-alert:trigger"
            >
              <:trigger>Delete item</:trigger>
              <:title>Delete this item?</:title>
              <:description>This action cannot be undone.</:description>
              <:content>
                <div class="flex flex-wrap justify-end gap-2 mt-4">
                  <.action
                    id="patterns-dialog-alert-cancel"
                    phx-click={Corex.Dialog.set_open(@id_alert, false)}
                    class="button button--sm button--ghost"
                  >
                    Cancel
                  </.action>
                  <.action
                    phx-click={Corex.Dialog.set_open(@id_alert, false)}
                    class="button button--sm button--alert"
                  >
                    Delete
                  </.action>
                </div>
              </:content>
            </.dialog>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
