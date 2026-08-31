defmodule Corex.ImageCropper do
  @moduledoc ~S'''
  ImageCropper for Phoenix LiveView. Behavior follows [Zag.js](https://zagjs.com/components/react/image-cropper).

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

    ```heex
    <.image_cropper class="image-cropper" src="/images/cropper-demo.png" />
    ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.image_cropper>`.

  ## Events

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_value_change="image_cropper_changed"` | Value changes | `%{"id" => id, "value" => value}` |

  <!-- tabs-open -->

  ### on_value_change

    ```heex
    <.image_cropper class="image-cropper" />
    ```

    ```elixir
    def handle_event("image_cropper_changed", payload, socket) do
      {:noreply, socket}
    end
    ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_value_change_client="image-cropper-changed"` | Value changes | `id`, `value` |

  ## Style

  Target parts with `data-scope` and `data-part`, or use Corex Design: `class="image-cropper"`.

    ```css
    [data-scope="image-cropper"][data-part="root"] {}
    ```

  Axes: **Semantic**, **Variant** (`ui-solid`), **Size**, **Radius**. See the [modifier guide](modifiers.html).

  <!-- tabs-open -->

  ### Semantic

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `image-cropper` |
  | Accent | `image-cropper ui-accent` |

  <!-- tabs-close -->

  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.ImageCropper.Anatomy.{Props, Root}
  alias Corex.ImageCropper.Connect

  attr(:id, :string, required: false)
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
  attr(:on_value_change, :string, default: nil)
  attr(:on_value_change_client, :string, default: nil)
  attr(:src, :string, default: "/images/cropper-demo.png")

  attr(:rest, :global)

  def image_cropper(assigns) do
    assigns = Corex.FormField.assign_stable_id(assigns, "image-cropper")

    ~H"""
    <div
      id={@id}
      phx-hook="ImageCropper"
      {Corex.Hook.loading()}
      {@rest}
      {Connect.props(%Props{
        id: @id,
        dir: @dir,
        src: @src,
        on_value_change: @on_value_change,
        on_value_change_client: @on_value_change_client
      })}
    >
      <div {Connect.mounted_root(%Root{id: @id, dir: @dir})}>
        <div data-scope="image-cropper" data-part="viewport">
          <img data-scope="image-cropper" data-part="image" src={@src} alt="" />
          <div data-scope="image-cropper" data-part="selection"></div>
        </div>
      </div>
    </div>
    """
  end
end
