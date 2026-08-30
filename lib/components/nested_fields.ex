defmodule Corex.NestedFields do
  @moduledoc ~S'''
  Repeatable nested form fields for Phoenix LiveView (`embeds_many` / `inputs_for`).

  Add and remove rows with Phoenix `sort_param` / `drop_param`. There is no Zag
  machine and no parallel LiveView list state.

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

    ```heex
    <.nested_fields field={@form[:social_links]} class="nested-fields">
      <:label>Social links</:label>
      <:description>Optional profile URLs for this ticket.</:description>
      <:col :let={f} label="Label">
        <.native_input field={f[:label]} type="text" class="native-input">
          <:label>Label</:label>
        </.native_input>
      </:col>
      <:col :let={f} label="URL">
        <.native_input field={f[:url]} type="url" class="native-input">
          <:label>URL</:label>
        </.native_input>
      </:col>
      <:add_trigger>Add link</:add_trigger>
      <:remove_trigger><.heroicon name="hero-trash" class="icon" /></:remove_trigger>
    </.nested_fields>
    ```

  ### Empty

    ```heex
    <.nested_fields field={@form[:social_links]} class="nested-fields">
      <:label>Social links</:label>
      <:empty>No links yet.</:empty>
      <:col :let={f} label="Label">
        <.native_input field={f[:label]} type="text" class="native-input">
          <:label>Label</:label>
        </.native_input>
      </:col>
      <:col :let={f} label="URL">
        <.native_input field={f[:url]} type="url" class="native-input">
          <:label>URL</:label>
        </.native_input>
      </:col>
      <:add_trigger>Add link</:add_trigger>
      <:remove_trigger><.heroicon name="hero-trash" class="icon" /></:remove_trigger>
    </.nested_fields>
    ```

  <!-- tabs-close -->

  Pair with `cast_embed/3` (or `cast_assoc/3`) using `sort_param` and `drop_param`
  named `{field}_sort` and `{field}_drop`. The add control posts `value="new"` on
  the sort param; remove posts the row index on the drop param.

  ## Style

  Use `class="nested-fields"` on the host.

  ```css
  @import "../corex/corex.css";

  [data-scope="nested-fields"][data-part="root"] {}
  [data-scope="nested-fields"][data-part="legend"] {}
  [data-scope="nested-fields"][data-part="description"] {}
  [data-scope="nested-fields"][data-part="grid"] {}
  [data-scope="nested-fields"][data-part="header"] {}
  [data-scope="nested-fields"][data-part="column-header"] {}
  [data-scope="nested-fields"][data-part="row"] {}
  [data-scope="nested-fields"][data-part="cell"] {}
  [data-scope="nested-fields"][data-part="empty"] {}
  [data-scope="nested-fields"][data-part="add-trigger"] {}
  [data-scope="nested-fields"][data-part="remove-trigger"] {}
  ```
  '''

  use Phoenix.Component

  alias Phoenix.LiveView.JS

  attr(:field, Phoenix.HTML.FormField,
    required: true,
    doc: "A form field for an embed or assoc list, e.g. `@form[:social_links]`"
  )

  attr(:id, :string, default: nil, doc: "Stable id prefix for column headers")

  attr(:add_value, :string,
    default: "new",
    doc: "Value posted on the sort param to append a row"
  )

  attr(:rest, :global)

  slot(:label, required: false, doc: "Fieldset legend")

  slot(:description, required: false, doc: "Optional supporting copy under the legend")

  slot(:empty, required: false, doc: "Shown when there are no rows")

  slot :col,
    required: true,
    doc: "One slot per column. Receives the nested form (`:let={f}`)." do
    attr(:label, :string, required: true)
    attr(:class, :string)
  end

  slot(:add_trigger, required: true, doc: "Label for the add-row control")

  slot(:remove_trigger,
    required: true,
    doc: "Contents of the per-row remove control. Receives the nested form."
  )

  def nested_fields(assigns) do
    field = assigns.field
    id = assigns.id || "#{field.id}-nested"

    assigns =
      assigns
      |> assign(:id, id)
      |> assign(:sort_name, param_name(field, "sort"))
      |> assign(:drop_name, param_name(field, "drop"))
      |> assign(:col_count, length(assigns.col))
      |> assign(:empty?, nested_empty?(field))

    ~H"""
    <div {@rest}>
      <fieldset data-scope="nested-fields" data-part="root" id={@id}>
        <legend :if={@label != []} data-scope="nested-fields" data-part="legend">
          {render_slot(@label)}
        </legend>
        <p :if={@description != []} data-scope="nested-fields" data-part="description">
          {render_slot(@description)}
        </p>

        <div
          data-scope="nested-fields"
          data-part="grid"
          style={"--nested-fields-cols: #{@col_count}"}
        >
          <div data-scope="nested-fields" data-part="header">
            <div
              :for={{col, index} <- Enum.with_index(@col)}
              id={"#{@id}-col-#{index}"}
              data-scope="nested-fields"
              data-part="column-header"
            >
              {col[:label]}
            </div>
            <span data-scope="nested-fields" data-part="header-actions"></span>
          </div>

          <.inputs_for :let={f} field={@field}>
            <input type="hidden" name={@sort_name} value={f.index} />
            <div data-scope="nested-fields" data-part="row">
              <div
                :for={{col, index} <- Enum.with_index(@col)}
                class={col[:class]}
                data-scope="nested-fields"
                data-part="cell"
                aria-labelledby={"#{@id}-col-#{index}"}
              >
                {render_slot(col, f)}
              </div>
              <div data-scope="nested-fields" data-part="row-actions">
                <button
                  type="button"
                  name={@drop_name}
                  value={f.index}
                  phx-click={JS.dispatch("change")}
                  class="button ui-alert ui-trigger--square"
                  aria-label={"Remove row #{f.index + 1}"}
                  data-scope="nested-fields"
                  data-part="remove-trigger"
                >
                  {render_slot(@remove_trigger, f)}
                </button>
              </div>
            </div>
          </.inputs_for>
        </div>

        <div :if={@empty != [] and @empty?} data-scope="nested-fields" data-part="empty">
          {render_slot(@empty)}
        </div>

        <input type="hidden" name={@drop_name} />
        <button
          type="button"
          name={@sort_name}
          value={@add_value}
          phx-click={JS.dispatch("change")}
          class="button"
          data-scope="nested-fields"
          data-part="add-trigger"
        >
          {render_slot(@add_trigger)}
        </button>
      </fieldset>
    </div>
    """
  end

  defp param_name(%{name: name}, suffix) when is_binary(name) do
    String.replace_suffix(name, "]", "_#{suffix}][]")
  end

  defp nested_empty?(%{value: value}) when value in [nil, []], do: true
  defp nested_empty?(%{value: value}) when is_list(value), do: value == []
  defp nested_empty?(_), do: false
end
