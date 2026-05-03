defmodule E2eWeb.SwitchFormLivePushTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  test "live changeset submit without toggle pushes toast-create", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/switch/live-form")

    view |> form("#switch-form-live") |> render_submit()

    assert_push_event(view, "toast-create", %{
      description: "",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted: notifications=false",
      type: "info"
    })
  end
end
