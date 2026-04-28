defmodule E2eWeb.App.Aside do
  use E2eWeb, :html
  import E2eWeb.{Helpers}

  attr(:kind, :atom, required: true)
  attr(:node_id_base, :string, required: true)
  attr(:tip_scope, :string, required: true)

  def aside_menu_tree_badge(assigns) do
    tip = aside_badge_tip(assigns.kind)
    scope = String.replace(assigns.tip_scope, ~r/[^a-zA-Z0-9_-]+/u, "-")
    tip_id = "aside-tip-#{scope}-#{assigns.node_id_base}-#{assigns.kind}"

    assigns =
      assigns
      |> assign(:tip, tip)
      |> assign(:tip_id, tip_id)
      |> assign(:zag_img?, assigns.kind == :zagjs)

    ~H"""
    <div class="flex shrink-0 items-center">
      <.tooltip
        id={@tip_id}
        trigger_tag={:span}
        placement="top"
        class="tooltip tooltip--sm"
        close_on_click={false}
      >
        <:trigger>
          <span class="flex items-center cursor-default">
            <%= if @zag_img? do %>
              <img
                src={~p"/images/tech/zag.webp"}
                alt=""
                class="max-h-8 w-auto object-contain"
                decoding="async"
              />
            <% else %>
              <.heroicon name={aside_menu_hero(@kind)} class="icon h-8" />
            <% end %>
          </span>
        </:trigger>
        <:content>{@tip}</:content>
      </.tooltip>
    </div>
    """
  end

  attr(:node, :any, required: true)
  attr(:tip_scope, :string, required: true)

  def aside_menu_tree_meta(assigns) do
    meta =
      case assigns.node do
        %{meta: m} when is_map(m) -> m
        _ -> %{}
      end

    badges =
      case Map.get(meta, :aside_badges) do
        b when is_list(b) and b != [] ->
          b

        _ ->
          case Map.get(meta, :aside_icon) do
            nil -> []
            k -> [k]
          end
      end

    id = Map.fetch!(assigns.node, :id)
    id_base = String.replace(id, ~r/[^a-zA-Z0-9_-]+/u, "-")
    assigns = assign(assigns, :badges, badges) |> assign(:id_base, id_base)

    ~H"""
    <div :if={@badges != []} class="flex shrink-0 items-center gap-1">
      <.aside_menu_tree_badge
        :for={kind <- @badges}
        kind={kind}
        node_id_base={@id_base}
        tip_scope={@tip_scope}
      />
    </div>
    """
  end

  attr(:node, :any, required: true)
  attr(:tip_scope, :string, required: true)

  def aside_menu_tree_label_row(assigns) do
    ~H"""
    <span class="flex w-full min-w-0 items-center gap-2">
      <span class="min-w-0 flex-1 truncate">{@node.label}</span>
      <.aside_menu_tree_meta node={@node} tip_scope={@tip_scope} />
    </span>
    """
  end

  attr(:path, :string, required: true)
  attr(:form_menu, :list, required: true)
  attr(:components_menu, :list, required: true)
  attr(:form_tree_id, :string, required: true)
  attr(:components_tree_id, :string, required: true)
  attr(:tree_class, :string, default: "tree-view tree-view--accent max-w-xs layout__aside-tree")

  def aside_nav_tree_views(assigns) do
    assigns =
      assigns
      |> assign(:full_path, E2eWeb.Path.with_current_locale(assigns.path))
      |> assign(:has_form_menu, assigns.form_menu != [])
      |> assign(:has_components_menu, assigns.components_menu != [])

    ~H"""
    <.tree_view
      :if={@has_components_menu}
      id={@components_tree_id}
      class={@tree_class}
      redirect
      value={[@full_path]}
      expanded_value={ancestor_ids_for_path(@components_menu, @full_path)}
      items={@components_menu}
    >
      <:label>Components</:label>
      <:branch :let={branch}>
        <.aside_menu_tree_label_row node={branch} tip_scope={@components_tree_id} />
      </:branch>
      <:item :let={item}>
        <span class="min-w-0 truncate">{item.label}</span>
      </:item>
      <:branch_indicator>
        <.heroicon name="hero-chevron-right" class="icon" />
      </:branch_indicator>
    </.tree_view>
    <.tree_view
      :if={@has_form_menu}
      id={@form_tree_id}
      class={@tree_class}
      redirect
      value={[@full_path]}
      expanded_value={ancestor_ids_for_path(@form_menu, @full_path)}
      items={@form_menu}
    >
      <:label>Forms</:label>
      <:branch :let={branch}>
        <.aside_menu_tree_label_row node={branch} tip_scope={@form_tree_id} />
      </:branch>
      <:item :let={item}>
        <span class="min-w-0 truncate">{item.label}</span>
      </:item>
      <:branch_indicator>
        <.heroicon name="hero-chevron-right" class="icon" />
      </:branch_indicator>
    </.tree_view>
    """
  end

  attr(:path, :string, required: true)

  def aside(assigns) do
    form_menu = form_menu_items()
    components_menu = components_menu_items()

    assigns =
      assigns
      |> assign(:form_menu, form_menu)
      |> assign(:components_menu, components_menu)

    ~H"""
    <aside
      id="layout-aside-nav"
      class="layout__side hidden lg:flex scrollbar scrollbar--sm w-full max-w-2xs overflow-y-auto py-size gap-size"
      aria-label="Documentation navigation"
      phx-hook="AsideNavScroll"
    >
      <.aside_nav_tree_views
        path={@path}
        form_menu={@form_menu}
        components_menu={@components_menu}
        form_tree_id="form-menu-side"
        components_tree_id="components-menu-side"
      />
    </aside>
    """
  end

  defp aside_badge_tip(:zagjs), do: "Zag.js"
  defp aside_badge_tip(:form), do: "Form"
  defp aside_badge_tip(:navigation), do: "Navigation"

  defp aside_menu_hero(:navigation), do: "hero-link"
  defp aside_menu_hero(:form), do: "hero-queue-list"
end
