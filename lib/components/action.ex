defmodule Corex.Action do
  @moduledoc """
  Renders a button element for actions based of Phoenix Core Components.
  Use the `type` attribute to set the button type.
  Icon-only buttons must pass `aria_label` to screen readers.

  ## Examples
    ```elixir
    <.action>Send!</.action>
    <.action phx-click="go">Send!</.action>
    <.action type="submit">Save</.action>
    <.action aria_label="Close dialog">
      <.icon name="hero-x-mark" aria-hidden="true" />
    </.action>
    ```

  ## Styling

  If you wish to use the default Corex styling, you can use the class `button` on the component.
  This requires to install `Mix.Tasks.Corex.Design` first and import the component css file.

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/button.css";
  ```

  You can then use modifiers

  ```heex
  <.action class="button button--accent button--lg">
  ```

  Learn more about modifiers and [Corex Design](https://corex-ui.com/components/button#modifiers)
  """

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

  attr(:rest, :global,
    include: ~w(class name value form phx-click phx-submit phx-disable-with phx-value)
  )

  slot(:inner_block, required: true)

  def action(assigns) do
    ~H"""
    <button type={@type} aria-label={@aria_label} disabled={@disabled} {@rest}>
      {render_slot(@inner_block)}
    </button>
    """
  end
end
