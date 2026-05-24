defmodule E2eWeb.NativeInputFormLiveTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  test "save_phoenix submits email and pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/native-input/live-form")
    %{proxy: {ref, _, _}} = view

    view
    |> form("#native-input-live-form-phoenix")
    |> render_submit(%{"native_input_phoenix" => %{"email" => "ada@ex.com"}})

    assert_receive {^ref, {:push_event, "toast-create", payload}}, 200
    assert payload.title == "Submitted"
    assert payload.type == "info"
    assert payload.groupId == "layout-toast"
    assert payload.duration == 5000
    assert payload.description == "Submitted: email=ada@ex.com"
  end

  test "validate_strict shows email format error", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/native-input/live-form")

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
    {view, _html} = live_ok!(conn, ~p"/native-input/live-form")
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
