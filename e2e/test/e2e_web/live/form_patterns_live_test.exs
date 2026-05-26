defmodule E2eWeb.FormPatternsLiveTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  @invalid_params %{
    "country" => "",
    "currency" => "",
    "tags" => [],
    "terms" => "false",
    "notifications" => "false",
    "password" => ""
  }

  test "page renders both pattern sections", %{conn: conn} do
    {_view, html} = live_ok!(conn, ~p"/forms/patterns")
    assert html =~ "Custom error"
    assert html =~ "Invalid on error"
    assert html =~ "Preferred currency"
    assert html =~ "Email notifications"
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
        "patterns_invalid" => %{
          "country" => "fra",
          "currency" => "eur",
          "tags" => ["alpha"],
          "terms" => "true",
          "notifications" => "false",
          "password" => "secret123"
        }
      })

    assert html =~ "must be accepted to continue"
  end

  test "invalid form save with valid params pushes toast", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/forms/patterns")

    view
    |> form("#form-patterns-invalid-on-error")
    |> render_submit(%{
      "patterns_invalid" => %{
        "country" => "fra",
        "currency" => "eur",
        "tags" => ["alpha"],
        "terms" => "true",
        "notifications" => "true",
        "password" => "secret123"
      }
    })

    assert_push_event(view, "toast-create", %{
      description:
        "country=fra currency=eur tags=[\"alpha\"] terms=true notifications=true password=***",
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end
end
