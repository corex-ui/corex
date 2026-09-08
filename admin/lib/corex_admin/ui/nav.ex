defmodule CorexAdmin.UI.Nav do
  @moduledoc """
  Sidebar tree, mobile navigation, and breadcrumbs.

  `tree/1` is what a host admin layout mounts in its aside. It only lists
  resources the actor may index, so navigation never advertises a page that
  would then refuse to load.
  """

  use CorexAdmin.UI

  attr :socket, :any, required: true
  attr :id, :string, default: "admin-nav-tree"
  attr :class, :string, default: "tree-view navigation max-w-xs aside-nav-tree"

  @doc "Grouped resource navigation for the admin aside."
  def tree(assigns) do
    grouped = Helpers.grouped_resources(assigns.socket)
    request_path = Helpers.current_path(assigns.socket)
    items = tree_items(assigns.socket, grouped)
    current_to = longest_matching_to(request_path, leaf_paths(items))

    assigns =
      assigns
      |> assign(:items, items)
      |> assign(:selected, List.wrap(current_to))
      |> assign(:expanded, Enum.map(grouped, fn {group, _} -> "group:#{group}" end))
      |> assign(:current_to, current_to)
      |> assign(:hub_title, Helpers.hub_title(assigns.socket))

    ~H"""
    <.tree_view
      id={@id}
      class={@class}
      redirect
      value={@selected}
      expanded_value={@expanded}
      items={@items}
    >
      <:label>{@hub_title}</:label>
      <:branch :let={branch}>
        <span class="admin-truncate">{branch.label}</span>
      </:branch>
      <:item :let={item}>
        <span
          class={["admin-truncate", item.to == @current_to && "admin-nav-current"]}
          data-current={if(item.to == @current_to, do: "")}
        >
          {item.label}
        </span>
      </:item>
      <:branch_indicator>
        <.heroicon name="hero-chevron-right" class="icon" />
      </:branch_indicator>
    </.tree_view>
    """
  end

  attr :socket, :any, required: true

  @doc "Collapsible navigation for narrow viewports."
  def mobile(assigns) do
    ~H"""
    <.collapsible id="admin-nav-mobile" class="collapsible admin-mobile-menu">
      <:trigger>
        <.heroicon name="hero-bars-3" />
        <span class="sr-only">{Gettext.t("Open admin navigation")}</span>
      </:trigger>
      <:content>
        <.tree socket={@socket} id="admin-nav-tree-mobile" />
      </:content>
    </.collapsible>
    """
  end

  attr :prefix, :string, required: true
  attr :spec, Spec, default: nil
  attr :live_action, :atom, default: :index
  attr :record, :any, default: nil
  attr :hub_title, :string, default: "Admin"

  @doc "Hub / resource / record trail on show, new, and edit pages."
  def breadcrumbs(assigns) do
    ~H"""
    <nav
      :if={@live_action in [:show, :new, :edit]}
      aria-label={Gettext.t("Breadcrumb")}
      class="admin-crumbs"
    >
      <ol class="admin-crumbs-list">
        <li>
          <.navigate to={@prefix} class="admin-crumb-link">{@hub_title}</.navigate>
        </li>
        <li :if={@spec} class="admin-crumbs-item">
          <.heroicon name="hero-chevron-right" class="icon ui-size-sm" />
          <.navigate
            :if={@live_action != :index}
            to={Path.join(@prefix, @spec.slug)}
            class="admin-crumb-link"
          >
            {@spec.label}
          </.navigate>
        </li>
        <li :if={@live_action == :new} class="admin-crumbs-item">
          <.heroicon name="hero-chevron-right" class="icon ui-size-sm" />
          <span class="admin-crumb-current">{Gettext.t("New")}</span>
        </li>
        <li :if={@live_action == :show and @record} class="admin-crumbs-item">
          <.heroicon name="hero-chevron-right" class="icon ui-size-sm" />
          <span class="admin-crumb-current">{Helpers.record_title(@spec, @record)}</span>
        </li>
        <li :if={@live_action == :edit and @record} class="admin-crumbs-item">
          <.heroicon name="hero-chevron-right" class="icon ui-size-sm" />
          <.navigate
            to={Path.join([@prefix, @spec.slug, Helpers.record_id(@spec, @record)])}
            class="admin-crumb-link"
          >
            {Helpers.record_title(@spec, @record)}
          </.navigate>
        </li>
        <li :if={@live_action == :edit and @record} class="admin-crumbs-item">
          <.heroicon name="hero-chevron-right" class="icon ui-size-sm" />
          <span class="admin-crumb-current">{Gettext.t("Edit")}</span>
        </li>
      </ol>
    </nav>
    """
  end

  defp tree_items(socket, grouped) do
    home = Helpers.home_path(socket)

    home_item = %{
      label: Helpers.hub_title(socket),
      value: home,
      to: home,
      redirect: :navigate
    }

    group_items =
      Enum.map(grouped, fn {group, resources} ->
        %{
          label: group,
          value: "group:#{group}",
          children:
            Enum.map(resources, fn resource ->
              spec = Helpers.spec(resource)
              path = Helpers.resource_path(socket, spec)

              %{label: spec.label, value: path, to: path, redirect: :navigate}
            end)
        }
      end)

    Corex.Tree.new([home_item | group_items])
  end

  defp leaf_paths(items), do: Enum.flat_map(List.wrap(items), &leaf_path/1)

  defp leaf_path(%{children: children} = node) when is_list(children) and children != [] do
    nested = Enum.flat_map(children, &leaf_path/1)

    case Map.get(node, :to) do
      to when is_binary(to) -> nested ++ [to]
      _ -> nested
    end
  end

  defp leaf_path(%{to: to}) when is_binary(to), do: [to]
  defp leaf_path(_), do: []

  # The hub itself is a prefix of every resource path, so the deepest match wins.
  defp longest_matching_to(path, paths) when is_binary(path) do
    paths
    |> Enum.filter(fn to ->
      is_binary(to) and (path == to or String.starts_with?(path, to <> "/"))
    end)
    |> Enum.max_by(&String.length/1, fn -> nil end)
  end

  defp longest_matching_to(_path, _paths), do: nil
end
