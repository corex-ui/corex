defmodule Corex.Splitter do
  @moduledoc ~S'''
  Splitter for Phoenix LiveView. Behavior follows [Zag.js](https://zagjs.com/components/react/splitter).

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

    ```heex
    <.splitter class="splitter" />
    ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.splitter>`.

  ## Events

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_resize="splitter_resized"` | Panels resize | `%{"id" => id, "size" => size}` |

  <!-- tabs-open -->

  ### on_resize

    ```heex
    <.splitter class="splitter" />
    ```

    ```elixir
    def handle_event("splitter_resized", payload, socket) do
      {:noreply, socket}
    end
    ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_resize_client="splitter-resized"` | Panels resize | `id`, `size` |

  ## Style

  Target parts with `data-scope` and `data-part`, or use Corex Design: `class="splitter"`.

    ```css
    [data-scope="splitter"][data-part="root"] {}
    ```

  Axes: **Semantic**, **Variant** (`ui-solid`), **Size**, **Radius**. See the [modifier guide](modifiers.html).

  <!-- tabs-open -->

  ### Semantic

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `splitter` |
  | Accent | `splitter ui-accent` |

  <!-- tabs-close -->

  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.Splitter.Anatomy.{Panel, Props, ResizeTrigger, Root}
  alias Corex.Splitter.Connect

  attr(:id, :string, required: false)
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
  attr(:on_resize, :string, default: nil)
  attr(:on_resize_client, :string, default: nil)
  attr(:orientation, :string, default: "horizontal", values: ["horizontal", "vertical"])

  attr(:rest, :global)

  def splitter(assigns) do
    assigns = Corex.FormField.assign_stable_id(assigns, "splitter")

    ~H"""
    <div
      id={@id}
      phx-hook="Splitter"
      {Corex.Hook.loading()}
      {@rest}
      {Connect.props(%Props{
        id: @id,
        dir: @dir,
        orientation: @orientation,
        on_resize: @on_resize,
        on_resize_client: @on_resize_client
      })}
    >
      <div {Connect.mounted_root(%Root{id: @id, dir: @dir, orientation: @orientation})}>
        <div
          {Connect.mounted_panel(%Panel{id: @id, dir: @dir, panel_id: "a"})}
          data-orientation={@orientation}
        >
          Sidebar. Drag the handle to resize this pane against the editor.
        </div>
        <button
          type="button"
          {Connect.mounted_resize_trigger(%ResizeTrigger{id: @id, dir: @dir, trigger_id: "a:b"})}
          data-orientation={@orientation}
        >
        </button>
        <div
          {Connect.mounted_panel(%Panel{id: @id, dir: @dir, panel_id: "b"})}
          data-orientation={@orientation}
        >
          Editor. Panel sizes come from Zag flex percentages after the hook hydrates.
        </div>
      </div>
    </div>
    """
  end
end
