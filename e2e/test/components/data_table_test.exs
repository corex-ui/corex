defmodule E2eWeb.DataTableTest do
  use E2eWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  @locale "en"

  describe "data_table with list" do
    test "renders headers and rows", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/#{@locale}/live/data-table")

      assert html =~ "ID"
      assert html =~ "Name"
      assert html =~ "Role"
      assert html =~ "Email"
      assert html =~ "Alice"
      assert html =~ "Bob"
      assert html =~ "Charlie"
      assert html =~ "Admin"
      assert html =~ "User"
      assert html =~ "Editor"
    end

    test "renders action slot", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/#{@locale}/live/data-table")

      assert html =~ ~r/aria-label="Edit Alice"/
      assert html =~ ~r/data-part="actions"/
    end

    test "uses data-table data attributes", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/#{@locale}/live/data-table")

      assert html =~ ~r/data-scope="data-table"/
      assert html =~ ~r/data-part="root"/
    end
  end

  describe "data_table with stream" do
    test "renders streamed rows", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/#{@locale}/live/data-table/stream")

      assert html =~ "Apple"
      assert html =~ "Banana"
      assert html =~ "Carrot"
    end

    test "uses phx-update stream on tbody", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/#{@locale}/live/data-table/stream")

      assert html =~ ~r/id="stream-table"/
      assert html =~ ~r/phx-update="stream"/
    end

    test "renders action slot for stream rows", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/#{@locale}/live/data-table/stream")

      assert html =~ ~r/aria-label="Delete Apple"/
      assert html =~ ~r/aria-label="Delete Banana"/
    end

    test "has row ids for stream", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/#{@locale}/live/data-table/stream")

      assert html =~ ~r/id="items-1"/
      assert html =~ ~r/id="items-2"/
    end
  end
end
