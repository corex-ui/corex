defmodule E2e.Form.NativeInputProfileTest do
  use ExUnit.Case, async: true

  alias E2e.Form.NativeInputProfile

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
