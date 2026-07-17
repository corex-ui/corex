defmodule E2eWeb.DatePickerFormLiveTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  defp invalid_form_html(html) do
    case Regex.run(
           ~r/<form[^>]*id="date-picker-validate-form-live-invalid"[^>]*>.*?<\/form>/s,
           html
         ) do
      [form] -> form
      _ -> flunk("invalid form not found in HTML")
    end
  end

  test "save_phoenix submits iso date and pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/date-picker/live-form")

    view
    |> form("#date-picker-live-form-phoenix")
    |> render_submit(%{"date_picker_phoenix" => %{"date" => "2024-06-01"}})

    assert_push_event(view, "toast-create", %{
      description: "Submitted: date=2024-06-01",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "validate_validate shows required error for empty date", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/date-picker/live-form")

    html =
      view
      |> form("#date-picker-validate-form-live")
      |> render_change(%{"date_picker_validate" => %{"date" => ""}})

    assert html =~ "can&#39;t be blank"
  end

  test "save_validate submits date and pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/date-picker/live-form")

    view
    |> form("#date-picker-validate-form-live")
    |> render_submit(%{"date_picker_validate" => %{"date" => "2025-12-25"}})

    assert_push_event(view, "toast-create", %{
      description: "Submitted: date=2025-12-25",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "invalid shows data-invalid after submit and clears on change", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/date-picker/live-form")

    html =
      view
      |> form("#date-picker-validate-form-live-invalid")
      |> render_submit(%{"date_picker_validate_invalid" => %{"date" => ""}})

    invalid_html = invalid_form_html(html)
    assert invalid_html =~ "can&#39;t be blank"

    assert invalid_html =~
             ~r/id="date-picker-validate-form-live-invalid_date"[^>]*data-invalid=""/

    html =
      view
      |> form("#date-picker-validate-form-live-invalid")
      |> render_change(%{"date_picker_validate_invalid" => %{"date" => "2025-06-01"}})

    invalid_html = invalid_form_html(html)
    refute invalid_html =~ "can&#39;t be blank"

    refute invalid_html =~
             ~r/id="date-picker-validate-form-live-invalid_date"[^>]*data-invalid=""/
  end
end
