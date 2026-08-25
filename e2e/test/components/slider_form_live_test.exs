defmodule E2eWeb.SliderFormLiveTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  defp invalid_form_html(html) do
    case Regex.run(
           ~r/<form[^>]*id="slider-validate-form-live-invalid"[^>]*>.*?<\/form>/s,
           html
         ) do
      [form] -> form
      _ -> flunk("invalid form not found in HTML")
    end
  end

  defp invalid_range_form_html(html) do
    case Regex.run(
           ~r/<form[^>]*id="slider-validate-form-live-invalid-range"[^>]*>.*?<\/form>/s,
           html
         ) do
      [form] -> form
      _ -> flunk("invalid range form not found in HTML")
    end
  end

  test "save_phoenix submits volume and pushes toast_create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/slider/live-form")

    view
    |> form("#slider-live-form-phoenix")
    |> render_submit(%{"slider_phoenix" => %{"volume" => "12.5"}})

    assert_push_event(view, "toast_create", %{
      description: "Submitted: volume=12.5",
      duration: 5000,
      group_id: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "save_phoenix_range submits volume list and pushes toast_create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/slider/live-form")

    view
    |> form("#slider-live-form-phoenix-range")
    |> render_submit(%{"slider_phoenix_range" => %{"volume" => ["20", "80"]}})

    assert_push_event(view, "toast_create", %{
      description: "Submitted: volume=[\"20\", \"80\"]",
      duration: 5000,
      group_id: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "validate_validate reflects not over 90 on change", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/slider/live-form")

    html =
      view
      |> form("#slider-validate-form-live")
      |> render_change(%{"slider_validate" => %{"volume" => "45"}})

    assert html =~ "must be over 90"
  end

  test "validate_validate_range reflects high not over 90 on change", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/slider/live-form")

    html =
      view
      |> form("#slider-validate-range-form-live")
      |> render_change(%{"slider_validate_range" => %{"volume" => ["20", "80"]}})

    assert html =~ "must be over 90"
  end

  test "validate form save not over 90 shows number message", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/slider/live-form")

    html =
      view
      |> form("#slider-validate-form-live")
      |> render_submit(%{"slider_validate" => %{"volume" => "90"}})

    assert html =~ "must be over 90"
  end

  test "validate range form save high not over 90 shows number message", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/slider/live-form")

    html =
      view
      |> form("#slider-validate-range-form-live")
      |> render_submit(%{"slider_validate_range" => %{"volume" => ["10", "90"]}})

    assert html =~ "must be over 90"
  end

  test "validate form save over 90 pushes toast_create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/slider/live-form")

    view
    |> form("#slider-validate-form-live")
    |> render_submit(%{"slider_validate" => %{"volume" => "95"}})

    assert_push_event(view, "toast_create", %{
      description: "Submitted: volume=95.0",
      duration: 5000,
      group_id: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "validate range form save high over 90 pushes toast_create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/slider/live-form")

    view
    |> form("#slider-validate-range-form-live")
    |> render_submit(%{"slider_validate_range" => %{"volume" => ["20", "95"]}})

    assert_push_event(view, "toast_create", %{
      description: "Submitted: volume=[20.0, 95.0]",
      duration: 5000,
      group_id: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "invalid shows data-invalid after submit and clears on valid change", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/slider/live-form")

    html =
      view
      |> form("#slider-validate-form-live-invalid")
      |> render_submit(%{"slider_validate_invalid" => %{"volume" => "45"}})

    invalid_html = invalid_form_html(html)
    assert invalid_html =~ "must be over 90"

    assert invalid_html =~
             ~r/id="slider-validate-form-live-invalid_volume"[^>]*data-invalid=""/

    html =
      view
      |> form("#slider-validate-form-live-invalid")
      |> render_change(%{"slider_validate_invalid" => %{"volume" => "95"}})

    invalid_html = invalid_form_html(html)
    refute invalid_html =~ "must be over 90"

    refute invalid_html =~
             ~r/id="slider-validate-form-live-invalid_volume"[^>]*data-invalid=""/
  end

  test "invalid range shows data-invalid after submit and clears on valid change", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/slider/live-form")

    html =
      view
      |> form("#slider-validate-form-live-invalid-range")
      |> render_submit(%{"slider_validate_invalid_range" => %{"volume" => ["20", "80"]}})

    invalid_html = invalid_range_form_html(html)
    assert invalid_html =~ "must be over 90"

    assert invalid_html =~
             ~r/id="slider-validate-form-live-invalid-range_volume"[^>]*data-invalid=""/

    html =
      view
      |> form("#slider-validate-form-live-invalid-range")
      |> render_change(%{"slider_validate_invalid_range" => %{"volume" => ["20", "95"]}})

    invalid_html = invalid_range_form_html(html)
    refute invalid_html =~ "must be over 90"

    refute invalid_html =~
             ~r/id="slider-validate-form-live-invalid-range_volume"[^>]*data-invalid=""/
  end
end
