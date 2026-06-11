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
    assert html =~ "data-disable-markup"
    assert markup_toggle_disabled?(html)
    refute attr_toggle_disabled?(html)
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
    assert html =~ ~s(id="accordion-style-variant-semantic")
    assert html =~ ~s(id="accordion-style-size")
  end

  test "action style live page includes authoring settings", %{conn: conn} do
    html = conn |> get(~p"/action/style") |> html_response(200)

    assert count_occurrences(html, ~s(id="doc-authoring-settings")) == 1
    assert html =~ "data-disable-markup"
    assert markup_toggle_disabled?(html)
    refute attr_toggle_disabled?(html)
    assert html =~ ~s(id="action-style-preview" class="doc-preview-tabs" data-authoring-scope="styled")
    assert html =~ ~s(data-authoring-panel="attr")
    assert html =~ ~s(data-authoring-panel="class")
    refute html =~ ~s(data-authoring-panel="markup")
    refute html =~ ~s(data-snippet-markup-template)
    assert html =~ ~s(id="action-as")
    assert html =~ ~s(id="my-action")
  end

  test "action style live page includes style matrix in test env", %{conn: conn} do
    html = conn |> get(~p"/action/style") |> html_response(200)

    assert html =~ ~s(id="action-style-page")
    assert html =~ ~s(id="action-style-matrix")
    assert html =~ ~s(id="action-style-variant-semantic")
    assert html =~ ~s(id="action-style-link")
  end

  test "action anatomy page includes triple authoring snippets", %{conn: conn} do
    html = conn |> get(~p"/action/anatomy") |> html_response(200)

    assert html =~ "action-anatomy-minimal"
    assert html =~ "action-anatomy-with-icon"
    assert html =~ "action-anatomy-icon-only"
    assert count_occurrences(html, ~s(data-snippet-markup-template)) == 3
    assert count_occurrences(html, ~s(data-snippet-class-template)) == 3
    assert count_occurrences(html, ~s(data-authoring-preview="styled")) == 3
    assert count_occurrences(html, ~s(data-authoring-preview="markup")) == 3
  end

  test "accordion anatomy page keeps unstyled authoring enabled", %{conn: conn} do
    html = conn |> get(~p"/accordion/anatomy") |> html_response(200)

    refute markup_toggle_disabled?(html)
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

  defp markup_toggle_disabled?(html) do
    toggle_fragment(html, "markup") =~ ~r/disabled/
  end

  defp attr_toggle_disabled?(html) do
    toggle_fragment(html, "attr") =~ ~r/disabled/
  end

  defp toggle_fragment(html, value) do
    case :binary.match(html, "toggle-group:doc-authoring-mode:#{value}") do
      {index, _} ->
        start = max(index - 40, 0)
        String.slice(html, start, 160)

      :nomatch ->
        ""
    end
  end
end
