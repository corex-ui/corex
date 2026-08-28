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
    refute html =~ "Session-scoped"
    refute html =~ "/admins"
    assert html =~ ~s(aria-label="Admin")
    assert length(Regex.scan(~r/aria-label="Admin"/, html)) == 1
  end

  test "index lists scoped tickets without textarea body", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/admin/tickets")
    assert html =~ "Broken login"
    assert html =~ "Open only"
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
    assert html =~ "admin-filter-bar"
    assert html =~ "Add filter"
    assert html =~ "Filters"
    assert html =~ ~s(data-part="control-inputs")
    assert html =~ ~s(data-range)
    refute html =~ ~s(type="date")
    assert html =~ "admin-footer"
    assert html =~ ~s(id="tickets-page-size")
    refute html =~ "admin-table-toolbar"
    refute html =~ "flex-nowrap"
    assert html =~ "Select all"
    assert html =~ "0 selected"
    assert html =~ ~s(id="tickets-bulk-delete")
    assert html =~ ~s(class="admin-command-bar")
    assert html =~ ~s(class="admin-command-selection")
    assert html =~ "admin-command-actions"
    assert html =~ ~s(class="admin-muted admin-table-bar-count")
    refute html =~ ~s(class="admin-table-bar")
    assert html =~ ~s(class="admin-command-search-form")
    assert html =~ "admin-command-search"
    assert html =~ "Show"
    assert html =~ ~s(class="sr-only")
    assert html =~ ~s(aria-label="Edit")
    refute html =~ "admin-row-menu"
    refute html =~ "tickets-command-select-all"
    refute html =~ ~r/id="tickets-page-size"[^>]*data-controlled/
    refute html =~ ~r/id="tickets-filter-status"[^>]*data-controlled/
    refute html =~ ~s(data-value="tickets")
    refute html =~ "All Tickets"
    refute html =~ ~s(data-to="/admin/tickets/new")
    assert html =~ ~s(data-to="/admin")
    assert html =~ ~s(data-to="/admin/tickets")
    assert html =~ ~s(data-value="/admin/tickets")
    assert html =~ ~s(placeholder="Search Tickets")
    refute html =~ "admin-filter-search"
    assert html =~ "native-input ui-size-sm"
    assert html =~ "ui-solid ui-brand"
    assert html =~ "ui-ghost ui-alert"
    assert html =~ "Today"
    assert html =~ "Yesterday"
    assert html =~ "Last 7 days"
    assert html =~ "Last 30 days"
    assert html =~ "Last 90 days"
    assert html =~ "This week"
    assert html =~ "This month"
    assert html =~ "This quarter"
    assert html =~ "YTD"
    assert html =~ ~r/id="tickets-filter-status"[^>]*phx-hook="Select"/
    refute html =~ ~r/id="tickets-filter-status"[^>]*phx-hook="ToggleGroup"/
    refute html =~ ~s(id="tickets-filter-status-op")
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

  test "sidebar tree uses index paths without a server nav event", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/admin")
    assert html =~ ~s(data-value="/admin")
    assert html =~ ~s(data-to="/admin/tickets")
    refute html =~ "All Tickets"
    refute html =~ ~s(data-on-selection-change="nav")

    {:ok, _view, html} = live(conn, "/admin/tickets")
    assert html =~ "Broken login"
    assert html =~ ~s(data-value="/admin/tickets")
  end

  test "show selects the matching resource leaf", %{
    conn: conn,
    ticket: ticket
  } do
    {:ok, _view, html} = live(conn, "/admin/tickets/#{ticket.id}")
    assert html =~ "Broken login"
    assert html =~ ~s(data-to="/admin/tickets")
    assert html =~ ~s(data-current)
    assert html =~ ~s(data-default-selected-value="[&quot;/admin/tickets&quot;]")
    refute html =~ ~s(data-default-selected-value="[&quot;/admin/tickets/#{ticket.id}&quot;]")
    refute html =~ "All Tickets"
    refute html =~ ~s(data-on-selection-change="nav")
  end

  test "new and edit select the matching resource leaf", %{conn: conn, ticket: ticket} do
    {:ok, _view, html} = live(conn, "/admin/tickets/new")
    assert html =~ ~s(data-to="/admin/tickets")
    assert html =~ ~s(data-default-selected-value="[&quot;/admin/tickets&quot;]")
    refute html =~ ~s(data-default-selected-value="[&quot;/admin/tickets/new&quot;]")

    {:ok, _view, html} = live(conn, "/admin/tickets/#{ticket.id}/edit")
    assert html =~ ~s(data-default-selected-value="[&quot;/admin/tickets&quot;]")

    refute html =~
             ~s(data-default-selected-value="[&quot;/admin/tickets/#{ticket.id}/edit&quot;]")
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

  test "add filter menu reveals an unpinned text filter", %{conn: conn} do
    {:ok, view, html} = live(conn, "/admin/tickets")
    refute html =~ ~s(id="tickets-filter-email")

    html = render_click(view, "add_filter", %{"value" => "email"})
    assert html =~ ~s(id="tickets-filter-email")
    assert html =~ "Email"
    assert html =~ "Contains"
    assert html =~ "Starts with"

    html = render_click(view, "add_filter", %{"value" => "id"})
    assert html =~ ~s(id="tickets-filter-id")

    html = render_click(view, "add_filter", %{"value" => "created"})
    assert html =~ ~s(id="tickets-filter-created")
    assert html =~ "Yesterday"
  end

  test "saved view toggle patches list params", %{conn: conn, scope: scope} do
    Tickets.create_ticket(scope, %{
      "title" => "Done ticket",
      "email" => "done@example.test",
      "status" => "done",
      "priority" => 4
    })

    {:ok, view, html} = live(conn, "/admin/tickets")
    assert html =~ "Open only"
    assert html =~ "Done ticket"

    html = render_click(view, "canned_filter", %{"index" => "0"})
    assert html =~ "Broken login"
    refute html =~ "Done ticket"
    assert html =~ "Status: open"
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

  test "date presets patch from/to ISO dates", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/admin/tickets")
    today = Date.utc_today()
    from = Date.add(today, -6)

    view
    |> element(~s(button[phx-click="filter_preset"][phx-value-preset="last_7"]))
    |> render_click()

    qs =
      Plug.Conn.Query.encode(%{
        "filters" => %{
          "inserted_at" => %{"from" => Date.to_iso8601(from), "to" => Date.to_iso8601(today)}
        }
      })

    assert_patch(view, "/admin/tickets?" <> qs)
  end

  test "clear all restores default filter params", %{conn: conn} do
    {:ok, view, html} = live(conn, "/admin/tickets?filters[status][]=open")
    assert html =~ "Clear all"
    refute html =~ "Reset all"

    view
    |> element("button", "Clear all")
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

  test "unknown resource is not routed", %{conn: conn} do
    conn = get(conn, "/admin/not-a-resource")
    assert conn.status == 404
  end

  test "show history tab reads the adapter", %{conn: conn, ticket: ticket} do
    {:ok, _view, html} = live(conn, "/admin/tickets/#{ticket.id}")
    assert html =~ "History"
    assert html =~ "ops@example.test"
    assert html =~ "Broken login"
  end

  test "index offers export picker with field names", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/admin/tickets")
    assert html =~ "Export"
    assert html =~ ~s(id="tickets-export")
    assert html =~ "CSV"
    assert html =~ ~s(name="fields[]")
    assert html =~ ~s(value="title")
    assert html =~ ~s(value="email")
    refute html =~ ~r/name="fields\[\]"[^>]*value="true"/
    refute html =~ ~r/name="fields\[\]"[^>]*value="false"/
    assert html =~ ~s(id="tickets-export-form")
  end

  test "export controller streams csv from dialog field names", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/admin/tickets")
    [_, token] = Regex.run(~r/name="token"[^>]*value="([^"]+)"/, html)

    fields =
      ~r/name="fields\[\]"[^>]*value="([^"]+)"/
      |> Regex.scan(html)
      |> Enum.map(&List.last/1)

    assert "title" in fields
    assert "email" in fields
    refute "true" in fields
    refute "false" in fields

    conn =
      conn
      |> Plug.Conn.put_private(:plug_skip_csrf_protection, true)
      |> post("/admin/tickets/export", %{
        "token" => token,
        "format" => "csv",
        "fields" => fields
      })

    assert conn.status == 200
    assert conn.resp_body =~ "Title"
    assert conn.resp_body =~ "Broken login"
  end

  test "export controller streams json", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/admin/tickets")
    [_, token] = Regex.run(~r/name="token"[^>]*value="([^"]+)"/, html)

    conn =
      conn
      |> Plug.Conn.put_private(:plug_skip_csrf_protection, true)
      |> post("/admin/tickets/export", %{
        "token" => token,
        "format" => "json",
        "fields" => ["title"]
      })

    assert conn.status == 200
    assert conn.resp_body =~ "Broken login"
    assert Jason.decode!(conn.resp_body)
  end
end
