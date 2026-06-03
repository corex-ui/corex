defmodule E2eWeb.PagesA11yTest do
  use E2eWeb.ConnCase, async: false
  use Wallaby.Feature

  import E2eWeb.A11yExport

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

  for {name, key} <- @static_pages, export <- exports() do
    @name name
    @key key
    @export export

    feature "#{@name} (#{@export} export) has no A11y violations", %{session: session} do
      path =
        case @key do
          :home -> @locale_path
          :users_index -> ~p"/users"
          :users_new -> ~p"/users/new"
          :admins_index -> ~p"/admins"
          :admins_new -> ~p"/admins/new"
        end

      session
      |> visit_with_export(path, @export)
      |> A11yAudit.Wallaby.assert_no_violations()
    end
  end

  describe "user pages" do
    setup :create_user

    defp create_user(_) do
      %{user: user_fixture()}
    end

    for export <- exports() do
      @export export

      feature "Users show (#{@export} export) has no A11y violations", %{
        session: session,
        user: user
      } do
        session
        |> visit_with_export(~p"/users/#{user.id}", @export)
        |> A11yAudit.Wallaby.assert_no_violations()
      end

      feature "Users edit (#{@export} export) has no A11y violations", %{
        session: session,
        user: user
      } do
        session
        |> visit_with_export(~p"/users/#{user.id}/edit", @export)
        |> A11yAudit.Wallaby.assert_no_violations()
      end
    end
  end

  describe "admin pages" do
    setup :create_admin

    defp create_admin(_) do
      %{admin: admin_fixture()}
    end

    for export <- exports() do
      @export export

      feature "Admins show (#{@export} export) has no A11y violations", %{
        session: session,
        admin: admin
      } do
        session
        |> visit_with_export(~p"/admins/#{admin.id}", @export)
        |> A11yAudit.Wallaby.assert_no_violations()
      end

      feature "Admins edit (#{@export} export) has no A11y violations", %{
        session: session,
        admin: admin
      } do
        session
        |> visit_with_export(~p"/admins/#{admin.id}/edit", @export)
        |> A11yAudit.Wallaby.assert_no_violations()
      end
    end
  end
end
