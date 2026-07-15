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
    <.heroicon name="hero-arrow-top-right-on-square" />
  </.navigate>
  <.navigate to="/file.pdf" download="report.pdf">
    Download PDF
    <.heroicon name="hero-arrow-down-tray" />
  </.navigate>
  <.navigate to="/profile" aria_label="View profile">
    <.heroicon name="hero-user" />
  </.navigate>
  ```

  ## Style

  If you wish to use the default Corex styling, you can use the `link` class on the component.
  This requires the `corex_design` dependency and `mix corex.design.build`; import the component css file.

  ```css
  @import "../corex/corex.css";
  ```

  You can then use modifiers

  ```heex
  <.navigate class="link ui-accent ui-size-lg">
  ```

  Axes: **Semantic** (`ui-accent`, `ui-brand`, `ui-alert`, `ui-info`, `ui-success`), **Variant** (`ui-solid`), **Size** (`ui-size-sm` … `ui-size-xl`). See the [modifier guide](modifiers.html).

  Variant modifiers control link surface treatment. Default is subtle (underline). Add `ui-solid` for a pill fill.

  | Variant | Treatment |
  | ------- | --------- |
  | Subtle (default) | Underline |
  | Solid | Pill fill |

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
    safe_to =
      if Corex.Url.allowed_href?(assigns.to) do
        assigns.to
      else
        if is_binary(assigns.to) and String.trim(assigns.to) != "" do
          IO.warn("Corex.Navigate: disallowed destination #{inspect(assigns.to)}")
        end

        nil
      end

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
      |> assign(:safe_to, safe_to)
      |> assign(:method_attrs, method_attrs)
      |> assign(:replace_attrs, replace_attrs)
      |> assign(:title, assigns.title || assigns.aria_label)

    ~H"""
    <.link
      href={@type == "href" && @safe_to}
      navigate={@type == "navigate" && @safe_to}
      patch={@type == "patch" && @safe_to}
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
