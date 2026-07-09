defmodule E2eWeb.AngleSliderFormLiveTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  defp invalid_form_html(html) do
    case Regex.run(
           ~r/<form[^>]*id="angle-slider-validate-form-live-invalid"[^>]*>.*?<\/form>/s,
           html
         ) do
      [form] -> form
      _ -> flunk("invalid form not found in HTML")
    end
  end

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

  test "invalid shows data-invalid after submit and clears on valid change", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/angle-slider/live-form")

    html =
      view
      |> form("#angle-slider-validate-form-live-invalid")
      |> render_submit(%{"angle_slider_validate_invalid" => %{"angle" => "100"}})

    invalid_html = invalid_form_html(html)
    assert invalid_html =~ "must be between 0 and 90"

    assert invalid_html =~
             ~r/id="angle-slider-validate-form-live-invalid_angle"[^>]*data-invalid=""/

    html =
      view
      |> form("#angle-slider-validate-form-live-invalid")
      |> render_change(%{"angle_slider_validate_invalid" => %{"angle" => "45"}})

    invalid_html = invalid_form_html(html)
    refute invalid_html =~ "must be between 0 and 90"

    refute invalid_html =~
             ~r/id="angle-slider-validate-form-live-invalid_angle"[^>]*data-invalid=""/
  end
end
