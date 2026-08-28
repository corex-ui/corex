defmodule CorexAdmin.Test.Owners do
  @moduledoc false

  alias CorexAdmin.Test.Owner

  @owners [
    %Owner{id: 1, name: "Ada", email: "ada@example.test"},
    %Owner{id: 2, name: "Grace", email: "grace@example.test"}
  ]

  @doc "Scoped owner list, optionally narrowed by the combobox query."
  def list_owners(_scope, opts \\ []) do
    query = opts |> Keyword.get(:query, "") |> to_string() |> String.downcase()

    if query == "" do
      @owners
    else
      Enum.filter(@owners, &String.contains?(String.downcase(&1.name), query))
    end
  end
end
