defmodule Mix.Corex.Gen.Inputs do
  @moduledoc false

  alias Mix.Phoenix.Schema

  @doc "Builds HEEx snippets for each schema attribute used by corex.gen templates."
  def inputs(%Schema{} = schema, field_prefix) do
    schema.attrs
    |> Enum.reject(fn {_key, type} -> type == :map end)
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

    cond do
      mode == :show and key in schema.redacts ->
        "\"••••••••\""

      type == :boolean ->
        "if(#{field}, do: \"Yes\", else: \"No\")"

      type == :date ->
        "#{field} && Calendar.strftime(#{field}, \"%Y-%m-%d\")"

      type in [:time, :time_usec] ->
        "#{field} && Calendar.strftime(#{field}, \"%H:%M:%S\")"

      type in [:naive_datetime, :naive_datetime_usec] ->
        "#{field} && Calendar.strftime(#{field}, \"%Y-%m-%d %H:%M\")"

      type in [:utc_datetime, :utc_datetime_usec] ->
        "#{field} && Calendar.strftime(#{field}, \"%Y-%m-%d %H:%M\")"

      type == :decimal ->
        "#{field} && Decimal.to_string(#{field})"

      match?({:enum, _}, type) ->
        "#{field} && Phoenix.Naming.humanize(to_string(#{field}))"

      type == {:array, :string} ->
        "Enum.join(#{field} || [], \", \")"

      type == {:array, :integer} ->
        "Enum.join(Enum.map(#{field} || [], &to_string/1), \", \")"

      match?({:array, _}, type) ->
        "inspect(#{field})"

      true ->
        field
    end
  end

  defp input_block(schema, field_prefix, key, type) do
    case type do
      :integer ->
        number_input_block(field_prefix, key, nil)

      :float ->
        number_input_block(field_prefix, key, 0.1)

      :decimal ->
        number_input_block(field_prefix, key, 0.1)

      :boolean ->
        checkbox_block(field_prefix, key)

      :text ->
        native_input_block(field_prefix, "textarea", key, error_slot: true)

      :string ->
        native_input_block(field_prefix, "text", key, error_slot: true)

      :uuid ->
        native_input_block(field_prefix, "text", key, error_slot: true)

      :binary ->
        native_input_block(field_prefix, "text", key, error_slot: true)

      :date ->
        date_picker_block(field_prefix, key)

      :time ->
        native_input_block(field_prefix, "time", key, error_slot: true)

      :time_usec ->
        native_input_block(field_prefix, "time", key, error_slot: true)

      :utc_datetime ->
        native_input_block(field_prefix, "datetime-local", key, error_slot: true)

      :naive_datetime ->
        native_input_block(field_prefix, "datetime-local", key, error_slot: true)

      :utc_datetime_usec ->
        native_input_block(field_prefix, "datetime-local", key, error_slot: true)

      :naive_datetime_usec ->
        native_input_block(field_prefix, "datetime-local", key, error_slot: true)

      {:array, _} = array_type ->
        select_array_block(field_prefix, key, array_type)

      {:enum, _} ->
        select_enum_block(schema, field_prefix, key)

      {:references, _} ->
        number_input_block(field_prefix, key, nil)

      _ ->
        native_input_block(field_prefix, "text", key, error_slot: true)
    end
  end

  defp number_input_block(field_prefix, key, step) do
    step_attr = if step, do: " step={0.1}", else: ""

    ~s"""
    <.number_input field={#{field_prefix}[#{inspect(key)}]} class="number-input"#{step_attr}>
      <:label>#{label(key)}</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
      <:error :let={msg}>
        <.heroicon name="hero-exclamation-circle" class="icon" />
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
        <.heroicon name="hero-exclamation-circle" class="icon" />
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
        <.heroicon name="hero-calendar" class="icon" />
      </:trigger>
      <:prev_trigger>
        <.heroicon name="hero-chevron-left" class="icon" />
      </:prev_trigger>
      <:next_trigger>
        <.heroicon name="hero-chevron-right" class="icon" />
      </:next_trigger>
      <:error :let={msg}>
        <.heroicon name="hero-exclamation-circle" class="icon" />
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
        <.heroicon name="hero-exclamation-circle" class="icon" />
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
        <.heroicon name="hero-exclamation-circle" class="icon" />
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
        <.heroicon name="hero-exclamation-circle" class="icon" />
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
        <.heroicon name="hero-exclamation-circle" class="icon" />
        {msg}
      </:error>
    """
  end

  defp array_items({:array, :string}) do
    Enum.map([1, 2], fn i -> %{label: "Option #{i}", value: "option#{i}"} end)
  end

  defp array_items({:array, :integer}) do
    Enum.map([1, 2], fn i -> %{label: "#{i}", value: i} end)
  end

  defp array_items({:array, _}), do: []

  defp label(key), do: Phoenix.Naming.humanize(to_string(key))
end
