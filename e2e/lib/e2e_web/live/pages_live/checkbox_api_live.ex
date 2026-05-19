defmodule E2eWeb.CheckboxApiLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.CheckboxDemo

  @id_bind "checkbox-api-bind"
  @id_server "checkbox-api-server"

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:id_bind, @id_bind)
     |> assign(:id_server, @id_server)
     |> assign(:client_binding_heex, CheckboxDemo.api_client_binding_code())
     |> assign(:js_dispatch_heex, CheckboxDemo.api_js_dispatch_heex())
     |> assign(:js_dispatch_js, CheckboxDemo.api_js_dispatch_js())
     |> assign(:js_dispatch_ts, CheckboxDemo.api_js_dispatch_ts())
     |> assign(:server_elixir, CheckboxDemo.api_server_elixir())}
  end

  def handle_event("api_check", %{"id" => id}, socket) do
    {:noreply, Corex.Checkbox.set_checked(socket, id, true)}
  end

  def handle_event("api_uncheck", %{"id" => id}, socket) do
    {:noreply, Corex.Checkbox.set_checked(socket, id, false)}
  end

  def handle_event("api_toggle", %{"id" => id}, socket) do
    {:noreply, Corex.Checkbox.toggle_checked(socket, id)}
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
        id="checkbox-api-page"
        title="Checkbox · API"
        subtitle="Programmatically set the checked state from the server or client bindings."
      >
        <.demo_section
          id="checkbox-api-client-binding"
          title="Set checked (Client Binding)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @client_binding_heex}
          ]}
        >
          <:preview>
            <CheckboxDemo.api_client_binding_example id={@id_bind} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="checkbox-api-js-dispatch"
          title="Set checked (Client JS)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @js_dispatch_heex},
            %{value: "js", label: "JS", language: :js, code: @js_dispatch_js},
            %{value: "ts", label: "TS", language: :javascript, code: @js_dispatch_ts}
          ]}
        >
          <:preview>
            <CheckboxDemo.api_js_dispatch_example />
          </:preview>
        </.demo_section>

        <.demo_section
          id="checkbox-api-server-section"
          title="Set checked (Server)"
          code_tabs={[
            %{value: "elixir", label: "Elixir", language: :elixir, code: @server_elixir}
          ]}
        >
          <:preview>
            <div class="flex flex-wrap gap-2 mb-4">
              <.action phx-click="api_check" phx-value-id={@id_server} class="button button--sm">
                Set checked
              </.action>
              <.action phx-click="api_uncheck" phx-value-id={@id_server} class="button button--sm">
                Set unchecked
              </.action>
              <.action phx-click="api_toggle" phx-value-id={@id_server} class="button button--sm">
                Toggle
              </.action>
            </div>
            <.checkbox id={@id_server} class="checkbox">
              <:label>Terms</:label>
              <:indicator>
                <.heroicon name="hero-check" />
              </:indicator>
              <:indeterminate>
                <.heroicon name="hero-minus" />
              </:indeterminate>
            </.checkbox>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
