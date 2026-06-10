defmodule Corex.Action do
  @moduledoc ~S'''
  Renders a button element for actions based on Phoenix Core Components.
  Use the `type` attribute to set the button type.
  Icon-only buttons must pass `aria_label` to screen readers.

  ## Anatomy

  ```heex
  <.action>Send!</.action>

  <.action phx-click="go">Send!</.action>

  <.action type="submit">Save</.action>

  <.action aria_label="Close dialog">
    <:indicator><.heroicon name="hero-x-mark" aria-hidden="true" /></:indicator>
  </.action>
  ```

  ## Styling

  Style attrs and BEM classes are equivalent. See [Unstyled](unstyled.html). Axes: `semantic`, `variant`, `size`, `shape`, `radius`.

  <!-- tabs-open -->

  ### With attributes

  ```heex
  <.action semantic="accent" size="lg" class="button">Get started</.action>
  ```

  ### With classes

  ```heex
  <.action class="button button--semantic-accent button--size-lg">Get started</.action>
  ```

  <!-- tabs-close -->

  Default look is `button` (`data-button`). Use `as="link"` for a
  link-styled control that remains a `<button>` (for example "Show more" actions).

  See [Styled](styled.html) or import generated CSS:

  ```css
  @import "./corex.tailwind.css";
  ```

  Stack modifiers on the host.

  <!-- tabs-open -->

  ### Color

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `button` |
  | Accent | `button button--semantic-accent` |
  | Brand | `button button--semantic-brand` |
  | Alert | `button button--semantic-alert` |
  | Info | `button button--semantic-info` |
  | Success | `button button--semantic-success` |

  ### Size

  | Modifier | Classes |
  | -------- | ------- |
  | SM | `button button--size-sm` |
  | MD | `button button--size-md` |
  | LG | `button button--size-lg` |
  | XL | `button button--size-xl` |

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

  use Corex.Variants,
    kind: :recipe,
    recipes: [:button, :link],
    default: :button,
    defaults: [variant: :solid, size: :md]

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

  slot(:inner_block, required: false)

  slot :indicator, required: false do
    attr(:class, :string, required: false)
  end

  def action(assigns) do
    ~H"""
    <button type={@type} aria-label={@aria_label} disabled={@disabled} name={@name} value={@value} class={corex_style_class(assigns)} {@rest}>
      <span :if={@indicator != []} data-part="indicator" class={Map.get(Enum.at(@indicator, 0), :class)}>
        {render_slot(@indicator)}
      </span>
      {render_slot(@inner_block)}
    </button>
    """
  end
end
