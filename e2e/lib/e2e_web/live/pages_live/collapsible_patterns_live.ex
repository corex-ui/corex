defmodule E2eWeb.CollapsiblePatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @id_async "patterns-collapsible-async"
  @id_controlled "patterns-collapsible-controlled"

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:id_async, @id_async)
      |> assign(:id_controlled, @id_controlled)
      |> assign(:open, false)
      |> assign(:async_heex_full, E2eWeb.Demos.CollapsibleDemo.patterns_async_heex_full())
      |> assign(:async_elixir, E2eWeb.Demos.CollapsibleDemo.patterns_async_elixir())
      |> assign(:controlled_heex, E2eWeb.Demos.CollapsibleDemo.patterns_controlled_heex())
      |> assign(:controlled_elixir, E2eWeb.Demos.CollapsibleDemo.patterns_controlled_elixir())
      |> assign_async(:collapsible, fn ->
        Process.sleep(1000)
        {:ok, %{collapsible: %{open: false, body: ~t"Loaded after async."}}}
      end)

    {:ok, socket}
  end

  def handle_event("patterns_collapsible_changed", %{"open" => open}, socket) do
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
        id="collapsible-patterns-page"
        title={~t"Collapsible · Pattern"}
        subtitle={~t"Common ways to structure Collapsible state and data flows."}
      >
        <.demo_section
          id="collapsible-patterns-async"
          title={~t"Async"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @async_heex_full},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @async_elixir}
          ]}
        >
          <:preview>
            <.async_result :let={panel} assign={@collapsible}>
              <:loading>
                <.collapsible_skeleton class="collapsible" />
              </:loading>

              <.collapsible id={@id_async} class="collapsible" open={panel.open}>
                <:trigger>Details</:trigger>
                <:closed>
                  <.heroicon name="hero-chevron-right" />
                </:closed>
                <:content>
                  {panel.body}
                </:content>
              </.collapsible>
            </.async_result>
          </:preview>
        </.demo_section>

        <.demo_section
          id="collapsible-patterns-controlled"
          title={~t"Controlled (LiveView)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @controlled_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @controlled_elixir}
          ]}
        >
          <:preview>
            <.collapsible
              id={@id_controlled}
              class="collapsible"
              controlled
              open={@open}
              on_open_change="patterns_collapsible_changed"
            >
              <:trigger>Controlled</:trigger>
              <:closed>
                <.heroicon name="hero-chevron-right" />
              </:closed>
              <:content>LiveView owns open.</:content>
            </.collapsible>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
