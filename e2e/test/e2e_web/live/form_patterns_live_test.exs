defmodule E2eWeb.FormPatternsLiveTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  @invalid_params %{
    "name" => "",
    "country" => "",
    "currency" => "",
    "tags" => [],
    "birth_date" => "",
    "signature" => [],
    "level" => "",
    "terms" => "false",
    "notifications" => "false",
    "password" => "",
    "role" => "",
    "pin" => "",
    "accent_color" => "",
    "heading_angle" => "",
    "title" => "",
    "avatar" => ""
  }

  @valid_params %{
    "name" => "Ada",
    "country" => "fra",
    "currency" => "eur",
    "tags" => ["alpha"],
    "birth_date" => "1990-01-15",
    "signature" => ["M0,0L1,1Z"],
    "level" => "3",
    "terms" => "true",
    "notifications" => "true",
    "password" => "secret123",
    "role" => "editor",
    "pin" => "1234",
    "accent_color" => "#3b82f6",
    "heading_angle" => "90",
    "title" => "Lead",
    "avatar" => "avatar.png"
  }

  test "page renders both pattern sections", %{conn: conn} do
    {_view, html} = live_ok!(conn, ~p"/forms/patterns")
    assert html =~ "Custom error"
    assert html =~ "Invalid on error"
    assert html =~ "Preferred currency"
    assert html =~ "Email notifications"
    assert html =~ "Accent color"
    assert html =~ "Avatar"
  end

  test "custom error shows tooltips without data-invalid on controls", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/forms/patterns")

    html =
      view
      |> form("#form-patterns-custom-error")
      |> render_change(%{"patterns_custom" => @invalid_params})

    assert html =~ "can&#39;t be blank"
    assert html =~ "must be accepted to continue"
    assert html =~ ~S|id="form-patterns-custom-error-currency-tip"|
    assert html =~ ~S|id="form-patterns-custom-error-notifications-tip"|
    assert html =~ ~S|id="form-patterns-custom-error-avatar-tip"|
    refute html =~ ~r/id="form-patterns-custom-error-currency"[^>]*data-invalid=""/
  end

  test "invalid on error shows inline errors and data-invalid on controls", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/forms/patterns")

    html =
      view
      |> form("#form-patterns-invalid-on-error")
      |> render_change(%{"patterns_invalid" => @invalid_params})

    assert html =~ "can&#39;t be blank"
    assert html =~ "must be accepted to continue"
    assert html =~ ~r/\bdata-invalid=""/
  end

  test "notifications acceptance error when switch left off", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/forms/patterns")

    html =
      view
      |> form("#form-patterns-invalid-on-error")
      |> render_change(%{
        "patterns_invalid" => Map.put(@valid_params, "notifications", "false")
      })

    assert html =~ "must be accepted to continue"
  end

  test "invalid form save with valid params pushes toast", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/forms/patterns")

    view
    |> form("#form-patterns-invalid-on-error")
    |> render_submit(%{"patterns_invalid" => @valid_params})

    assert_push_event(view, "toast_create", %{
      description:
        "name=Ada country=fra currency=eur tags=[\"alpha\"] birth_date=1990-01-15 level=3 terms=true notifications=true role=editor pin=*** accent_color=#3b82f6 heading_angle=90.0 title=Lead avatar=avatar.png password=***",
      group_id: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end
end
