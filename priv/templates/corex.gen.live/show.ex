defmodule <%= inspect context.web_module %>.<%= inspect Module.concat(schema.web_namespace, schema.alias) %>Live.Show do
  use <%= inspect context.web_module %>, :live_view

  alias <%= inspect context.module %>

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
      <article class="mx-auto flex w-full min-w-0 max-w-6xl flex-col items-center gap-size-lg text-ink rounded-md">
        <.layout_heading class="layout-heading">
          <:title><%= schema.human_singular %> {@<%= schema.singular %>.<%= primary_key %>}</:title>
          <:subtitle>This is a <%= schema.singular %> record from your database.</:subtitle>
          <:actions>
            <.navigate
              to={~p"<%= if layout_locale do %>/#{@locale}<% end %><%= scope_assign_route_prefix %><%= schema.route_prefix %>"}
              type="navigate"
              class="button"
              aria_label="Back to list"
              title="Back to list"
            >
              <.heroicon name="hero-arrow-left" />
            </.navigate>
            <.navigate
              to={~p"<%= if layout_locale do %>/#{@locale}<% end %><%= scope_assign_route_prefix %><%= schema.route_prefix %>/#{@<%= schema.singular %>}/edit?return_to=show"}
              type="navigate"
              class="button button--accent button--square"
              aria_label="Edit <%= schema.human_singular %>"
              title="Edit <%= schema.human_singular %>"
            >
              <.heroicon name="hero-pencil-square" />
              <span class="sr-only">Edit <%= schema.human_singular %></span>
            </.navigate>
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
                    class="button button--sm button--variant-ghost"
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

        <.data_list class="data-list"><%= for {k, type} <- schema.attrs do %>
          <:label value="<%= Atom.to_string(k) %>"><%= Phoenix.Naming.humanize(Atom.to_string(k)) %></:label>
          <:content value="<%= Atom.to_string(k) %>">{<%= Mix.Corex.Gen.Inputs.display_expr("@#{schema.singular}", k, type, schema, :show) %>}</:content><% end %>
        </.data_list>
      </article>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"<%= primary_key %>" => <%= primary_key %>}, _session, socket) do<%= if scope do %>
    if connected?(socket) do
      <%= inspect context.alias %>.subscribe_<%= schema.plural %>(<%= socket_scope %>)
    end
<% end %>
    {:ok,
     socket
     |> assign(:page_title, "Show <%= schema.human_singular %>")
     |> assign(:<%= schema.singular %>, <%= inspect context.alias %>.get_<%= schema.singular %>!(<%= context_scope_prefix %><%= primary_key %>))}
  end

  @impl true
  def handle_event("delete", %{"<%= primary_key %>" => <%= primary_key %>}, socket) do
    <%= schema.singular %> = <%= inspect context.alias %>.get_<%= schema.singular %>!(<%= context_scope_prefix %><%= primary_key %>)
    {:ok, _} = <%= inspect context.alias %>.delete_<%= schema.singular %>(<%= context_scope_prefix %><%= schema.singular %>)

    {:noreply,
     socket
     |> put_flash(:info, "<%= schema.human_singular %> deleted successfully")
     |> push_navigate(to: ~p"<%= if layout_locale do %>/#{socket.assigns.locale}<% end %><%= scope_param_route_prefix %><%= schema.route_prefix %>")}
  end<%= if scope do %>

  @impl true
  def handle_info(
        {:updated, %<%= inspect schema.module %>{<%= primary_key %>: <%= primary_key %>} = <%= schema.singular %>},
        %{assigns: %{<%= schema.singular %>: %{<%= primary_key %>: <%= primary_key %>}}} = socket
      ) do
    {:noreply, assign(socket, :<%= schema.singular %>, <%= schema.singular %>)}
  end

  def handle_info(
        {:deleted, %<%= inspect schema.module %>{<%= primary_key %>: <%= primary_key %>}},
        %{assigns: %{<%= schema.singular %>: %{<%= primary_key %>: <%= primary_key %>}}} = socket
      ) do
    {:noreply,
     socket
     |> put_flash(:error, "The current <%= schema.singular %> was deleted.")
     |> push_navigate(to: ~p"<%= if layout_locale do %>/#{socket.assigns.locale}<% end %><%= scope_socket_route_prefix %><%= schema.route_prefix %>")}
  end

  def handle_info({type, %<%= inspect schema.module %>{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, socket}
  end<% end %>
end
