defmodule E2eWeb.Plugs.DocAuthoringTest do
  use E2eWeb.ConnCase, async: true

  test "reads authoring cookie into root html data attribute", %{conn: conn} do
    html =
      conn
      |> put_req_cookie("phx_authoring", "class")
      |> get(~p"/action/style")
      |> html_response(200)

    assert html =~ ~s(data-authoring="class")
    assert count_occurrences(html, ~s(id="doc-authoring-settings")) == 1
    assert html =~ ~s(data-on-value-change-client="corex:preview:set-authoring")
    refute html =~ ~s(id="doc-page-toolbar" class="doc-page-toolbar" phx-update="ignore")
    refute html =~ ~s(id="doc-app-name")
    refute html =~ ~s(id="authoring-switcher")
  end

  test "reads markup authoring cookie into root html data attribute", %{conn: conn} do
    html =
      conn
      |> put_req_cookie("phx_authoring", "markup")
      |> get(~p"/accordion/style")
      |> html_response(200)

    assert html =~ ~s(data-authoring="markup")
  end

  test "defaults authoring to attr", %{conn: conn} do
    html = conn |> get(~p"/action/style") |> html_response(200)

    assert html =~ ~s(data-authoring="attr")
  end

  test "accordion style live page includes authoring settings", %{conn: conn} do
    html = conn |> get(~p"/accordion/style") |> html_response(200)

    assert count_occurrences(html, ~s(id="doc-authoring-settings")) == 1
    assert html =~ ~s(id="accordion-style-preview" class="doc-preview-tabs" data-authoring-scope="styled")
    assert html =~ ~s(data-authoring-panel="attr")
    assert html =~ ~s(data-authoring-panel="class")
    refute html =~ ~s(data-authoring-panel="markup")
    refute html =~ ~s(data-snippet-markup-template)
    refute html =~ ~s(semantic="info" class="accordion)
  end

  test "accordion style live page omits unstyled snippets when authoring is markup", %{conn: conn} do
    html =
      conn
      |> put_req_cookie("phx_authoring", "markup")
      |> get(~p"/accordion/style")
      |> html_response(200)

    playground =
      html
      |> String.split(~s(id="accordion-style-preview"))
      |> Enum.at(1, "")
      |> String.split(~s(id="accordion-style-matrix"))
      |> hd()

    assert playground =~ ~s(data-authoring-scope="styled")
    refute playground =~ ~s(data-authoring-panel="markup")
    refute playground =~ ~s(data-snippet-markup-template)
    refute playground =~ "unstyled"
  end

  test "accordion style live page includes style matrix in test env", %{conn: conn} do
    html = conn |> get(~p"/accordion/style") |> html_response(200)

    assert html =~ ~s(id="accordion-style-page")
    assert html =~ ~s(id="accordion-style-matrix")
    assert html =~ ~s(id="accordion-styling-variant-semantic")
    assert html =~ ~s(id="accordion-styling-size")
  end

  test "accordion anatomy page includes triple authoring snippets", %{conn: conn} do
    html = conn |> get(~p"/accordion/anatomy") |> html_response(200)

    assert html =~ "accordion-anatomy-minimal"
    assert html =~ "accordion-anatomy-custom-slots"
    assert html =~ "accordion-anatomy-manual-slots"
    assert html =~ "accordion-anatomy-compound"
    assert count_occurrences(html, ~s(data-snippet-markup-template)) == 5
    assert count_occurrences(html, ~s(data-snippet-class-template)) == 5
    assert count_occurrences(html, ~s(data-authoring-preview="styled")) == 5
    assert count_occurrences(html, ~s(data-authoring-preview="markup")) == 5
  end

  test "accordion api live page includes triple authoring snippets", %{conn: conn} do
    html = conn |> get(~p"/accordion/api") |> html_response(200)

    assert count_occurrences(html, ~s(data-snippet-markup-template)) == 12
    assert count_occurrences(html, ~s(data-authoring-preview="styled")) == 12
  end

  defp count_occurrences(haystack, needle) do
    haystack
    |> String.split(needle)
    |> length()
    |> Kernel.-(1)
  end
end
