defmodule <%= inspect context.web_module %>.<%= inspect Module.concat(schema.web_namespace, schema.alias) %>Live.Form do
  use <%= inspect context.web_module %>, :live_view

  alias <%= inspect context.module %>
  alias <%= inspect schema.module %>

  @impl true
  def render(assigns) do
    ~H"""
    <%= if layout_mode || layout_theme || layout_locale || scope do %><Layouts.app
      flash={@flash}<%= if layout_mode do %>
      mode={@mode}<% end %><%= if layout_theme do %>
      theme={@theme}<% end %><%= if layout_locale do %>
      locale={@locale}
      current_path={@current_path}<% end %><%= if scope do %>
      <%= scope.assign_key %>={@<%= scope.assign_key %>}<% end %>
    >
    <% else %><Layouts.app flash={@flash}><% end %>
      <article class="layout__article">
        <.layout_heading class="layout-heading">
          <:title>{@page_title}</:title>
          <:subtitle>Use this form to manage <%= schema.singular %> records in your database.</:subtitle>
          <:actions :if={@live_action == :edit}>
            <.dialog
              id={"<%= schema.singular %>-delete-#{@<%= schema.singular %>.<%= primary_key %>}"}
              class="dialog"
              role="alertdialog"
              modal
              close_on_interact_outside={false}
              initial_focus={"<%= schema.singular %>-delete-#{@<%= schema.singular %>.<%= primary_key %>}-cancel"}
              final_focus={"dialog:<%= schema.singular %>-delete-#{@<%= schema.singular %>.<%= primary_key %>}:trigger"}
            >
              <:trigger
                class="button button--alert button--square"
                aria_label="Delete <%= schema.human_singular %>"
                title="Delete <%= schema.human_singular %>"
              >
                <.heroicon name="hero-trash" />
              </:trigger>
              <:title>Delete <%= schema.singular %>?</:title>
              <:description>This action cannot be undone.</:description>
              <:content>
                <div class="flex flex-wrap justify-end gap-2 mt-4">
                  <.action
                    id={"<%= schema.singular %>-delete-#{@<%= schema.singular %>.<%= primary_key %>}-cancel"}
                    phx-click={Corex.Dialog.set_open("<%= schema.singular %>-delete-#{@<%= schema.singular %>.<%= primary_key %>}", false)}
                    class="button button--sm button--ghost"
                  >
                    Cancel
                  </.action>
                  <.action
                    id={"<%= schema.singular %>-delete-#{@<%= schema.singular %>.<%= primary_key %>}-confirm"}
                    phx-click={
                      Corex.Dialog.set_open("<%= schema.singular %>-delete-#{@<%= schema.singular %>.<%= primary_key %>}", false)
                      |> JS.push("delete", value: %{<%= primary_key %>: @<%= schema.singular %>.<%= primary_key %>})
                    }
                    class="button button--sm button--alert"
                  >
                    Delete
                  </.action>
                </div>
              </:content>
            </.dialog>
          </:actions>
        </.layout_heading>

        <.form
          for={@form}
          phx-change="validate"
          phx-submit="save"
        >
<%= Mix.Tasks.Corex.Gen.Html.indent_inputs(inputs, 10) %>
          <div class="layout__row justify-between">
            <.navigate to={return_path(<%= if layout_locale do %>@locale, <% end %><%= assign_scope_prefix %>@return_to, @<%= schema.singular %>)} type="navigate" class="button">
              Cancel
            </.navigate>
            <.action phx-disable-with="Saving..." class="button button--accent" type="submit">
              Save <%= schema.human_singular %>
            </.action>
          </div>
        </.form>
      </article>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"<%= primary_key %>" => <%= primary_key %>}) do
    <%= schema.singular %> = <%= inspect context.alias %>.get_<%= schema.singular %>!(<%= context_scope_prefix %><%= primary_key %>)

    socket
    |> assign(:page_title, "Edit <%= schema.human_singular %>")
    |> assign(:<%= schema.singular %>, <%= schema.singular %>)
    |> assign(:form, to_form(<%= inspect context.alias %>.change_<%= schema.singular %>(<%= context_scope_prefix %><%= schema.singular %>), id: "<%= schema.singular %>-form"))
  end

  defp apply_action(socket, :new, _params) do
    <%= schema.singular %> = %<%= inspect schema.alias %>{<%= if scope do %><%= scope.schema_key %>: <%= socket_scope %>.<%= Enum.join(scope.access_path, ".") %><% end %>}

    socket
    |> assign(:page_title, "New <%= schema.human_singular %>")
    |> assign(:<%= schema.singular %>, <%= schema.singular %>)
    |> assign(:form, to_form(<%= inspect context.alias %>.change_<%= schema.singular %>(<%= context_scope_prefix %><%= schema.singular %>), id: "<%= schema.singular %>-form"))
  end

  @impl true
  def handle_event("validate", %{"<%= schema.singular %>" => <%= schema.singular %>_params}, socket) do
    changeset = <%= inspect context.alias %>.change_<%= schema.singular %>(<%= context_scope_prefix %>socket.assigns.<%= schema.singular %>, <%= schema.singular %>_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate, id: "<%= schema.singular %>-form"))}
  end

  def handle_event("save", %{"<%= schema.singular %>" => <%= schema.singular %>_params}, socket) do
    save_<%= schema.singular %>(socket, socket.assigns.live_action, <%= schema.singular %>_params)
  end

  def handle_event("delete", %{"<%= primary_key %>" => <%= primary_key %>}, socket) do
    <%= schema.singular %> = <%= inspect context.alias %>.get_<%= schema.singular %>!(<%= context_scope_prefix %><%= primary_key %>)
    {:ok, _} = <%= inspect context.alias %>.delete_<%= schema.singular %>(<%= context_scope_prefix %><%= schema.singular %>)

    {:noreply,
     socket
     |> put_flash(:info, "<%= schema.human_singular %> deleted successfully")
     |> push_navigate(to: ~p"<%= if layout_locale do %>/#{socket.assigns.locale}<% end %><%= scope_param_route_prefix %><%= schema.route_prefix %>")}
  end

  defp save_<%= schema.singular %>(socket, :edit, <%= schema.singular %>_params) do
    case <%= inspect context.alias %>.update_<%= schema.singular %>(<%= context_scope_prefix %>socket.assigns.<%= schema.singular %>, <%= schema.singular %>_params) do
      {:ok, <%= schema.singular %>} ->
        {:noreply,
         socket
         |> put_flash(:info, "<%= schema.human_singular %> updated successfully")
         <%= if scope do %>|> push_navigate(
           to: return_path(<%= if layout_locale do %>socket.assigns.locale, <% end %><%= context_scope_prefix %>socket.assigns.return_to, <%= schema.singular %>)
         )}<% else %>|> push_navigate(to: return_path(<%= if layout_locale do %>socket.assigns.locale, <% end %>socket.assigns.return_to, <%= schema.singular %>))}<% end %>

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset, id: "<%= schema.singular %>-form"))}
    end
  end

  defp save_<%= schema.singular %>(socket, :new, <%= schema.singular %>_params) do
    case <%= inspect context.alias %>.create_<%= schema.singular %>(<%= context_scope_prefix %><%= schema.singular %>_params) do
      {:ok, <%= schema.singular %>} ->
        {:noreply,
         socket
         |> put_flash(:info, "<%= schema.human_singular %> created successfully")
         <%= if scope do %>|> push_navigate(
           to: return_path(<%= if layout_locale do %>socket.assigns.locale, <% end %><%= context_scope_prefix %>socket.assigns.return_to, <%= schema.singular %>)
         )}<% else %>|> push_navigate(to: return_path(<%= if layout_locale do %>socket.assigns.locale, <% end %>socket.assigns.return_to, <%= schema.singular %>))}<% end %>

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  <%= if layout_locale do %>defp return_path(locale, <%= scope_param_prefix %>"index", _<%= schema.singular %>), do: ~p"<%= scope_param_route_prefix %><%= schema.route_prefix %>"
  defp return_path(locale, <%= scope_param_prefix %>"show", <%= schema.singular %>), do: ~p"<%= scope_param_route_prefix %><%= schema.route_prefix %>/#{<%= schema.singular %>}"
<% else %>defp return_path(<%= scope_param_prefix %>"index", _<%= schema.singular %>), do: ~p"<%= scope_param_route_prefix %><%= schema.route_prefix %>"
  defp return_path(<%= scope_param_prefix %>"show", <%= schema.singular %>), do: ~p"<%= scope_param_route_prefix %><%= schema.route_prefix %>/#{<%= schema.singular %>}"
<% end %>end
