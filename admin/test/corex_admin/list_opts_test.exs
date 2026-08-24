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
    assert opts.sort == nil
  end

  test "never atomizes unknown filter keys" do
    opts = ListOpts.from_params(spec(), %{"filters" => %{"status" => "open", "hack" => "1"}})
    assert opts.filters == %{status: "open"}
  end

  test "truncates long search strings" do
    opts = ListOpts.from_params(spec(), %{"q" => String.duplicate("a", 500)})
    assert String.length(opts.search) == 200
  end

  test "caps page size" do
    opts = ListOpts.from_params(spec(), %{"page_size" => "9999"})
    assert opts.page_size == CorexAdmin.max_page_size()
  end

  test "rejects non-positive page" do
    opts = ListOpts.from_params(spec(), %{"page" => "0"})
    assert opts.page == 1
  end

  test "round-trips bookmarkable params" do
    opts =
      ListOpts.from_params(spec(), %{
        "page" => "2",
        "sort" => "email",
        "q" => "hello",
        "filters" => %{"status" => "open"}
      })

    params = ListOpts.to_params(opts)
    assert params["page"] == "2"
    assert params["sort"] == "email"
    assert params["q"] == "hello"
    assert params["filters"]["status"] == "open"
  end
end
