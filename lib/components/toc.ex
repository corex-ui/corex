defmodule Corex.Toc do
  @moduledoc ~S'''
  Toc for Phoenix LiveView. Behavior follows [Zag.js](https://zagjs.com/components/react/tree-view).
  
  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

    ```heex
    <.toc class="toc" />
    ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.toc>`.

  ## Events

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_value_change="toc_changed"` | Value changes | `%{"id" => id, "value" => value}` |

  <!-- tabs-open -->

  ### on_value_change

    ```heex
    <.toc class="toc" />
    ```

    ```elixir
    def handle_event("toc_changed", payload, socket) do
      {:noreply, socket}
    end
    ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_value_change_client="toc-changed"` | Value changes | `id`, `value` |

  ## Style

  Target parts with `data-scope` and `data-part`, or use Corex Design: `class="toc"`.

    ```css
    [data-scope="toc"][data-part="root"] {}
    ```

  Axes: **Semantic**, **Variant** (`ui-solid`), **Size**, **Radius**. See the [modifier guide](modifiers.html).

  <!-- tabs-open -->

  ### Semantic

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `toc` |
  | Accent | `toc ui-accent` |

  <!-- tabs-close -->

  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.Toc.Anatomy.{Props, Root}
  alias Corex.Toc.Connect

  attr(:id, :string, required: false)
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
  attr(:on_value_change, :string, default: nil)
  attr(:on_value_change_client, :string, default: nil)

  attr(:rest, :global)

  def toc(assigns) do
    assigns = Corex.FormField.assign_stable_id(assigns, "toc")

    ~H"""
    <div
      id={@id}
      phx-hook="Toc"
      {Corex.Hook.loading()}
      {@rest}
      {Connect.props(%Props{
        id: @id,
        dir: @dir,
        on_value_change: @on_value_change,
        on_value_change_client: @on_value_change_client
      })}
    >
      <nav {Connect.mounted_root(%Root{id: @id, dir: @dir})}>
        <ul data-scope="toc" data-part="list">
          <li data-scope="toc" data-part="item" data-value="intro" data-depth="2">
            <a data-scope="toc" data-part="link" data-value="intro" data-depth="2" href="#intro">Intro</a>
          </li>
          <li data-scope="toc" data-part="item" data-value="usage" data-depth="2">
            <a data-scope="toc" data-part="link" data-value="usage" data-depth="2" href="#usage">Usage</a>
          </li>
        </ul>
      </nav>
    </div>
    """
  end
end
