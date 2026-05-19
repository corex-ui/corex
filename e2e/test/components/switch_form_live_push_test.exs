defmodule E2eWeb.SwitchFormLivePushTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  test "live changeset submit without toggle pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/switch/live-form")

    view |> form("#switch-form-live") |> render_submit()

    assert_push_event(view, "toast-create", %{
      description: "Submitted: notifications=false",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "changeset validate shows cast error for invalid boolean", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/switch/live-form")

    html =
      view
      |> form("#switch-form-live")
      |> render_change(%{"preferences" => %{"notifications" => "invalid"}})

    assert html =~ "is invalid"
  end

  test "changeset save with notifications true pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/switch/live-form")

    view
    |> form("#switch-form-live")
    |> render_submit(%{"preferences" => %{"notifications" => "true"}})

    assert_push_event(view, "toast-create", %{
      description: "Submitted: notifications=true",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "validate_strict shows cast error for invalid boolean", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/switch/live-form")

    html =
      view
      |> form("#switch-strict-form-live")
      |> render_change(%{"preferences_strict" => %{"notifications" => "invalid"}})

    assert html =~ "is invalid"
  end

  test "save_strict with notifications true pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/switch/live-form")

    view
    |> form("#switch-strict-form-live")
    |> render_submit(%{"preferences_strict" => %{"notifications" => "true"}})

    assert_push_event(view, "toast-create", %{
      description: "Submitted: notifications=true",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "save_strict with invalid boolean shows error markup", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/switch/live-form")

    html =
      view
      |> form("#switch-strict-form-live")
      |> render_submit(%{"preferences_strict" => %{"notifications" => "invalid"}})

    assert html =~ "is invalid"
  end
end
