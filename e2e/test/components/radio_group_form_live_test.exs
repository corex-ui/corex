defmodule E2eWeb.RadioGroupFormLiveTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  test "ecto validate shows required error for empty choice", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/radio-group/live-form")

    html =
      view
      |> form("#radio-group-live-form-ecto")
      |> render_change(%{"radio_group_ecto" => %{"choice" => ""}})

    assert html =~ "can&#39;t be blank"
  end

  test "ecto save with choice pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/radio-group/live-form")

    view
    |> form("#radio-group-live-form-ecto")
    |> render_submit(%{"radio_group_ecto" => %{"choice" => "lorem"}})

    assert_push_event(view, "toast-create", %{
      description: "Submitted: choice=lorem",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end
end
