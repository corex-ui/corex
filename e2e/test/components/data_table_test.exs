defmodule E2eWeb.DataTableTest do
  use E2eWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "data_table with list" do
    test "renders headers and rows", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/data-table/patterns")

      assert html =~ "ID"
      assert html =~ "Name"
      assert html =~ "Role"
      assert html =~ "Email"
      assert html =~ "Alice"
      assert html =~ "Bob"
      assert html =~ "Charlie"
      assert html =~ "Admin"
      assert html =~ "User"
      assert html =~ "Manager"
    end

    test "renders action slot", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/data-table/patterns")

      assert html =~ ~r/data-part="actions"/
      assert html =~ "hero-pencil-square"
    end

    test "uses data-table data attributes", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/data-table/patterns")

      assert html =~ ~r/data-scope="data-table"/
      assert html =~ ~r/data-part="root"/
    end

    test "keeps :empty slot markup in the DOM when rows are present; hides via data-table CSS", %{
      conn: conn
    } do
      {:ok, _view, html} = live(conn, ~p"/data-table/patterns")

      assert html =~ "pattern-full-empty"
      assert html =~ "Alice"
    end

    test "renders :empty slot when list rows are empty on anatomy page", %{conn: conn} do
      conn = get(conn, ~p"/data-table/anatomy")
      html = html_response(conn, 200)

      assert html =~ "data-table-anatomy-empty-msg"
      assert html =~ ~r/data-part="empty"/
    end
  end

  describe "data_table with stream" do
    test "renders streamed rows", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/data-table/patterns")

      assert html =~ "Apple"
      assert html =~ "Banana"
      assert html =~ "Carrot"
    end

    test "uses phx-update stream on tbody", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/data-table/patterns")

      assert html =~ ~r/id="pattern-stream-table"/
      assert html =~ ~r/phx-update="stream"/
    end

    test "renders action slot for stream rows", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/data-table/patterns")

      assert html =~ ~r/data-part="actions"/
      assert html =~ "hero-trash"
    end

    test "has row ids for stream", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/data-table/patterns")

      assert html =~ ~r/id="pattern_stream-1"/
      assert html =~ ~r/id="pattern_stream-2"/
    end

    test "keeps :empty slot markup alongside streamed rows; hides via data-table CSS", %{
      conn: conn
    } do
      {:ok, _view, html} = live(conn, ~p"/data-table/patterns")

      assert html =~ "pattern-stream-empty"
      assert html =~ "Apple"
    end
  end

  describe "data_table database patterns" do
    test "renders database-backed table and pagination", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/data-table/patterns")

      assert html =~ "pattern-db-table"
      assert html =~ "pattern-db-pagination"
      assert html =~ ~r/data-part="sort-trigger"/
    end
  end

  describe "data_table flop patterns" do
    test "renders flop-backed table and pagination", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/data-table/patterns")

      assert html =~ "pattern-flop-table"
      assert html =~ "pattern-flop-pagination"
    end

    test "loads sorted cities from flop query params", %{conn: conn} do
      {:ok, _view, html} =
        live(
          conn,
          ~p"/data-table/patterns?#{%{order_by: ["name"], order_directions: ["desc"], page: 1}}"
        )

      assert html =~ "pattern-flop-table"
      assert html =~ "Paris"
    end
  end
end
