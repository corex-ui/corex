defmodule E2e.Form.NativeInputProfileTest do
  use ExUnit.Case, async: true

  alias E2e.Form.NativeInputProfile

  test "changeset_validate/2 requires every form field" do
    changeset = NativeInputProfile.changeset_validate(%NativeInputProfile{}, %{})

    refute changeset.valid?

    assert Enum.sort(Keyword.keys(changeset.errors)) ==
             Enum.sort(NativeInputProfile.__schema__(:fields) -- [:id, :tags])
  end

  test "changeset_validate/2 accepts valid_attrs/0" do
    changeset =
      NativeInputProfile.changeset_validate(
        %NativeInputProfile{},
        NativeInputProfile.valid_attrs()
      )

    assert changeset.valid?
  end

  test "format_for_toast/1 accepts apply_changes struct" do
    {:ok, data} =
      %NativeInputProfile{}
      |> NativeInputProfile.changeset(%{
        "name" => "Test",
        "email" => "a@b.co",
        "agree" => "true",
        "tags" => ["elixir"]
      })
      |> Ecto.Changeset.apply_action(:insert)

    toast = NativeInputProfile.format_for_toast(data)

    assert toast =~ "name=\"Test\""
    assert toast =~ "tags=[\"elixir\"]"
    assert toast =~ "password=***"
  end
end
