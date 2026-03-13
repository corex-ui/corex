defmodule <%= inspect context.web_module %>.<%= inspect Module.concat(schema.web_namespace, schema.alias) %>Live.Index do
  use <%= inspect context.web_module %>, :live_view

  alias <%= inspect context.module %>

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}<%= if layout_mode do %>
      mode={@mode}<% end %><%= if layout_theme do %>
      theme={@theme}<% end %><%= if layout_themes do %>
      themes={@themes}<% end %><%= if layout_locale do %>
      locale={@locale}
      current_path={@current_path}<% end %><%= if scope do %>
      <%= scope.assign_key %>={@<%= scope.assign_key %>}<% end %>
    >
      <.layout_heading>
        <:title>Listing <%= schema.human_plural %></:title>
        <:subtitle>Add and manage <%= schema.singular %> records</:subtitle>
        <:actions>
          <.navigate to={~p"<%= if layout_locale do %>/#{@locale}<% end %><%= scope_assign_route_prefix %><%= schema.route_prefix %>/new"} type="navigate" class="button button--accent">
            <.heroicon name="hero-plus" /> New <%= schema.human_singular %>
          </.navigate>
        </:actions>
      </.layout_heading>

      <.data_table
        id="<%= schema.plural %>"
        class="data-table"
        rows={@streams.<%= schema.collection %>}
        row_click={fn {_id, <%= schema.singular %>} -> JS.navigate(~p"<%= if layout_locale do %>/#{@locale}<% end %><%= scope_assign_route_prefix %><%= schema.route_prefix %>/#{<%= schema.singular %>}") end}
      ><%= for {k, _} <- schema.attrs do %>
        <:col :let={{_id, <%= schema.singular %>}} label="<%= Phoenix.Naming.humanize(Atom.to_string(k)) %>">{<%= schema.singular %>.<%= k %>}</:col><% end %>
        <:action :let={{_id, <%= schema.singular %>}}>
          <div class="sr-only">
            <.link navigate={~p"<%= if layout_locale do %>/#{@locale}<% end %><%= scope_assign_route_prefix %><%= schema.route_prefix %>/#{<%= schema.singular %>}"} class="link">Show</.link>
          </div>
          <.link
            navigate={~p"<%= if layout_locale do %>/#{@locale}<% end %><%= scope_assign_route_prefix %><%= schema.route_prefix %>/#{<%= schema.singular %>}/edit"}
            class="button button--sm"
            aria-label={"Edit #{<%= schema.singular %>.<%= schema.attrs |> Keyword.keys() |> List.first() %>}"}
          >
            <.heroicon name="hero-pencil-square" />
          </.link>
        </:action>
        <:action :let={{_id, <%= schema.singular %>}}>
          <.action
            phx-click={JS.push("delete", value: %{<%= primary_key %>: <%= schema.singular %>.<%= primary_key %>})}
            data-confirm="Are you sure?"
            class="button button--sm button--alert"
            aria-label={"Delete #{<%= schema.singular %>.<%= schema.attrs |> Keyword.keys() |> List.first() %>}"}
          >
            <.heroicon name="hero-trash" />
          </.action>
        </:action>
      </.data_table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do<%= if scope do %>
    if connected?(socket) do
      <%= inspect context.alias %>.subscribe_<%= schema.plural %>(<%= socket_scope %>)
    end
<% end %>
    {:ok,
     socket
     |> assign(:page_title, "Listing <%= schema.human_plural %>")<%= if primary_key != :id do %>
     |> stream_configure(:<%= schema.collection %>, dom_id: &"<%= schema.collection %>-#{&1.<%= primary_key %>}")<% end %>
     |> stream(:<%= schema.collection %>, list_<%= schema.plural %>(<%= socket_scope %>))}
  end

  @impl true
  def handle_event("delete", %{"<%= primary_key %>" => <%= primary_key %>}, socket) do
    <%= schema.singular %> = <%= inspect context.alias %>.get_<%= schema.singular %>!(<%= context_scope_prefix %><%= primary_key %>)
    {:ok, _} = <%= inspect context.alias %>.delete_<%= schema.singular %>(<%= context_scope_prefix %><%= schema.singular %>)

    {:noreply, stream_delete(socket, :<%= schema.collection %>, <%= schema.singular %>)}
  end<%= if scope do %>

  @impl true
  def handle_info({type, %<%= inspect schema.module %>{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, stream(socket, :<%= schema.collection %>, list_<%= schema.plural %>(<%= socket_scope %>), reset: true)}
  end<% end %>

  defp list_<%= schema.plural %>(<%= scope && scope.assign_key %>) do
    <%= inspect context.alias %>.list_<%= schema.plural %>(<%= scope && scope.assign_key %>)
  end
end
