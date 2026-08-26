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

  test "allowlists nested embed keys and sort/drop params" do
    spec = TicketResource.__corex_admin_resource__()

    attrs =
      Attrs.take_writable(spec, %{
        "title" => "Hello",
        "social_links" => %{
          "0" => %{"label" => "Docs", "url" => "https://example.test", "bogus" => "nope"}
        },
        "social_links_sort" => ["0", "new"],
        "social_links_drop" => [""],
        "bogus" => "nope"
      })

    assert attrs["title"] == "Hello"

    assert attrs["social_links"] == %{
             "0" => %{"label" => "Docs", "url" => "https://example.test"}
           }

    assert attrs["social_links_sort"] == ["0", "new"]
    assert attrs["social_links_drop"] == [""]
    refute Map.has_key?(attrs, "bogus")
    refute Map.has_key?(attrs["social_links"]["0"], "bogus")
  end
end
