defmodule Corex.Toggle do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Toggle](https://zagjs.com/components/react/toggle).

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

  ```heex
  <.toggle id="toggle-anatomy-minimal" class="toggle">
    lorem
  </.toggle>
  ```

  ### With indicator

  ```heex
  <.toggle id="toggle-anatomy-indicator-label" class="toggle">
    <:indicator><.heroicon name="hero-bold" /></:indicator>
    Bold
  </.toggle>

  <.toggle id="toggle-anatomy-indicator-sr" class="toggle">
    <:indicator><.heroicon name="hero-bold" /></:indicator>
    <span class="sr-only">Bold</span>
  </.toggle>
  ```

  ### Dual label

  Set `data-toggle-dual-label` on the host to swap visible label text when pressed. Use a second `<span data-pressed>` for the on-state label.

  ```heex
  <.toggle id="toggle-anatomy-switching-label" class="toggle" data-toggle-dual-label>
    <span>lorem</span>
    <span data-pressed>donec</span>
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
    id="toggle-on-pressed-change-server"
    class="toggle"
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
    class="toggle"
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
    id="toggle-patterns-controlled"
    class="toggle"
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

  Target parts with `data-scope` and `data-part`, or use Corex Design: import tokens and `toggle.css`, then set `class="toggle"` on `<.toggle>`.

  ```css
  [data-scope="toggle"][data-part="root"] {}
  [data-scope="toggle"][data-part="indicator"] {}
  ```

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/toggle.css";
  ```

  Stack modifiers on the host (`class` on `<.toggle>`).

  <!-- tabs-open -->

  ### Color

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `toggle` |
  | Accent | `toggle toggle--accent` |
  | Brand | `toggle toggle--brand` |
  | Alert | `toggle toggle--alert` |
  | Info | `toggle toggle--info` |
  | Success | `toggle toggle--success` |

  ### Size

  | Modifier | Classes |
  | -------- | ------- |
  | SM | `toggle toggle--sm` |
  | MD | `toggle toggle--md` |
  | LG | `toggle toggle--lg` |
  | XL | `toggle toggle--xl` |

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

  alias Corex.Toggle.Anatomy.{Indicator, Props, Root}
  alias Corex.Toggle.Connect
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

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

  @doc type: :api
  def set_pressed(toggle_id, pressed) when is_binary(toggle_id) and is_boolean(pressed) do
    JS.dispatch("corex:toggle:set-pressed",
      to: "##{toggle_id}",
      detail: %{pressed: pressed},
      bubbles: false
    )
  end

  def set_pressed(socket, toggle_id, pressed)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(toggle_id) and
             is_boolean(pressed) do
    LiveView.push_event(socket, "toggle_set_pressed", %{
      id: toggle_id,
      pressed: pressed
    })
  end

  @doc type: :api
  def toggle_pressed(toggle_id) when is_binary(toggle_id) do
    JS.dispatch("corex:toggle:toggle-pressed",
      to: "##{toggle_id}",
      bubbles: false
    )
  end

  def toggle_pressed(socket, toggle_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(toggle_id) do
    LiveView.push_event(socket, "toggle_toggle_pressed", %{id: toggle_id})
  end
end
