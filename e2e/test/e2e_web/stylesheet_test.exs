defmodule E2eWeb.StylesheetTest do
  use E2eWeb.ConnCase, async: true

  test "doc layout loads single site.css bundle", %{conn: conn} do
    html = conn |> get(~p"/") |> html_response(200)

    assert html =~ "/assets/css/site.css"
    refute html =~ ~s(href="/corex/design.css")
    refute html =~ "corex.tailwind.recipes.css"
  end

  test "built bundles exclude legacy corex component utilities", %{conn: _conn} do
    site = File.read!(Path.join([File.cwd!(), "priv/static/assets/css/site.css"]))
    chrome = File.read!(Path.join([File.cwd!(), "assets/css/site-chrome.css"]))
    site_source = File.read!(Path.join([File.cwd!(), "assets/css/site.css"]))
    chrome_source = File.read!(Path.join([File.cwd!(), "assets/css/site-chrome.css"]))

    refute site =~ "@utility ui-"
    refute chrome =~ "@utility ui-"
    refute site_source =~ "../corex/"
    refute chrome_source =~ "../corex/"
  end

  test "corex tailwind bundle exists after compile", %{conn: _conn} do
    dir = Path.join([File.cwd!(), "assets/css"])
    theme = File.read!(Path.join(dir, "layers/theme.css"))
    base = File.read!(Path.join(dir, "layers/base.css"))
    button = File.read!(Path.join(dir, "recipes/button.css"))
    accordion = File.read!(Path.join(dir, "recipes/accordion.css"))
    row = File.read!(Path.join(dir, "recipes/row.css"))
    tokens = File.read!(Path.join(dir, "layers/tokens.css"))

    assert File.exists?(Path.join(dir, "corex.tailwind.css"))
    assert File.exists?(Path.join(dir, "aggregates/recipes.css"))
    assert File.exists?(Path.join(dir, "layers/utilities.css"))
    refute File.exists?(Path.join(dir, "recipes/class"))
    refute File.exists?(Path.join(dir, "recipes/data"))

    utilities = File.read!(Path.join(dir, "layers/utilities.css"))
    assert utilities =~ "@utility part-trigger"
    assert utilities =~ "@utility visual-solid"

    assert theme =~ "@theme inline"
    assert base =~ ".typo h1"
    refute base =~ "body h1"
    assert base =~ "@layer reset, base;"
    refute button =~ "@utility button--*"
    assert button =~ "@utility button--semantic-*"
    assert button =~ "--paint-bg: --value(--color-*, [color])"
    assert button =~ "@utility button--variant-solid"
    assert button =~ "@apply visual-solid"
    refute button =~ "--ui-solid"
    refute accordion =~ "data-accordion-semantic"
    assert accordion =~ "@apply part-trigger"
    assert accordion =~ "@utility accordion--rounded-*"
    assert accordion =~ "@utility accordion--max-w-*"
    refute accordion =~ ".accordion.accordion--rounded-md {"
    assert accordion =~ "@utility accordion--semantic-*"
    assert accordion =~ "@utility accordion--size-*"
    assert accordion =~ "--paint-bg: --value(--color-*, [color])"
    assert accordion =~ "@utility accordion--variant-solid"
    assert accordion =~ "@apply visual-solid"
    assert row =~ ".row"
    refute button =~ "[data-button]"
    assert tokens =~ "--color-brand:"
    assert tokens =~ "--spacing:"
    assert theme =~ "--spacing-lg:"
  end

  test "css export chrome does not duplicate recipe layer or legacy migrated components", %{
    conn: _conn
  } do
    chrome = File.read!(Path.join([File.cwd!(), "assets/css/site-chrome.css"]))

    refute chrome =~ "@layer recipes"
    refute chrome =~ "@utility select--"
    refute chrome =~ "@utility button--"
  end

  test "built site.css includes recipe styling via corex.tailwind.css", %{conn: _conn} do
    site = File.read!(Path.join([File.cwd!(), "priv/static/assets/css/site.css"]))

    assert site =~ ".shell-header"
    assert site =~ ".select"
    assert site =~ "--paint-bg"
    assert site =~ "color-accent"
    refute site =~ "@source inline"
  end

  test "tailwind export renders bem button markup in e2e", %{conn: conn} do
    html = conn |> get(~p"/action/anatomy") |> html_response(200)

    assert html =~ ~s(class="button button--)
    refute html =~ ~s(data-button-semantic)
  end

  test "corex tailwind recipes use rounded radius bem suffix", %{conn: _conn} do
    accordion = File.read!(Path.join([File.cwd!(), "assets/css/recipes/accordion.css"]))

    assert accordion =~ "@utility accordion--rounded-*"
    assert accordion =~ "border-radius: --value(--radius-*"
    refute accordion =~ ".accordion.accordion--rounded-md {"
  end

  test "select style page avoids bare tailwind max-width on host", %{conn: conn} do
    html = conn |> get(~p"/select/style") |> html_response(200)

    refute html =~ ~s(class="select--rounded)
    refute html =~ ~s(class="max-w-md")
    assert html =~ "select--rounded-md"
    assert html =~ "select--max-w-md"
  end

  test "listbox style page demos use host max-width bem modifiers", %{conn: conn} do
    html = conn |> get(~p"/listbox/style") |> html_response(200)

    assert html =~ "listbox listbox--max-w-md"
    refute html =~ ~s(class="listbox max-w-md")
  end
end
