defmodule E2eWeb.AdminDemoLiveTest do
  use E2eWeb.ConnCase

  alias E2e.AdminDemo
  alias E2e.AdminDemo.Scope

  @seeded_ticket "Password reset email never arrives"
  @seeded_post "Shipping Corex Admin"
  @ticket_count 30

  test "home and tickets index", %{conn: conn} do
    {_view, html} = live_ok!(conn, ~p"/admin")
    assert html =~ "Tickets"
    assert html =~ "Posts"
    assert html =~ "Authors"
    assert html =~ ~S(data-scope="admin")
    assert html =~ "admin-main"
    assert html =~ "max-w-7xl"
    assert html =~ "px-space-xl py-size"
    refute html =~ "Choose a resource"
    assert html =~ ~S(aria-current="page")
    assert html =~ "Main navigation"

    {_view, html} = live_ok!(conn, ~p"/admin/tickets")
    assert html =~ @seeded_ticket
    assert html =~ "admin-main"
    assert html =~ "admin-content"
    assert html =~ "page=2"
    assert html =~ ~S(id="tickets-filters")
    assert html =~ "Add filter"
    assert html =~ "admin-filter-bar"
    assert html =~ ~r/id="tickets-views"[^>]*phx-hook="Select"/
    assert html =~ "Select all"
    assert html =~ "0 selected"
    assert html =~ ~S(data-to="/en/admin)
    assert html =~ ~S(placeholder="Search Tickets")
    assert html =~ ~S(class="admin-command-bar")
    assert html =~ ~S(class="admin-command-selection")
    assert html =~ "admin-command-actions"
    assert html =~ ~S(id="tickets-page-size")
    refute html =~ ~S(aria-label="Breadcrumb")
    assert html =~ ~r/id="tickets-filter-status"[^>]*phx-hook="Select"/

    {_view, html} = live_ok!(conn, ~p"/admin/tickets?page=2")
    assert html =~ "report"
  end

  test "index shows metric cards computed by the context", %{conn: conn} do
    {_view, html} = live_ok!(conn, ~p"/admin/tickets")

    assert html =~ "admin-metrics"
    assert html =~ "All tickets"
    assert html =~ "waiting on us"
    assert html =~ "waiting on customer"
  end

  test "range filters use a compact trigger and their own dialog", %{conn: conn} do
    {_view, html} = live_ok!(conn, ~p"/admin/tickets")

    assert html =~ "admin-filter-summary"
    assert html =~ ~S(id="tickets-range-priority")
    assert html =~ ~S(id="tickets-range-due_on")
    assert html =~ "admin-dialog--scroll"
    assert html =~ "Last 7 days"

    # The date picker lives in the dialog, not on the filter row.
    assert html =~ ~S(id="tickets-range-filter-due_on")
    refute html =~ ~S(id="tickets-filter-due_on")
  end

  test "priority slider bounds come from the seeded data", %{conn: conn} do
    {_view, html} = live_ok!(conn, ~p"/admin/tickets")
    assert html =~ ~S(id="tickets-range-filter-priority-slider")

    AdminDemo.Seed.ensure_seeded("priority-bounds")
    assert %{min: 1, max: 5} = AdminDemo.ticket_priority_bounds(%Scope{demo_id: "priority-bounds"})

    # An empty queue offers no range at all rather than a slider that matches nothing.
    assert AdminDemo.ticket_priority_bounds(%Scope{demo_id: "no-such-demo"}) == nil
  end

  test "a filter can reach through an association", %{conn: conn} do
    qs = Plug.Conn.Query.encode(%{"filters" => %{"assignee_name" => "Ada"}})
    {_view, html} = live_ok!(conn, "#{~p"/admin/tickets"}?#{qs}")

    assert html =~ "Ada Okonkwo"
    refute html =~ "Grace Lindqvist"
  end

  test "sidebar tree uses index paths from tickets and from show", %{conn: conn} do
    {_view, html} = live_ok!(conn, ~p"/admin/tickets")
    assert html =~ ~S(data-value="/en/admin/posts")
    assert html =~ ~S(data-to="/en/admin/posts")
    refute html =~ ~S(data-value="posts")

    conn = init_test_session(conn, %{"admin_demo_id" => "nav-show-to-posts"})
    {_view, html} = live_ok!(conn, ~p"/admin/tickets")

    id = html |> then(&Regex.run(~r/tickets-table-select-(\d+)/, &1)) |> List.last()

    {view, html} = live_ok!(conn, ~p"/admin/tickets/#{id}")
    assert has_element?(view, ".admin-details")
    assert html =~ ~S(data-to="/en/admin/posts")
    assert html =~ ~S(data-current)

    [_, selected] =
      Regex.run(~r/id="admin-nav-tree"[^>]*data-default-selected-value="([^"]*)"/, html)

    assert selected == "[&quot;/en/admin/tickets&quot;]"
  end

  test "posts index lists seeded rows with author and status badge", %{conn: conn} do
    {_view, html} = live_ok!(conn, ~p"/admin/posts")
    assert html =~ @seeded_post
    assert html =~ "admin-main"
    assert html =~ ~S(id="posts-filters")
    assert html =~ "Ada Okonkwo"
    assert html =~ "badge ui-size-sm ui-success"
    assert html =~ "Scheduled"
  end

  test "authors index shows a computed post count", %{conn: conn} do
    {_view, html} = live_ok!(conn, ~p"/admin/authors")

    assert html =~ "Ada Okonkwo"
    assert html =~ "Posts"
    assert html =~ "admin-metrics"
  end

  test "author show lists related posts", %{conn: conn} do
    scope = %Scope{demo_id: "author-related"}
    conn = init_test_session(conn, %{"admin_demo_id" => "author-related"})
    {_view, html} = live_ok!(conn, ~p"/admin/authors")

    id = html |> then(&Regex.run(~r/authors-table-select-(\d+)/, &1)) |> List.last()
    author = AdminDemo.get_author!(scope, id)

    {_view, html} = live_ok!(conn, ~p"/admin/authors/#{id}")

    assert html =~ author.name
    assert html =~ "Recent posts"
    assert Enum.any?(author.posts, fn post -> html =~ post.title end)

    # The relation renders as its own panel, not also as a detail row.
    refute html =~ ~s(<dt class="admin-detail-label">Recent posts</dt>)
  end

  test "a datetime range filter narrows posts by published window", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/admin/posts")

    from = DateTime.utc_now() |> DateTime.add(-2, :day) |> Calendar.strftime("%Y-%m-%dT%H:%M")
    to = DateTime.utc_now() |> Calendar.strftime("%Y-%m-%dT%H:%M")

    view
    |> form("#posts-range-filter-published_at-form")
    |> render_change(%{"filters" => %{"published_at" => %{"from" => from, "to" => to}}})

    assert_patch(view)
    assert render(view) =~ "Showing"
  end

  test "search filters tickets", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/admin/tickets")

    html =
      view
      |> element("#tickets-search")
      |> render_change(%{"q" => "Webhook retries"})

    assert html =~ "Webhook retries are duplicated"
    refute html =~ "Password reset email never arrives"
  end

  test "page size select patches query string", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/admin/tickets")

    render_hook(view, "page_size", %{"id" => "tickets-page-size", "value" => ["10"]})

    assert_patch(view, ~p"/admin/tickets?page_size=10")
    assert render(view) =~ "Showing 1–10 of #{@ticket_count}"
  end

  test "status multi-select and clear all", %{conn: conn} do
    index = ~p"/admin/tickets"
    qs = Plug.Conn.Query.encode(%{"filters" => %{"status" => ["done"]}})

    {view, html} = live_ok!(conn, "#{index}?#{qs}")
    assert html =~ "Clear all"

    view |> element("#tickets-clear-filters") |> render_click()
    assert_patch(view, index)
  end

  test "out of range page clamps to last page", %{conn: conn} do
    index = ~p"/admin/tickets"
    assert {:error, {kind, %{to: to}}} = live(conn, "#{index}?page=999")
    assert kind in [:live_redirect, :live_patch]
    assert to == "#{index}?page=2"
  end

  test "bulk delete removes selected tickets", %{conn: conn} do
    conn = init_test_session(conn, %{"admin_demo_id" => "bulk-delete-demo"})
    {view, html} = live_ok!(conn, ~p"/admin/tickets")

    id = html |> then(&Regex.run(~r/tickets-table-select-(\d+)/, &1)) |> List.last()
    title = ticket_title(html, id)

    view |> render_click("select", %{"id" => "tickets-table-select-#{id}", "checked" => true})

    html = render_click(view, "bulk_delete")
    refute html =~ title
  end

  test "a bulk action with a form moves the selection", %{conn: conn} do
    conn = init_test_session(conn, %{"admin_demo_id" => "bulk-status-demo"})
    {view, html} = live_ok!(conn, ~p"/admin/tickets")

    assert html =~ "Set status"
    assert html =~ ~S(id="tickets-action-set_status")
    assert html =~ ~S(name="payload[status]")

    id = html |> then(&Regex.run(~r/tickets-table-select-(\d+)/, &1)) |> List.last()
    view |> render_click("select", %{"id" => "tickets-table-select-#{id}", "checked" => true})

    view
    |> form("#tickets-action-set_status-form", %{
      "name" => "set_status",
      "payload" => %{"status" => "done"}
    })
    |> render_submit()

    ticket = AdminDemo.get_ticket!(%Scope{demo_id: "bulk-status-demo"}, id)
    assert ticket.status == "done"
  end

  test "selecting a row shows the selected count", %{conn: conn} do
    {view, html} = live_ok!(conn, ~p"/admin/tickets")

    id = html |> then(&Regex.run(~r/tickets-table-select-(\d+)/, &1)) |> List.last()

    html =
      view
      |> render_click("select", %{"id" => "tickets-table-select-#{id}", "checked" => true})

    assert html =~ "1 selected"
    assert html =~ ~S(id="tickets-bulk-delete")
    assert html =~ ~r/id="tickets-table-select-#{Regex.escape(id)}"[^>]*data-checked="true"/

    html = render_click(view, "select_all", %{"checked" => true})
    assert html =~ "25 selected"

    html = render_click(view, "select_all", %{"checked" => false})
    assert html =~ "0 selected"
    assert html =~ "admin-is-disabled"
  end

  test "create and add another returns to a blank form", %{conn: conn} do
    conn = init_test_session(conn, %{"admin_demo_id" => "create-another"})
    {view, _html} = live_ok!(conn, ~p"/admin/tickets/new")

    {_view, html} =
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

    assert html =~ "Create and add another"
    refute html =~ "Keep editing"
  end

  test "edit offers Save and Save and close", %{conn: conn} do
    conn = init_test_session(conn, %{"admin_demo_id" => "edit-actions"})
    {_view, html} = live_ok!(conn, ~p"/admin/tickets")
    id = html |> then(&Regex.run(~r/tickets-table-select-(\d+)/, &1)) |> List.last()

    {_view, html} = live_ok!(conn, ~p"/admin/tickets/#{id}/edit")
    assert html =~ "Save and close"
    assert html =~ ~S(name="continue")
  end

  test "the assignee picker is fed by the context", %{conn: conn} do
    conn = init_test_session(conn, %{"admin_demo_id" => "assignee-picker"})
    {_view, html} = live_ok!(conn, ~p"/admin/tickets/new")

    assert html =~ "Assignee"
    assert html =~ ~S(name="ticket[assignee_id]")
    assert html =~ "Ada Okonkwo"
    # Inactive authors are excluded by the context query, not by the admin.
    refute html =~ "Tomas Weber"
  end

  test "new ticket form includes nested social links", %{conn: conn} do
    conn = init_test_session(conn, %{"admin_demo_id" => "nested-fields"})
    {_view, html} = live_ok!(conn, ~p"/admin/tickets/new")

    assert html =~ "Social links"
    assert html =~ ~S(data-scope="nested-fields")
    assert html =~ "admin-nested-legend"
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
    assert html =~ ~S(name="ticket[social_links][0][label]")

    {_view, html} = live_ok!(conn, ~p"/admin/tickets/#{ticket.id}")
    assert html =~ "Docs"
    assert html =~ "https://example.test/docs"
    assert html =~ ~S(class="admin-details")
  end

  test "the admin clears extra preferred links before saving" do
    spec = E2eWeb.Admin.TicketResource.__corex_admin_resource__()

    attrs =
      CorexAdmin.Attrs.take_writable(spec, %{
        "title" => "Two preferred",
        "social_links" => %{
          "0" => %{"label" => "A", "url" => "https://a.test", "preferred" => "true"},
          "1" => %{"label" => "B", "url" => "https://b.test", "preferred" => "true"}
        }
      })

    assert attrs["social_links"]["0"]["preferred"] == "false"
    assert attrs["social_links"]["1"]["preferred"] == "true"
  end

  test "the schema also refuses two preferred links" do
    scope = %Scope{demo_id: "exclusive-preferred"}

    assert {:error, changeset} =
             AdminDemo.create_ticket(scope, %{
               "title" => "Two preferred",
               "email" => "two@example.test",
               "status" => "open",
               "priority" => 1,
               "social_links" => [
                 %{"label" => "A", "url" => "https://a.test", "preferred" => true},
                 %{"label" => "B", "url" => "https://b.test", "preferred" => true}
               ]
             })

    assert "only one link can be preferred" in changeset_errors(changeset, :social_links)
  end

  test "invalid ticket create shows tooltip field errors", %{conn: conn} do
    conn = init_test_session(conn, %{"admin_demo_id" => "tooltip-errors"})
    {view, html} = live_ok!(conn, ~p"/admin/tickets/new")
    assert html =~ "admin-form-grid"

    html =
      view
      |> form("#tickets-form", %{
        "ticket" => %{"title" => "", "email" => "", "status" => "open", "priority" => "1"}
      })
      |> render_submit()

    assert html =~ ~S(data-scope="tooltip")
    assert html =~ "exclamation-circle"
    assert html =~ "admin-field-error"
  end

  test "a post scheduled without a date is rejected", %{conn: conn} do
    conn = init_test_session(conn, %{"admin_demo_id" => "post-validation"})
    {view, _html} = live_ok!(conn, ~p"/admin/posts/new")

    html =
      view
      |> form("#posts-form", %{
        "post" => %{"title" => "No date", "slug" => "no-date", "status" => "scheduled"}
      })
      |> render_submit()

    assert html =~ "admin-field-error"
    assert html =~ ~S(data-scope="tooltip")
  end

  test "sessions are isolated", %{conn: conn} do
    conn_a = init_test_session(conn, %{"admin_demo_id" => "demo-a"})
    conn_b = init_test_session(build_conn(), %{"admin_demo_id" => "demo-b"})

    {_view, html_a} = live_ok!(conn_a, ~p"/admin/tickets")
    {_view, html_b} = live_ok!(conn_b, ~p"/admin/tickets")

    assert html_a =~ @seeded_ticket
    assert html_b =~ @seeded_ticket

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

  test "index offers export on every resource", %{conn: conn} do
    for {path, slug} <- [
          {~p"/admin/tickets", "tickets"},
          {~p"/admin/posts", "posts"},
          {~p"/admin/authors", "authors"}
        ] do
      {_view, html} = live_ok!(conn, path)
      assert html =~ "Export"
      assert html =~ ~s(id="#{slug}-export")
    end
  end

  test "Arabic locale translates admin chrome", %{conn: conn} do
    {_view, html} = live_ok!(conn, "/ar/admin/tickets")
    assert html =~ "عوامل التصفية"
    refute html =~ ">Filters<"
  end

  defp ticket_title(html, id) do
    [_, title] = Regex.run(~r/tickets-table-select-#{id}.*?admin-cell[^>]*>([^<]+)</s, html)
    String.trim(title)
  end

  defp changeset_errors(changeset, field) do
    changeset.errors
    |> Enum.filter(fn {key, _} -> key == field end)
    |> Enum.map(fn {_key, {msg, _opts}} -> msg end)
  end
end
