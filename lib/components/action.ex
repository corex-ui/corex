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
  @import "../corex/corex.css";
  ```

  Stack modifiers on the host. Combine axes, for example `button ui-accent ui-size-lg` or `button ui-info`.

  Axes: **Semantic** (`ui-accent`, `ui-brand`, `ui-alert`, `ui-info`, `ui-success`), **Variant** (`ui-solid`), **Size** (`ui-size-sm` … `ui-size-xl`), **Radius** (`ui-rounded-*`). See the [modifier guide](modifiers.html).

  Semantic modifiers set palette variables. Add `ui-solid` for a filled button. Default is subtle.

  <!-- tabs-open -->

  ### Semantic

  Palette variables for button ink and fill. Does not change surface treatment by itself.

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `button` |
  | Accent | `button ui-accent` |
  | Brand | `button ui-brand` |
  | Alert | `button ui-alert` |
  | Info | `button ui-info` |
  | Success | `button ui-success` |

  ### Variant

  | Modifier | Classes |
  | -------- | ------- |
  | Subtle (default) | `button` or `button ui-accent` |
  | Solid | `button ui-accent ui-solid` |

  ### Size

  | Modifier | Classes |
  | -------- | ------- |
  | SM | `button ui-size-sm` |
  | MD | `button ui-size-md` |
  | LG | `button ui-size-lg` |
  | XL | `button ui-size-xl` |

  ### Rounded

  | Modifier | Classes |
  | -------- | ------- |
  | None | `button ui-rounded-none` |
  | SM | `button ui-rounded-sm` |
  | MD | `button ui-rounded-md` |
  | LG | `button ui-rounded-lg` |
  | XL | `button ui-rounded-xl` |
  | Full | `button ui-rounded-full` |

  ### Shape

  | Modifier | Classes |
  | -------- | ------- |
  | Square | `button ui-trigger--square` |
  | Circle | `button ui-trigger--circle` |

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
