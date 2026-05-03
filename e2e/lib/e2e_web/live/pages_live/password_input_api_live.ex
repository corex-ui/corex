defmodule E2eWeb.PasswordInputApiLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.PasswordInputDemo, as: Demo
  alias E2eWeb.Demos.RadioGroupDemo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("password_input_api_visibility", _payload, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("api_password_show", %{"id" => id}, socket) do
    {:noreply, Corex.PasswordInput.set_visible(socket, id, true)}
  end

  @impl true
  def handle_event("api_password_hide", %{"id" => id}, socket) do
    {:noreply, Corex.PasswordInput.set_visible(socket, id, false)}
  end

  @impl true
  def handle_event("api_password_toggle_visible", %{"id" => id}, socket) do
    {:noreply, Corex.PasswordInput.toggle_visible(socket, id)}
  end

  @impl true
  def handle_event("api_password_focus", %{"id" => id}, socket) do
    {:noreply, Corex.PasswordInput.focus(socket, id)}
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
        id="password-input-api-page"
        title="Password Input · API"
        subtitle="LiveView push, client DOM events, programmatic visibility, and a native radio form."
      >
        <.demo_section
          id="password-input-api-binding"
          title="LiveView binding"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: Demo.api_binding_heex()},
            %{value: "elixir", label: "Elixir", language: :elixir, code: Demo.api_binding_elixir()},
            %{
              value: "initial",
              label: "Initial visible",
              language: :heex,
              code: Demo.api_initial_heex()
            },
            %{
              value: "initial_elixir",
              label: "Initial Elixir",
              language: :elixir,
              code: Demo.api_initial_elixir()
            }
          ]}
        >
          <:preview><Demo.api_binding_example /></:preview>
        </.demo_section>

        <.demo_section
          id="password-input-api-client"
          title="Client JS"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: Demo.api_client_heex()},
            %{value: "js", label: "JS", language: :js, code: Demo.api_client_js()},
            %{value: "ts", label: "TS", language: :javascript, code: Demo.api_client_ts()}
          ]}
        >
          <:preview><Demo.api_client_example /></:preview>
        </.demo_section>

        <.demo_section
          id="password-input-api-server"
          title="Set visibility (Server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: Demo.api_server_heex()},
            %{value: "elixir", label: "Elixir", language: :elixir, code: Demo.api_server_elixir()}
          ]}
        >
          <:preview><Demo.api_server_example /></:preview>
        </.demo_section>

        <.demo_section
          id="password-input-api-native-form"
          title="Native form (plain HTML)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: RadioGroupDemo.form_native_heex()},
            %{value: "ecto", label: "Ecto", language: :elixir, code: RadioGroupDemo.form_ecto()}
          ]}
        >
          <:preview><RadioGroupDemo.form_preview_controller_native /></:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
