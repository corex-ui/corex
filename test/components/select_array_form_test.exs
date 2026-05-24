defmodule Corex.SelectArrayFormTest do
  use ExUnit.Case, async: true

  import Ecto.Changeset

  defmodule Profile do
    use Ecto.Schema

    embedded_schema do
      field(:tags, {:array, :string}, default: [])
    end

    def changeset(profile, attrs) do
      cast(profile, attrs, [:tags])
    end
  end

  test "ecto cast accepts list params from select multiple name[] submission" do
    changeset = Profile.changeset(%Profile{}, %{"tags" => ["option1", "option2"]})

    assert changeset.valid?
    assert Ecto.Changeset.apply_changes(changeset).tags == ["option1", "option2"]
  end

  test "ecto cast rejects comma string params from legacy select submission" do
    changeset = Profile.changeset(%Profile{}, %{"tags" => "option1,option2"})

    refute changeset.valid?
    assert Keyword.has_key?(changeset.errors, :tags)
  end
end
