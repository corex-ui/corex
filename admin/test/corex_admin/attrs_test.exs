defmodule CorexAdmin.AttrsTest do
  use ExUnit.Case, async: true

  alias CorexAdmin.Attrs
  alias CorexAdmin.Test.TicketResource

  test "only copies writable fields" do
    spec = TicketResource.__corex_admin_resource__()

    attrs =
      Attrs.take_writable(spec, %{
        "title" => "Hello",
        "id" => "99",
        "password" => "secret",
        "inserted_at" => "2020-01-01",
        "bogus" => "nope"
      })

    assert attrs["title"] == "Hello"
    assert attrs["password"] == "secret"
    refute Map.has_key?(attrs, "id")
    refute Map.has_key?(attrs, "inserted_at")
    refute Map.has_key?(attrs, "bogus")
  end

  test "drops blank passwords" do
    spec = TicketResource.__corex_admin_resource__()
    attrs = Attrs.take_writable(spec, %{"title" => "Hello", "password" => ""})
    refute Map.has_key?(attrs, "password")
  end
end
