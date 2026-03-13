defmodule E2eWeb.PagesA11yTest do
  use E2eWeb.ConnCase, async: false
  use Wallaby.Feature

  import E2e.AccountsFixtures

  @locale "en"

  @static_pages [
    {"Home", "/#{@locale}"},
    {"Users index", "/#{@locale}/users"},
    {"Users new", "/#{@locale}/users/new"},
    {"Admins index", "/#{@locale}/admins"},
    {"Admins new", "/#{@locale}/admins/new"}
  ]

  for {name, path} <- @static_pages do
    @name name
    @path path

    feature "#{@name} has no A11y violations", %{session: session} do
      session
      |> Wallaby.Browser.visit(@path)
      |> E2eWeb.Model.wait(500)
      |> A11yAudit.Wallaby.assert_no_violations()
    end
  end

  describe "user pages" do
    setup :create_user

    defp create_user(_) do
      %{user: user_fixture()}
    end

    feature "Users show has no A11y violations", %{session: session, user: user} do
      path = "/#{@locale}/users/#{user.id}"

      session
      |> Wallaby.Browser.visit(path)
      |> E2eWeb.Model.wait(500)
      |> A11yAudit.Wallaby.assert_no_violations()
    end

    feature "Users edit has no A11y violations", %{session: session, user: user} do
      path = "/#{@locale}/users/#{user.id}/edit"

      session
      |> Wallaby.Browser.visit(path)
      |> E2eWeb.Model.wait(500)
      |> A11yAudit.Wallaby.assert_no_violations()
    end
  end

  describe "admin pages" do
    setup :create_admin

    defp create_admin(_) do
      %{admin: admin_fixture()}
    end

    feature "Admins show has no A11y violations", %{session: session, admin: admin} do
      path = "/#{@locale}/admins/#{admin.id}"

      session
      |> Wallaby.Browser.visit(path)
      |> E2eWeb.Model.wait(500)
      |> A11yAudit.Wallaby.assert_no_violations()
    end

    feature "Admins edit has no A11y violations", %{session: session, admin: admin} do
      path = "/#{@locale}/admins/#{admin.id}/edit"

      session
      |> Wallaby.Browser.visit(path)
      |> E2eWeb.Model.wait(500)
      |> A11yAudit.Wallaby.assert_no_violations()
    end
  end
end
