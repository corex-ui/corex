defmodule E2eWeb.SelectFormLiveTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  test "ecto validate shows required error for empty country", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/select/live-form")

    html =
      view
      |> form("#select-live-form-ecto")
      |> render_change(%{"select_ecto" => %{"country" => ""}})

    assert html =~ "can&#39;t be blank"
  end

  test "ecto save with country pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/select/live-form")

    view
    |> form("#select-live-form-ecto")
    |> render_submit(%{"select_ecto" => %{"country" => "fra"}})

    assert_push_event(view, "toast-create", %{
      description: "country=fra",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end
end
