defmodule Corex.NavigationMenu do
  @moduledoc ~S'''
  Navigation menu for Phoenix LiveView. Behavior follows [Zag.js Navigation Menu](https://zagjs.com/components/react/navigation-menu).

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

    ```heex
    <.navigation_menu class="navigation-menu" />
    ```

  ### Mega menu

    ```heex
    <.navigation_menu class="navigation-menu">
      <:item value="product" type="trigger">Product</:item>
      <:content value="product">
        <p>Feature overview</p>
      </:content>
      <:item value="docs" href="#">Docs</:item>
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

  alias Corex.NavigationMenu.Anatomy.{Props, Root}
  alias Corex.NavigationMenu.Connect

  attr(:id, :string, required: false)
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
  attr(:on_value_change, :string, default: nil)
  attr(:on_value_change_client, :string, default: nil)
  attr(:rest, :global)

  slot :item, required: false do
    attr(:value, :string, required: true)
    attr(:href, :string, required: false)
    attr(:type, :string, required: false)
  end

  slot :content, required: false do
    attr(:value, :string, required: true)
  end

  def navigation_menu(assigns) do
    assigns = Corex.FormField.assign_stable_id(assigns, "navigation-menu")
    assigns = assign(assigns, :use_default?, assigns.item == [])

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
        <ul data-scope="navigation-menu" data-part="list">
          <%= if @use_default? do %>
            <li data-scope="navigation-menu" data-part="item" data-value="product">
              <button type="button" data-scope="navigation-menu" data-part="trigger" data-value="product">
                Product
              </button>
            </li>
            <li data-scope="navigation-menu" data-part="item" data-value="docs">
              <button type="button" data-scope="navigation-menu" data-part="trigger" data-value="docs">
                Docs
              </button>
            </li>
            <li data-scope="navigation-menu" data-part="item" data-value="blog">
              <a data-scope="navigation-menu" data-part="link" data-value="blog" href="#">Blog</a>
            </li>
            <li data-scope="navigation-menu" data-part="item" data-value="pricing">
              <a data-scope="navigation-menu" data-part="link" data-value="pricing" href="#">Pricing</a>
            </li>
          <% else %>
            <li :for={item <- @item} data-scope="navigation-menu" data-part="item" data-value={item.value}>
              <a
                :if={item[:href]}
                data-scope="navigation-menu"
                data-part="link"
                data-value={item.value}
                href={item[:href]}
              >
                {render_slot(item)}
              </a>
              <button
                :if={!item[:href]}
                type="button"
                data-scope="navigation-menu"
                data-part="trigger"
                data-value={item.value}
              >
                {render_slot(item)}
              </button>
            </li>
          <% end %>
        </ul>

        <%= if @use_default? do %>
          <div data-scope="navigation-menu" data-part="content" data-value="product" hidden>
            <div data-scope="navigation-menu" data-part="viewport-inner">
              <p data-scope="navigation-menu" data-part="heading">Build with Corex</p>
              <p>Phoenix LiveView components with Zag.js behavior, Design tokens, and an installer.</p>
              <a href="#">Components</a>
              <a href="#">Playground</a>
              <a href="#">Design</a>
            </div>
          </div>
          <div data-scope="navigation-menu" data-part="content" data-value="docs" hidden>
            <div data-scope="navigation-menu" data-part="viewport-inner">
              <p data-scope="navigation-menu" data-part="heading">Documentation</p>
              <a href="#">Getting started</a>
              <a href="#">Anatomy</a>
              <a href="#">Forms</a>
              <a href="#">Accessibility</a>
            </div>
          </div>
        <% else %>
          <div
            :for={panel <- @content}
            data-scope="navigation-menu"
            data-part="content"
            data-value={panel.value}
            hidden
          >
            {render_slot(panel)}
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
