defmodule E2eWeb.CheckboxFormLiveTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  test "changeset validate shows acceptance error when unchecked", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/checkbox/live-form")

    html =
      view
      |> form("#checkbox-live-form")
      |> render_change(%{"terms" => %{"terms" => "false"}})

    assert html =~ "must be accepted"
  end

  test "changeset save with accepted terms pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/checkbox/live-form")

    view
    |> form("#checkbox-live-form")
    |> render_submit(%{"terms" => %{"terms" => "true"}})

    assert_push_event(view, "toast-create", %{
      description: "Submitted: terms=true",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "changeset save when not accepted shows error markup", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/checkbox/live-form")

    html =
      view
      |> form("#checkbox-live-form")
      |> render_submit(%{"terms" => %{"terms" => "false"}})

    assert html =~ "must be accepted"
  end

  test "validate_strict shows custom acceptance message", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/checkbox/live-form")

    html =
      view
      |> form("#checkbox-strict-form-live")
      |> render_change(%{"terms_strict" => %{"terms" => "false"}})

    assert html =~ "must be accepted to continue"
  end

  test "save_strict with accepted terms pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/checkbox/live-form")

    view
    |> form("#checkbox-strict-form-live")
    |> render_submit(%{"terms_strict" => %{"terms" => "true"}})

    assert_push_event(view, "toast-create", %{
      description: "Submitted: terms=true",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "save_strict when not accepted shows strict messages", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/checkbox/live-form")

    html =
      view
      |> form("#checkbox-strict-form-live")
      |> render_submit(%{"terms_strict" => %{"terms" => "false"}})

    assert html =~ "must be accepted to continue"
  end
end
