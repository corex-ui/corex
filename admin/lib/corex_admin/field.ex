defmodule CorexAdmin.Field do
  @moduledoc """
  Behaviour for admin field types.

  Built-in aliases (`:text`, `:select`, …) resolve to `CorexAdmin.Field.*`
  modules. Host apps may pass a module instead:

      field :color, MyApp.Admin.Fields.Color

  Custom modules must render **Corex** components (`native_input`, `select`,
  `date_picker`, …) — never a second UI kit. `export/2` is data-only.
  """

  alias CorexAdmin.Resource.Field

  @type assigns :: map()

  @callback input(assigns()) :: Phoenix.LiveView.Rendered.t()
  @callback display(assigns()) :: Phoenix.LiveView.Rendered.t()
  @callback export(Field.t(), map()) :: term()

  @builtins %{
    id: CorexAdmin.Field.Id,
    text: CorexAdmin.Field.Text,
    textarea: CorexAdmin.Field.Textarea,
    email: CorexAdmin.Field.Email,
    password: CorexAdmin.Field.Password,
    number: CorexAdmin.Field.Number,
    boolean: CorexAdmin.Field.Boolean,
    select: CorexAdmin.Field.Select,
    date: CorexAdmin.Field.Date,
    datetime: CorexAdmin.Field.Datetime,
    url: CorexAdmin.Field.Url,
    embeds_many: CorexAdmin.Field.EmbedsMany
  }

  @doc "Built-in type atom → module map."
  def builtins, do: @builtins

  @doc "Resolves the implementation module for a field struct."
  @spec module(Field.t()) :: module()
  def module(%Field{mod: mod}) when is_atom(mod) and not is_nil(mod), do: mod
  def module(%Field{type: type}), do: Map.get(@builtins, type, CorexAdmin.Field.Text)

  @doc "Whether `type` is a built-in alias or a host field module."
  @spec known_type?(term()) :: boolean()
  def known_type?(type) when is_atom(type) do
    Map.has_key?(@builtins, type) or field_module?(type)
  end

  def known_type?(_), do: false

  @doc false
  def field_module?(mod) when is_atom(mod) do
    Code.ensure_loaded?(mod) and function_exported?(mod, :input, 1) and
      function_exported?(mod, :display, 1) and function_exported?(mod, :export, 2)
  end

  def field_module?(_), do: false

  @doc "Renders the form control for `assigns.field`."
  def input(assigns), do: module(assigns.field).input(assigns)

  @doc "Renders the read-only cell/value for `assigns.field`."
  def display(assigns), do: module(assigns.field).display(assigns)

  @doc "Scalar value for CSV/JSON export (never HTML)."
  def export(%Field{} = field, record) when is_map(record) do
    module(field).export(field, record)
  end

  @doc "Default scalar used by built-in field modules."
  def export_value(%Field{redact: true}, _record), do: nil
  def export_value(%Field{type: :password}, _record), do: nil

  def export_value(%Field{type: :embeds_many, name: name, fields: children}, record) do
    case Map.get(record, name) do
      list when is_list(list) ->
        Enum.map(list, fn row ->
          Map.new(children, fn child -> {Atom.to_string(child.name), export_value(child, row)} end)
        end)

      _ ->
        []
    end
  end

  def export_value(%Field{name: name, type: type}, record) do
    case Map.get(record, name) do
      nil -> nil
      %Date{} = date -> Date.to_iso8601(date)
      %DateTime{} = dt -> DateTime.to_iso8601(dt)
      %NaiveDateTime{} = dt -> NaiveDateTime.to_iso8601(dt)
      true -> true
      false -> false
      _value when type == :password -> nil
      value when is_binary(value) or is_number(value) -> value
      value when is_atom(value) -> Atom.to_string(value)
      value -> inspect(value)
    end
  end

  @doc "Human-readable string for tables, show, and chips."
  def format(%Field{redact: true}, _record), do: "••••"

  def format(%Field{type: :embeds_many, name: name, fields: children}, record) do
    case Map.get(record, name) do
      list when is_list(list) and list != [] ->
        Enum.map_join(list, "; ", &embed_row_text(&1, children))

      _ ->
        "—"
    end
  end

  def format(%Field{name: name, type: type}, record) do
    case Map.get(record, name) do
      nil -> "—"
      true -> CorexAdmin.Gettext.t("Yes")
      false -> CorexAdmin.Gettext.t("No")
      %Date{} = date -> Date.to_iso8601(date)
      %DateTime{} = dt -> Calendar.strftime(dt, "%Y-%m-%d %H:%M")
      %NaiveDateTime{} = dt -> NaiveDateTime.to_iso8601(dt)
      _value when type == :password -> "••••"
      value when is_binary(value) -> value
      value when is_integer(value) or is_float(value) -> to_string(value)
      value when is_atom(value) -> Atom.to_string(value)
      value -> inspect(value)
    end
  end

  defp embed_row_text(row, children) do
    children
    |> Enum.map(&format(&1, row))
    |> Enum.reject(&(&1 in [nil, "", "—"]))
    |> Enum.join(" · ")
  end
end
