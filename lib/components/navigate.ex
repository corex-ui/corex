defmodule Corex.Navigate do
  @moduledoc """
  Renders an anchor element for navigation based of Phoenix Core Components and Phoenix Link

  Supports plain href, LiveView navigate, and LiveView patch.
  External links should be flagged with the `external` attribute.
  Icon-only links must pass `aria_label` to screen readers.

  This is the **link** counterpart to `Corex.Action` (button): `to` + `type` select the link mode;
  `method` and `replace` are the same knobs Phoenix’s unified `button` forwards on `{@rest}` when
  it renders `<.link>`, exposed here as named attrs so call sites stay explicit. Any other link
  attributes go through `rest`.

  ## Anatomy

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
        <svg aria-hidden="true" ...></svg>
      </.navigate>
    ```

  ## Style

  If you wish to use the default Corex styling, you can use the `link` class on the component.
  This requires you to install `Mix.Tasks.Corex.Design` first and import the component css file.

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/link.css";
  ```

  You can then use modifiers

  ```heex
  <.navigate class="link link--accent link--lg">
  ```

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

  attr(:title, :string,
    default: nil,
    doc: "Native tooltip on hover; defaults to aria_label when omitted"
  )

  attr(:replace, :boolean,
    default: false,
    doc: "Forwarded to Phoenix link for navigate/patch only; no effect for href (warns)."
  )

  attr(:method, :string,
    default: nil,
    doc: "Forwarded to Phoenix link for href only; no effect for navigate/patch (warns)."
  )

  attr(:rest, :global)

  slot(:inner_block, required: true)

  def navigate(%{replace: true, type: "href"} = assigns) do
    IO.warn("<.navigate> replace has no effect with type=\"href\"")
    navigate(%{assigns | replace: false})
  end

  def navigate(%{method: method, type: type} = assigns)
      when is_binary(method) and type in ["navigate", "patch"] do
    IO.warn("<.navigate> method has no effect with type=\"#{type}\"")
    navigate(%{assigns | method: nil})
  end

  def navigate(%{external: true, type: type} = assigns) when type in ["navigate", "patch"] do
    IO.warn("<.navigate> external has no effect with type=\"#{type}\"")
    navigate(%{assigns | external: false})
  end

  def navigate(assigns) do
    method_attrs =
      if assigns.type == "href" && is_binary(assigns.method) do
        %{method: assigns.method}
      else
        %{}
      end

    replace_attrs =
      if assigns.type in ["navigate", "patch"] && assigns.replace do
        %{replace: true}
      else
        %{}
      end

    assigns =
      assigns
      |> assign(:method_attrs, method_attrs)
      |> assign(:replace_attrs, replace_attrs)
      |> assign(:title, assigns.title || assigns.aria_label)

    ~H"""
    <.link
      href={@type == "href" && @to}
      navigate={@type == "navigate" && @to}
      patch={@type == "patch" && @to}
      download={@download}
      aria-label={@aria_label}
      title={@title}
      {@replace_attrs}
      {@method_attrs}
      target={@external && "_blank"}
      rel={@external && "noopener noreferrer"}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.link>
    """
  end
end
