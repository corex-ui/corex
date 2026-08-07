defmodule E2eWeb.RadioGroupFormLiveTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  test "phoenix save without a choice does not crash", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/radio-group/live-form")

    view
    |> form("#radio-group-live-form-phoenix")
    |> render_submit()

    assert_push_event(view, "toast_create", %{
      description: "choice=",
      group_id: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "ecto save without a choice shows validation error", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/radio-group/live-form")

    html =
      view
      |> form("#radio-group-live-form-ecto")
      |> render_submit()

    assert html =~ "can&#39;t be blank"
    refute_push_event(view, "toast_create", %{})
  end

  test "ecto save with choice pushes toast_create", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/radio-group/live-form")

    view
    |> form("#radio-group-live-form-ecto")
    |> render_change(%{"radio_group_ecto" => %{"choice" => "duis"}})

    view
    |> form("#radio-group-live-form-ecto")
    |> render_submit(%{"radio_group_ecto" => %{"choice" => "duis"}})

    assert_push_event(view, "toast_create", %{
      description: "Submitted: choice=duis",
      group_id: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end
end
