defmodule E2eWeb.NumberInputFormLiveTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  test "ecto validate shows required error when value blank", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/number-input/live-form")

    html =
      view
      |> form("#number-input-live-form-ecto")
      |> render_change(%{"number_input_ecto" => %{"value" => ""}})

    assert html =~ "can&#39;t be blank"
  end

  test "ecto save with value pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/number-input/live-form")

    view
    |> form("#number-input-live-form-ecto")
    |> render_submit(%{"number_input_ecto" => %{"value" => "99"}})

    assert_push_event(view, "toast-create", %{
      description: "Submitted: value=99.0",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "ecto validate reflects number range error on change", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/number-input/live-form")

    html =
      view
      |> form("#number-input-live-form-ecto")
      |> render_change(%{"number_input_ecto" => %{"value" => "0"}})

    assert html =~ "must be greater than or equal to"
  end

  test "ecto save with in-range value pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/number-input/live-form")

    view
    |> form("#number-input-live-form-ecto")
    |> render_submit(%{"number_input_ecto" => %{"value" => "50"}})

    assert_push_event(view, "toast-create", %{
      description: "Submitted: value=50.0",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "phoenix save default value pushes toast-create", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/number-input/live-form")

    view
    |> form("#number-input-live-form-phoenix")
    |> render_change(%{"number_input_phoenix" => %{"value" => "1234"}})

    view
    |> form("#number-input-live-form-phoenix")
    |> render_submit(%{"number_input_phoenix" => %{"value" => "1234"}})

    assert_push_event(view, "toast-create", %{
      description: "value=\"1234\"",
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "phoenix save with changed value pushes toast-create", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/number-input/live-form")

    view
    |> form("#number-input-live-form-phoenix")
    |> render_change(%{"number_input_phoenix" => %{"value" => "42"}})

    view
    |> form("#number-input-live-form-phoenix")
    |> render_submit(%{"number_input_phoenix" => %{"value" => "42"}})

    assert_push_event(view, "toast-create", %{
      description: "value=\"42\"",
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "ecto save out of range shows number validation in markup", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/number-input/live-form")

    html =
      view
      |> form("#number-input-live-form-ecto")
      |> render_submit(%{"number_input_ecto" => %{"value" => "0"}})

    assert html =~ "must be greater than or equal to"
  end
end
