defmodule E2eWeb.PinInputFormLiveTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  test "ecto validate reflects submitted pin in markup", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/pin-input/live-form")

    html =
      view
      |> form("#pin-input-live-form-ecto")
      |> render_change(%{"pin_ecto" => %{"pin" => "9999"}})

    assert html =~ "9999"
  end

  test "ecto save pushes toast-create with pin description", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/pin-input/live-form")

    view
    |> form("#pin-input-live-form-ecto")
    |> render_submit(%{"pin_ecto" => %{"pin" => "4242"}})

    assert_push_event(view, "toast-create", %{
      description: "Submitted: pin=4242",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end
end
