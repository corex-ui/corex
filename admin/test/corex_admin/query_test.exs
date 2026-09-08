defmodule CorexAdmin.QueryTest do
  use ExUnit.Case, async: true

  import Ecto.Query

  alias CorexAdmin.ListOpts
  alias CorexAdmin.Query
  alias CorexAdmin.Resource.Filter
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

  test "joins an association named by a filter path" do
    filter = %Filter{name: :owner_email, type: :text, field: :email, path: [:owner, :email]}

    opts = %ListOpts{
      page: 1,
      page_size: 10,
      filters: %{owner_email: %{contains: "ops"}},
      filter_specs: %{owner_email: filter}
    }

    query = Query.apply(from(t in Ticket), opts)

    assert Ecto.Query.has_named_binding?(query, :owner)
    assert query.wheres != []
  end

  test "joins once when several filters share an association" do
    specs = %{
      owner_email: %Filter{name: :owner_email, type: :text, field: :email, path: [:owner, :email]},
      owner_name: %Filter{name: :owner_name, type: :text, field: :name, path: [:owner, :name]}
    }

    opts = %ListOpts{
      page: 1,
      page_size: 10,
      filters: %{owner_email: %{contains: "ops"}, owner_name: %{contains: "ada"}},
      filter_specs: specs
    }

    query = Query.apply(from(t in Ticket), opts)

    assert length(query.joins) == 1
  end

  test "searches across an association path" do
    opts = %ListOpts{
      page: 1,
      page_size: 10,
      search: "ada",
      search_fields: [:owner_name],
      search_paths: %{owner_name: [:owner, :name]}
    }

    query = Query.apply(from(t in Ticket), opts)

    assert Ecto.Query.has_named_binding?(query, :owner)
    assert query.wheres != []
  end

  test "raises rather than returning an unfiltered query for an unknown shape" do
    opts = %ListOpts{page: 1, page_size: 10, filters: %{status: {:weird, :shape}}}

    assert_raise ArgumentError, ~r/cannot apply filter :status/, fn ->
      Query.apply(from(t in Ticket), opts)
    end
  end

  test "a filter module may own its own query application" do
    filter = %Filter{
      name: :fuzzy,
      type: :custom,
      mod: CorexAdmin.Test.Filters.Fuzzy,
      field: :title
    }

    opts = %ListOpts{
      page: 1,
      page_size: 10,
      filters: %{fuzzy: "abc"},
      filter_specs: %{fuzzy: filter}
    }

    query = Query.apply(from(t in Ticket), opts)

    assert inspect(query.wheres, limit: :infinity) =~ "fragment"
  end
end
