defmodule E2eWeb.SelectFormLiveTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  test "changeset validate shows required error for empty country", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/select/live-form")

    html =
      view
      |> form("#select-form")
      |> render_change(%{"select_form" => %{"country" => ""}})

    assert html =~ "can&#39;t be blank"
  end

  test "changeset save with country pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/select/live-form")

    view
    |> form("#select-form")
    |> render_submit(%{"select_form" => %{"country" => "fra"}})

    assert_push_event(view, "toast-create", %{
      description: "Submitted: country=fra",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "validate_strict shows required error for empty country", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/select/live-form")

    html =
      view
      |> form("#select-strict-form-live")
      |> render_change(%{"select_strict" => %{"country" => ""}})

    assert html =~ "can&#39;t be blank"
  end

  test "save_strict with country pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/select/live-form")

    view
    |> form("#select-strict-form-live")
    |> render_submit(%{"select_strict" => %{"country" => "deu"}})

    assert_push_event(view, "toast-create", %{
      description: "Submitted: country=deu",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end
end
