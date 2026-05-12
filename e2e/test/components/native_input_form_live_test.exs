defmodule E2eWeb.NativeInputFormLiveTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  test "validate shows required error when name blank", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/native-input/live-form")

    html =
      view
      |> form("#native-input-live-profile-form")
      |> render_change(%{"profile" => %{"name" => "", "email" => "u@x.com", "agree" => "false"}})

    assert html =~ "can&#39;t be blank"
  end

  test "save with required profile fields pushes toast-create", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/native-input/live-form")
    %{proxy: {ref, _, _}} = view

    view
    |> form("#native-input-live-profile-form")
    |> render_submit(%{
      "profile" => %{"name" => "Ada", "email" => "ada@ex.com", "agree" => "true"}
    })

    assert_receive {^ref, {:push_event, "toast-create", payload}}, 200
    assert payload.title == "Submitted"
    assert payload.type == "info"
    assert payload.groupId == "layout-toast"
    assert payload.duration == 5000
    desc = payload.description
    assert desc =~ "name=\"Ada\""
    assert desc =~ "email=\"ada@ex.com\""
    assert desc =~ "agree=true"
  end

  test "validate_strict shows email format error", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/native-input/live-form")

    html =
      view
      |> form("#native-input-live-strict-form")
      |> render_change(%{
        "profile_strict" => %{
          "name" => "Ada",
          "email" => "not-an-email",
          "bio" => "abc",
          "role" => "admin",
          "count" => "5",
          "agree" => "true"
        }
      })

    assert html =~ "must look like an email address"
  end

  test "save_strict with valid profile pushes toast-create", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/native-input/live-form")
    %{proxy: {ref, _, _}} = view

    view
    |> form("#native-input-live-strict-form")
    |> render_submit(%{
      "profile_strict" => %{
        "name" => "Ada",
        "email" => "ada@ex.com",
        "bio" => "Short bio here",
        "role" => "admin",
        "count" => "5",
        "agree" => "true"
      }
    })

    assert_receive {^ref, {:push_event, "toast-create", payload}}, 200
    assert payload.title == "Submitted"
    desc = payload.description
    assert desc =~ "name=\"Ada\""
    assert desc =~ "email=\"ada@ex.com\""
    assert desc =~ "bio=\"Short bio here\""
    assert desc =~ "count=5"
    assert desc =~ "role=\"admin\""
    assert desc =~ "agree=true"
  end
end
