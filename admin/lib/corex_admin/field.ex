defmodule CorexAdmin.Field do
  @moduledoc """
  Behaviour for admin field types.

  A field module decides three things: the form control (`input/1`), the
  read-only value (`display/1`), and the export scalar (`export/2`). All three
  are used everywhere the field appears — index cell, show detail, form, and
  CSV — so a custom module cannot change one surface and silently miss another.

      field :color, MyApp.Admin.Fields.Color

      defmodule MyApp.Admin.Fields.Color do
        @behaviour CorexAdmin.Field
        use Phoenix.Component
        use Corex

        def input(assigns) do
          ~H\"""
          <.color_picker field={@form[@field.name]} class="color-picker">
            <:label>{@field.label}</:label>
          </.color_picker>
          \"""
        end

        def display(assigns) do
          ~H\"""
          <span class="admin-cell" style={"--swatch: \#{@value}"}>{@value}</span>
          \"""
        end

        def export(field, record), do: Map.get(record, field.name)
      end

  Custom modules must render **Corex** components. `export/2` is data only —
  never HTML, because the same value is written into CSV.

  ## Overriding one surface without a module

  When only the cell needs to change, name a function instead of writing a whole
  module:

      field :status, :select, options: ~w(open done),
        render: {MyAppWeb.Admin.Cells, :status_badge}

  `render:` replaces `display/1`; `render_form:` replaces `input/1`. Both receive
  the same assigns (`@field`, `@record` or `@form`, `@value`) and must return a
  rendered template. They are `{module, function}` pairs rather than captures so
  a resource stays serializable data.
  """

  alias CorexAdmin.Resource.Field, as: FieldSpec

  @type assigns :: map()

  @doc "Form control for this field."
  @callback input(assigns()) :: Phoenix.LiveView.Rendered.t()

  @doc "Read-only value, used on index and show."
  @callback display(assigns()) :: Phoenix.LiveView.Rendered.t()

  @doc "Scalar for CSV/JSON export. Never HTML."
  @callback export(FieldSpec.t(), map()) :: term()

  @doc "Plain-text form of the value, for summaries and exports. Optional."
  @callback text(FieldSpec.t(), map()) :: String.t()

  @optional_callbacks text: 2

  @doc "Host module implementing this field, or nil for a built-in type."
  @spec module(FieldSpec.t()) :: module() | nil
  def module(%FieldSpec{mod: mod}) when is_atom(mod) and not is_nil(mod), do: mod
  def module(_field), do: nil

  @doc "Whether `mod` implements the required callbacks."
  @spec field_module?(term()) :: boolean()
  def field_module?(mod) when is_atom(mod) and not is_nil(mod) do
    Code.ensure_loaded?(mod) and function_exported?(mod, :input, 1) and
      function_exported?(mod, :display, 1) and function_exported?(mod, :export, 2)
  end

  def field_module?(_), do: false

  @doc "Scalar value for CSV/JSON export (never HTML)."
  @spec export(FieldSpec.t(), map()) :: term()
  def export(%FieldSpec{} = field, record) when is_map(record) do
    case module(field) do
      nil -> export_value(field, record)
      mod -> mod.export(field, record)
    end
  end

  @doc "Default scalar used by built-in field types."
  @spec export_value(FieldSpec.t(), map()) :: term()
  def export_value(%FieldSpec{redact: true}, _record), do: nil
  def export_value(%FieldSpec{type: :password}, _record), do: nil

  def export_value(%FieldSpec{type: type, name: name, fields: children}, record)
      when type in [:embeds_many, :embeds_one] do
    case Map.get(record, name) do
      list when is_list(list) ->
        Enum.map(list, &export_row(&1, children))

      nil ->
        if type == :embeds_many, do: [], else: nil

      row ->
        export_row(row, children)
    end
  end

  def export_value(%FieldSpec{name: name, type: type}, record) do
    case Map.get(record, name) do
      nil -> nil
      %Date{} = date -> Date.to_iso8601(date)
      %DateTime{} = dt -> DateTime.to_iso8601(dt)
      %NaiveDateTime{} = dt -> NaiveDateTime.to_iso8601(dt)
      %Ecto.Association.NotLoaded{} -> nil
      true -> true
      false -> false
      _value when type == :password -> nil
      value when is_binary(value) or is_number(value) -> value
      value when is_atom(value) -> Atom.to_string(value)
      value when is_list(value) -> Enum.map_join(value, ", ", &to_string/1)
      value -> inspect(value)
    end
  end

  defp export_row(row, children) do
    Map.new(children, fn child -> {Atom.to_string(child.name), export_value(child, row)} end)
  end

  @doc """
  Human-readable string for tables, summaries, and breadcrumbs.

  A field module may override this with `text/2`; otherwise built-in formatting
  applies.
  """
  @spec format(FieldSpec.t(), map()) :: String.t()
  def format(%FieldSpec{} = field, record) do
    mod = module(field)

    if mod && function_exported?(mod, :text, 2) do
      to_string(mod.text(field, record))
    else
      format_value(field, record)
    end
  end

  @doc "Built-in text formatting for a field value."
  @spec format_value(FieldSpec.t(), map()) :: String.t()
  def format_value(%FieldSpec{redact: true}, _record), do: "••••"

  def format_value(%FieldSpec{type: type, name: name, fields: children}, record)
      when type in [:embeds_many, :embeds_one] do
    case Map.get(record, name) do
      list when is_list(list) and list != [] ->
        Enum.map_join(list, "; ", &embed_row_text(&1, children))

      nil ->
        "—"

      [] ->
        "—"

      row ->
        embed_row_text(row, children)
    end
  end

  def format_value(%FieldSpec{relation: relation} = field, record) when not is_nil(relation) do
    case Map.get(record, field.name) do
      %Ecto.Association.NotLoaded{} -> "—"
      nil -> "—"
      list when is_list(list) -> related_list_text(relation, list)
      related -> blank_to_dash(CorexAdmin.Resource.Relation.label(relation, related))
    end
  end

  def format_value(%FieldSpec{name: name, type: type}, record) do
    case Map.get(record, name) do
      nil -> "—"
      true -> CorexAdmin.Gettext.t("Yes")
      false -> CorexAdmin.Gettext.t("No")
      %Date{} = date -> Date.to_iso8601(date)
      %DateTime{} = dt -> Calendar.strftime(dt, "%Y-%m-%d %H:%M")
      %NaiveDateTime{} = dt -> NaiveDateTime.to_iso8601(dt)
      %Ecto.Association.NotLoaded{} -> "—"
      _value when type == :password -> "••••"
      value when is_binary(value) -> value
      value when is_integer(value) or is_float(value) -> to_string(value)
      value when is_atom(value) -> Atom.to_string(value)
      [] -> "—"
      value when is_list(value) -> Enum.map_join(value, ", ", &to_string/1)
      value -> inspect(value)
    end
  end

  defp related_list_text(relation, list) do
    case Enum.map(list, &CorexAdmin.Resource.Relation.label(relation, &1)) do
      [] -> "—"
      labels -> Enum.join(labels, ", ")
    end
  end

  defp blank_to_dash(""), do: "—"
  defp blank_to_dash(value), do: value

  defp embed_row_text(row, children) do
    children
    |> Enum.map(&format(&1, row))
    |> Enum.reject(&(&1 in [nil, "", "—"]))
    |> Enum.join(" · ")
  end
end
