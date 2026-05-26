defmodule E2eWeb.CheckboxFormLiveTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  test "phoenix save unchecked keeps terms false in toast", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/checkbox/live-form")

    view
    |> form("#checkbox-live-form-phoenix")
    |> render_submit(%{"terms_phoenix" => %{"terms" => "false"}})

    assert_push_event(view, "toast-create", %{
      description: "terms=false",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "phoenix save with accepted terms pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/checkbox/live-form")

    view
    |> form("#checkbox-live-form-phoenix")
    |> render_submit(%{"terms_phoenix" => %{"terms" => "true"}})

    assert_push_event(view, "toast-create", %{
      description: "terms=true",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "ecto validate shows acceptance error when unchecked", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/checkbox/live-form")

    html =
      view
      |> form("#checkbox-live-form-ecto")
      |> render_change(%{"terms_ecto" => %{"terms" => "false"}})

    assert html =~ "must be accepted"
  end

  test "ecto save with accepted terms pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/checkbox/live-form")

    view
    |> form("#checkbox-live-form-ecto")
    |> render_submit(%{"terms_ecto" => %{"terms" => "true"}})

    assert_push_event(view, "toast-create", %{
      description: "Submitted: terms=true",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "ecto save when not accepted shows error markup", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/checkbox/live-form")

    html =
      view
      |> form("#checkbox-live-form-ecto")
      |> render_submit(%{"terms_ecto" => %{"terms" => "false"}})

    assert html =~ "must be accepted"
  end
end
