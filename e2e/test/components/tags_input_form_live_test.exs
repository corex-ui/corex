defmodule E2eWeb.TagsInputFormLiveTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  test "ecto validate accepts tags list param on changeset form", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/tags-input/live-form")

    html =
      view
      |> form("#tags-input-live-form-ecto")
      |> render_change(%{"tags_input_ecto" => %{"tags" => ["one", "two"]}})

    assert html =~ "tags-input-live-form-ecto_tags"
  end

  test "ecto save with empty tags shows can't be blank", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/tags-input/live-form")

    html =
      view
      |> form("#tags-input-live-form-ecto")
      |> render_submit(%{"tags_input_ecto" => %{"tags" => [""]}})

    assert html =~ "tags-input-live-form-ecto"
    assert html =~ "can&#39;t be blank" or html =~ "can't be blank"
  end

  test "ecto validate with empty tags shows can't be blank", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/tags-input/live-form")

    html =
      view
      |> form("#tags-input-live-form-ecto")
      |> render_change(%{"tags_input_ecto" => %{"tags" => [""]}})

    assert html =~ "can&#39;t be blank" or html =~ "can't be blank"
  end

  test "phoenix save pushes toast-create and keeps form usable", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/tags-input/live-form")

    view
    |> form("#tags-input-live-form-phoenix")
    |> render_submit(%{"tags_input_phoenix" => %{"tags" => ["alpha", "beta"]}})

    assert_push_event(view, "toast-create", %{
      description: "tags=[\"alpha\", \"beta\"]",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })

    html =
      view
      |> form("#tags-input-live-form-phoenix")
      |> render_submit(%{"tags_input_phoenix" => %{"tags" => ["alpha", "beta", "gamma"]}})

    assert html =~ "tags-input-live-form-phoenix"
  end

  test "ecto save pushes toast-create with tags description", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/tags-input/live-form")

    view
    |> form("#tags-input-live-form-ecto")
    |> render_submit(%{"tags_input_ecto" => %{"tags" => ["alpha", "beta"]}})

    assert_push_event(view, "toast-create", %{
      description: "Submitted: tags=[\"alpha\", \"beta\"]",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end
end
