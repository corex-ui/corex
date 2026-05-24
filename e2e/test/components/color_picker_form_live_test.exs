defmodule E2eWeb.ColorPickerFormLiveTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  test "validate_validate shows alpha cap error for high-opacity rgba", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/color-picker/live-form")

    html =
      view
      |> form("#color-picker-validate-form-live")
      |> render_change(%{"color_picker_validate" => %{"color" => "rgba(255,0,0,0.9)"}})

    assert html =~ "maximum alpha allowed is 50%"
  end

  test "save_phoenix submits hex color and pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/color-picker/live-form")

    view
    |> form("#color-picker-live-form-phoenix")
    |> render_submit(%{"color_picker_phoenix" => %{"color" => "#ef4444"}})

    assert_push_event(view, "toast-create", %{
      description: "Submitted: color=#ef4444",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "save_validate submits rgba within alpha cap and pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/color-picker/live-form")

    view
    |> form("#color-picker-validate-form-live")
    |> render_submit(%{"color_picker_validate" => %{"color" => "rgba(10,20,30,0.2)"}})

    assert_push_event(view, "toast-create", %{
      description: "Submitted: color=rgba(10,20,30,0.2)",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end
end
