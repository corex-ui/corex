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

  test "index lists scoped tickets", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/admin/tickets")
    assert html =~ "Broken login"
    refute html =~ "password"
  end

  test "show hides redacted fields", %{conn: conn, ticket: ticket} do
    {:ok, _view, html} = live(conn, "/admin/tickets/#{ticket.id}")
    assert html =~ "Broken login"
    refute html =~ "Secret"
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

  test "denies viewers", %{conn: conn} do
    conn =
      Plug.Test.init_test_session(conn, %{"admin_demo_id" => "live-demo", "role" => "viewer"})

    {:error, {:live_redirect, %{to: "/admin"}}} = live(conn, "/admin/tickets")
  end

  test "unknown resource redirects", %{conn: conn} do
    {:error, {:live_redirect, %{to: "/admin"}}} = live(conn, "/admin/not-a-resource")
  end
end
