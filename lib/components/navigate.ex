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

  Axes: **Semantic** (`ui-accent`, `ui-brand`, `ui-alert`, `ui-info`, `ui-success`), **Variant** (`ui-solid`, `ui-nav`), **Size** (`ui-size-sm` … `ui-size-xl`). See the [modifier guide](modifiers.html).

  Variant modifiers control link surface treatment. Default is subtle (underline). Add `ui-solid` for a pill fill, or `ui-nav` for chrome-less navigation (ink color, no underline, `aria-current` weight and color).

  | Variant | Treatment |
  | ------- | --------- |
  | Subtle (default) | Underline |
  | Solid | Pill fill |
  | Nav | No underline, ink hover, current via `aria-current` |

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

  def navigate(assigns) do
    assigns =
      assigns
      |> drop_inert_replace()
      |> drop_inert_method()
      |> drop_inert_external()

    assigns =
      assigns
      |> assign(:safe_to, safe_destination(assigns.to))
      |> assign(:method_attrs, method_attrs(assigns))
      |> assign(:replace_attrs, replace_attrs(assigns))
      |> assign(:external_attrs, external_attrs(assigns))
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
      {@external_attrs}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.link>
    """
  end

  defp method_attrs(%{type: "href", method: method}) when is_binary(method), do: %{method: method}
  defp method_attrs(_assigns), do: %{}

  defp replace_attrs(%{type: type, replace: true}) when type in ["navigate", "patch"],
    do: %{replace: true}

  defp replace_attrs(_assigns), do: %{}

  defp external_attrs(%{external: true}), do: %{target: "_blank", rel: "noopener noreferrer"}
  defp external_attrs(_assigns), do: %{}

  defp drop_inert_replace(%{replace: true, type: "href"} = assigns) do
    Corex.Dev.warn(~S(<.navigate> replace has no effect with type="href"))
    assign(assigns, :replace, false)
  end

  defp drop_inert_replace(assigns), do: assigns

  defp drop_inert_method(%{method: method, type: type} = assigns)
       when is_binary(method) and type in ["navigate", "patch"] do
    Corex.Dev.warn(~s(<.navigate> method has no effect with type="#{type}"))
    assign(assigns, :method, nil)
  end

  defp drop_inert_method(assigns), do: assigns

  defp drop_inert_external(%{external: true, type: type} = assigns)
       when type in ["navigate", "patch"] do
    Corex.Dev.warn(~s(<.navigate> external has no effect with type="#{type}"))
    assign(assigns, :external, false)
  end

  defp drop_inert_external(assigns), do: assigns

  defp safe_destination(to) do
    if Corex.Url.allowed_href?(to), do: to, else: reject_destination(to)
  end

  defp reject_destination(to) when is_binary(to) do
    case String.trim(to) do
      "" -> nil
      _trimmed -> warn_disallowed(to)
    end
  end

  defp reject_destination(_to), do: nil

  defp warn_disallowed(to) do
    Corex.Dev.warn("Corex.Navigate: disallowed destination #{inspect(to)}")
    nil
  end
end
