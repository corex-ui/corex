defmodule Corex.ImageCropper do
  @moduledoc ~S'''
  ImageCropper for Phoenix LiveView. Behavior follows [Zag.js](https://zagjs.com/components/react/image-cropper).

  Crop geometry is created after JavaScript hydrates. The server renders a loading viewport and the source image only.

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

    ```heex
    <.image_cropper class="image-cropper" src="/images/beach.jpg" />
    ```

  ### Preview

    ```heex
    <.action phx-click={Corex.ImageCropper.preview("cropper")} class="button ui-size-sm">View preview</.action>
    <.image_cropper id="cropper" class="image-cropper" src="/images/beach.jpg" />
    <img data-image-cropper-preview="cropper" alt="Crop preview" hidden />
    ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.image_cropper>`.

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`preview/1`](#preview/1) | Export the current crop as a data URL (client) | `%Phoenix.LiveView.JS{}` |

  ## Events

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_value_change="image_cropper_changed"` | Value changes | `%{"id" => id, "value" => value}` |

  <!-- tabs-open -->

  ### on_value_change

    ```heex
    <.image_cropper class="image-cropper" src="/images/beach.jpg" />
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

  import Corex.Api.Doc

  alias Corex.ImageCropper.Anatomy.{Image, Props, Root, Viewport}
  alias Corex.ImageCropper.Connect
  alias Corex.Selectors
  alias Phoenix.LiveView.JS

  attr(:id, :string, required: false)
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
  attr(:on_value_change, :string, default: nil)
  attr(:on_value_change_client, :string, default: nil)
  attr(:src, :string, default: "/images/beach.jpg")

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
        <div {Connect.mounted_viewport(%Viewport{id: @id, dir: @dir})}>
          <img {Connect.mounted_image(%Image{id: @id, dir: @dir})} src={@src} alt="" />
        </div>
      </div>
    </div>
    """
  end

  api_doc(~S"""
  Export the current crop as a data URL and paint `[data-image-cropper-preview="<id>"]`.
  """)

  @spec preview(String.t()) :: Phoenix.LiveView.JS.t()
  def preview(image_cropper_id) when is_binary(image_cropper_id) do
    JS.dispatch("corex:image-cropper:preview",
      to: Selectors.css_id(image_cropper_id),
      detail: %{},
      bubbles: false
    )
  end
end
