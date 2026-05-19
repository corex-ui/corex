defmodule E2eWeb.FileUploadFormLiveTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  test "save with no uploads pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/file-upload-live/form")

    view
    |> form("#file-upload-live-form")
    |> render_submit(%{})

    assert_push_event(view, "toast-create", %{
      description: "No files consumed",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end
end
