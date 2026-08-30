defmodule CorexAdmin.HistoryTest do
  use ExUnit.Case, async: true

  alias CorexAdmin.History
  alias CorexAdmin.History.Version
  alias CorexAdmin.Test.History, as: Fake
  alias CorexAdmin.Test.TicketResource

  test "returns versions from the resource adapter" do
    spec = TicketResource.__corex_admin_resource__()
    [version] = History.fetch(spec, 1, [])

    assert %Version{} = version
    assert version.actor == "ops@example.test"
    assert hd(version.changes).field == "title"
  end

  test "empty when no adapter" do
    spec = %{history: nil}
    assert History.fetch(spec, 1, []) == []
  end

  test "fake adapter implements the behaviour" do
    assert [%Version{}] = Fake.history(nil, 1, [])
  end

  test "carbonite adapter is a no-op without a repo" do
    assert History.Carbonite.history(CorexAdmin.Test.Ticket, 1, []) == []
  end

  test "threadline adapter is a no-op when Threadline is not loaded" do
    assert History.Threadline.history(CorexAdmin.Test.Ticket, 1, []) == []
  end
end
