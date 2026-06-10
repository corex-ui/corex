defmodule Corex.Toggle do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Toggle](https://zagjs.com/components/react/toggle).

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

  ```heex
  <.toggle>
    lorem
  </.toggle>
  ```

  ### With indicator

  ```heex
  <.toggle>
    <:indicator><.heroicon name="hero-bold" /></:indicator>
    Bold
  </.toggle>

  <.toggle>
    <:indicator><.heroicon name="hero-bold" /></:indicator>
    <span class="sr-only">Bold</span>
  </.toggle>
  ```

  ### Dual label

  Set `data-toggle-dual-label` on the host to swap visible label text when pressed. Use a second `<span data-pressed>` for the on-state label.

  ```heex
  <.toggle data-toggle-dual-label>
    <span>lorem</span>
    <span data-pressed>donec</span>
  </.toggle>
  ```

  <!-- tabs-close -->

  ## Styling

  Style attrs and BEM classes are equivalent. See [Unstyled](unstyled.html). Axes: `semantic`, `variant`, `size`, `text`, `radius`.

  <!-- tabs-open -->

  ### With attributes

  ```heex
  <.toggle semantic="accent" variant="solid" size="md" class="toggle">
    lorem
  </.toggle>
  ```

  ### With classes

  ```heex
  <.toggle class="toggle toggle--semantic-accent toggle--variant-solid toggle--size-md">
    lorem
  </.toggle>
  ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.toggle>`.

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`set_pressed/2`](#set_pressed/2) | Set pressed state (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_pressed/3`](#set_pressed/3) | Set pressed state (server) | `socket` |
  | [`toggle_pressed/2`](#toggle_pressed/2) | Toggle pressed (client) | `%Phoenix.LiveView.JS{}` |
  | [`toggle_pressed/3`](#toggle_pressed/3) | Toggle pressed (server) | `socket` |

  ## Events

  Pick an event name and pass it to `on_*` on `<.toggle>`.

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_pressed_change="toggle_pressed_changed"` | Pressed state changes | `%{"id" => id, "pressed" => boolean}` |

  <!-- tabs-open -->

  ### on_pressed_change

  ```heex
  <.toggle
    controlled
    pressed={false}
    on_pressed_change="toggle_pressed_changed"
  >
    lorem
  </.toggle>
  ```

  ```elixir
  def handle_event("toggle_pressed_changed", %{"pressed" => pressed}, socket) do
    p = pressed == true or pressed == "true"
    {:noreply, assign(socket, :pressed, p)}
  end
  ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_pressed_change_client="toggle-client-changed"` | Pressed state changes | `id`, `pressed` |

  <!-- tabs-open -->

  ### on_pressed_change_client

  ```heex
  <.toggle
    id="toggle-on-pressed-change-client"
    on_pressed_change_client="toggle-client-changed"
  >
    lorem
  </.toggle>
  ```

  ```javascript
  const el = document.getElementById("toggle-on-pressed-change-client");
  el?.addEventListener("toggle-client-changed", (e) => console.log(e.detail));
  ```

  <!-- tabs-close -->

  ## Patterns

  <!-- tabs-open -->

  ### Controlled

  For server-owned pressed state, set `controlled`, bind `pressed`, and handle `on_pressed_change` in LiveView.

  ```heex
  <.toggle
    controlled
    pressed={@pressed}
    on_pressed_change="toggle_patterns_pressed"
  >
    lorem
  </.toggle>
  ```

  ```elixir
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :pressed, false)}
  end

  def handle_event("toggle_patterns_pressed", %{"pressed" => pressed}, socket) do
    {:noreply, assign(socket, :pressed, pressed == true or pressed == "true")}
  end
  ```

  <!-- tabs-close -->

  ## Style

  Target parts with `data-scope` and `data-part`, or use [Corex Design](styled.html): `@import "./corex.tailwind.css"` in `app.css`.

  ```css
  [data-scope="toggle"][data-part="root"] {}
  [data-scope="toggle"][data-part="indicator"] {}
  ```

  Stack modifiers on the host (`class` on `<.toggle>`).

  <!-- tabs-open -->

  ### Color

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `toggle` |
  | Accent | `toggle toggle--semantic-accent` |
  | Brand | `toggle toggle--semantic-brand` |
  | Alert | `toggle toggle--semantic-alert` |
  | Info | `toggle toggle--semantic-info` |
  | Success | `toggle toggle--semantic-success` |

  ### Size

  | Modifier | Classes |
  | -------- | ------- |
  | SM | `toggle toggle--size-sm` |
  | MD | `toggle toggle--size-md` |
  | LG | `toggle toggle--size-lg` |
  | XL | `toggle toggle--size-xl` |

  ### Rounded

  | Modifier | Classes |
  | -------- | ------- |
  | None | `toggle toggle--rounded-none` |
  | SM | `toggle toggle--rounded-sm` |
  | MD | `toggle toggle--rounded-md` |
  | LG | `toggle toggle--rounded-lg` |
  | XL | `toggle toggle--rounded-xl` |
  | Full | `toggle toggle--rounded-full` |

  <!-- tabs-close -->

  '''

  @doc type: :component
  use Phoenix.Component

  import Corex.Api.Doc

  alias Corex.Toggle.Anatomy.{Indicator, Props, Root}
  alias Corex.Toggle.Connect
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  use Corex.Variants,
    base: "toggle",
    axes: [
      width: :width,
      max_width: :max_width,
      height: :height,
      max_height: :max_height,
      semantic: :semantic,
      variant: :visual,
      size: :size,
      text: :text,
      radius: :radius
    ],
    defaults: [
      width: "fit",
      max_width: "none",
      height: "auto",
      max_height: "none",
      variant: "solid",
      size: "md"
    ]

  attr(:id, :string, required: false)

  attr(:pressed, :boolean,
    default: false,
    doc: "Initial or controlled pressed state"
  )

  attr(:controlled, :boolean, default: false)
  attr(:disabled, :boolean, default: false)

  attr(:dir, :string,
    default: nil,
    values: [nil, "ltr", "rtl"],
    doc: "When nil, derived from document"
  )

  attr(:on_pressed_change, :string, default: nil)
  attr(:on_pressed_change_client, :string, default: nil)

  attr(:rest, :global)

  slot(:inner_block, required: false)

  slot :indicator, required: false do
    attr(:class, :string, required: false)
  end

  def toggle(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "toggle-#{System.unique_integer([:positive])}" end)
      |> assign_new(:dir, fn -> "ltr" end)

    ~H"""
    <div
      id={@id}
      phx-hook="Toggle"
      data-loading
      phx-mounted={Phoenix.LiveView.JS.ignore_attributes(["data-loading"])}
      class={corex_style_class(assigns)}
     
      {@rest}
      {Connect.props(%Props{
        id: @id,
        controlled: @controlled,
        pressed: @pressed,
        disabled: @disabled,
        dir: @dir,
        on_pressed_change: @on_pressed_change,
        on_pressed_change_client: @on_pressed_change_client
      })}
    >
      <button
        phx-mounted={Connect.ignore_root(%Root{id: @id, dir: @dir, pressed: @pressed, disabled: @disabled})}
        {Connect.root(%Root{id: @id, dir: @dir, pressed: @pressed, disabled: @disabled})}
      >
        <span
          :if={@indicator != []}
          class={Map.get(Enum.at(@indicator, 0), :class)}
          phx-mounted={Connect.ignore_indicator(%Indicator{id: @id, dir: @dir, pressed: @pressed, disabled: @disabled})}
          {Connect.indicator(%Indicator{id: @id, dir: @dir, pressed: @pressed, disabled: @disabled})}
        >
          {render_slot(@indicator)}
        </span>
        {render_slot(@inner_block)}
      </button>
    </div>
    """
  end

  api_doc(~S"""
  Set pressed state from a control (`phx-click`).

  ```heex
  <.action phx-click={Corex.Toggle.set_pressed("my-toggle", true)}>On</.action>
  <.toggle id="my-toggle" class="toggle">Label</.toggle>
  ```

  ```javascript
  document.getElementById("my-toggle")?.dispatchEvent(
    new CustomEvent("corex:toggle:set-pressed", {
      bubbles: false,
      detail: { pressed: true },
    })
  );
  ```
  """)

  def set_pressed(toggle_id, pressed) when is_binary(toggle_id) and is_boolean(pressed) do
    JS.dispatch("corex:toggle:set-pressed",
      to: "##{toggle_id}",
      detail: %{pressed: pressed},
      bubbles: false
    )
  end

  api_doc(~S"""
  Set pressed state from `handle_event`.

  ```heex
  <.action phx-click="press_toggle">On</.action>
  <.toggle id="my-toggle" class="toggle">Label</.toggle>
  ```

  ```elixir
  def handle_event("press_toggle", _, socket) do
    {:noreply, Corex.Toggle.set_pressed(socket, "my-toggle", true)}
  end
  ```
  """)

  def set_pressed(socket, toggle_id, pressed)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(toggle_id) and
             is_boolean(pressed) do
    LiveView.push_event(socket, "toggle_set_pressed", %{
      id: toggle_id,
      pressed: pressed
    })
  end

  api_doc(~S"""
  Flip pressed state from a control (`phx-click`).

  ```heex
  <.action phx-click={Corex.Toggle.toggle_pressed("my-toggle")}>Toggle</.action>
  <.toggle id="my-toggle" class="toggle">Label</.toggle>
  ```

  ```javascript
  document.getElementById("my-toggle")?.dispatchEvent(
    new CustomEvent("corex:toggle:toggle-pressed", { bubbles: false })
  );
  ```
  """)

  def toggle_pressed(toggle_id) when is_binary(toggle_id) do
    JS.dispatch("corex:toggle:toggle-pressed",
      to: "##{toggle_id}",
      bubbles: false
    )
  end

  api_doc(~S"""
  Flip pressed state from `handle_event`.

  ```heex
  <.action phx-click="flip_toggle">Toggle</.action>
  <.toggle id="my-toggle" class="toggle">Label</.toggle>
  ```

  ```elixir
  def handle_event("flip_toggle", _, socket) do
    {:noreply, Corex.Toggle.toggle_pressed(socket, "my-toggle")}
  end
  ```
  """)

  def toggle_pressed(socket, toggle_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(toggle_id) do
    LiveView.push_event(socket, "toggle_toggle_pressed", %{id: toggle_id})
  end
end
