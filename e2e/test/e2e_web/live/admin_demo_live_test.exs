defmodule E2eWeb.AdminDemoLiveTest do
  use E2eWeb.ConnCase

  alias E2e.AdminDemo
  alias E2e.AdminDemo.Scope

  test "home and tickets index", %{conn: conn} do
    {_view, html} = live_ok!(conn, ~p"/admin")
    assert html =~ "Tickets"
    assert html =~ "Posts"
    assert html =~ "Session-scoped"
    refute html =~ "Back to site"
    refute html =~ "Choose a resource"
    assert html =~ ~s(aria-current="page")
    assert html =~ "Main navigation"

    {_view, html} = live_ok!(conn, ~p"/admin/tickets")
    assert html =~ "Welcome ticket"
    assert html =~ "page=2"
    assert html =~ ~s(id="tickets-filters")
    assert html =~ "Select all"
    assert html =~ "0 selected"
    refute html =~ "tickets-command-select-all"
    assert html =~ ~s(data-value="tickets")
    assert html =~ ~s(data-to="/en/admin")
    assert html =~ ~s(data-to="/en/admin/tickets")
    assert html =~ "All Tickets"
    assert html =~ ~s(placeholder="Search Tickets")
    assert html =~ ~s(class="admin-command-bar")
    assert html =~ ~s(class="admin-table-toolbar")
    assert html =~ ~s(data-part="control-inputs")
    assert html =~ ~s(data-range)
    refute html =~ ~s(type="date")
    refute html =~ ~s(aria-label="Breadcrumb")

    {_view, html} = live_ok!(conn, ~p"/admin/tickets?page=2")
    assert html =~ "Queue ticket"
  end

  test "sidebar nav live-redirects from tickets to posts", %{conn: conn} do
    {view, html} = live_ok!(conn, ~p"/admin/tickets")
    assert html =~ ~s(data-value="posts")
    assert html =~ ~s(data-to="/en/admin/posts")

    {view, html} =
      view
      |> render_click("nav", %{"selectedValue" => ["/en/admin/posts"], "isItem" => true})
      |> follow_redirect(conn)
      |> unwrap_live_redirect!()

    assert html =~ "Welcome post"
    assert has_element?(view, "#posts-filters")
  end

  test "sidebar nav live-redirects from a ticket show back to posts", %{conn: conn} do
    conn = init_test_session(conn, %{"admin_demo_id" => "nav-show-to-posts"})
    {_view, html} = live_ok!(conn, ~p"/admin/tickets")

    id =
      html
      |> then(&Regex.run(~r/tickets-table-select-(\d+)/, &1))
      |> List.last()

    {view, _html} = live_ok!(conn, ~p"/admin/tickets/#{id}")
    assert has_element?(view, ".data-list")
    assert render(view) =~ ~s(data-to="/en/admin/posts")

    {view, html} =
      view
      |> render_click("nav", %{"selectedValue" => ["/en/admin/posts"], "isItem" => true})
      |> follow_redirect(conn)
      |> unwrap_live_redirect!()

    assert html =~ "Welcome post"
    assert has_element?(view, "#posts-filters")
  end

  test "posts index lists seeded rows", %{conn: conn} do
    {_view, html} = live_ok!(conn, ~p"/admin/posts")
    assert html =~ "Welcome post"
    assert html =~ "Draft notes"
    assert html =~ ~s(id="posts-filters")
    assert html =~ ~s(data-state="closed")
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

    render_hook(view, "page_size", %{"id" => "tickets-page-size", "value" => ["10"]})

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
    assert html =~ "Reset all"
    refute html =~ "Clear all"

    view
    |> element("button", "Reset all")
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

  test "selecting a row shows the selected count", %{conn: conn} do
    {view, html} = live_ok!(conn, ~p"/admin/tickets")

    id =
      html
      |> then(&Regex.run(~r/tickets-table-select-(\d+)/, &1))
      |> List.last()

    html =
      view
      |> render_click("select", %{"id" => "tickets-table-select-#{id}", "checked" => true})

    assert html =~ "1 selected"
    assert html =~ ~s(id="tickets-bulk-delete")

    assert html =~
             ~r/id="tickets-table-select-#{Regex.escape(id)}"[^>]*data-checked="true"/

    html =
      render_click(view, "select_all", %{
        "checked" => false,
        "id" => "tickets-table-select-all"
      })

    assert html =~ "1 selected"

    html =
      render_click(view, "select_all", %{
        "checked" => "indeterminate",
        "id" => "tickets-table-select-all"
      })

    assert html =~ "1 selected"

    html = render_click(view, "select_all", %{"checked" => true})
    assert html =~ "25 selected"
    refute html =~ ~s(class="admin-is-disabled")

    html = render_click(view, "select_all", %{"checked" => false})
    assert html =~ "0 selected"
    assert html =~ ~s(class="admin-is-disabled")
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
    assert html =~ ~s(class="data-list ui-size-sm")
    assert html =~ ~s(data-orientation="horizontal")
  end

  test "invalid ticket create shows tooltip field errors", %{conn: conn} do
    conn = init_test_session(conn, %{"admin_demo_id" => "tooltip-errors"})
    {view, html} = live_ok!(conn, ~p"/admin/tickets/new")
    assert html =~ "admin-form-grid"
    refute html =~ "max-w-3xl"

    html =
      view
      |> form("#tickets-form", %{
        "ticket" => %{"title" => "", "email" => "", "status" => "open", "priority" => "1"}
      })
      |> render_submit()

    assert html =~ ~s(data-scope="tooltip")
    assert html =~ "exclamation-circle"
    assert html =~ "admin-field-error"
    refute html =~ ~s(data-part="error">can't be blank)
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
