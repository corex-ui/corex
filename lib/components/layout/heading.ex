defmodule Corex.Layout.Heading do
  @moduledoc ~S'''
  A layout heading component for page titles, subtitles, and actions.

  ## Anatomy

  ### Basic

  Use the `:title` and `:subtitle` slots for the main heading content. Use the `:actions` slot for buttons or links on the right.

  ```heex
  <.layout_heading class="layout-heading">
    <:title>Page Title</:title>
    <:subtitle>Optional subtitle or context</:subtitle>
    <:actions>
      <.action phx-click="save" class="button button--accent">Save</.action>
    </:actions>
  </.layout_heading>
  ```

  ### Title and subtitle only

  Omit the `:actions` slot when no action buttons are needed.

  ```heex
  <.layout_heading class="layout-heading">
    <:title>Settings</:title>
    <:subtitle>Manage your preferences</:subtitle>
  </.layout_heading>
  ```

  ### Heading tags

  `title_tag` and `subtitle_tag` set the HTML element for each slot (passed to `<.dynamic_tag>` as `tag_name`). Defaults are `"h1"` and `"h2"`. Use a lower title tag when the heading sits under another page title, and `"p"` for `subtitle_tag` when the line is supporting copy rather than a section heading.

  ```heex
  <.layout_heading class="layout-heading" title_tag="h2" subtitle_tag="p">
    <:title>Playground</:title>
    <:subtitle>Optional controls summary</:subtitle>
  </.layout_heading>
  ```

  ## Style

  Use `class="layout-heading"` on the host, plus optional `layout-heading--*` modifiers for semantic ink on the title and subtitle.

  Axes: **Semantic** (`--accent`, `--brand`, `--alert`, `--info`, `--success`), **Size** (`--sm`, `--md`, `--lg`, `--xl`, also scales text). No variant axis (typography layout only). See the [modifier guide](modifiers.html).

  <!-- tabs-open -->

  ### Accent

  ```heex
  <.layout_heading class="layout-heading layout-heading--accent">
    <:title>Accent title</:title>
    <:subtitle>Accent subtitle</:subtitle>
  </.layout_heading>
  ```

  ### Max width

  ```heex
  <.layout_heading class="layout-heading layout-heading--max-w-prose">
    <:title>Constrained width</:title>
    <:subtitle>Uses a layout-heading width modifier on the host.</:subtitle>
  </.layout_heading>
  ```

  <!-- tabs-close -->

  Target elements with data attributes:

  - `[data-scope="layout-heading"][data-part="root"]` – root container
  - `[data-scope="layout-heading"][data-part="content"]` – title/subtitle wrapper
  - `[data-scope="layout-heading"][data-part="title"]` – main title
  - `[data-scope="layout-heading"][data-part="subtitle"]` – subtitle
  - `[data-scope="layout-heading"][data-part="actions"]` – actions wrapper
  '''
  @doc type: :component
  use Phoenix.Component

  attr(:rest, :global, doc: "Additional HTML attributes on the outer wrapper.")

  @heading_tags ~W(h1 h2 h3 h4 h5 h6 p)

  attr(:title_tag, :string,
    default: "h1",
    values: @heading_tags,
    doc: "HTML tag for the `:title` slot (`h1`–`h6` or `p`). Default `h1` for page titles."
  )

  attr(:subtitle_tag, :string,
    default: "h2",
    values: @heading_tags,
    doc:
      "HTML tag for the `:subtitle` slot (`h1`–`h6` or `p`). Default `h2`; use `p` for non-heading supporting text."
  )

  slot(:title, doc: "Main heading text. Rendered with `data-part=\"title\"`.")
  slot(:subtitle, doc: "Optional line below the title. Rendered with `data-part=\"subtitle\"`.")
  slot(:actions, doc: "Optional controls aligned to the end of the row (buttons, links).")
  slot(:inner_pre, doc: "Content rendered inside the wrapper, before the heading root.")
  slot(:inner_post, doc: "Content rendered inside the wrapper, after the heading root.")

  @doc """
  Renders a page or section heading with title, optional subtitle, and optional actions.

  See module doc for anatomy, styling, and `title_tag` / `subtitle_tag` examples.
  """
  def layout_heading(assigns) do
    ~H"""
    <div {@rest}>
    {render_slot(@inner_pre)}
    <div data-scope="layout-heading" data-part="root">
      <div :if={@title != [] or @subtitle != []} data-scope="layout-heading" data-part="content">
        <.dynamic_tag
          :if={@title != []}
          tag_name={@title_tag}
          data-scope="layout-heading"
          data-part="title"
        >
          {render_slot(@title)}
        </.dynamic_tag>
        <.dynamic_tag
          :if={@subtitle != []}
          tag_name={@subtitle_tag}
          data-scope="layout-heading"
          data-part="subtitle"
        >
          {render_slot(@subtitle)}
        </.dynamic_tag>
      </div>
      <div :if={@actions != []} data-scope="layout-heading" data-part="actions">
        {render_slot(@actions)}
      </div>
    </div>
    {render_slot(@inner_post)}
    </div>
    """
  end
end
