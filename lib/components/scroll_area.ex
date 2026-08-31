defmodule Corex.ScrollArea do
  @moduledoc ~S'''
  ScrollArea for Phoenix LiveView. Behavior follows [Zag.js](https://zagjs.com/components/react/scroll-area).

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

    ```heex
    <.scroll_area class="scroll-area">
      <p>Scrollable paragraph. Corex ships LiveView hosts with Zag.js behavior so overlays, lists, and fields stay accessible.</p>
    </.scroll_area>
    ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.scroll_area>`.

  ## Events

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_value_change="scroll_area_changed"` | Value changes | `%{"id" => id, "value" => value}` |

  <!-- tabs-open -->

  ### on_value_change

    ```heex
    <.scroll_area class="scroll-area">
      <:inner_block>Long content</:inner_block>
    </.scroll_area>
    ```

    ```elixir
    def handle_event("scroll_area_changed", payload, socket) do
      {:noreply, socket}
    end
    ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_value_change_client="scroll-area-changed"` | Value changes | `id`, `value` |

  ## Style

  Target parts with `data-scope` and `data-part`, or use Corex Design: `class="scroll-area"`.

    ```css
    [data-scope="scroll-area"][data-part="root"] {}
    ```

  Axes: **Semantic**, **Size**, **Radius**. No variant axis. See the [modifier guide](modifiers.html).

  <!-- tabs-open -->

  ### Semantic

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `scroll-area` |
  | Accent | `scroll-area ui-accent` |

  <!-- tabs-close -->

  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.ScrollArea.Anatomy.{Props, Root}
  alias Corex.ScrollArea.Connect

  attr(:id, :string, required: false)
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
  attr(:on_value_change, :string, default: nil)
  attr(:on_value_change_client, :string, default: nil)
  slot(:inner_block, required: false)

  attr(:rest, :global)

  def scroll_area(assigns) do
    assigns = Corex.FormField.assign_stable_id(assigns, "scroll-area")

    ~H"""
    <div
      id={@id}
      phx-hook="ScrollArea"
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
        <div data-scope="scroll-area" data-part="viewport">
          <div data-scope="scroll-area" data-part="content">
            <%= if @inner_block != [] do %>
              {render_slot(@inner_block)}
            <% else %>
              <p :for={n <- 1..12}>Scrollable paragraph {n}. Corex ships LiveView hosts with Zag.js behavior so overlays, lists, and fields stay accessible.</p>
            <% end %>
          </div>
        </div>
        <div data-scope="scroll-area" data-part="scrollbar">
          <div data-scope="scroll-area" data-part="thumb"></div>
        </div>
      </div>
    </div>
    """
  end
end
