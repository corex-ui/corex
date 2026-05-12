defmodule E2eWeb.ComboboxFormLiveTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  test "changeset validate shows required error for empty country", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/combobox/live-form")

    html =
      view
      |> form("#combobox-live-form")
      |> render_change(%{"combobox" => %{"country" => ""}})

    assert html =~ "can&#39;t be blank"
  end

  test "changeset save with country pushes toast-create", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/combobox/live-form")

    view
    |> form("#combobox-live-form")
    |> render_submit(%{"combobox" => %{"country" => "fra"}})

    assert_push_event(view, "toast-create", %{
      description: "Submitted: country=fra",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "validate_strict shows required error for empty country", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/combobox/live-form")

    html =
      view
      |> form("#combobox-strict-form-live")
      |> render_change(%{"combobox_strict" => %{"country" => ""}})

    assert html =~ "can&#39;t be blank"
  end

  test "save_strict with country pushes toast-create", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/combobox/live-form")

    view
    |> form("#combobox-strict-form-live")
    |> render_submit(%{"combobox_strict" => %{"country" => "deu"}})

    assert_push_event(view, "toast-create", %{
      description: "Submitted: country=deu",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end
end
