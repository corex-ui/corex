defmodule CorexAdmin.Test.Filters.Fuzzy do
  @moduledoc false
  @behaviour CorexAdmin.Filter

  import Ecto.Query

  alias CorexAdmin.Query.Ref

  @impl true
  def parse(_filter, value), do: CorexAdmin.Filter.Cast.text(value)

  @impl true
  def apply(query, %Ref{binding: nil, field: field}, term) do
    where(query, [row], fragment("? % ?", field(row, ^field), ^term))
  end

  def apply(query, %Ref{binding: as, field: field}, term) do
    where(query, [{^as, b}], fragment("? % ?", field(b, ^field), ^term))
  end
end
