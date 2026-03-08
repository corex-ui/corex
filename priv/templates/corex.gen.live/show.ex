defmodule <%= inspect context.web_module %>.<%= inspect Module.concat(schema.web_namespace, schema.alias) %>Live.Show do
  use <%= inspect context.web_module %>, :live_view

  alias <%= inspect context.module %>

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}<%= if layout_mode do %> mode={@mode}<% end %><%= if layout_theme do %> theme={@theme}<% end %><%= if layout_theme do %> themes={@themes}<% end %><%= if layout_locale do %> locale={@locale} current_path={@current_path}<% end %><%= if scope do %> <%= scope.assign_key %>={@<%= scope.assign_key %>}<% end %>>
      <div class="flex items-center justify-between gap-4">
        <div>
          <h1 class="text-lg font-semibold"><%= schema.human_singular %> {@<%= schema.singular %>.<%= primary_key %>}</h1>
          <p class="mt-1 text-sm text-zinc-500">This is a <%= schema.singular %> record from your database.</p>
        </div>
        <div class="flex gap-2">
          <.navigate to={~p"<%= if layout_locale do %>/#{@locale}<% end %><%= scope_assign_route_prefix %><%= schema.route_prefix %>"} type="navigate" aria_label="Back to list">
            <.heroicon name="hero-arrow-left" />
          </.navigate>
          <.navigate
            to={~p"<%= if layout_locale do %>/#{@locale}<% end %><%= scope_assign_route_prefix %><%= schema.route_prefix %>/#{@<%= schema.singular %>}/edit?return_to=show"}
            type="navigate"
            class="button button--primary"
          >
            <.heroicon name="hero-pencil-square" /> Edit <%= schema.singular %>
          </.navigate>
        </div>
      </div>

      <dl class="mt-6 grid grid-cols-1 gap-4 sm:grid-cols-2"><%= for {k, _} <- schema.attrs do %>
        <div class="border-t border-zinc-100 pt-4 dark:border-zinc-700">
          <dt class="text-sm font-medium text-zinc-500"><%= Phoenix.Naming.humanize(Atom.to_string(k)) %></dt>
          <dd class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">{@<%= schema.singular %>.<%= k %>}</dd>
        </div><% end %>
      </dl>
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
