defmodule E2eWeb.DatePickerFormLiveTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

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
end
