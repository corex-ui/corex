defmodule E2eWeb.SwitchFormLivePushTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  @form_id "#switch-live-form-ecto"

  test "ecto validate shows acceptance error when unchecked", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/switch/live-form")

    html =
      view
      |> form(@form_id)
      |> render_change(%{"preferences_ecto" => %{"notifications" => "false"}})

    assert html =~ "must be accepted"
    refute html =~ ~r/\bdata-invalid=""/
  end

  test "ecto save when not accepted shows error markup", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/switch/live-form")

    html = view |> form(@form_id) |> render_submit()

    assert html =~ "must be accepted"
    refute html =~ ~r/\bdata-invalid=""/
    refute_push_event(view, "toast-create", %{})
  end

  test "validate shows cast error for invalid boolean", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/switch/live-form")

    html =
      view
      |> form(@form_id)
      |> render_change(%{"preferences_ecto" => %{"notifications" => "invalid"}})

    assert html =~ "is invalid"
  end

  test "save with notifications true pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/switch/live-form")

    view
    |> form(@form_id)
    |> render_submit(%{"preferences_ecto" => %{"notifications" => "true"}})

    assert_push_event(view, "toast-create", %{
      description: "Submitted: notifications=true",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "save with invalid boolean shows error markup", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/switch/live-form")

    html =
      view
      |> form(@form_id)
      |> render_submit(%{"preferences_ecto" => %{"notifications" => "invalid"}})

    assert html =~ "is invalid"
  end
end
