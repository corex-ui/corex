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

  test "an exclusive nested boolean keeps only the last row that set it" do
    spec = TicketResource.__corex_admin_resource__()

    attrs =
      Attrs.take_writable(spec, %{
        "title" => "Hello",
        "social_links" => %{
          "0" => %{"label" => "A", "url" => "https://a.test", "preferred" => "true"},
          "1" => %{"label" => "B", "url" => "https://b.test", "preferred" => "true"},
          "2" => %{"label" => "C", "url" => "https://c.test", "preferred" => "false"}
        }
      })

    assert attrs["social_links"]["0"]["preferred"] == "false"
    assert attrs["social_links"]["1"]["preferred"] == "true"
    assert attrs["social_links"]["2"]["preferred"] == "false"
  end

  test "an exclusive nested boolean is left alone when no row sets it" do
    spec = TicketResource.__corex_admin_resource__()

    attrs =
      Attrs.take_writable(spec, %{
        "social_links" => %{
          "0" => %{"label" => "A", "url" => "https://a.test", "preferred" => "false"}
        }
      })

    assert attrs["social_links"]["0"]["preferred"] == "false"
  end

  test "reads a belongs_to from its foreign key" do
    spec = TicketResource.__corex_admin_resource__()
    attrs = Attrs.take_writable(spec, %{"title" => "Hello", "owner_id" => "2", "owner" => "nope"})

    assert attrs["owner_id"] == "2"
    refute Map.has_key?(attrs, "owner")
  end

  test "a computed column is never writable" do
    spec = TicketResource.__corex_admin_resource__()
    attrs = Attrs.take_writable(spec, %{"title" => "Hello", "shout" => "HELLO"})

    refute Map.has_key?(attrs, "shout")
  end
end
