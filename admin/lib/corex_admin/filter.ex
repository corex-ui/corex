defmodule CorexAdmin.Filter do
  @moduledoc """
  Behaviour for index filter types.

  A filter module owns one filter's whole lifecycle: how params become a
  canonical value (`parse/2`) and, when the built-in shapes cannot express it,
  how that value narrows a query (`apply/3`).

  Built-in type atoms (`:select`, `:date_range`, …) resolve to
  `CorexAdmin.Filter.*` modules. Host apps may name a module instead:

      filters do
        filter :nearby, MyApp.Admin.Filters.Nearby, label: "Within 10km"
      end

  ## Parsing

  `parse/2` receives the resource's `%CorexAdmin.Resource.Filter{}` and the raw
  params value, and returns a canonical value (see
  `CorexAdmin.State.Filters`) or `nil` for "no constraint". It must treat the
  input as untrusted: values outside `options:` are dropped, not forwarded.

  ## Querying

  Most filters need no `apply/3` — `CorexAdmin.Query` already dispatches the
  canonical shapes. Implement it when the filter needs a join, a fragment, or a
  comparison the shapes do not cover:

      defmodule MyApp.Admin.Filters.Nearby do
        @behaviour CorexAdmin.Filter
        import Ecto.Query

        def parse(_filter, value), do: CorexAdmin.Filter.Cast.number(value)

        def apply(query, %CorexAdmin.Query.Ref{field: field}, km) do
          where(query, [row], fragment("? <@> point(0,0) < ?", field(row, ^field), ^km))
        end
      end

  `apply/3` runs inside the host context, never against a repo owned by the
  admin.
  """

  alias CorexAdmin.Resource.Filter, as: FilterSpec

  @doc "Canonical value for `filter` from an untrusted params value."
  @callback parse(FilterSpec.t(), term()) :: term() | nil

  @doc "Narrows `query` using a canonical value. Optional."
  @callback apply(Ecto.Queryable.t(), CorexAdmin.Query.Ref.t(), term()) :: Ecto.Queryable.t()

  @optional_callbacks apply: 3

  @builtins %{
    select: CorexAdmin.Filter.Select,
    multi_select: CorexAdmin.Filter.MultiSelect,
    tags: CorexAdmin.Filter.Tags,
    text: CorexAdmin.Filter.Text,
    id: CorexAdmin.Filter.Id,
    number: CorexAdmin.Filter.Number,
    number_range: CorexAdmin.Filter.NumberRange,
    date_range: CorexAdmin.Filter.DateRange,
    datetime_range: CorexAdmin.Filter.DatetimeRange,
    boolean: CorexAdmin.Filter.Boolean,
    presence: CorexAdmin.Filter.Presence,
    relative_date: CorexAdmin.Filter.RelativeDate
  }

  @doc "Built-in type atom to module map."
  @spec builtins() :: %{atom() => module()}
  def builtins, do: @builtins

  @doc "Whether `type` is a built-in atom or a host filter module."
  @spec known_type?(term()) :: boolean()
  def known_type?(type) when is_atom(type) do
    Map.has_key?(@builtins, type) or filter_module?(type)
  end

  def known_type?(_), do: false

  @doc "Whether `mod` implements the required callbacks."
  @spec filter_module?(term()) :: boolean()
  def filter_module?(mod) when is_atom(mod) and not is_nil(mod) do
    Code.ensure_loaded?(mod) and function_exported?(mod, :parse, 2)
  end

  def filter_module?(_), do: false
end
