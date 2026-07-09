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
  @import "../corex/components.css";
  ```

  Stack modifiers on the host. Combine axes, for example `button button--accent button--lg` or `button button--info button--variant-ghost`.

  Axes: **Semantic** (`--accent`, `--brand`, `--alert`, `--info`, `--success`), **Variant** (`--variant-solid`, `--variant-subtle`, `--variant-ghost`, `--variant-outline`), **Size** (`--sm`, `--md`, `--lg`, `--xl`, also scales text). See the [modifier guide](modifiers.html).

  Semantic modifiers set palette variables. Variant modifiers control surface treatment. Default is subtle; add `button--variant-solid` for a filled button.

  <!-- tabs-open -->

  ### Semantic

  Palette variables for button ink and fill. Does not change surface treatment by itself.

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `button` |
  | Accent | `button button--accent` |
  | Brand | `button button--brand` |
  | Alert | `button button--alert` |
  | Info | `button button--info` |
  | Success | `button button--success` |

  ### Variant

  Visual treatment of the button surface. Combine with a semantic modifier for palette-driven ink and fill.

  | Modifier | Classes |
  | -------- | ------- |
  | Subtle (default) | `button` or `button button--accent` |
  | Solid | `button button--accent button--variant-solid` |
  | Ghost | `button button--variant-ghost` |
  | Outline | `button button--accent button--variant-outline` |

  ### Size

  | Modifier | Classes |
  | -------- | ------- |
  | SM | `button button--sm` |
  | MD | `button button--md` |
  | LG | `button button--lg` |
  | XL | `button button--xl` |

  ### Rounded

  Use Tailwind `rounded-*` utilities on the host (for example `class="button rounded-xl"`).

  | Modifier | Classes |
  | -------- | ------- |
  | None | `button rounded-none` |
  | SM | `button rounded-sm` |
  | MD | `button rounded-md` |
  | LG | `button rounded-lg` |
  | XL | `button rounded-xl` |
  | Full | `button rounded-full` |

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
