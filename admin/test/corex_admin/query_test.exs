defmodule CorexAdmin.QueryTest do
  use ExUnit.Case, async: true

  import Ecto.Query

  alias CorexAdmin.ListOpts
  alias CorexAdmin.Query
  alias CorexAdmin.Test.Ticket

  test "applies allowlisted sort" do
    opts = %ListOpts{page: 1, page_size: 10, sort: {:title, :desc}}
    query = Query.apply(from(t in Ticket), opts)
    assert [%{expr: expr}] = query.order_bys
    assert inspect(expr) =~ "desc"
  end

  test "applies parameterized search" do
    opts = %ListOpts{page: 1, page_size: 10, search: "100%_off", search_fields: [:title]}
    query = Query.apply(from(t in Ticket), opts)
    assert query.wheres != []
  end

  test "applies equality, in, date range, and number range filters" do
    opts = %ListOpts{
      page: 1,
      page_size: 10,
      filters: %{
        status: ["open", "done"],
        inserted_at: %{from: ~D[2026-08-01], to: ~D[2026-08-25]},
        priority: %{min: 1, max: 5}
      }
    }

    query = Query.apply(from(t in Ticket), opts)
    assert length(query.wheres) >= 3
    inspect_wheres = inspect(query.wheres, limit: :infinity, pretty: false)
    assert inspect_wheres =~ "in"
    assert inspect_wheres =~ "inserted_at"
    assert inspect_wheres =~ "priority"
  end

  test "match_filter? handles list and range values" do
    ticket = %Ticket{
      status: "open",
      priority: 3,
      inserted_at: ~U[2026-08-10 12:00:00Z]
    }

    assert Query.match_filter?(ticket, :status, ["open", "done"])
    refute Query.match_filter?(ticket, :status, ["done"])
    assert Query.match_filter?(ticket, :priority, %{min: 1, max: 5})
    refute Query.match_filter?(ticket, :priority, %{min: 4, max: 5})
    assert Query.match_filter?(ticket, :inserted_at, %{from: ~D[2026-08-01], to: ~D[2026-08-25]})
    refute Query.match_filter?(ticket, :inserted_at, %{from: ~D[2026-08-11], to: ~D[2026-08-25]})
  end

  test "match_filter? handles contains and presence" do
    ticket = %Ticket{email: "ops@example.test", body: ""}

    assert Query.match_filter?(ticket, :email, %{contains: "ops@"})
    refute Query.match_filter?(ticket, :email, %{contains: "nope"})
    assert Query.match_filter?(ticket, :body, :empty)
    refute Query.match_filter?(ticket, :body, :set)
  end

  test "match_filter? handles operators, not-in, and relative dates" do
    ticket = %Ticket{
      email: "ops@example.test",
      status: "open",
      inserted_at: DateTime.utc_now()
    }

    assert Query.match_filter?(ticket, :email, %{op: :starts_with, value: "ops"})
    refute Query.match_filter?(ticket, :email, %{op: :starts_with, value: "zzz"})
    assert Query.match_filter?(ticket, :email, %{op: :not_contains, value: "zzz"})
    refute Query.match_filter?(ticket, :status, %{op: :not_in, value: ["open"]})
    assert Query.match_filter?(ticket, :status, %{op: :not_in, value: ["done"]})
    assert Query.match_filter?(ticket, :inserted_at, %{relative: :today})
    refute Query.match_filter?(ticket, :inserted_at, %{relative: :yesterday})
  end

  test "paginates with limit and offset" do
    opts = %ListOpts{page: 3, page_size: 10}
    query = Query.paginate(from(t in Ticket), opts)
    assert %{expr: {:^, _, [0]}, params: [{10, :integer}]} = query.limit
    assert %{expr: {:^, _, [0]}, params: [{20, :integer}]} = query.offset
  end
end
