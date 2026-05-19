defmodule E2eWeb.RadioGroupFormLiveTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  test "changeset validate shows required error for empty choice", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/radio-group/live-form")

    html =
      view
      |> form("#radio-group-live-form")
      |> render_change(%{"radio_group_live" => %{"choice" => ""}})

    assert html =~ "can&#39;t be blank"
  end

  test "changeset save with choice pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/radio-group/live-form")

    view
    |> form("#radio-group-live-form")
    |> render_submit(%{"radio_group_live" => %{"choice" => "lorem"}})

    assert_push_event(view, "toast-create", %{
      description: "Submitted: choice=lorem",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "validate_strict shows required error for empty choice", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/radio-group/live-form")

    html =
      view
      |> form("#radio-group-strict-form-live")
      |> render_change(%{"radio_group_strict" => %{"choice" => ""}})

    assert html =~ "can&#39;t be blank"
  end

  test "save_strict with choice pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/radio-group/live-form")

    view
    |> form("#radio-group-strict-form-live")
    |> render_submit(%{"radio_group_strict" => %{"choice" => "donec"}})

    assert_push_event(view, "toast-create", %{
      description: "Submitted: choice=donec",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end
end
