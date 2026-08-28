defmodule CorexAdmin.Filter.Select do
  @moduledoc "Single choice from `options:`. Supports `:in` / `:not_in`."
  @behaviour CorexAdmin.Filter

  alias CorexAdmin.Filter.Cast
  alias CorexAdmin.Resource.Filter

  @impl true
  def parse(%Filter{} = filter, value) do
    {op, inner} = Cast.split_op(filter, value)

    case Cast.option(filter, inner) do
      nil -> if op in [nil, Filter.default_operator(filter)], do: nil, else: %{op: op}
      parsed when op == :not_in -> %{op: :not_in, value: [parsed]}
      parsed -> parsed
    end
  end
end

defmodule CorexAdmin.Filter.MultiSelect do
  @moduledoc "Any-of choice from `options:`. Supports `:in` / `:not_in`."
  @behaviour CorexAdmin.Filter

  alias CorexAdmin.Filter.Cast
  alias CorexAdmin.Resource.Filter

  @impl true
  def parse(%Filter{} = filter, value) do
    {op, inner} = Cast.split_op(filter, value)

    case Cast.option_list(filter, inner) do
      nil -> if op in [nil, Filter.default_operator(filter)], do: nil, else: %{op: op}
      parsed when op == :not_in -> %{op: :not_in, value: parsed}
      parsed -> parsed
    end
  end
end

defmodule CorexAdmin.Filter.Tags do
  @moduledoc "Free-form list of tags. Values are not restricted to `options:`."
  @behaviour CorexAdmin.Filter

  alias CorexAdmin.Filter.Cast
  alias CorexAdmin.Resource.Filter

  @impl true
  def parse(%Filter{} = filter, value) do
    {op, inner} = Cast.split_op(filter, value)

    case Cast.option_list(%Filter{filter | options: nil}, inner) do
      nil -> if op in [nil, Filter.default_operator(filter)], do: nil, else: %{op: op}
      parsed when op == :not_in -> %{op: :not_in, value: parsed}
      parsed -> parsed
    end
  end
end

defmodule CorexAdmin.Filter.Text do
  @moduledoc "Substring or exact text match. Operators: contains, equals, starts/ends with, not contains."
  @behaviour CorexAdmin.Filter

  alias CorexAdmin.Filter.Cast

  @impl true
  def parse(filter, value), do: Cast.op_filter(filter, value, &Cast.text/1)
end

defmodule CorexAdmin.Filter.Id do
  @moduledoc "Exact primary-key match. Numeric strings become integers."
  @behaviour CorexAdmin.Filter

  alias CorexAdmin.Filter.Cast

  @impl true
  def parse(filter, value), do: Cast.op_filter(filter, value, &cast_id/1)

  defp cast_id(value) do
    case Cast.text(value) do
      nil ->
        nil

      text ->
        case Integer.parse(text) do
          {int, ""} -> int
          _ -> text
        end
    end
  end
end

defmodule CorexAdmin.Filter.Number do
  @moduledoc "Numeric comparison. Operators: eq, gte, lte."
  @behaviour CorexAdmin.Filter

  alias CorexAdmin.Filter.Cast

  @impl true
  def parse(filter, value), do: Cast.op_filter(filter, value, &Cast.number/1)
end

defmodule CorexAdmin.Filter.NumberRange do
  @moduledoc "Inclusive `%{min: _, max: _}` numeric bounds."
  @behaviour CorexAdmin.Filter

  alias CorexAdmin.Filter.Cast

  @impl true
  def parse(_filter, value), do: Cast.number_range(value)
end

defmodule CorexAdmin.Filter.DateRange do
  @moduledoc """
  Inclusive calendar-day range.

  `to` covers the whole day: the query uses `< to + 1 day` rather than
  `<= to`, so a row stamped at 18:00 on the end date still matches.
  """
  @behaviour CorexAdmin.Filter

  alias CorexAdmin.Filter.Cast

  @impl true
  def parse(_filter, value), do: Cast.range(value, :date)
end

defmodule CorexAdmin.Filter.DatetimeRange do
  @moduledoc "Range inclusive of both instants, to the second."
  @behaviour CorexAdmin.Filter

  alias CorexAdmin.Filter.Cast

  @impl true
  def parse(_filter, value), do: Cast.range(value, :datetime)
end

defmodule CorexAdmin.Filter.Boolean do
  @moduledoc "Yes / no equality."
  @behaviour CorexAdmin.Filter

  alias CorexAdmin.Filter.Cast

  @impl true
  def parse(_filter, value) do
    case Cast.token(value) do
      token when token in ~w(true 1 yes on) -> true
      token when token in ~w(false 0 no off) -> false
      _ -> nil
    end
  end
end

defmodule CorexAdmin.Filter.Presence do
  @moduledoc "Whether the column has a value at all."
  @behaviour CorexAdmin.Filter

  alias CorexAdmin.Filter.Cast

  @impl true
  def parse(_filter, value) do
    case Cast.token(value) do
      token when token in ~w(empty blank) -> :empty
      token when token in ~w(set present) -> :set
      _ -> nil
    end
  end
end

defmodule CorexAdmin.Filter.RelativeDate do
  @moduledoc """
  Named rolling window (today, last 7 days, this quarter, …).

  The window is stored by name, not as dates, so a bookmarked URL keeps meaning
  "last 7 days" instead of freezing the week it was created.
  """
  @behaviour CorexAdmin.Filter

  alias CorexAdmin.Filter.Cast
  alias CorexAdmin.Resource.Filter

  @impl true
  def parse(%Filter{} = filter, value) do
    window = Cast.token(unwrap(value))
    allowed = Enum.map(Filter.relative_windows(filter), &Atom.to_string/1)

    if window in allowed, do: %{relative: Filter.parse_atom(window)}, else: nil
  end

  defp unwrap(%{value: value}), do: value
  defp unwrap(%{"value" => value}), do: value
  defp unwrap(%{relative: value}), do: value
  defp unwrap(%{"relative" => value}), do: value
  defp unwrap(value), do: value
end
