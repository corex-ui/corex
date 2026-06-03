defmodule Mix.Corex.Gen.Inputs do
  @moduledoc false

  alias Mix.Phoenix.Schema

  @doc "Builds HEEx snippets for each schema attribute used by corex.gen templates."
  def inputs(%Schema{} = schema, field_prefix) do
    schema.attrs
    |> Enum.reject(fn {_key, type} -> skip_input_type?(type) end)
    |> Enum.map(fn {key, type} ->
      if key in schema.redacts do
        password_input_block(field_prefix, key)
      else
        input_block(schema, field_prefix, key, type)
      end
    end)
  end

  @doc "Returns a HEEx expression for displaying a field value in index or show templates."
  def display_expr(record, key, type, %Schema{} = schema, mode \\ :index) do
    field = "#{record}.#{key}"

    if mode == :show and key in schema.redacts do
      "\"••••••••\""
    else
      type_display_expr(field, type)
    end
  end

  defp type_display_expr(field, :boolean), do: "if(#{field}, do: \"Yes\", else: \"No\")"

  defp type_display_expr(field, :date),
    do: "#{field} && Calendar.strftime(#{field}, \"%Y-%m-%d\")"

  defp type_display_expr(field, type) when type in [:time, :time_usec],
    do: "#{field} && Calendar.strftime(#{field}, \"%H:%M:%S\")"

  defp type_display_expr(field, type)
       when type in [:naive_datetime, :naive_datetime_usec, :utc_datetime, :utc_datetime_usec],
       do: "#{field} && Calendar.strftime(#{field}, \"%Y-%m-%d %H:%M\")"

  defp type_display_expr(field, :decimal),
    do: "#{field} && Decimal.to_string(#{field})"

  defp type_display_expr(field, {:enum, _}),
    do: "#{field} && Phoenix.Naming.humanize(to_string(#{field}))"

  defp type_display_expr(field, {:array, :string}),
    do: "Enum.join(#{field} || [], \", \")"

  defp type_display_expr(field, {:array, :integer}),
    do: "Enum.join(Enum.map(#{field} || [], &to_string/1), \", \")"

  defp type_display_expr(field, {:array, _}), do: "inspect(#{field})"
  defp type_display_expr(field, _type), do: field

  defp input_block(_schema, field_prefix, key, :integer),
    do: number_input_block(field_prefix, key, nil)

  defp input_block(_schema, field_prefix, key, :float),
    do: number_input_block(field_prefix, key, 0.1)

  defp input_block(_schema, field_prefix, key, :decimal),
    do: number_input_block(field_prefix, key, 0.1)

  defp input_block(_schema, field_prefix, key, :boolean),
    do: checkbox_block(field_prefix, key)

  defp input_block(_schema, field_prefix, key, :text),
    do: native_input_block(field_prefix, "textarea", key, error_slot: true)

  defp input_block(_schema, field_prefix, key, type)
       when type in [:string, :uuid, :binary],
       do: native_input_block(field_prefix, "text", key, error_slot: true)

  defp input_block(_schema, field_prefix, key, :date),
    do: date_picker_block(field_prefix, key)

  defp input_block(_schema, field_prefix, key, :time),
    do: native_input_block(field_prefix, "time", key, error_slot: true)

  defp input_block(_schema, field_prefix, key, :time_usec),
    do: native_input_block(field_prefix, "time", key, error_slot: true)

  defp input_block(_schema, field_prefix, key, type)
       when type in [:utc_datetime, :naive_datetime, :utc_datetime_usec, :naive_datetime_usec],
       do: native_input_block(field_prefix, "datetime-local", key, error_slot: true)

  defp input_block(_schema, field_prefix, key, {:array, _} = array_type),
    do: select_array_block(field_prefix, key, array_type)

  defp input_block(schema, field_prefix, key, {:enum, _}),
    do: select_enum_block(schema, field_prefix, key)

  defp input_block(_schema, field_prefix, key, {:references, _}),
    do: number_input_block(field_prefix, key, nil)

  defp input_block(_schema, field_prefix, key, _type),
    do: native_input_block(field_prefix, "text", key, error_slot: true)

  defp number_input_block(field_prefix, key, step) do
    step_attr = if step, do: " step={0.1}", else: ""

    ~s"""
    <.number_input field={#{field_prefix}[#{inspect(key)}]} class="number-input"#{step_attr}>
      <:label>#{label(key)}</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" /></:increment_trigger>
      <:error :let={msg}>
        <.heroicon name="hero-exclamation-circle" />
        {msg}
      </:error>
    </.number_input>
    """
  end

  defp checkbox_block(field_prefix, key) do
    ~s"""
    <.checkbox field={#{field_prefix}[#{inspect(key)}]} class="checkbox">
      <:label>#{label(key)}</:label>
      <:indicator>
        <.heroicon name="hero-check" />
      </:indicator>
      <:error :let={msg}>
        <.heroicon name="hero-exclamation-circle" />
        {msg}
      </:error>
    </.checkbox>
    """
  end

  defp date_picker_block(field_prefix, key) do
    ~s"""
    <.date_picker field={#{field_prefix}[#{inspect(key)}]} class="date-picker">
      <:label>#{label(key)}</:label>
      <:trigger>
        <.heroicon name="hero-calendar" />
      </:trigger>
      <:prev_trigger>
        <.heroicon name="hero-chevron-left" />
      </:prev_trigger>
      <:next_trigger>
        <.heroicon name="hero-chevron-right" />
      </:next_trigger>
      <:error :let={msg}>
        <.heroicon name="hero-exclamation-circle" />
        {msg}
      </:error>
    </.date_picker>
    """
  end

  defp select_array_block(field_prefix, key, type) do
    items_inspect = type |> array_items() |> inspect()

    ~s"""
    <.select
      field={#{field_prefix}[#{inspect(key)}]}
      class="select"
      multiple
      deselectable
      close_on_select={false}
      items={#{items_inspect}}
      translation={%Corex.Select.Translation{placeholder: "Choose values"}}
    >
      <:label>#{label(key)}</:label>
      <:trigger>
        <.heroicon name="hero-chevron-down" />
      </:trigger>
      <:error :let={msg}>
        <.heroicon name="hero-exclamation-circle" />
        {msg}
      </:error>
    </.select>
    """
  end

  defp select_enum_block(%Schema{} = schema, field_prefix, key) do
    ~s"""
    <.select
      field={#{field_prefix}[#{inspect(key)}]}
      class="select"
      items={
        Enum.map(Ecto.Enum.values(#{inspect(schema.module)}, #{inspect(key)}), fn v ->
          %{value: v, label: Phoenix.Naming.humanize(to_string(v))}
        end)
      }
      translation={%Corex.Select.Translation{placeholder: "Choose a value"}}
    >
      <:label>#{label(key)}</:label>
      <:trigger>
        <.heroicon name="hero-chevron-down" />
      </:trigger>
      <:error :let={msg}>
        <.heroicon name="hero-exclamation-circle" />
        {msg}
      </:error>
    </.select>
    """
  end

  defp password_input_block(field_prefix, key) do
    ~s"""
    <.password_input field={#{field_prefix}[#{inspect(key)}]} class="password-input">
      <:label>#{label(key)}</:label>
      <:error :let={msg}>
        <.heroicon name="hero-exclamation-circle" />
        {msg}
      </:error>
      <:visible_indicator><.heroicon name="hero-eye" /></:visible_indicator>
      <:hidden_indicator><.heroicon name="hero-eye-slash" /></:hidden_indicator>
    </.password_input>
    """
  end

  defp native_input_block(field_prefix, type, key, opts) do
    error = if Keyword.get(opts, :error_slot, false), do: "\n  " <> error_slot(), else: ""

    ~s"""
    <.native_input
      field={#{field_prefix}[#{inspect(key)}]}
      type="#{type}"
      class="native-input"
    >
      <:label>#{label(key)}</:label>#{error}
    </.native_input>
    """
  end

  defp error_slot do
    ~S"""
    <:error :let={msg}>
        <.heroicon name="hero-exclamation-circle" />
        {msg}
      </:error>
    """
  end

  defp array_items({:array, :string}) do
    Enum.map([1, 2], fn i -> %{label: "Option #{i}", value: "option#{i}"} end)
  end

  defp array_items({:array, _}), do: []

  defp skip_input_type?(:map), do: true
  defp skip_input_type?({:array, :integer}), do: true
  defp skip_input_type?(_), do: false

  defp label(key), do: Phoenix.Naming.humanize(to_string(key))
end
