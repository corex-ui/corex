defmodule Corex.Navigate do
  @moduledoc """
  Renders an anchor element for navigation based of Phoenix Core Components and Phoenix Link

  Supports plain href, LiveView navigate, and LiveView patch.
  External links should be flagged with the `external` attribute.
  Icon-only links must pass `aria_label` to screen readers.

  ## Examples

  ```heex
      <.navigate to="/about">About</.navigate>
      <.navigate to={~p"/dashboard"} type="navigate">Dashboard</.navigate>
      <.navigate to={~p"/items"} type="patch">Filter</.navigate>
      <.navigate to="https://example.com" external>
        External
        <svg aria-label="Opens in a new window" ...>...</svg>
      </.navigate>
      <.navigate to="/file.pdf" download="report.pdf">
        Download PDF
        <svg aria-label="Download PDF, 2MB" ...>...</svg>
      </.navigate>
      <.navigate to="/profile" aria_label="View profile">
        <svg aria-hidden="true" ...>...</svg>
      </.navigate>
    ```

  ## Styling

  If you wish to use the default Corex styling, you can use the class `link` on the component.
  This requires to install `Mix.Tasks.Corex.Design` first and import the component css file.

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/link.css";
  ```

  You can then use modifiers

  ```heex
  <.navigate class="link link--accent link--lg">
  ```

  Learn more about modifiers and [Corex Design](https://corex-ui.com/components/link#modifiers)
  """

  @doc type: :component
  use Phoenix.Component

  attr(:to, :string, required: true, doc: "The destination URL")

  attr(:type, :string,
    default: "href",
    values: ["href", "navigate", "patch"],
    doc: "The navigation type, defaults to href"
  )

  attr(:external, :boolean,
    default: false,
    doc:
      "Marks the link as external, only valid with type=\"href\". Adds target=\"_blank\" and rel=\"noopener noreferrer\""
  )

  attr(:download, :any,
    default: nil,
    doc: "Prompts the browser to download the target, accepts a boolean or filename string"
  )

  attr(:aria_label, :string,
    default: nil,
    doc: "Required for icon-only links, describes the link to screen readers"
  )

  attr(:rest, :global, include: ~w(class method replace))
  slot(:inner_block, required: true)

  def navigate(%{rest: %{replace: _}, type: "href"} = assigns) do
    IO.warn("<.navigate> replace has no effect with type=\"href\"")
    navigate(Map.update!(assigns, :rest, &Map.delete(&1, :replace)))
  end

  def navigate(%{rest: %{method: _}, type: type} = assigns) when type in ["navigate", "patch"] do
    IO.warn("<.navigate> method has no effect with type=\"#{type}\"")
    navigate(Map.update!(assigns, :rest, &Map.delete(&1, :method)))
  end

  def navigate(%{external: true, type: type} = assigns) when type in ["navigate", "patch"] do
    IO.warn("<.navigate> external has no effect with type=\"#{type}\"")
    navigate(%{assigns | external: false})
  end

  def navigate(assigns) do
    ~H"""
    <.link
      href={@type == "href" && @to}
      navigate={@type == "navigate" && @to}
      patch={@type == "patch" && @to}
      download={@download}
      aria-label={@aria_label}
      target={@external && "_blank"}
      rel={@external && "noopener noreferrer"}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.link>
    """
  end
end
