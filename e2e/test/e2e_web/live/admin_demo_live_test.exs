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

  test "page size select patches query string", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/admin/tickets")

    view
    |> element("#tickets-page-size")
    |> render_change(%{"page_size" => "10"})

    assert_patch(view, ~p"/admin/tickets?page_size=10")
    html = render(view)
    assert html =~ "Showing 1–10 of 32"
  end

  test "status multi-select, date range, and clear chips", %{conn: conn} do
    index = ~p"/admin/tickets"

    qs =
      Plug.Conn.Query.encode(%{
        "filters" => %{"status" => ["open"]}
      })

    {_view, html} = live_ok!(conn, "#{index}?#{qs}")
    assert html =~ "Welcome ticket"
    refute html =~ "Search me"
    assert html =~ "Status: open"

    today = Date.utc_today() |> Date.to_iso8601()

    date_qs =
      Plug.Conn.Query.encode(%{
        "filters" => %{"inserted_at" => %{"from" => today, "to" => today}}
      })

    {_view, html} = live_ok!(conn, "#{index}?#{date_qs}")
    assert html =~ "Welcome ticket"
    refute html =~ "High priority"

    {view, html} = live_ok!(conn, "#{index}?#{qs}")
    assert html =~ "Clear all"

    view
    |> element("button", "Clear all")
    |> render_click()

    assert_patch(view, index)
  end

  test "out of range page clamps to last page", %{conn: conn} do
    index = ~p"/admin/tickets"
    assert {:error, {kind, %{to: to}}} = live(conn, "#{index}?page=999")
    assert kind in [:live_redirect, :live_patch]
    assert to == "#{index}?page=2"
  end

  test "bulk delete removes selected tickets", %{conn: conn} do
    {view, html} = live_ok!(conn, ~p"/admin/tickets")
    assert html =~ "Welcome ticket"

    id =
      html
      |> then(&Regex.run(~r/tickets-table-select-(\d+)/, &1))
      |> List.last()

    view
    |> render_click("select", %{"id" => "tickets-table-select-#{id}", "checked" => true})

    html = render_click(view, "bulk_delete")
    refute html =~ "Welcome ticket"
  end

  test "save and continue stays on the edit form", %{conn: conn} do
    conn = init_test_session(conn, %{"admin_demo_id" => "save-continue"})
    {view, _html} = live_ok!(conn, ~p"/admin/tickets/new")

    {view, html} =
      view
      |> form("#tickets-form", %{
        "ticket" => %{
          "title" => "Keep editing",
          "email" => "keep@example.test",
          "status" => "open",
          "priority" => "2"
        }
      })
      |> render_submit(%{"continue" => "true"})
      |> follow_redirect(conn)
      |> unwrap_live_redirect!()

    assert html =~ "Keep editing"
    assert html =~ "Save and continue"
    assert render(view) =~ ~s(id="tickets-form")
  end

  test "new ticket form includes nested social links", %{conn: conn} do
    conn = init_test_session(conn, %{"admin_demo_id" => "nested-fields"})
    {_view, html} = live_ok!(conn, ~p"/admin/tickets/new")

    assert html =~ "Social links"
    assert html =~ ~s(data-scope="nested-fields")
    refute html =~ "max-w-3xl"
  end

  test "edit and show render nested social links", %{conn: conn} do
    conn = init_test_session(conn, %{"admin_demo_id" => "nested-fields-edit"})

    {:ok, ticket} =
      AdminDemo.create_ticket(%Scope{demo_id: "nested-fields-edit"}, %{
        "title" => "With links",
        "email" => "links@example.test",
        "status" => "open",
        "priority" => 1,
        "social_links" => [
          %{"label" => "Docs", "url" => "https://example.test/docs", "preferred" => true}
        ]
      })

    {_view, html} = live_ok!(conn, ~p"/admin/tickets/#{ticket.id}/edit")
    assert html =~ "Social links"
    assert html =~ "Docs"
    assert html =~ ~s(name="ticket[social_links][0][label]")
    refute html =~ "max-w-3xl"

    {_view, html} = live_ok!(conn, ~p"/admin/tickets/#{ticket.id}")
    assert html =~ "Docs"
    assert html =~ "https://example.test/docs"
    refute html =~ "max-w-3xl"
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
