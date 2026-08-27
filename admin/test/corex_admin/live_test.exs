defmodule CorexAdmin.LiveTest do
  use CorexAdmin.ConnCase, async: false

  alias CorexAdmin.Test.Tickets

  setup %{conn: conn} do
    conn = Plug.Test.init_test_session(conn, %{"admin_demo_id" => "live-demo", "role" => "admin"})
    scope = %{demo_id: "live-demo", role: :admin}

    {:ok, ticket} =
      Tickets.create_ticket(scope, %{
        "title" => "Broken login",
        "email" => "ops@example.test",
        "status" => "open",
        "priority" => 2
      })

    {:ok, conn: conn, ticket: ticket, scope: scope}
  end

  test "home lists authorized resources", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/admin")
    assert html =~ "Tickets"
    assert html =~ "Support"
    assert html =~ ~s(aria-label="Admin")
    assert length(Regex.scan(~r/aria-label="Admin"/, html)) == 1
  end

  test "index lists scoped tickets without textarea body", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/admin/tickets")
    assert html =~ "Broken login"
    refute html =~ "password"
    assert html =~ "Per page"
    assert html =~ "Showing 1–1 of 1"
    refute html =~ "Synthetic"
    refute html =~ "max-w-3xl"
    refute html =~ "rounded-md border border-border p-space"
    assert html =~ ~s(data-part="sort-icon")
    refute html =~ ~s(aria-label="Breadcrumb")
    refute html =~ "grid-cols-1 items-center"
    assert html =~ ~s(id="tickets-filters")
    assert html =~ "Filters"
    assert html =~ ~s(data-part="control-inputs")
    assert html =~ ~s(data-range)
    refute html =~ ~s(type="date")
    assert html =~ "admin-footer"
    refute html =~ "flex-nowrap"
    assert html =~ "Select all"
    assert html =~ "0 selected"
    assert html =~ ~s(id="tickets-bulk-delete")
    assert html =~ ~s(class="admin-command-bar")
    assert html =~ ~s(id="tickets-page-size")
    assert html =~ ~s(class="admin-table-toolbar")
    assert html =~ "Show"
    assert html =~ ~s(class="sr-only")
    assert html =~ ~s(aria-label="Edit")
    refute html =~ "admin-row-menu"
    refute html =~ "tickets-command-select-all"
    refute html =~ ~r/id="tickets-page-size"[^>]*data-controlled/
    refute html =~ ~r/id="tickets-filter-status"[^>]*data-controlled/
    assert html =~ ~s(data-value="tickets")
    assert html =~ ~s(data-to="/admin")
    assert html =~ ~s(data-to="/admin/tickets")
    assert html =~ "All Tickets"
    assert html =~ "New Tickets"
    assert html =~ ~s(placeholder="Search Tickets")
    assert html =~ "ui-solid ui-brand"
    assert html =~ "hero-bars-3"
  end

  test "selecting a row shows the selected count", %{conn: conn, ticket: ticket, scope: scope} do
    Tickets.create_ticket(scope, %{
      "title" => "Other ticket",
      "email" => "other@example.test",
      "status" => "done",
      "priority" => 1
    })

    {:ok, view, _html} = live(conn, "/admin/tickets")

    html =
      view
      |> render_click("select", %{"id" => "tickets-table-select-#{ticket.id}", "checked" => true})

    assert html =~ "1 selected"
    assert html =~ ~s(id="tickets-bulk-delete")

    html =
      render_click(view, "select_all", %{
        "checked" => false,
        "id" => "tickets-table-select-all"
      })

    assert html =~ "1 selected"
  end

  test "sidebar nav live-redirects to a resource", %{conn: conn} do
    {:ok, view, html} = live(conn, "/admin")
    assert html =~ ~s(data-value="/admin")
    assert html =~ ~s(data-to="/admin/tickets")
    assert html =~ "All Tickets"

    {:ok, _view, html} =
      view
      |> render_click("nav", %{"selectedValue" => ["/admin/tickets"], "isItem" => true})
      |> follow_redirect(conn)

    assert html =~ "Broken login"
  end

  test "sidebar nav live-redirects from show back to the resource index", %{
    conn: conn,
    ticket: ticket
  } do
    {:ok, view, html} = live(conn, "/admin/tickets/#{ticket.id}")
    assert html =~ "Broken login"
    assert html =~ ~s(data-to="/admin/tickets")

    {:ok, _view, html} =
      view
      |> render_click("nav", %{"selectedValue" => ["/admin/tickets"], "isItem" => true})
      |> follow_redirect(conn)

    assert html =~ "Broken login"
    assert html =~ ~s(class="admin-command-bar")
    assert html =~ "All Tickets"
  end

  test "search filters tickets", %{conn: conn, scope: scope} do
    Tickets.create_ticket(scope, %{
      "title" => "Other ticket",
      "email" => "other@example.test",
      "status" => "done",
      "priority" => 1
    })

    {:ok, view, _html} = live(conn, "/admin/tickets")

    html =
      view
      |> element("#tickets-search")
      |> render_change(%{"q" => "Broken"})

    assert html =~ "Broken login"
    refute html =~ "Other ticket"
  end

  test "page size select patches query string", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/admin/tickets")

    render_hook(view, "page_size", %{"id" => "tickets-page-size", "value" => ["10"]})

    assert_patch(view, "/admin/tickets?page_size=10")
  end

  test "out of range page clamps to last page", %{conn: conn} do
    assert {:error, {kind, %{to: "/admin/tickets"}}} =
             live(conn, "/admin/tickets?page=999")

    assert kind in [:live_redirect, :live_patch]
  end

  test "status multi-select and date range via URL", %{conn: conn, scope: scope, ticket: ticket} do
    Tickets.create_ticket(scope, %{
      "title" => "Done ticket",
      "email" => "done@example.test",
      "status" => "done",
      "priority" => 4
    })

    {:ok, _view, html} = live(conn, "/admin/tickets?filters[status][]=open")
    assert html =~ "Broken login"
    refute html =~ "Done ticket"
    assert html =~ "Status: open"
    assert html =~ "ui-trigger--square"

    today = Date.utc_today() |> Date.to_iso8601()

    qs =
      Plug.Conn.Query.encode(%{
        "filters" => %{"inserted_at" => %{"from" => today, "to" => today}}
      })

    {:ok, _view, html} = live(conn, "/admin/tickets?" <> qs)
    assert html =~ ticket.title
  end

  test "date range value_change waits for both dates", %{conn: conn, ticket: ticket} do
    {:ok, view, _html} = live(conn, "/admin/tickets")
    today = Date.utc_today() |> Date.to_iso8601()

    html =
      render_hook(view, "filter", %{
        "id" => "tickets-filter-inserted_at",
        "value" => today
      })

    refute html =~ "Inserted at:"
    refute_patched(view)

    html =
      render_change(view, "search", %{
        "q" => "",
        "filters" => %{"inserted_at" => [today]}
      })

    refute html =~ "Inserted at:"
    refute_patched(view)

    html =
      render_hook(view, "filter", %{
        "id" => "tickets-filter-inserted_at",
        "value" => "#{today},#{today}"
      })

    assert html =~ ticket.title
    assert html =~ "Inserted at:"

    qs =
      Plug.Conn.Query.encode(%{
        "filters" => %{"inserted_at" => %{"from" => today, "to" => today}}
      })

    assert_patch(view, "/admin/tickets?" <> qs)
  end

  test "reset all restores default filter params", %{conn: conn} do
    {:ok, view, html} = live(conn, "/admin/tickets?filters[status][]=open")
    assert html =~ "Reset all"
    refute html =~ "Clear all"

    view
    |> element("button", "Reset all")
    |> render_click()

    assert_patch(view, "/admin/tickets")
  end

  test "reset filter restores one field", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/admin/tickets?filters[status][]=open")

    view
    |> element(~s(button[phx-click="reset_filter"][phx-value-field="status"]))
    |> render_click()

    assert_patch(view, "/admin/tickets")
  end

  test "chip X clears a filter to any", %{conn: conn} do
    {:ok, view, html} = live(conn, "/admin/tickets?filters[status][]=open")
    assert html =~ "Status: open"

    view
    |> element(~s(button[aria-label="Clear Status"]))
    |> render_click()

    assert_patch(view, "/admin/tickets")
  end

  test "bulk delete removes selected rows", %{conn: conn, ticket: ticket} do
    {:ok, view, _html} = live(conn, "/admin/tickets")

    view
    |> render_click("select", %{"id" => "tickets-table-select-#{ticket.id}", "checked" => true})

    html = render_click(view, "bulk_delete")
    refute html =~ "Broken login"
    assert html =~ "No Tickets yet."
  end

  test "new form uses full-width hosts and tooltip field errors", %{conn: conn} do
    {:ok, view, html} = live(conn, "/admin/tickets/new")
    assert html =~ "admin-form-grid"
    refute html =~ "max-w-none"
    refute html =~ "max-w-3xl"

    html =
      view
      |> form("#tickets-form", %{"ticket" => %{"title" => "", "email" => "", "status" => "open"}})
      |> render_submit()

    assert html =~ ~s(data-scope="tooltip")
    assert html =~ "exclamation-circle"
    assert html =~ "admin-field-error"
  end

  test "show uses title field and hides redacted fields", %{conn: conn, ticket: ticket} do
    {:ok, _view, html} = live(conn, "/admin/tickets/#{ticket.id}")
    assert html =~ "Broken login"
    refute html =~ "Secret"
    assert html =~ ~s(class="data-list ui-size-sm")
    assert html =~ ~s(data-orientation="horizontal")
    assert html =~ "ui-solid ui-alert"
  end

  test "create via context form", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/admin/tickets/new")

    {:ok, _view, html} =
      view
      |> form("#tickets-form", %{
        "ticket" => %{
          "title" => "New ticket",
          "email" => "new@example.test",
          "status" => "open"
        }
      })
      |> render_submit()
      |> follow_redirect(conn)

    assert html =~ "New ticket"
  end

  test "save and continue stays on edit", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/admin/tickets/new")

    {:ok, _view, html} =
      view
      |> form("#tickets-form", %{
        "ticket" => %{
          "title" => "Keep editing",
          "email" => "keep@example.test",
          "status" => "open"
        }
      })
      |> render_submit(%{"continue" => "true"})
      |> follow_redirect(conn)

    assert html =~ "Keep editing"
    assert html =~ "Save and continue"
  end

  test "nested social links round-trip on create", %{conn: conn, scope: scope} do
    {:ok, _view, html} = live(conn, "/admin/tickets/new")
    assert html =~ "Social links"
    assert html =~ ~s(data-scope="nested-fields")
    assert html =~ "Add Social links"

    {:ok, ticket} =
      Tickets.create_ticket(scope, %{
        "title" => "With links",
        "email" => "links@example.test",
        "status" => "open",
        "social_links" => [
          %{"label" => "Docs", "url" => "https://example.test/docs", "preferred" => true}
        ]
      })

    {:ok, _view, html} = live(conn, "/admin/tickets/#{ticket.id}")
    assert html =~ "With links"
    assert html =~ "Docs"
    assert html =~ "https://example.test/docs"
    assert html =~ "Yes"

    {:ok, view, html} = live(conn, "/admin/tickets/#{ticket.id}/edit")
    assert html =~ ~s(name="ticket[social_links_sort][]")
    assert html =~ "Docs"

    html =
      view
      |> form("#tickets-form")
      |> render_change(%{
        "ticket" => %{
          "title" => "With links",
          "email" => "links@example.test",
          "status" => "open",
          "social_links_sort" => ["0", "new"]
        }
      })

    assert html =~ ~s(name="ticket[social_links][1][label]")
  end

  test "denies viewers", %{conn: conn} do
    conn =
      Plug.Test.init_test_session(conn, %{"admin_demo_id" => "live-demo", "role" => "viewer"})

    {:error, {:live_redirect, %{to: "/admin"}}} = live(conn, "/admin/tickets")
  end

  test "unknown resource redirects", %{conn: conn} do
    {:error, {:live_redirect, %{to: "/admin"}}} = live(conn, "/admin/not-a-resource")
  end
end
