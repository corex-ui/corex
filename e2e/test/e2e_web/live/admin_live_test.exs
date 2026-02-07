defmodule E2eWeb.AdminLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest
  import E2e.AccountsFixtures

  @create_attrs %{name: "some name", country: "fra", birth_date: "1990-01-15", terms: true}
  @update_attrs %{
    name: "some updated name",
    country: "deu",
    birth_date: "1995-06-20",
    terms: true
  }
  @invalid_attrs %{name: "", country: "", birth_date: nil, terms: false}
  # On edit form, country select only allows current value ("fra"); keep it to trigger "can't be blank" on name only
  @invalid_attrs_edit %{name: "", country: "fra", birth_date: "1990-01-15", terms: false}

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
             |> form("#admin", admin: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      # Send validate with country so server updates form; then submit passes hidden-input check
      form_live
      |> render_change("validate", %{"admin" => @create_attrs})

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
             |> form("#admin", admin: @invalid_attrs_edit)
             |> render_change() =~ "can&#39;t be blank"

      # Send validate with country "deu" so server updates form; then submit passes hidden-input check
      form_live
      |> render_change("validate", %{"admin" => @update_attrs})

      assert {:ok, index_live, _html} =
               form_live
               |> form("#admin", admin: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/admins")

      html = render(index_live)
      assert html =~ "Admin updated successfully"
      assert html =~ "some updated name"
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
             |> form("#admin", admin: @invalid_attrs_edit)
             |> render_change() =~ "can&#39;t be blank"

      # Send validate with country "deu" so server updates form; then submit passes hidden-input check
      form_live
      |> render_change("validate", %{"admin" => @update_attrs})

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
