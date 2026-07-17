defmodule E2eWeb.SwitchFormLivePushTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  @form_id "#switch-live-form-ecto"

  defp controlled_form_html(html) do
    case Regex.run(~r/<form[^>]*id="switch-live-form-ecto-controlled"[^>]*>.*?<\/form>/s, html) do
      [form] -> form
      _ -> flunk("controlled form not found in HTML")
    end
  end

  defp ecto_invalid_form_html(html) do
    case Regex.run(~r/<form[^>]*id="switch-live-form-ecto-invalid"[^>]*>.*?<\/form>/s, html) do
      [form] -> form
      _ -> flunk("ecto invalid form not found in HTML")
    end
  end

  test "ecto validate shows acceptance error when unchecked", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/switch/live-form")

    html =
      view
      |> form(@form_id)
      |> render_change(%{"preferences_ecto" => %{"notifications" => "false"}})

    assert html =~ "must be accepted"
    refute html =~ ~r/\bdata-invalid=""/
  end

  test "ecto save when not accepted shows error markup", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/switch/live-form")

    html = view |> form(@form_id) |> render_submit()

    assert html =~ "must be accepted"
    refute html =~ ~r/\bdata-invalid=""/
    refute_push_event(view, "toast-create", %{})
  end

  test "validate shows cast error for invalid boolean", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/switch/live-form")

    html =
      view
      |> form(@form_id)
      |> render_change(%{"preferences_ecto" => %{"notifications" => "invalid"}})

    assert html =~ "is invalid"
  end

  test "save with notifications true pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/switch/live-form")

    view
    |> form(@form_id)
    |> render_submit(%{"preferences_ecto" => %{"notifications" => "true"}})

    assert_push_event(view, "toast-create", %{
      description: "Submitted: notifications=true",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "save with invalid boolean shows error markup", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/switch/live-form")

    html =
      view
      |> form(@form_id)
      |> render_submit(%{"preferences_ecto" => %{"notifications" => "invalid"}})

    assert html =~ "is invalid"
  end

  test "ecto controlled validate shows acceptance error when unchecked", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/switch/live-form")

    html =
      view
      |> form("#switch-live-form-ecto-controlled")
      |> render_change(%{"preferences_ecto_controlled" => %{"notifications" => "false"}})

    assert html =~ "must be accepted"
  end

  test "ecto controlled save when not accepted shows error markup", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/switch/live-form")

    html =
      view
      |> form("#switch-live-form-ecto-controlled")
      |> render_submit(%{"preferences_ecto_controlled" => %{"notifications" => "false"}})

    assert html =~ "must be accepted"
  end

  test "ecto controlled checking clears error and syncs checked state", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/switch/live-form")

    html =
      view
      |> form("#switch-live-form-ecto-controlled")
      |> render_submit(%{"preferences_ecto_controlled" => %{"notifications" => "false"}})

    controlled_html = controlled_form_html(html)
    assert controlled_html =~ "must be accepted"

    html =
      view
      |> form("#switch-live-form-ecto-controlled")
      |> render_change(%{"preferences_ecto_controlled" => %{"notifications" => "true"}})

    controlled_html = controlled_form_html(html)
    refute controlled_html =~ "must be accepted"
    assert controlled_html =~ ~S/data-checked="true"/
    assert controlled_html =~ ~S/data-state="checked"/
  end

  test "ecto controlled save with accepted notifications pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/switch/live-form")

    view
    |> form("#switch-live-form-ecto-controlled")
    |> render_submit(%{"preferences_ecto_controlled" => %{"notifications" => "true"}})

    assert_push_event(view, "toast-create", %{
      description: "Submitted: notifications=true",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "ecto invalid shows data-invalid after submit", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/switch/live-form")

    html =
      view
      |> form("#switch-live-form-ecto-invalid")
      |> render_submit(%{"preferences_ecto_invalid" => %{"notifications" => "false"}})

    ecto_invalid_html = ecto_invalid_form_html(html)
    assert ecto_invalid_html =~ "must be accepted"

    assert ecto_invalid_html =~
             ~r/id="switch-live-form-ecto-invalid_notifications"[^>]*data-invalid=""/
  end

  test "ecto invalid checking clears error and data-invalid", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/switch/live-form")

    html =
      view
      |> form("#switch-live-form-ecto-invalid")
      |> render_submit(%{"preferences_ecto_invalid" => %{"notifications" => "false"}})

    ecto_invalid_html = ecto_invalid_form_html(html)
    assert ecto_invalid_html =~ "must be accepted"

    assert ecto_invalid_html =~
             ~r/id="switch-live-form-ecto-invalid_notifications"[^>]*data-invalid=""/

    html =
      view
      |> form("#switch-live-form-ecto-invalid")
      |> render_change(%{"preferences_ecto_invalid" => %{"notifications" => "true"}})

    ecto_invalid_html = ecto_invalid_form_html(html)
    refute ecto_invalid_html =~ "must be accepted"

    refute ecto_invalid_html =~
             ~r/id="switch-live-form-ecto-invalid_notifications"[^>]*data-invalid=""/
  end

  test "ecto invalid save with accepted notifications pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/switch/live-form")

    view
    |> form("#switch-live-form-ecto-invalid")
    |> render_submit(%{"preferences_ecto_invalid" => %{"notifications" => "true"}})

    assert_push_event(view, "toast-create", %{
      description: "Submitted: notifications=true",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end
end
