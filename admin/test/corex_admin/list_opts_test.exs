defmodule CorexAdmin.ListOptsTest do
  use ExUnit.Case, async: true

  alias CorexAdmin.ListOpts
  alias CorexAdmin.Test.TicketResource

  defp spec, do: TicketResource.__corex_admin_resource__()

  test "allowlists sort and drops unknown keys" do
    opts =
      ListOpts.from_params(spec(), %{"sort" => "title", "dir" => "desc", "sort_by" => "nope"})

    assert opts.sort == {:title, :desc}

    opts = ListOpts.from_params(spec(), %{"sort" => "password"})
    assert opts.sort == {:inserted_at, :desc}
  end

  test "applies default_sort when sort is omitted" do
    opts = ListOpts.from_params(spec(), %{})
    assert opts.sort == {:inserted_at, :desc}
  end

  test "never atomizes unknown filter keys" do
    opts = ListOpts.from_params(spec(), %{"filters" => %{"status" => "open", "hack" => "1"}})
    assert opts.filters == %{status: ["open"]}
  end

  test "parses multi-select, date range, and number range" do
    opts =
      ListOpts.from_params(spec(), %{
        "filters" => %{
          "status" => ["open", "done", "nope"],
          "inserted_at" => %{"from" => "2026-08-01", "to" => "2026-08-25"},
          "priority" => %{"min" => "1", "max" => "5"}
        }
      })

    assert opts.filters[:status] == ["open", "done"]
    assert opts.filters[:inserted_at] == %{from: ~D[2026-08-01], to: ~D[2026-08-25]}
    assert opts.filters[:priority] == %{min: 1, max: 5}
  end

  test "drops invalid dates and out-of-option page sizes" do
    opts =
      ListOpts.from_params(spec(), %{
        "page_size" => "13",
        "filters" => %{"inserted_at" => %{"from" => "not-a-date"}}
      })

    assert opts.page_size == 25
    refute Map.has_key?(opts.filters, :inserted_at)

    opts = ListOpts.from_params(spec(), %{"page_size" => "9999"})
    assert opts.page_size == 25
  end

  test "truncates long search strings" do
    opts = ListOpts.from_params(spec(), %{"q" => String.duplicate("a", 500)})
    assert String.length(opts.search) == 200
  end

  test "rejects non-positive page" do
    opts = ListOpts.from_params(spec(), %{"page" => "0"})
    assert opts.page == 1
  end

  test "round-trips bookmarkable params" do
    opts =
      ListOpts.from_params(spec(), %{
        "page" => "2",
        "page_size" => "10",
        "sort" => "email",
        "q" => "hello",
        "filters" => %{
          "status" => ["open"],
          "inserted_at" => %{"from" => "2026-08-01", "to" => "2026-08-02"}
        }
      })

    params = ListOpts.to_params(opts)
    assert params["page"] == "2"
    assert params["page_size"] == "10"
    assert params["sort"] == "email"
    assert params["q"] == "hello"
    assert params["filters"]["status"] == ["open"]
    assert params["filters"]["inserted_at"]["from"] == "2026-08-01"
    assert params["filters"]["inserted_at"]["to"] == "2026-08-02"
  end
end
