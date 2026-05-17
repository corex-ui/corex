defmodule Corex.Action do
  @moduledoc ~S'''
  Renders a button element for actions based on Phoenix Core Components.
  Use the `type` attribute to set the button type.
  Icon-only buttons must pass `aria_label` to screen readers.

  ## Anatomy

  ```heex
  <.action class="button">Send!</.action>

  <.action class="button" phx-click="go">Send!</.action>

  <.action class="button" type="submit">Save</.action>

  <.action class="button" aria_label="Close dialog">
    <.heroicon name="hero-x-mark" aria-hidden="true" />
  </.action>
  ```

  ## Style

  Import tokens and `button.css`, then set `class="button"` on `<.action>`.

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/button.css";
  ```

  Stack modifiers on the host.

  <!-- tabs-open -->

  ### Color

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `button` |
  | Accent | `button button--accent` |
  | Brand | `button button--brand` |
  | Alert | `button button--alert` |
  | Info | `button button--info` |
  | Success | `button button--success` |

  ### Size

  | Modifier | Classes |
  | -------- | ------- |
  | SM | `button button--sm` |
  | MD | `button button--md` |
  | LG | `button button--lg` |
  | XL | `button button--xl` |

  ### Rounded

  | Modifier | Classes |
  | -------- | ------- |
  | None | `button button--rounded-none` |
  | SM | `button button--rounded-sm` |
  | MD | `button button--rounded-md` |
  | LG | `button button--rounded-lg` |
  | XL | `button button--rounded-xl` |
  | Full | `button button--rounded-full` |

  <!-- tabs-close -->

  '''

  @doc type: :component
  use Phoenix.Component

  attr(:type, :string,
    default: "button",
    values: ["button", "submit", "reset"],
    doc: "The button type, defaults to button to prevent accidental form submissions"
  )

  attr(:aria_label, :string,
    default: nil,
    doc: "Required for icon-only buttons, describes the button to screen readers"
  )

  attr(:disabled, :boolean, default: false, doc: "Disables the button")

  attr(:name, :string, default: nil, doc: "Form input name for submit buttons")
  attr(:value, :string, default: nil, doc: "Form input value for submit buttons")

  attr(:rest, :global)

  slot(:inner_block, required: true)

  def action(assigns) do
    ~H"""
    <button type={@type} aria-label={@aria_label} disabled={@disabled} name={@name} value={@value} {@rest}>
      {render_slot(@inner_block)}
    </button>
    """
  end
end
