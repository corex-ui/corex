defmodule E2eWeb.UserControllerTest do
  use E2eWeb.ConnCase

  import E2e.AccountsFixtures

  @create_attrs %{
    name: "some name",
    country: "some country",
    birth_date: "1990-01-15",
    signature: "/path/to/signature.png",
    terms: true,
    level: 5,
    currency: "eur",
    tags: ["alpha", "beta"]
  }
  @update_attrs %{
    name: "some updated name",
    country: "some updated country",
    birth_date: "1995-06-20",
    signature: "/path/to/updated-signature.png",
    terms: true,
    level: 3,
    currency: "usd",
    tags: ["gamma", "delta"]
  }
  @invalid_attrs %{
    name: nil,
    country: nil,
    birth_date: nil,
    signature: nil,
    terms: nil,
    level: nil,
    currency: nil,
    tags: nil
  }

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, ~p"/users")
      assert html_response(conn, 200) =~ "Listing Users"
    end
  end

  describe "new user" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/users/new")
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "create user" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/users", user: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/users/#{id}"

      conn = get(conn, ~p"/users/#{id}")
      assert html_response(conn, 200) =~ "User #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/users", user: @invalid_attrs)
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "edit user" do
    setup [:create_user]

    test "renders form for editing chosen user", %{conn: conn, user: user} do
      conn = get(conn, ~p"/users/#{user}/edit")
      html = html_response(conn, 200)

      assert html =~ "Edit User"
      assert html =~ "role=\"alertdialog\""
      assert html =~ "user-delete-#{user.id}"
    end
  end

  describe "update user" do
    setup [:create_user]

    test "redirects when data is valid", %{conn: conn, user: user} do
      conn = put(conn, ~p"/users/#{user}", user: @update_attrs)
      assert redirected_to(conn) == ~p"/users/#{user}"

      conn = get(conn, ~p"/users/#{user}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, ~p"/users/#{user}", user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "show user" do
    setup [:create_user]

    test "renders show page with delete dialog", %{conn: conn, user: user} do
      conn = get(conn, ~p"/users/#{user}")
      html = html_response(conn, 200)

      assert html =~ "User #{user.id}"
      assert html =~ "role=\"alertdialog\""
      assert html =~ "user-delete-#{user.id}"
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, ~p"/users/#{user}")
      assert redirected_to(conn) == ~p"/users"

      assert_error_sent 404, fn ->
        get(conn, ~p"/users/#{user}")
      end
    end
  end

  defp create_user(_) do
    user = user_fixture()

    %{user: user}
  end
end
