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

  test "paginates with limit and offset" do
    opts = %ListOpts{page: 3, page_size: 10}
    query = Query.paginate(from(t in Ticket), opts)
    assert %{expr: {:^, _, [0]}, params: [{10, :integer}]} = query.limit
    assert %{expr: {:^, _, [0]}, params: [{20, :integer}]} = query.offset
  end
end
