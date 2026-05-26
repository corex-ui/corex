defmodule E2eWeb.PasswordInputFormLiveTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  test "ecto validate shows required error when password blank", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/password-input/live-form")

    html =
      view
      |> form("#password-input-live-form-ecto")
      |> render_change(%{"password_input_ecto" => %{"password" => ""}})

    assert html =~ "can&#39;t be blank"
  end

  test "ecto save with password pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/password-input/live-form")

    view
    |> form("#password-input-live-form-ecto")
    |> render_submit(%{"password_input_ecto" => %{"password" => "secret123"}})

    assert_push_event(view, "toast-create", %{
      description: "password=***",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "ecto validate shows length error for short password", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/password-input/live-form")

    html =
      view
      |> form("#password-input-live-form-ecto")
      |> render_change(%{"password_input_ecto" => %{"password" => "short"}})

    assert html =~ "must be at least 8 characters"
  end

  test "ecto save with long password pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/password-input/live-form")

    view
    |> form("#password-input-live-form-ecto")
    |> render_submit(%{"password_input_ecto" => %{"password" => "longenough"}})

    assert_push_event(view, "toast-create", %{
      description: "password=***",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end
end
