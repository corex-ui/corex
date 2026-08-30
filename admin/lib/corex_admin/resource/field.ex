defmodule CorexAdmin.Resource.Field do
  @moduledoc """
  One entry from a resource `fields do` block.

  This is data. How a field renders and exports lives in its module
  (`CorexAdmin.Field`), which `mod` names or `type` resolves.
  """

  alias CorexAdmin.Resource.Relation

  defstruct [
    :name,
    :type,
    :mod,
    :label,
    :path,
    :relation,
    :render,
    :render_form,
    readable: true,
    writable: true,
    searchable: false,
    sortable: false,
    redact: false,
    index: true,
    show: true,
    exclusive: false,
    virtual: false,
    options: nil,
    schema: nil,
    fields: []
  ]

  @type renderer :: (map() -> Phoenix.LiveView.Rendered.t()) | nil

  @type t :: %__MODULE__{
          name: atom(),
          type: atom(),
          mod: module() | nil,
          label: String.t(),
          path: [atom()] | nil,
          relation: Relation.t() | nil,
          render: renderer(),
          render_form: renderer(),
          readable: boolean(),
          writable: boolean(),
          searchable: boolean(),
          sortable: boolean(),
          redact: boolean(),
          index: boolean(),
          show: boolean(),
          exclusive: boolean(),
          virtual: boolean(),
          options: [term()] | nil,
          schema: module() | nil,
          fields: [t()]
        }

  @doc """
  Association binding and column this field reads.

  `nil` binding means the root schema.
  """
  @spec target(t()) :: {atom() | nil, atom()}
  def target(%__MODULE__{path: [single]}), do: {nil, single}

  def target(%__MODULE__{path: path}) when is_list(path) and path != [] do
    {Enum.at(path, -2), List.last(path)}
  end

  def target(%__MODULE__{name: name}), do: {nil, name}

  @doc "Whether this field holds nested records rather than a scalar."
  @spec nested?(t()) :: boolean()
  def nested?(%__MODULE__{type: type}), do: type in [:embeds_many, :embeds_one]

  @doc "Whether this field points at another resource."
  @spec relation?(t()) :: boolean()
  def relation?(%__MODULE__{relation: %Relation{}}), do: true
  def relation?(_), do: false
end
