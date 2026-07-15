defmodule E2eWeb.CheckboxFormLiveTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  defp controlled_form_html(html) do
    case Regex.run(~r/<form[^>]*id="checkbox-live-form-ecto-controlled"[^>]*>.*?<\/form>/s, html) do
      [form] -> form
      _ -> flunk("controlled form not found in HTML")
    end
  end

  defp ecto_invalid_form_html(html) do
    case Regex.run(~r/<form[^>]*id="checkbox-live-form-ecto-invalid"[^>]*>.*?<\/form>/s, html) do
      [form] -> form
      _ -> flunk("ecto invalid form not found in HTML")
    end
  end

  test "phoenix save unchecked keeps terms false in toast", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/checkbox/live-form")

    view
    |> form("#checkbox-live-form-phoenix")
    |> render_submit(%{"terms_phoenix" => %{"terms" => "false"}})

    assert_push_event(view, "toast-create", %{
      description: "terms=false",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "phoenix save with accepted terms pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/checkbox/live-form")

    view
    |> form("#checkbox-live-form-phoenix")
    |> render_submit(%{"terms_phoenix" => %{"terms" => "true"}})

    assert_push_event(view, "toast-create", %{
      description: "terms=true",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "ecto validate shows acceptance error when unchecked", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/checkbox/live-form")

    html =
      view
      |> form("#checkbox-live-form-ecto")
      |> render_change(%{"terms_ecto" => %{"terms" => "false"}})

    assert html =~ "must be accepted"
  end

  test "ecto save with accepted terms pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/checkbox/live-form")

    view
    |> form("#checkbox-live-form-ecto")
    |> render_submit(%{"terms_ecto" => %{"terms" => "true"}})

    assert_push_event(view, "toast-create", %{
      description: "Submitted: terms=true",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "ecto save when not accepted shows error markup", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/checkbox/live-form")

    html =
      view
      |> form("#checkbox-live-form-ecto")
      |> render_submit(%{"terms_ecto" => %{"terms" => "false"}})

    assert html =~ "must be accepted"
  end

  test "ecto controlled validate shows acceptance error when unchecked", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/checkbox/live-form")

    html =
      view
      |> form("#checkbox-live-form-ecto-controlled")
      |> render_change(%{"terms_ecto_controlled" => %{"terms" => "false"}})

    assert html =~ "must be accepted"
  end

  test "ecto controlled save when not accepted shows error markup", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/checkbox/live-form")

    html =
      view
      |> form("#checkbox-live-form-ecto-controlled")
      |> render_submit(%{"terms_ecto_controlled" => %{"terms" => "false"}})

    assert html =~ "must be accepted"
  end

  test "ecto controlled checking clears error and syncs checked state", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/checkbox/live-form")

    html =
      view
      |> form("#checkbox-live-form-ecto-controlled")
      |> render_submit(%{"terms_ecto_controlled" => %{"terms" => "false"}})

    controlled_html = controlled_form_html(html)
    assert controlled_html =~ "must be accepted"

    html =
      view
      |> form("#checkbox-live-form-ecto-controlled")
      |> render_change(%{"terms_ecto_controlled" => %{"terms" => "true"}})

    controlled_html = controlled_form_html(html)
    refute controlled_html =~ "must be accepted"
    assert controlled_html =~ ~s/data-checked="true"/
    assert controlled_html =~ ~s/data-state="checked"/
  end

  test "ecto controlled save with accepted terms pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/checkbox/live-form")

    view
    |> form("#checkbox-live-form-ecto-controlled")
    |> render_submit(%{"terms_ecto_controlled" => %{"terms" => "true"}})

    assert_push_event(view, "toast-create", %{
      description: "Submitted: terms=true",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "ecto invalid shows data-invalid after submit", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/checkbox/live-form")

    html =
      view
      |> form("#checkbox-live-form-ecto-invalid")
      |> render_submit(%{"terms_ecto_invalid" => %{"terms" => "false"}})

    ecto_invalid_html = ecto_invalid_form_html(html)
    assert ecto_invalid_html =~ "must be accepted"
    assert ecto_invalid_html =~ ~r/id="checkbox-live-form-ecto-invalid_terms"[^>]*data-invalid=""/
  end

  test "ecto invalid checking clears error and data-invalid", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/checkbox/live-form")

    html =
      view
      |> form("#checkbox-live-form-ecto-invalid")
      |> render_submit(%{"terms_ecto_invalid" => %{"terms" => "false"}})

    ecto_invalid_html = ecto_invalid_form_html(html)
    assert ecto_invalid_html =~ "must be accepted"
    assert ecto_invalid_html =~ ~r/id="checkbox-live-form-ecto-invalid_terms"[^>]*data-invalid=""/

    html =
      view
      |> form("#checkbox-live-form-ecto-invalid")
      |> render_change(%{"terms_ecto_invalid" => %{"terms" => "true"}})

    ecto_invalid_html = ecto_invalid_form_html(html)
    refute ecto_invalid_html =~ "must be accepted"
    refute ecto_invalid_html =~ ~r/id="checkbox-live-form-ecto-invalid_terms"[^>]*data-invalid=""/
  end

  test "ecto invalid save with accepted terms pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/checkbox/live-form")

    view
    |> form("#checkbox-live-form-ecto-invalid")
    |> render_submit(%{"terms_ecto_invalid" => %{"terms" => "true"}})

    assert_push_event(view, "toast-create", %{
      description: "Submitted: terms=true",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end
end
