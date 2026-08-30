defmodule CorexAdmin.UI.Fields do
  @moduledoc """
  Renders one field, on any surface.

  Index cells, show details, and form inputs all come through here, which is why
  a custom field module or a `render:` override applies everywhere at once
  rather than only in the table.

  Dispatch order for a read-only value:

    1. the field's `render:` override
    2. the field's host module `display/1`
    3. the built-in renderer for its type
  """

  use CorexAdmin.UI

  alias CorexAdmin.Field, as: FieldAPI
  alias CorexAdmin.Resource.Relation

  attr :field, Field, required: true
  attr :record, :any, required: true

  @doc "Read-only value for an index cell or a show row."
  def value(assigns) do
    assigns = assign(assigns, :value, Map.get(assigns.record, assigns.field.name))

    cond do
      renderer = assigns.field.render -> invoke(renderer, assigns)
      mod = FieldAPI.module(assigns.field) -> mod.display(assigns)
      true -> builtin_value(assigns)
    end
  end

  attr :field, Field, required: true
  attr :form, :any, required: true
  attr :options, :list, default: []

  @doc "Form control for a field."
  def input(assigns) do
    cond do
      renderer = assigns.field.render_form -> invoke(renderer, assigns)
      mod = FieldAPI.module(assigns.field) -> mod.input(assigns)
      true -> builtin_input(assigns)
    end
  end

  defp invoke({mod, fun}, assigns) when is_atom(mod) and is_atom(fun) do
    apply(mod, fun, [assigns])
  end

  defp invoke(mod, assigns) when is_atom(mod), do: mod.display(assigns)

  # -- read-only ------------------------------------------------------------

  defp builtin_value(assigns) do
    assigns = assign(assigns, :text, FieldAPI.format(assigns.field, assigns.record))

    ~H"""
    <span :if={@field.type == :boolean} class="admin-cell">
      <.heroicon
        name={if(@value, do: "hero-check-circle", else: "hero-minus-circle")}
        class={["icon", if(@value, do: "admin-yes", else: "admin-no")]}
      />
      <span class="sr-only">{@text}</span>
    </span>
    <span :if={@field.type == :url and is_binary(@value) and @value != ""} class="admin-cell">
      <a href={@value} class="link" target="_blank" rel="noopener noreferrer">{@text}</a>
    </span>
    <span
      :if={@field.type not in [:boolean, :url] or (@field.type == :url and @text == "—")}
      class="admin-cell"
      title={@text}
    >
      {@text}
    </span>
    """
  end

  # -- form -----------------------------------------------------------------

  defp builtin_input(assigns) do
    assigns = assign(assigns, :tip_id, error_tip_id(assigns.form, assigns.field))

    case assigns.field.type do
      :select -> select_input(assigns)
      :radio -> radio_input(assigns)
      :belongs_to -> belongs_to_input(assigns)
      :has_many -> has_many_input(assigns)
      :date -> date_input(assigns)
      :number -> number_input_field(assigns)
      :boolean -> boolean_input(assigns)
      :password -> password_input_field(assigns)
      :datetime -> datetime_input(assigns)
      :tags -> tags_input_field(assigns)
      :textarea -> textarea_input(assigns)
      type when type in [:embeds_many, :embeds_one] -> nested_input(assigns)
      _ -> text_input(assigns)
    end
  end

  defp select_input(assigns) do
    assigns = assign(assigns, :items, list_items(assigns.field.options))

    ~H"""
    <.select field={@form[@field.name]} class="select" items={@items} auto_invalid>
      <:label>{@field.label}</:label>
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      <:error :let={msg} class="admin-field-error">
        <.error_tip id={@tip_id} msg={msg} />
      </:error>
    </.select>
    """
  end

  defp radio_input(assigns) do
    assigns = assign(assigns, :items, list_items(assigns.field.options))

    ~H"""
    <.radio_group field={@form[@field.name]} class="radio-group" items={@items} auto_invalid>
      <:label>{@field.label}</:label>
      <:error :let={msg} class="admin-field-error">
        <.error_tip id={@tip_id} msg={msg} />
      </:error>
    </.radio_group>
    """
  end

  # A relation picker gets its options from the host context, so the admin never
  # queries the association itself.
  defp belongs_to_input(assigns) do
    relation = assigns.field.relation
    items = list_items(assigns.options)

    assigns =
      assigns
      |> assign(:items, items)
      |> assign(:searchable?, relation && relation.search)

    ~H"""
    <.combobox
      :if={@searchable?}
      field={@form[relation_key(@field)]}
      class="combobox"
      items={@items}
      on_input_value_change="relation_search"
      auto_invalid
    >
      <:label>{@field.label}</:label>
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      <:clear_trigger><.heroicon name="hero-x-mark" class="icon" /></:clear_trigger>
      <:error :let={msg} class="admin-field-error">
        <.error_tip id={@tip_id} msg={msg} />
      </:error>
    </.combobox>
    <.select
      :if={!@searchable?}
      field={@form[relation_key(@field)]}
      class="select"
      items={@items}
      auto_invalid
    >
      <:label>{@field.label}</:label>
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      <:error :let={msg} class="admin-field-error">
        <.error_tip id={@tip_id} msg={msg} />
      </:error>
    </.select>
    """
  end

  defp has_many_input(assigns) do
    assigns = assign(assigns, :items, list_items(assigns.options))

    ~H"""
    <.combobox
      field={@form[relation_key(@field)]}
      class="combobox"
      items={@items}
      multiple
      on_input_value_change="relation_search"
      auto_invalid
    >
      <:label>{@field.label}</:label>
      <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
      <:clear_trigger><.heroicon name="hero-x-mark" class="icon" /></:clear_trigger>
      <:error :let={msg} class="admin-field-error">
        <.error_tip id={@tip_id} msg={msg} />
      </:error>
    </.combobox>
    """
  end

  defp date_input(assigns) do
    ~H"""
    <.date_picker field={@form[@field.name]} class="date-picker" auto_invalid>
      <:label>{@field.label}</:label>
      <:trigger><.heroicon name="hero-calendar" class="icon" /></:trigger>
      <:prev_trigger><.heroicon name="hero-chevron-left" class="icon" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-chevron-right" class="icon" /></:next_trigger>
      <:error :let={msg} class="admin-field-error">
        <.error_tip id={@tip_id} msg={msg} />
      </:error>
    </.date_picker>
    """
  end

  defp number_input_field(assigns) do
    ~H"""
    <.number_input field={@form[@field.name]} class="number-input" orientation="vertical" auto_invalid>
      <:label>{@field.label}</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
      <:error :let={msg} class="admin-field-error">
        <.error_tip id={@tip_id} msg={msg} />
      </:error>
    </.number_input>
    """
  end

  defp boolean_input(assigns) do
    ~H"""
    <.switch field={@form[@field.name]} class="switch" auto_invalid>
      <:label>{@field.label}</:label>
      <:error :let={msg} class="admin-field-error">
        <.error_tip id={@tip_id} msg={msg} />
      </:error>
    </.switch>
    """
  end

  defp password_input_field(assigns) do
    ~H"""
    <.password_input field={@form[@field.name]} class="password-input" value="" auto_invalid>
      <:label>{@field.label}</:label>
      <:error :let={msg} class="admin-field-error">
        <.error_tip id={@tip_id} msg={msg} />
      </:error>
    </.password_input>
    """
  end

  defp datetime_input(assigns) do
    ~H"""
    <.native_input type="datetime-local" field={@form[@field.name]} class="native-input" auto_invalid>
      <:label>{@field.label}</:label>
      <:error :let={msg} class="admin-field-error">
        <.error_tip id={@tip_id} msg={msg} />
      </:error>
    </.native_input>
    """
  end

  defp tags_input_field(assigns) do
    ~H"""
    <.tags_input field={@form[@field.name]} class="tags-input" blur_behavior="add" auto_invalid>
      <:label>{@field.label}</:label>
      <:close><.heroicon name="hero-x-mark" class="icon" /></:close>
      <:error :let={msg} class="admin-field-error">
        <.error_tip id={@tip_id} msg={msg} />
      </:error>
    </.tags_input>
    """
  end

  defp textarea_input(assigns) do
    ~H"""
    <.native_input type="textarea" field={@form[@field.name]} class="native-input" auto_invalid>
      <:label>{@field.label}</:label>
      <:error :let={msg} class="admin-field-error">
        <.error_tip id={@tip_id} msg={msg} />
      </:error>
    </.native_input>
    """
  end

  defp text_input(assigns) do
    ~H"""
    <.native_input
      type={native_type(@field.type)}
      field={@form[@field.name]}
      class="native-input"
      auto_invalid
    >
      <:label>{@field.label}</:label>
      <:error :let={msg} class="admin-field-error">
        <.error_tip id={@tip_id} msg={msg} />
      </:error>
    </.native_input>
    """
  end

  # The error tip sits on the legend row rather than inside a cell: a nested row
  # is a grid of narrow controls, and an absolutely positioned icon inside one
  # of them overlaps the input it is describing.
  defp nested_input(assigns) do
    assigns =
      assigns
      |> assign(:errors, nested_errors(assigns.form, assigns.field))
      |> assign(:tip_id, error_tip_id(assigns.form, assigns.field))

    ~H"""
    <div class="admin-nested">
      <.nested_fields field={@form[@field.name]} class="nested-fields">
        <:label>
          <span class="admin-nested-legend">
            <span>{@field.label}</span>
            <.error_tip :if={@errors != []} id={@tip_id} msg={hd(@errors)} />
          </span>
        </:label>
        <:empty>{Gettext.t("No %{label} yet.", label: @field.label)}</:empty>
        <:col :let={nested} :for={child <- @field.fields} label={child.label}>
          <.input field={child} form={nested} />
        </:col>
        <:add_trigger>
          <.heroicon name="hero-plus" class="icon" />
          <span>{Gettext.t("Add")}</span>
        </:add_trigger>
        <:remove_trigger>
          <.heroicon name="hero-trash" class="icon" />
        </:remove_trigger>
      </.nested_fields>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :msg, :string, required: true

  @doc "Inline error indicator with the message in a tooltip."
  def error_tip(assigns) do
    ~H"""
    <.tooltip
      id={@id}
      class="tooltip ui-size-sm"
      positioning={%Corex.Positioning{placement: "top-end"}}
    >
      <:trigger>
        <.heroicon name="hero-exclamation-circle" class="icon" />
      </:trigger>
      <:content>{@msg}</:content>
    </.tooltip>
    """
  end

  attr :field, Field, required: true
  attr :record, :any, required: true

  @doc "Read-only panel for a nested embed on the show page."
  def embed(assigns) do
    rows =
      case Map.get(assigns.record, assigns.field.name) do
        list when is_list(list) -> list
        nil -> []
        row -> [row]
      end

    assigns = assign(assigns, :rows, rows)

    ~H"""
    <section class="admin-embed">
      <h2 class="admin-embed-title">{@field.label}</h2>
      <p :if={@rows == []} class="admin-embed-empty">{Gettext.t("None")}</p>
      <div :if={@rows != []} class="admin-embed-rows">
        <div :for={row <- @rows} class="admin-embed-row">
          <div :for={child <- @field.fields} class="admin-embed-field">
            <span class="admin-embed-label">{child.label}</span>
            <span class="admin-embed-value">{CorexAdmin.Field.format(child, row)}</span>
          </div>
        </div>
      </div>
    </section>
    """
  end

  @doc "Form param key for a relation field (the foreign key, not the association)."
  @spec relation_key(Field.t()) :: atom()
  def relation_key(%Field{relation: %Relation{owner_key: key}}) when not is_nil(key), do: key
  def relation_key(%Field{name: name}), do: name

  defp native_type(:email), do: "email"
  defp native_type(:url), do: "url"
  defp native_type(:number), do: "number"
  defp native_type(:file), do: "file"
  defp native_type(_), do: "text"

  defp nested_errors(form, %Field{name: name}) do
    case form.source do
      %Ecto.Changeset{} = changeset ->
        changeset.errors
        |> Enum.filter(fn {key, _} -> key == name end)
        |> Enum.map(fn {_key, {msg, _opts}} -> msg end)

      _ ->
        []
    end
  end

  defp error_tip_id(form, %Field{name: name}) do
    base =
      cond do
        is_binary(form.id) and form.id != "" -> form.id
        is_binary(form.name) and form.name != "" -> form.name
        true -> "field"
      end

    "#{base}-#{name}-error-tip"
  end
end
