defmodule E2e.Form.PreferencesFormTest do
  use ExUnit.Case, async: true

  import Phoenix.Component

  alias E2e.Form.Preferences

  test "Preferences changeset rejects unchecked notifications" do
    assert %{valid?: false} = Preferences.changeset(%Preferences{}, %{"notifications" => "false"})
  end

  test "Preferences changeset_validate uses custom acceptance message" do
    cs = Preferences.changeset_validate(%Preferences{}, %{"notifications" => "false"})
    assert %{valid?: false} = cs
    assert [{msg, _} | _] = Keyword.get_values(cs.errors, :notifications)
    assert msg == "must be accepted to continue"
  end

  test "Preferences changeset rejects invalid boolean cast" do
    cs = Preferences.changeset(%Preferences{}, %{"notifications" => "invalid"})
    assert %{valid?: false} = cs
    assert Keyword.get_values(cs.errors, :notifications) != []
  end

  test "to_form for Preferences exposes nested name and id for switch field" do
    cs = Preferences.changeset(%Preferences{}, %{})
    f = to_form(cs, as: :preferences, id: "switch-form-live")
    assert f[:notifications].name == "preferences[notifications]"
    assert f[:notifications].id == "switch-form-live_notifications"
  end
end
