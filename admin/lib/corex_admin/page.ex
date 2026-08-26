defmodule CorexAdmin.Page do
  @moduledoc """
  A page of records returned by a context `list/2` function.
  """

  @enforce_keys [:entries, :total, :page, :page_size]
  defstruct [:entries, :total, :page, :page_size]

  @type t :: %__MODULE__{
          entries: [term()],
          total: non_neg_integer(),
          page: pos_integer(),
          page_size: pos_integer()
        }

  @doc "1-based last page for this result set (always at least 1)."
  @spec last_page(t()) :: pos_integer()
  def last_page(%__MODULE__{total: total, page_size: page_size})
      when is_integer(total) and total >= 0 and is_integer(page_size) and page_size > 0 do
    if total == 0, do: 1, else: div(total + page_size - 1, page_size)
  end

  @doc "1-based first and last row indexes shown on this page, plus total."
  @spec window(t()) :: {non_neg_integer(), non_neg_integer(), non_neg_integer()}
  def window(%__MODULE__{total: 0}), do: {0, 0, 0}

  def window(%__MODULE__{page: page, page_size: page_size, total: total, entries: entries}) do
    first = (page - 1) * page_size + 1
    last = first + max(length(entries) - 1, 0)
    {first, min(last, total), total}
  end
end
