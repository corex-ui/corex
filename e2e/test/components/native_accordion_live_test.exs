defmodule E2eWeb.NativeAccordionLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Corex.NativeAccordion.Ids

  @controlled_id "native-accordion-controlled"

  defp trigger_sel(item),
    do: ~s([id="#{Ids.trigger_id(@controlled_id, item)}"])

  test "playground mounts without accordion hook", %{conn: conn} do
    {view, html} = live_ok!(conn, ~p"/native-accordion/playground")

    assert html =~ "Native Accordion"
    assert html =~ ~s(data-native="")
    refute html =~ ~s(phx-hook="Accordion")
    assert has_element?(view, "##{@controlled_id}")
  end

  test "controlled toggle opens and closes via LiveView", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/native-accordion/playground")

    assert has_element?(view, trigger_sel("lorem") <> "[aria-expanded=true]")
    assert has_element?(view, trigger_sel("duis") <> "[aria-expanded=false]")

    view
    |> element(trigger_sel("duis"))
    |> render_click()

    assert has_element?(view, trigger_sel("duis") <> "[aria-expanded=true]")
    assert has_element?(view, trigger_sel("lorem") <> "[aria-expanded=true]")

    view
    |> element(trigger_sel("lorem"))
    |> render_click()

    assert has_element?(view, trigger_sel("lorem") <> "[aria-expanded=false]")
    assert has_element?(view, trigger_sel("duis") <> "[aria-expanded=true]")
  end

  test "controlled single mode replaces open item", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/native-accordion/playground")

    _html = render_click(view, "control_changed", %{"id" => "multiple", "checked" => "false"})

    assert has_element?(view, trigger_sel("lorem") <> "[aria-expanded=true]")

    view
    |> element(trigger_sel("duis"))
    |> render_click()

    assert has_element?(view, trigger_sel("duis") <> "[aria-expanded=true]")
    assert has_element?(view, trigger_sel("lorem") <> "[aria-expanded=false]")
  end

  test "vertical keyboard bindings target neighboring triggers", %{conn: conn} do
    {_view, html} = live_ok!(conn, ~p"/native-accordion/playground")

    assert html =~ ~s(id="#{Ids.trigger_id(@controlled_id, "lorem")}")
    assert html =~ "ArrowDown"
    assert html =~ "ArrowUp"
    assert html =~ "Home"
    assert html =~ "End"
    assert html =~ "duis"
    assert html =~ "donec"
  end
end
