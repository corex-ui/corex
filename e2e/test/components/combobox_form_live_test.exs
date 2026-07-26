defmodule E2eWeb.ComboboxFormLiveTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  test "ecto validate shows required error for empty country", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/combobox/live-form")

    html =
      view
      |> form("#combobox-live-form-ecto")
      |> render_change(%{"combobox_ecto" => %{"country" => ""}})

    assert html =~ "can&#39;t be blank"
  end

  test "ecto save with country pushes toast_create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/combobox/live-form")

    view
    |> form("#combobox-live-form-ecto")
    |> render_submit(%{"combobox_ecto" => %{"country" => "fra"}})

    assert_push_event(view, "toast_create", %{
      description: "Submitted: country=fra",
      duration: 5000,
      group_id: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end
end
