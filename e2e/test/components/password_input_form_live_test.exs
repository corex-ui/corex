defmodule E2eWeb.PasswordInputFormLiveTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  test "changeset validate shows required error when password blank", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/password-input/live-form")

    html =
      view
      |> form("#password-input-live-form")
      |> render_change(%{"password_input_live" => %{"password" => ""}})

    assert html =~ "can&#39;t be blank"
  end

  test "changeset save with password pushes toast-create", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/password-input/live-form")

    view
    |> form("#password-input-live-form")
    |> render_submit(%{"password_input_live" => %{"password" => "secret123"}})

    assert_push_event(view, "toast-create", %{
      description: "Submitted: password=***",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "validate_strict shows length error for short password", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/password-input/live-form")

    html =
      view
      |> form("#password-input-strict-form-live")
      |> render_change(%{"password_input_strict" => %{"password" => "short"}})

    assert html =~ "must be at least 8 characters"
  end

  test "save_strict with long password pushes toast-create", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/password-input/live-form")

    view
    |> form("#password-input-strict-form-live")
    |> render_submit(%{"password_input_strict" => %{"password" => "longenough"}})

    assert_push_event(view, "toast-create", %{
      description: "Submitted: password=***",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end
end
