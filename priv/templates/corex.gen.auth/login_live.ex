defmodule <%= inspect context.web_module %>.<%= inspect Module.concat(schema.web_namespace, schema.alias) %>Live.Login do
  use <%= inspect context.web_module %>, :live_view

  alias <%= inspect context.module %>

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}<%= if layout_mode do %> mode={@mode}<% end %><%= if layout_theme do %> theme={@theme}<% end %><%= if layout_themes do %> themes={@themes}<% end %><%= if layout_locale do %> locale={@locale} current_path={@current_path}<% end %> <%= scope_config.scope.assign_key %>={@<%= scope_config.scope.assign_key %>}>
      <.layout_heading>
        <:title>Log in</:title>
        <:subtitle>
          <%%= if @<%= scope_config.scope.assign_key %> do %>
            You need to reauthenticate to perform sensitive actions on your account.
          <%% else %>
            Don't have an account?
            <.navigate to={~p"<%= if layout_locale do %>/#{@locale}<% end %><%= schema.route_prefix %>/register"} class="link link--brand">
              Sign up
            </.navigate>
            for an account now.
          <%% end %>
        </:subtitle>
      </.layout_heading>

      <div :if={local_mail_adapter?()} class="alert alert-info">
          <.heroicon name="hero-information-circle" class="icon" />
          <div>
            <p>You are running the local mail adapter.</p>
            <p>
              To see sent emails, visit <.navigate to="/dev/mailbox" class="link">the mailbox page</.navigate>.
            </p>
          </div>
        </div>

        <.form
          :let={f}
          for={@form}
          id="login_form_magic"
          action={~p"<%= if layout_locale do %>/#{@locale}<% end %><%= schema.route_prefix %>/log-in"}
          phx-submit="submit_magic"
        >
          <.native_input
            readonly={!!@<%= scope_config.scope.assign_key %>}
            field={f[:email]}
            type="email"
            autocomplete="username"
            spellcheck="false"
            required
            phx-mounted={JS.focus()}
            class="native-input"
          >
            <:label>Email</:label>
            <:error :let={msg}>{msg}</:error>
          </.native_input>
          <.action class="button button--brand button--sm" type="submit">
            Log in with email <span aria-hidden="true">→</span>
          </.action>
        </.form>

        <div class="divider">or</div>

        <.form
          :let={f}
          for={@form}
          id="login_form_password"
          action={~p"<%= if layout_locale do %>/#{@locale}<% end %><%= schema.route_prefix %>/log-in"}
          phx-submit="submit_password"
          phx-trigger-action={@trigger_submit}
        >
          <.native_input
            readonly={!!@<%= scope_config.scope.assign_key %>}
            field={f[:email]}
            type="email"
            autocomplete="username"
            spellcheck="false"
            required
            class="native-input"
          >
            <:label>Email</:label>
            <:error :let={msg}>{msg}</:error>
          </.native_input>
          <.native_input
            field={@form[:password]}
            type="password"
            autocomplete="current-password"
            spellcheck="false"
            class="native-input"
          >
            <:label>Password</:label>
            <:error :let={msg}>{msg}</:error>
          </.native_input>
          <.action
            class="button button--brand button--sm"
            type="submit"
            name={@form[:remember_me].name}
            value="true"
          >
            Log in and stay logged in <span aria-hidden="true">→</span>
          </.action>
          <.action class="button button--accent button--sm" type="submit">
            Log in only this time
          </.action>
        </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    email =
      Phoenix.Flash.get(socket.assigns.flash, :email) ||
        get_in(socket.assigns, [:<%= scope_config.scope.assign_key %>, Access.key(:<%= schema.singular %>), Access.key(:email)])

    form = to_form(%{"email" => email}, as: "<%= schema.singular %>")

    {:ok, assign(socket, form: form, trigger_submit: false)}
  end

  @impl true
  def handle_event("submit_password", _params, socket) do
    {:noreply, assign(socket, :trigger_submit, true)}
  end

  def handle_event("submit_magic", %{"<%= schema.singular %>" => %{"email" => email}}, socket) do
    if <%= schema.singular %> = <%= inspect context.alias %>.get_<%= schema.singular %>_by_email(email) do
      <%= inspect context.alias %>.deliver_login_instructions(
        <%= schema.singular %>,
        &url(~p"<%= if layout_locale do %>/#{socket.assigns.locale}<% end %><%= schema.route_prefix %>/log-in/#{&1}")
      )
    end

    info =
      "If your email is in our system, you will receive instructions for logging in shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> push_navigate(to: ~p"<%= if layout_locale do %>/#{socket.assigns.locale}<% end %><%= schema.route_prefix %>/log-in")}
  end

  defp local_mail_adapter? do
    Application.get_env(:<%= Mix.Corex.otp_app() %>, <%= inspect context.base_module %>.Mailer)[:adapter] == Swoosh.Adapters.Local
  end
end
