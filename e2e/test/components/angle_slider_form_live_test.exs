defmodule E2eWeb.AngleSliderFormLiveTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  test "save_phoenix submits angle and pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/angle-slider/live-form")

    view
    |> form("#angle-slider-live-form-phoenix")
    |> render_submit(%{"angle_slider_phoenix" => %{"angle" => "12.5"}})

    assert_push_event(view, "toast-create", %{
      description: "Submitted: angle=12.5",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "validate_validate reflects out of range on change", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/angle-slider/live-form")

    html =
      view
      |> form("#angle-slider-validate-form-live")
      |> render_change(%{"angle_slider_validate" => %{"angle" => "120"}})

    assert html =~ "must be between 0 and 90"
  end

  test "validate form save out of range shows number message", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/angle-slider/live-form")

    html =
      view
      |> form("#angle-slider-validate-form-live")
      |> render_submit(%{"angle_slider_validate" => %{"angle" => "100"}})

    assert html =~ "must be between 0 and 90"
  end

  test "validate form save in range pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/angle-slider/live-form")

    view
    |> form("#angle-slider-validate-form-live")
    |> render_submit(%{"angle_slider_validate" => %{"angle" => "45"}})

    assert_push_event(view, "toast-create", %{
      description: "Submitted: angle=45.0",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end
end
