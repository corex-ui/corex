defmodule E2eWeb.NumberInputFormLiveTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  test "changeset validate shows required error when value blank", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/number-input/live-form")

    html =
      view
      |> form("#number-input-live-changeset-form")
      |> render_change(%{"number_input_changeset" => %{"value" => ""}})

    assert html =~ "can&#39;t be blank"
  end

  test "changeset save with value pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/number-input/live-form")

    view
    |> form("#number-input-live-changeset-form")
    |> render_submit(%{"number_input_changeset" => %{"value" => "99"}})

    assert_push_event(view, "toast-create", %{
      description: "Submitted: 99.0",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "validate_strict reflects number range error on change", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/number-input/live-form")

    html =
      view
      |> form("#number-input-live-validate-form")
      |> render_change(%{"number_input_validate" => %{"value" => "0"}})

    assert html =~ "must be greater than or equal to"
  end

  test "save_strict with in-range value pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/number-input/live-form")

    view
    |> form("#number-input-live-validate-form")
    |> render_submit(%{"number_input_validate" => %{"value" => "50"}})

    assert_push_event(view, "toast-create", %{
      description: "Submitted (strict): 50.0",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "save_strict out of range shows number validation in markup", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/number-input/live-form")

    html =
      view
      |> form("#number-input-live-validate-form")
      |> render_submit(%{"number_input_validate" => %{"value" => "0"}})

    assert html =~ "must be greater than or equal to"
  end
end
