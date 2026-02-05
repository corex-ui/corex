defmodule E2eWeb.AdminLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest
  import E2e.AccountsFixtures

  @create_attrs %{name: "some name", country: "fra", terms: true}
  @update_attrs %{name: "some updated name", country: "deu", terms: true}
  @invalid_attrs %{name: nil, country: nil, terms: true}
  defp create_admin(_) do
    admin = admin_fixture()

    %{admin: admin}
  end

  describe "Index" do
    setup [:create_admin]

    test "lists all admins", %{conn: conn, admin: admin} do
      {:ok, _index_live, html} = live(conn, ~p"/admins")

      assert html =~ "Listing Admins"
      assert html =~ admin.name
    end

    test "saves new admin", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/admins")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Admin")
               |> render_click()
               |> follow_redirect(conn, ~p"/admins/new")

      assert render(form_live) =~ "New Admin"

      assert form_live
             |> form("#admin", admin: Map.put(@invalid_attrs, :country, ""))
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#admin", admin: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/admins")

      html = render(index_live)
      assert html =~ "Admin created successfully"
      assert html =~ "some name"
    end

    test "updates admin in listing", %{conn: conn, admin: admin} do
      {:ok, index_live, _html} = live(conn, ~p"/admins")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#admins-#{admin.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/admins/#{admin}/edit")

      assert render(form_live) =~ "Edit Admin"

      assert form_live
             |> form("#admin", admin: %{name: "", country: admin.country, terms: true})
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#admin", admin: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/admins")

      html = render(index_live)
      assert html =~ "Admin updated successfully"
      assert html =~ "some updated name"
      assert html =~ "deu"
    end

    test "deletes admin in listing", %{conn: conn, admin: admin} do
      {:ok, index_live, _html} = live(conn, ~p"/admins")

      assert index_live |> element("#admins-#{admin.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#admins-#{admin.id}")
    end
  end

  describe "Show" do
    setup [:create_admin]

    test "displays admin", %{conn: conn, admin: admin} do
      {:ok, _show_live, html} = live(conn, ~p"/admins/#{admin}")

      assert html =~ "Show Admin"
      assert html =~ admin.name
    end

    test "updates admin and returns to show", %{conn: conn, admin: admin} do
      {:ok, show_live, _html} = live(conn, ~p"/admins/#{admin}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/admins/#{admin}/edit?return_to=show")

      assert render(form_live) =~ "Edit Admin"

      assert form_live
             |> form("#admin", admin: %{name: "", country: admin.country, terms: true})
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#admin", admin: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/admins/#{admin}")

      html = render(show_live)
      assert html =~ "Admin updated successfully"
      assert html =~ "some updated name"
    end
  end
end
