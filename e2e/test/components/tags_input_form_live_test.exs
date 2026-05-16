defmodule E2eWeb.TagsInputFormLiveTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  test "validate accepts tags param on changeset form", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/tags-input/live-form")

    html =
      view
      |> form("#tags-input-live-changeset-form")
      |> render_change(%{"tags_input_changeset" => %{"tags" => "one,two"}})

    assert html =~ "tags-input-live-changeset-form_tags"
  end

  test "save pushes toast-create with tags description", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/tags-input/live-form")

    view
    |> form("#tags-input-live-changeset-form")
    |> render_submit(%{"tags_input_changeset" => %{"tags" => "alpha,beta"}})

    assert_push_event(view, "toast-create", %{
      description: "Submitted: tags=alpha,beta",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end
end
