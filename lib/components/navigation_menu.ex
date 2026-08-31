defmodule Corex.NavigationMenu do
  @moduledoc ~S'''
  Navigation menu for Phoenix LiveView. Behavior follows [Zag.js Navigation Menu](https://zagjs.com/components/react/navigation-menu).

  Pass `items={Corex.List.new([...])}`. Items with `:to` render as links. Items without `:to` render as triggers and pair with `<:content value="...">`.

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

    ```heex
    <.navigation_menu
      class="navigation-menu"
      items={
        Corex.List.new([
          %{value: "product", label: "Product"},
          %{value: "docs", label: "Docs"},
          %{value: "blog", label: "Blog", to: "#"},
          %{value: "pricing", label: "Pricing", to: "#"}
        ])
      }
    >
      <:content value="product">
        <p data-scope="navigation-menu" data-part="heading">Build with Corex</p>
        <p>Phoenix LiveView components with Zag.js behavior, Design tokens, and an installer.</p>
        <a href="#">Components</a>
        <a href="#">Playground</a>
        <a href="#">Design</a>
      </:content>
      <:content value="docs">
        <p data-scope="navigation-menu" data-part="heading">Documentation</p>
        <a href="#">Getting started</a>
        <a href="#">Anatomy</a>
        <a href="#">Forms</a>
        <a href="#">Accessibility</a>
      </:content>
    </.navigation_menu>
    ```

  ### Custom slots

  Use `:trigger`, `:link`, and `:content` with `:let={item}` to customize each row. Trigger items have no `:to`. Link items set `:to`.

    ```heex
    <.navigation_menu
      class="navigation-menu"
      items={
        Corex.List.new([
          %{value: "product", label: "Product", meta: %{icon: "hero-squares-2x2"}},
          %{value: "docs", label: "Docs", to: "#", meta: %{icon: "hero-book-open"}}
        ])
      }
    >
      <:trigger :let={item}>
        <.heroicon name={item.meta.icon} />{item.label}
      </:trigger>
      <:link :let={item}>
        <.heroicon name={item.meta.icon} />{item.label}
      </:link>
      <:content :let={item} value="product">
        <p data-scope="navigation-menu" data-part="heading">{item.label}</p>
        <a href="#">Components</a>
        <a href="#">Playground</a>
        <a href="#">Design tokens</a>
        <a href="#">Installer</a>
      </:content>
    </.navigation_menu>
    ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.navigation_menu>`.

  ## Events

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_value_change="navigation_menu_changed"` | Active item changes | `%{"id" => id, "value" => value}` |

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_value_change_client="navigation-menu-changed"` | Active item changes | `id`, `value` |

  ## Style

  Target parts with `data-scope` and `data-part`, or use Corex Design: `class="navigation-menu"`.

    ```css
    [data-scope="navigation-menu"][data-part="root"] {}
    [data-scope="navigation-menu"][data-part="content"] {}
    ```

  Axes: **Semantic**, **Variant** (`ui-solid`), **Size**, **Radius**. See the [modifier guide](modifiers.html).

  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.NavigationMenu.Anatomy.{Content, Link, List, Props, Root, Trigger}
  alias Corex.NavigationMenu.Connect

  @spec default_items() :: [Corex.List.Item.t()]
  def default_items do
    Corex.List.new([
      %{value: "product", label: "Product"},
      %{value: "docs", label: "Docs"},
      %{value: "blog", label: "Blog", to: "#"},
      %{value: "pricing", label: "Pricing", to: "#"}
    ])
  end

  attr(:id, :string, required: false)
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
  attr(:on_value_change, :string, default: nil)
  attr(:on_value_change_client, :string, default: nil)

  attr(:items, :list,
    default: nil,
    doc: "Items from `Corex.List.new/1`. Items with `:to` render as links; others as triggers."
  )

  attr(:rest, :global)

  slot :trigger do
    attr(:class, :string, required: false)
  end

  slot :link do
    attr(:class, :string, required: false)
  end

  slot :content do
    attr(:value, :string, required: false)
    attr(:class, :string, required: false)
  end

  slot :indicator do
    attr(:class, :string, required: false)
  end

  def navigation_menu(assigns) do
    assigns = Corex.FormField.assign_stable_id(assigns, "navigation-menu")

    items =
      case assigns.items do
        nil -> default_items()
        list when is_list(list) -> Corex.List.new(list)
      end

    content_by_value =
      Map.new(assigns.content, fn slot -> {slot[:value], slot} end)

    assigns =
      assigns
      |> assign(:nav_items, items)
      |> assign(:content_by_value, content_by_value)

    ~H"""
    <div
      id={@id}
      phx-hook="NavigationMenu"
      {Corex.Hook.loading()}
      {@rest}
      {Connect.props(%Props{
        id: @id,
        dir: @dir,
        on_value_change: @on_value_change,
        on_value_change_client: @on_value_change_client
      })}
    >
      <div {Connect.mounted_root(%Root{id: @id, dir: @dir})}>
        <ul {Connect.mounted_list(%List{id: @id, dir: @dir})}>
          <li :for={item <- @nav_items} data-scope="navigation-menu" data-part="item" data-value={item.value}>
            <a
              :if={item.to}
              {Connect.mounted_link(%Link{id: @id, dir: @dir, value: item.value})}
              href={item.to}
            >
              <%= if @link != [] do %>
                {render_slot(@link, item)}
              <% else %>
                {item.label}
              <% end %>
            </a>
            <button
              :if={!item.to}
              {Connect.mounted_trigger(%Trigger{id: @id, dir: @dir, value: item.value})}
            >
              <%= if @trigger != [] do %>
                {render_slot(@trigger, item)}
              <% else %>
                {item.label}
              <% end %>
              <%= if @indicator != [] do %>
                {render_slot(@indicator, item)}
              <% else %>
                <Corex.Heroicon.heroicon name="hero-chevron-down" />
              <% end %>
            </button>
          </li>
        </ul>

        <div
          :for={item <- trigger_items(@nav_items)}
          {Connect.mounted_content(%Content{id: @id, dir: @dir, value: item.value})}
        >
          <div data-scope="navigation-menu" data-part="viewport-inner">
            <%= if slot = @content_by_value[item.value] do %>
              {render_slot([slot], item)}
            <% else %>
              {default_panel(item)}
            <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp trigger_items(items), do: Enum.reject(items, & &1.to)

  defp default_panel(%{value: "product"}) do
    assigns = %{}

    ~H"""
    <p data-scope="navigation-menu" data-part="heading">Build with Corex</p>
    <p>Phoenix LiveView components with Zag.js behavior, Design tokens, and an installer.</p>
    <a href="#">Components</a>
    <a href="#">Playground</a>
    <a href="#">Design</a>
    """
  end

  defp default_panel(%{value: "docs"}) do
    assigns = %{}

    ~H"""
    <p data-scope="navigation-menu" data-part="heading">Documentation</p>
    <a href="#">Getting started</a>
    <a href="#">Anatomy</a>
    <a href="#">Forms</a>
    <a href="#">Accessibility</a>
    """
  end

  defp default_panel(item) do
    assigns = %{item: item}

    ~H"""
    <p data-scope="navigation-menu" data-part="heading">{@item.label}</p>
    """
  end
end
