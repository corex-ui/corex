defmodule Corex.TagsInputArrayFormTest do
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

  test "ecto cast accepts list params from tags_input array submission" do
    changeset = Profile.changeset(%Profile{}, %{"tags" => ["alpha", "beta"]})

    assert changeset.valid?
    assert Ecto.Changeset.apply_changes(changeset).tags == ["alpha", "beta"]
  end

  test "ecto cast rejects comma string params" do
    changeset = Profile.changeset(%Profile{}, %{"tags" => "alpha,beta"})

    refute changeset.valid?
    assert Keyword.has_key?(changeset.errors, :tags)
  end
end
