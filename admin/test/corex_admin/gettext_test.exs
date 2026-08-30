defmodule CorexAdmin.GettextTest do
  use ExUnit.Case, async: true

  alias CorexAdmin.Gettext

  test "returns English when no backend is configured" do
    assert Gettext.t("Filters") == "Filters"
    assert Gettext.t("Search %{label}", label: "Tickets") == "Search Tickets"
    assert Gettext.t("%{count} selected", count: 0) == "0 selected"
  end
end
