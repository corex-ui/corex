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

  ## Style

  Use `class="layout-heading"` on the host, plus optional `layout-heading--*` modifiers for semantic ink on the title and subtitle.

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

  attr(:rest, :global)

  slot(:title)
  slot(:subtitle)
  slot(:actions)
  slot(:inner_pre)
  slot(:inner_post)

  def layout_heading(assigns) do
    ~H"""
    <div {@rest}>
    {render_slot(@inner_pre)}
    <div data-scope="layout-heading" data-part="root">
      <div :if={@title != [] or @subtitle != []} data-scope="layout-heading" data-part="content">
        <h1 :if={@title != []} data-scope="layout-heading" data-part="title">{render_slot(@title)}</h1>
        <h2 :if={@subtitle != []} data-scope="layout-heading" data-part="subtitle">{render_slot(@subtitle)}</h2>
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
