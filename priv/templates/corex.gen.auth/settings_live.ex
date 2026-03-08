defmodule <%= inspect context.web_module %>.<%= inspect Module.concat(schema.web_namespace, schema.alias) %>Live.Settings do
  use <%= inspect context.web_module %>, :live_view

  on_mount {<%= inspect auth_module %>, :require_sudo_mode}

  alias <%= inspect context.module %>

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}<%= if layout_mode do %> mode={@mode}<% end %><%= if layout_theme do %> theme={@theme}<% end %><%= if layout_theme do %> themes={@themes}<% end %><%= if layout_locale do %> locale={@locale} current_path={@current_path}<% end %> <%= scope_config.scope.assign_key %>={@<%= scope_config.scope.assign_key %>}>
      <div class="text-center">
        <div>
          <h1 class="text-lg font-semibold">Account Settings</h1>
          <p class="mt-1 text-sm text-zinc-500">
            Manage your account email address and password settings
          </p>
        </div>
      </div>

      <.form for={@email_form} id="email_form" phx-submit="update_email" phx-change="validate_email">
        <.native_input
          field={@email_form[:email]}
          type="email"
          autocomplete="username"
          spellcheck="false"
          required
          class="native-input"
        >
          <:label>Email</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.action
          class="button button--brand button--sm"
          phx-disable-with="Changing..."
          type="submit"
        >
          Change Email
        </.action>
      </.form>

      <div class="divider" />

      <.form
        for={@password_form}
        id="password_form"
        action={~p"<%= if layout_locale do %>/#{@locale}<% end %><%= schema.route_prefix %>/update-password"}
        method="post"
        phx-change="validate_password"
        phx-submit="update_password"
        phx-trigger-action={@trigger_submit}
      >
        <input
          name={@password_form[:email].name}
          type="hidden"
          id="hidden_<%= schema.singular %>_email"
          spellcheck="false"
          value={@current_email}
        />
        <.native_input
          field={@password_form[:password]}
          type="password"
          autocomplete="new-password"
          spellcheck="false"
          required
          class="native-input"
        >
          <:label>New password</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={@password_form[:password_confirmation]}
          type="password"
          autocomplete="new-password"
          spellcheck="false"
          class="native-input"
        >
          <:label>Confirm new password</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.action
          class="button button--brand button--sm"
          phx-disable-with="Saving..."
          type="submit"
        >
          Save Password
        </.action>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"token" => token}, _session, socket) do
    socket =
      case <%= inspect context.alias %>.update_<%= schema.singular %>_email(socket.assigns.<%= scope_config.scope.assign_key %>.<%= schema.singular %>, token) do
        {:ok, _<%= schema.singular %>} ->
          put_flash(socket, :info, "Email changed successfully.")

        {:error, _} ->
          put_flash(socket, :error, "Email change link is invalid or it has expired.")
      end

    {:ok, push_navigate(socket, to: ~p"<%= if layout_locale do %>/#{socket.params["locale"]}<% end %><%= schema.route_prefix %>/settings")}
  end

  def mount(_params, _session, socket) do
    <%= schema.singular %> = socket.assigns.<%= scope_config.scope.assign_key %>.<%= schema.singular %>
    email_changeset = <%= inspect context.alias %>.change_<%= schema.singular %>_email(<%= schema.singular %>, %{}, validate_unique: false)
    password_changeset = <%= inspect context.alias %>.change_<%= schema.singular %>_password(<%= schema.singular %>, %{}, hash_password: false)

    socket =
      socket
      |> assign(:current_email, <%= schema.singular %>.email)
      |> assign(:email_form, to_form(email_changeset))
      |> assign(:password_form, to_form(password_changeset))
      |> assign(:trigger_submit, false)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate_email", params, socket) do
    %{"<%= schema.singular %>" => <%= schema.singular %>_params} = params

    email_form =
      socket.assigns.<%= scope_config.scope.assign_key %>.<%= schema.singular %>
      |> <%= inspect context.alias %>.change_<%= schema.singular %>_email(<%= schema.singular %>_params, validate_unique: false)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, email_form: email_form)}
  end

  def handle_event("update_email", params, socket) do
    %{"<%= schema.singular %>" => <%= schema.singular %>_params} = params
    <%= schema.singular %> = socket.assigns.<%= scope_config.scope.assign_key %>.<%= schema.singular %>
    true = <%= inspect context.alias %>.sudo_mode?(<%= schema.singular %>)

    case <%= inspect context.alias %>.change_<%= schema.singular %>_email(<%= schema.singular %>, <%= schema.singular %>_params) do
      %{valid?: true} = changeset ->
        <%= inspect context.alias %>.deliver_<%= schema.singular %>_update_email_instructions(
          Ecto.Changeset.apply_action!(changeset, :insert),
          <%= schema.singular %>.email,
          &url(~p"<%= if layout_locale do %>/#{socket.assigns.locale}<% end %><%= schema.route_prefix %>/settings/confirm-email/#{&1}")
        )

        info = "A link to confirm your email change has been sent to the new address."
        {:noreply, socket |> put_flash(:info, info)}

      changeset ->
        {:noreply, assign(socket, :email_form, to_form(changeset, action: :insert))}
    end
  end

  def handle_event("validate_password", params, socket) do
    %{"<%= schema.singular %>" => <%= schema.singular %>_params} = params

    password_form =
      socket.assigns.<%= scope_config.scope.assign_key %>.<%= schema.singular %>
      |> <%= inspect context.alias %>.change_<%= schema.singular %>_password(<%= schema.singular %>_params, hash_password: false)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, password_form: password_form)}
  end

  def handle_event("update_password", params, socket) do
    %{"<%= schema.singular %>" => <%= schema.singular %>_params} = params
    <%= schema.singular %> = socket.assigns.<%= scope_config.scope.assign_key %>.<%= schema.singular %>
    true = <%= inspect context.alias %>.sudo_mode?(<%= schema.singular %>)

    case <%= inspect context.alias %>.change_<%= schema.singular %>_password(<%= schema.singular %>, <%= schema.singular %>_params) do
      %{valid?: true} = changeset ->
        {:noreply, assign(socket, trigger_submit: true, password_form: to_form(changeset))}

      changeset ->
        {:noreply, assign(socket, password_form: to_form(changeset, action: :insert))}
    end
  end
end
