defmodule CorexAdmin.Query.Ref do
  @moduledoc """
  Which column a filter, sort, or search term targets.

  `binding` is `nil` for the root schema, or the association name for a joined
  one. A custom `CorexAdmin.Filter` receives a ref so it can build its own
  Ecto expression against the right binding:

      def apply(query, %CorexAdmin.Query.Ref{binding: nil, field: field}, value) do
        where(query, [row], fragment("? % ?", field(row, ^field), ^value))
      end

      def apply(query, %CorexAdmin.Query.Ref{binding: as, field: field}, value) do
        where(query, [{^as, b}], field(b, ^field) == ^value)
      end

  `CorexAdmin.Query` guarantees the binding is already joined and named before
  calling, so a ref is always usable as-is.
  """

  defstruct [:binding, :field]

  @type t :: %__MODULE__{binding: atom() | nil, field: atom()}

  @doc "Ref for a root-schema column."
  @spec root(atom()) :: t()
  def root(field), do: %__MODULE__{binding: nil, field: field}

  @doc """
  Ref from an association path.

  `[:email]` is the root column `email`; `[:author, :email]` is `email` on the
  joined `author`.
  """
  @spec from_path([atom()] | nil, atom()) :: t()
  def from_path(nil, fallback), do: root(fallback)
  def from_path([], fallback), do: root(fallback)
  def from_path([single], _fallback), do: root(single)

  def from_path(path, _fallback) when is_list(path) do
    %__MODULE__{binding: Enum.at(path, -2), field: List.last(path)}
  end

  @doc "Whether this ref needs a join."
  @spec joined?(t()) :: boolean()
  def joined?(%__MODULE__{binding: binding}), do: not is_nil(binding)
end
