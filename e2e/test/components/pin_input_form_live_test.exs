defmodule E2eWeb.PinInputFormLiveTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  test "ecto validate reflects submitted pin in markup", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/pin-input/live-form")

    html =
      view
      |> form("#pin-input-live-form-ecto")
      |> render_change(%{"pin_ecto" => %{"pin" => ["9", "9", "9", "9"]}})

    assert html =~ "9999"
  end

  test "ecto save without nested params does not crash", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/pin-input/live-form")

    html =
      view
      |> element("#pin-input-live-form-ecto")
      |> render_submit()

    assert html =~ "pin-input-live-form-ecto"
  end

  test "phoenix save without nested params does not crash", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/pin-input/live-form")

    html =
      view
      |> element("#pin-input-live-form-phoenix")
      |> render_submit()

    assert html =~ "pin-input-live-form-phoenix"
  end

  test "ecto save pushes toast-create with pin description", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/pin-input/live-form")

    view
    |> form("#pin-input-live-form-ecto")
    |> render_submit(%{"pin_ecto" => %{"pin" => ["4", "2", "4", "2"]}})

    assert_push_event(view, "toast-create", %{
      description: "Submitted: pin=[\"4\", \"2\", \"4\", \"2\"]",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end
end
