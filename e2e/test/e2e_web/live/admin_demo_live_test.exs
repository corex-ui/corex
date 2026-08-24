defmodule E2eWeb.AdminDemoLiveTest do
  use E2eWeb.ConnCase

  alias E2e.AdminDemo
  alias E2e.AdminDemo.Scope

  test "home and tickets index", %{conn: conn} do
    {_view, html} = live_ok!(conn, ~p"/admin")
    assert html =~ "Tickets"
    assert html =~ "Isolated"

    {_view, html} = live_ok!(conn, ~p"/admin/tickets")
    assert html =~ "Welcome ticket"
    assert html =~ "page=2"

    {_view, html} = live_ok!(conn, ~p"/admin/tickets?page=2")
    assert html =~ "Queue ticket"
  end

  test "search filters tickets", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/admin/tickets")

    html =
      view
      |> element("#tickets-search")
      |> render_change(%{"q" => "Search me"})

    assert html =~ "Search me"
    refute html =~ "High priority"
  end

  test "sessions are isolated", %{conn: conn} do
    conn_a = init_test_session(conn, %{"admin_demo_id" => "demo-a"})
    conn_b = init_test_session(build_conn(), %{"admin_demo_id" => "demo-b"})

    {_view, html_a} = live_ok!(conn_a, ~p"/admin/tickets")
    {_view, html_b} = live_ok!(conn_b, ~p"/admin/tickets")

    assert html_a =~ "Welcome ticket"
    assert html_b =~ "Welcome ticket"

    {:ok, ticket} =
      AdminDemo.create_ticket(%Scope{demo_id: "demo-a"}, %{
        "title" => "Only A",
        "email" => "a@example.test",
        "status" => "open",
        "priority" => 1
      })

    {view_a, _} = live_ok!(conn_a, ~p"/admin/tickets?q=Only A")
    {view_b, _} = live_ok!(conn_b, ~p"/admin/tickets?q=Only A")

    assert has_element?(view_a, "#tickets-table", "Only A")
    refute has_element?(view_b, "#tickets-table", "Only A")

    assert_raise Ecto.NoResultsError, fn ->
      AdminDemo.get_ticket!(%Scope{demo_id: "demo-b"}, ticket.id)
    end
  end

  test "header and homepage link to admin", %{conn: conn} do
    conn = get(conn, ~p"/")
    html = html_response(conn, 200)
    assert html =~ "Corex Admin"
    assert html =~ "Open admin demo"
  end
end
