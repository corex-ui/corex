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

  test "validate_validate reflects out of range on change", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/slider/live-form")

    html =
      view
      |> form("#slider-validate-form-live")
      |> render_change(%{"slider_validate" => %{"volume" => "120"}})

    assert html =~ "must be between 0 and 90"
  end

  test "validate form save out of range shows number message", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/slider/live-form")

    html =
      view
      |> form("#slider-validate-form-live")
      |> render_submit(%{"slider_validate" => %{"volume" => "100"}})

    assert html =~ "must be between 0 and 90"
  end

  test "validate form save in range pushes toast_create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/slider/live-form")

    view
    |> form("#slider-validate-form-live")
    |> render_submit(%{"slider_validate" => %{"volume" => "45"}})

    assert_push_event(view, "toast_create", %{
      description: "Submitted: volume=45.0",
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
      |> render_submit(%{"slider_validate_invalid" => %{"volume" => "100"}})

    invalid_html = invalid_form_html(html)
    assert invalid_html =~ "must be between 0 and 90"

    assert invalid_html =~
             ~r/id="slider-validate-form-live-invalid_volume"[^>]*data-invalid=""/

    html =
      view
      |> form("#slider-validate-form-live-invalid")
      |> render_change(%{"slider_validate_invalid" => %{"volume" => "45"}})

    invalid_html = invalid_form_html(html)
    refute invalid_html =~ "must be between 0 and 90"

    refute invalid_html =~
             ~r/id="slider-validate-form-live-invalid_volume"[^>]*data-invalid=""/
  end
end
