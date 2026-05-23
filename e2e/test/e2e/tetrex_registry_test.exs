defmodule E2e.Tetrex.RegistryTest do
  use E2e.DataCase, async: false

  alias E2e.Tetrex.Registry
  alias E2e.Tetrex.Session

  setup do
    E2e.DataCase.cleanup_tetrex_sessions()
    :ok
  end

  test "create lists only when session is running" do
    id = Registry.create()
    assert id != ""
    refute Enum.any?(Registry.list_active(), &(&1.id == id))

    :ok = Session.ensure_started(id)
    :ok = Registry.track_player(id, self())
    assert Enum.any?(Registry.list_active(), &(&1.id == id))
  end

  test "unregister removes session" do
    id = Registry.create()
    :ok = Registry.unregister(id)
    refute Enum.any?(Registry.list_active(), &(&1.id == id))
  end

  test "Session.stop/1 removes session from list_active" do
    id = Registry.create()
    :ok = Session.ensure_started(id)
    :ok = Registry.track_player(id, self())
    assert Enum.any?(Registry.list_active(), &(&1.id == id))

    :ok = Session.stop(id)

    refute Enum.any?(Registry.list_active(), &(&1.id == id))
  end
end
