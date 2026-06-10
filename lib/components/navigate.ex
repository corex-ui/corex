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

  ## Styling

  Style attrs and BEM classes are equivalent. See [Unstyled](unstyled.html). Axes: `semantic`, `variant`, `size`, `shape`, `radius`.

  <!-- tabs-open -->

  ### With attributes

  ```heex
  <.navigate to="/signup" as="button" variant="solid" semantic="accent" size="lg" class="button">
    Get started
  </.navigate>
  ```

  ### With classes

  ```heex
  <.navigate to="/signup" as="button" class="button button--semantic-accent button--size-lg">
    Get started
  </.navigate>
  ```

  <!-- tabs-close -->

  Default look is `link` (`data-link`). Use `as="button"` with
  `variant`, `semantic`, and `size` for CTA-style links that remain anchors.

  See [Styled](styled.html) or import generated CSS:

  ```css
  @import "./corex.tailwind.css";
  ```

  ```heex
  <.navigate to="/" semantic="accent">Docs</.navigate>
  <.navigate to="/signup" as="button" variant="solid" semantic="accent" size="md">Get started</.navigate>
  <.navigate to="/docs" as="button" variant="solid" semantic="brand" size="md">Browse</.navigate>
  <.navigate to="https://hexdocs.pm/corex" as="button" variant="ghost" size="md" external>Hexdocs</.navigate>
  ```

  Solid CTAs need both `variant="solid"` and a `size` step for padding and min-height. Use `semantic="brand"` on a marketing primary button; pair with `variant="ghost"` on a secondary external link.

  """

  @doc type: :component
  use Phoenix.Component
  use Corex.Variants,
    kind: :polymorphic,
    looks: [button: "button", link: "link"],
    default_as: :link,
    axes: [
      width: :width,
      max_width: :max_width,
      height: :height,
      max_height: :max_height,
      semantic: :semantic,
      size: :size,
      text: :text,
      radius: :radius,
      variant: :visual,
      shape: :shape
    ]

  attr(:disabled, :boolean,
    default: false,
    doc: "Marks the link disabled (aria-disabled and data-disabled; href is omitted)"
  )

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

  slot(:inner_block, required: false)

  slot :indicator, required: false do
    attr(:class, :string, required: false)
  end

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
      href={@type == "href" && href_when_enabled(@disabled, @safe_to)}
      navigate={@type == "navigate" && href_when_enabled(@disabled, @safe_to)}
      patch={@type == "patch" && href_when_enabled(@disabled, @safe_to)}
      download={@download}
      aria-label={@aria_label}
      aria-disabled={@disabled && "true"}
      data-disabled={@disabled && ""}
      title={@title}
      class={corex_style_class(assigns)}
     
      {@replace_attrs}
      {@method_attrs}
      target={@external && "_blank"}
      rel={@external && "noopener noreferrer"}
      {@rest}
    >
      <span :if={@indicator != []} data-part="indicator" class={Map.get(Enum.at(@indicator, 0), :class)}>
        {render_slot(@indicator)}
      </span>
      {render_slot(@inner_block)}
    </.link>
    """
  end

  defp href_when_enabled(true, _to), do: nil
  defp href_when_enabled(false, to), do: to
end
