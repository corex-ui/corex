defmodule E2eWeb.EditableFormLiveTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  test "ecto validate reflects text field in markup", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/editable/live-form")

    html =
      view
      |> form("#editable-live-form-ecto")
      |> render_change(%{"editable_ecto" => %{"text" => "LiveView copy"}})

    assert html =~ "LiveView copy"
  end

  test "ecto save pushes toast-create with submitted text", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/editable/live-form")

    view
    |> form("#editable-live-form-ecto")
    |> render_submit(%{"editable_ecto" => %{"text" => "Hello"}})

    assert_push_event(view, "toast-create", %{
      description: "Submitted: text=Hello",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end
end
