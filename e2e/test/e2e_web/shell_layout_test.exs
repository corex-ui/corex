defmodule E2eWeb.ShellLayoutTest do
  use E2eWeb.ConnCase, async: true

  test "doc layout loads site.css", %{conn: conn} do
    html = conn |> get(~p"/action/style") |> html_response(200)

    assert html =~ "/assets/css/site.css"
    refute html =~ ~s(href="/corex/design.css")
  end

  test "app shell renders header, aside, and theme controls", %{conn: conn} do
    html = conn |> get(~p"/action/style") |> html_response(200)

    assert html =~ "class=\"row"
    assert html =~ "class=\"stack"
    assert html =~ "shell-aside"
    assert html =~ "shell-header"
    assert html =~ "shell-footer"
    assert html =~ ~s(id="main-content")
    assert html =~ ~s(id="theme-select")
    assert html =~ ~s(id="mode-switcher")
    assert html =~ ~s(data-on-value-change-client="corex:preview:set-theme")
    assert html =~ ~s(data-on-pressed-change-client="corex:preview:set-mode")
    refute html =~ ~s(id="export-select")
    refute html =~ ~s(id="authoring-switcher")
    assert html =~ ~s(id="doc-authoring-settings")
    assert html =~ ~s(data-on-value-change-client="corex:preview:set-authoring")
    refute html =~ ~s(id="doc-page-toolbar" class="doc-page-toolbar" phx-update="ignore")
    refute html =~ "layout__header"
    refute html =~ "layout__main"
  end

  test "home shell renders across theme and mode combinations", %{conn: conn} do
    for theme <- ~w(neo uno duo leo), mode <- ~w(light dark) do
      html =
        conn
        |> put_req_cookie("phx_theme", theme)
        |> put_req_cookie("phx_mode", mode)
        |> get(~p"/")
        |> html_response(200)

      assert html =~ ~s(data-theme="#{theme}")
      assert html =~ ~s(data-mode="#{mode}")
      assert html =~ "shell-content--marketing"
      assert html =~ "shell-header"
      assert html =~ "row--justify-between"
      assert html =~ "row--w-full"
      assert html =~ "h1--semantic-brand"
      assert html =~ ~s(id="mode-switcher")
      assert html =~ "toggle--shape-square"
      refute html =~ "toggle--rounded-full toggle--shape-square"
      assert html =~ "home__hero"
      assert html =~ ~s(class="icon")
      assert html =~ ~s(id="hero-accordion")
      assert html =~ "button--variant-solid"
      assert html =~ "button--semantic-brand"
      assert html =~ "button--size-lg"
      assert html =~ "button--variant-ghost"
      assert html =~ ~p"/accordion/playground"
      assert html =~ "class=\"stack"
    end
  end
end
