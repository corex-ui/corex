defmodule E2eWeb.PagesA11yTest do
  use E2eWeb.ConnCase, async: false
  use Wallaby.Feature

  import E2e.AccountsFixtures

  setup do
    Localize.put_locale(:en)
    :ok
  end

  @static_pages [
    {"Home", :home},
    {"Users index", :users_index},
    {"Users new", :users_new},
    {"Admins index", :admins_index},
    {"Admins new", :admins_new}
  ]

  @locale_path "/" <> E2eWeb.DocA11yRoutes.locale()

  for {name, key} <- @static_pages do
    @name name
    @key key

    feature "#{@name} has no A11y violations", %{session: session} do
      path =
        case @key do
          :home -> @locale_path
          :users_index -> ~p"/users"
          :users_new -> ~p"/users/new"
          :admins_index -> ~p"/admins"
          :admins_new -> ~p"/admins/new"
        end

      session
      |> Wallaby.Browser.visit(path)
      |> A11yAudit.Wallaby.assert_no_violations()
    end
  end

  describe "user pages" do
    setup :create_user

    defp create_user(_) do
      %{user: user_fixture()}
    end

    feature "Users show has no A11y violations", %{session: session, user: user} do
      path = ~p"/users/#{user.id}"

      session
      |> Wallaby.Browser.visit(path)
      |> A11yAudit.Wallaby.assert_no_violations()
    end

    feature "Users edit has no A11y violations", %{session: session, user: user} do
      path = ~p"/users/#{user.id}/edit"

      session
      |> Wallaby.Browser.visit(path)
      |> A11yAudit.Wallaby.assert_no_violations()
    end
  end

  describe "admin pages" do
    setup :create_admin

    defp create_admin(_) do
      %{admin: admin_fixture()}
    end

    feature "Admins show has no A11y violations", %{session: session, admin: admin} do
      path = ~p"/admins/#{admin.id}"

      session
      |> Wallaby.Browser.visit(path)
      |> A11yAudit.Wallaby.assert_no_violations()
    end

    feature "Admins edit has no A11y violations", %{session: session, admin: admin} do
      path = ~p"/admins/#{admin.id}/edit"

      session
      |> Wallaby.Browser.visit(path)
      |> A11yAudit.Wallaby.assert_no_violations()
    end
  end
end
