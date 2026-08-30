defmodule E2eWeb.NativeAccordionLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Corex.NativeAccordion.Ids

  @playground_id "my-native-accordion"
  @patterns_controlled "patterns-controlled"

  defp trigger_sel(accordion_id, item),
    do: ~s([id="#{Ids.trigger_id(accordion_id, item)}"])

  test "playground mounts like Accordion (single canvas, no controlled h2)", %{conn: conn} do
    {view, html} = live_ok!(conn, ~p"/native-accordion/playground")

    assert html =~ "Native Accordion"
    assert html =~ ~s(data-native="")
    assert html =~ ~s(id="orientation")
    refute html =~ "Controlled (LiveView value)"
    refute html =~ "Uncontrolled (JS pipes)"
    refute html =~ ~s(phx-hook="Accordion")
    assert has_element?(view, "##{@playground_id}")
  end

  test "playground keydown ArrowUp updates focused_value", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/native-accordion/playground")

    lorem = trigger_sel(@playground_id, "lorem")
    duis = trigger_sel(@playground_id, "duis")

    assert has_element?(view, lorem <> "[tabindex='0']")

    view
    |> element(lorem)
    |> render_keydown(%{"key" => "ArrowDown"})

    assert has_element?(view, duis <> "[tabindex='0']")
    assert has_element?(view, ~s([id="#{Ids.trigger_id(@playground_id, "duis")}-focus-pin"]))

    view
    |> element(duis)
    |> render_keydown(%{"key" => "ArrowUp"})

    assert has_element?(view, lorem <> "[tabindex='0']")
  end

  test "patterns controlled toggle updates open assign", %{conn: conn} do
    {view, html} = live_ok!(conn, ~p"/native-accordion/patterns")

    assert html =~ "Controlled (LiveView)"
    assert html =~ "Open:"

    duis = trigger_sel(@patterns_controlled, "duis")
    lorem = trigger_sel(@patterns_controlled, "lorem")

    assert has_element?(view, lorem <> "[aria-expanded=true]")

    view
    |> element(duis)
    |> render_click()

    assert has_element?(view, duis <> "[aria-expanded=true]")
    assert has_element?(view, lorem <> "[aria-expanded=false]")
    html = render(view)
    assert html =~ "Open:"
    assert html =~ "duis"
  end

  test "events and api pages mount", %{conn: conn} do
    {_view, html} = live_ok!(conn, ~p"/native-accordion/events")
    assert html =~ "On Value Change"

    {_view, html} = live_ok!(conn, ~p"/native-accordion/api")
    assert html =~ "set_value"
  end

  test "anatomy and style controller pages render", %{conn: conn} do
    conn = get(conn, ~p"/native-accordion/anatomy")
    html = html_response(conn, 200)
    assert html =~ "native-accordion-anatomy-page"
    assert html =~ "Minimal"
    assert html =~ "Compound"

    conn = get(build_conn(), ~p"/native-accordion/style")
    html = html_response(conn, 200)
    assert html =~ "native-accordion-styling-page"
    assert html =~ "Semantic"
  end
end
