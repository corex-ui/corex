defmodule E2eWeb.NativeInputFormLiveTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  test "save_phoenix submits profile and pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/native-input/live-form")
    %{proxy: {ref, _, _}} = view

    view
    |> form("#native-input-live-form-phoenix")
    |> render_submit(%{
      "profile_phoenix" => %{
        "name" => "Ada",
        "email" => "ada@ex.com",
        "bio" => "Short bio",
        "role" => "admin",
        "count" => "5",
        "size" => "m",
        "agree" => "true"
      }
    })

    assert_receive {^ref, {:push_event, "toast-create", payload}}, 200
    assert payload.title == "Submitted"
    assert payload.type == "info"
    assert payload.groupId == "layout-toast"
    assert payload.duration == 5000
    assert payload.description =~ "name=\"Ada\""
    assert payload.description =~ "email=\"ada@ex.com\""
    assert payload.description =~ "size=\"m\""
  end

  test "validate shows email format error", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/native-input/live-form")

    html =
      view
      |> form("#native-input-live-form-ecto")
      |> render_change(%{
        "profile_ecto" => %{
          "name" => "Ada",
          "email" => "not-an-email",
          "bio" => "abc",
          "role" => "admin",
          "count" => "5",
          "size" => "m",
          "agree" => "true"
        }
      })

    assert html =~ "must look like an email address"
  end

  test "save with valid profile pushes toast-create including size and tags", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/native-input/live-form")
    %{proxy: {ref, _, _}} = view

    view
    |> form("#native-input-live-form-ecto")
    |> render_submit(%{
      "profile_ecto" => E2e.Form.NativeInputProfile.valid_attrs()
    })

    assert_receive {^ref, {:push_event, "toast-create", payload}}, 200
    assert payload.title == "Submitted"
    desc = payload.description
    assert desc =~ "name=\"Ada\""
    assert desc =~ "email=\"ada@ex.com\""
    assert desc =~ "bio=\"Short bio here\""
    assert desc =~ "birth_date=\"1990-01-15\""
    assert desc =~ "count=5"
    assert desc =~ "role=\"admin\""
    assert desc =~ "size=\"l\""
    assert desc =~ "tags=[\"elixir\", \"phoenix\"]"
    assert desc =~ "agree=true"
  end
end
