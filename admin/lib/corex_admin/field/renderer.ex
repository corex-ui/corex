defmodule CorexAdmin.Field.Renderer do
  @moduledoc false

  use Phoenix.Component
  use Corex

  alias CorexAdmin.Field
  alias CorexAdmin.Gettext
  alias CorexAdmin.Resource.Field, as: FieldSpec

  attr(:field, FieldSpec, required: true)
  attr(:form, :any, required: true)

  def input(%{field: %FieldSpec{type: :select}} = assigns) do
    assigns =
      assigns
      |> assign(:items, list_items(assigns.field.options))
      |> assign(:tip_id, field_error_id(assigns.form, assigns.field))

    ~H"""
    <.select field={@form[@field.name]} class="select" items={@items} auto_invalid>
      <:label>{@field.label}</:label>
      <:trigger>
        <.heroicon name="hero-chevron-down" />
      </:trigger>
      <:error :let={msg} class="admin-field-error">
        <.field_error_tip id={@tip_id} msg={msg} />
      </:error>
    </.select>
    """
  end

  def input(%{field: %FieldSpec{type: :date}} = assigns) do
    assigns = assign(assigns, :tip_id, field_error_id(assigns.form, assigns.field))

    ~H"""
    <.date_picker field={@form[@field.name]} class="date-picker" auto_invalid>
      <:label>{@field.label}</:label>
      <:trigger>
        <.heroicon name="hero-calendar" />
      </:trigger>
      <:prev_trigger>
        <.heroicon name="hero-chevron-left" />
      </:prev_trigger>
      <:next_trigger>
        <.heroicon name="hero-chevron-right" />
      </:next_trigger>
      <:error :let={msg} class="admin-field-error">
        <.field_error_tip id={@tip_id} msg={msg} />
      </:error>
    </.date_picker>
    """
  end

  def input(%{field: %FieldSpec{type: :number}} = assigns) do
    assigns = assign(assigns, :tip_id, field_error_id(assigns.form, assigns.field))

    ~H"""
    <.number_input
      field={@form[@field.name]}
      class="number-input"
      orientation="vertical"
      auto_invalid
    >
      <:label>{@field.label}</:label>
      <:decrement_trigger>
        <.heroicon name="hero-chevron-down" class="icon" />
      </:decrement_trigger>
      <:increment_trigger>
        <.heroicon name="hero-chevron-up" class="icon" />
      </:increment_trigger>
      <:error :let={msg} class="admin-field-error">
        <.field_error_tip id={@tip_id} msg={msg} />
      </:error>
    </.number_input>
    """
  end

  def input(%{field: %FieldSpec{type: :embeds_many}} = assigns) do
    ~H"""
    <.nested_fields field={@form[@field.name]} class="nested-fields">
      <:label>{@field.label}</:label>
      <:empty>{Gettext.t("No %{label} yet.", label: @field.label)}</:empty>
      <:col :let={nested} :for={child <- @field.fields} label={child.label}>
        <.input field={child} form={nested} />
      </:col>
      <:add_trigger>{Gettext.t("Add %{label}", label: @field.label)}</:add_trigger>
      <:remove_trigger>
        <.heroicon name="hero-trash" class="icon" />
      </:remove_trigger>
    </.nested_fields>
    """
  end

  def input(%{field: %FieldSpec{type: :boolean}} = assigns) do
    assigns = assign(assigns, :tip_id, field_error_id(assigns.form, assigns.field))

    ~H"""
    <.switch field={@form[@field.name]} class="switch" auto_invalid>
      <:label>{@field.label}</:label>
      <:error :let={msg} class="admin-field-error">
        <.field_error_tip id={@tip_id} msg={msg} />
      </:error>
    </.switch>
    """
  end

  def input(%{field: %FieldSpec{type: :password}} = assigns) do
    assigns = assign(assigns, :tip_id, field_error_id(assigns.form, assigns.field))

    ~H"""
    <.password_input field={@form[@field.name]} class="password-input" value="" auto_invalid>
      <:label>{@field.label}</:label>
      <:error :let={msg} class="admin-field-error">
        <.field_error_tip id={@tip_id} msg={msg} />
      </:error>
    </.password_input>
    """
  end

  def input(%{field: %FieldSpec{type: :datetime}} = assigns) do
    assigns = assign(assigns, :tip_id, field_error_id(assigns.form, assigns.field))

    ~H"""
    <.native_input
      type="datetime-local"
      field={@form[@field.name]}
      class="native-input"
      auto_invalid
    >
      <:label>{@field.label}</:label>
      <:error :let={msg} class="admin-field-error">
        <.field_error_tip id={@tip_id} msg={msg} />
      </:error>
    </.native_input>
    """
  end

  def input(assigns) do
    assigns = assign(assigns, :tip_id, field_error_id(assigns.form, assigns.field))

    ~H"""
    <.native_input
      type={native_type(@field.type)}
      field={@form[@field.name]}
      class="native-input"
      auto_invalid
    >
      <:label>{@field.label}</:label>
      <:error :let={msg} class="admin-field-error">
        <.field_error_tip id={@tip_id} msg={msg} />
      </:error>
    </.native_input>
    """
  end

  attr(:field, FieldSpec, required: true)
  attr(:record, :any, required: true)

  def display(assigns) do
    formatted = Field.format(assigns.field, assigns.record)

    assigns =
      assigns
      |> assign(:formatted, formatted)
      |> assign(:badge, select_badge_class(assigns.field, assigns.record))

    ~H"""
    <span :if={@badge} class={@badge}>{@formatted}</span>
    <span :if={!@badge} class="admin-cell" title={@formatted}>{@formatted}</span>
    """
  end

  attr(:field, FieldSpec, required: true)
  attr(:record, :any, required: true)

  def embed_show(%{field: %FieldSpec{type: :embeds_many}} = assigns) do
    rows = List.wrap(Map.get(assigns.record, assigns.field.name))
    assigns = assign(assigns, :rows, rows)

    ~H"""
    <section class="admin-embed">
      <h2 class="admin-embed-title">{@field.label}</h2>
      <p :if={@rows == []} class="admin-embed-empty">{Gettext.t("None")}</p>
      <div :if={@rows != []} class="admin-embed-rows">
        <div :for={row <- @rows} class="admin-embed-row">
          <div :for={child <- @field.fields} class="admin-embed-field">
            <span class="admin-embed-label">{child.label}</span>
            <span class="admin-embed-value">{Field.format(child, row)}</span>
          </div>
        </div>
      </div>
    </section>
    """
  end

  attr(:id, :string, required: true)
  attr(:msg, :string, required: true)

  defp field_error_tip(assigns) do
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

  defp field_error_id(form, %FieldSpec{name: name}) do
    base =
      cond do
        is_binary(form.id) and form.id != "" -> form.id
        is_binary(form.name) and form.name != "" -> form.name
        true -> "field"
      end

    "#{base}-#{name}-error-tip"
  end

  defp native_type(:id), do: "text"
  defp native_type(:text), do: "text"
  defp native_type(:textarea), do: "textarea"
  defp native_type(:email), do: "email"
  defp native_type(:password), do: "password"
  defp native_type(:url), do: "url"
  defp native_type(:custom), do: "text"
  defp native_type(_), do: "text"

  defp list_items(options) when is_list(options) do
    Corex.List.new(
      Enum.map(options, fn
        {label, value} -> %{label: to_string(label), value: to_string(value)}
        value -> %{label: to_string(value), value: to_string(value)}
      end)
    )
  end

  defp list_items(_), do: Corex.List.new([])

  defp select_badge_class(%FieldSpec{type: :select, name: name}, record) do
    case Map.get(record, name) do
      "done" -> "badge ui-success ui-size-sm"
      "open" -> "badge ui-info ui-size-sm"
      value when value not in [nil, ""] -> "badge ui-size-sm"
      _ -> nil
    end
  end

  defp select_badge_class(_, _), do: nil
end
