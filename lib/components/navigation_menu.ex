defmodule Corex.NavigationMenu do
  @moduledoc ~S'''
  NavigationMenu for Phoenix LiveView. Behavior follows [Zag.js](https://zagjs.com/components/react/navigation-menu).
  
  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

    ```heex
    <.navigation_menu class="navigation-menu" />
    ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.navigation_menu>`.

  ## Events

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_value_change="navigation_menu_changed"` | Value changes | `%{"id" => id, "value" => value}` |

  <!-- tabs-open -->

  ### on_value_change

    ```heex
    <.navigation_menu class="navigation-menu" />
    ```

    ```elixir
    def handle_event("navigation_menu_changed", payload, socket) do
      {:noreply, socket}
    end
    ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_value_change_client="navigation-menu-changed"` | Value changes | `id`, `value` |

  ## Style

  Target parts with `data-scope` and `data-part`, or use Corex Design: `class="navigation-menu"`.

    ```css
    [data-scope="navigation-menu"][data-part="root"] {}
    ```

  Axes: **Semantic**, **Variant** (`ui-solid`), **Size**, **Radius**. See the [modifier guide](modifiers.html).

  <!-- tabs-open -->

  ### Semantic

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `navigation-menu` |
  | Accent | `navigation-menu ui-accent` |

  <!-- tabs-close -->

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

  def navigation_menu(assigns) do
    assigns = Corex.FormField.assign_stable_id(assigns, "navigation-menu")

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
        <div data-scope="navigation-menu" data-part="list">
          <div data-scope="navigation-menu" data-part="item" data-value="home">
            <a data-scope="navigation-menu" data-part="link" data-value="home" href="#">Home</a>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
