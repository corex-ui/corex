defmodule E2eWeb.SelectFormLiveTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  @form_id "#select-live-form-ecto"
  @controlled_form_id "#select-live-form-ecto-controlled"
  @invalid_form_id "#select-live-form-ecto-invalid"

  defp controlled_form_html(html) do
    case Regex.run(~r/<form[^>]*id="select-live-form-ecto-controlled"[^>]*>.*?<\/form>/s, html) do
      [form] -> form
      _ -> flunk("controlled form not found in HTML")
    end
  end

  defp invalid_form_html(html) do
    case Regex.run(~r/<form[^>]*id="select-live-form-ecto-invalid"[^>]*>.*?<\/form>/s, html) do
      [form] -> form
      _ -> flunk("invalid form not found in HTML")
    end
  end

  test "ecto validate shows required error for empty country", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/select/live-form")

    html =
      view
      |> form(@form_id)
      |> render_change(%{"select_ecto" => %{"country" => ""}})

    assert html =~ "can&#39;t be blank"
  end

  test "ecto save with country pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/select/live-form")

    view
    |> form(@form_id)
    |> render_submit(%{"select_ecto" => %{"country" => "fra"}})

    assert_push_event(view, "toast-create", %{
      description: "country=fra",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "ecto controlled submit empty shows required error", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/select/live-form")

    html =
      view
      |> form(@controlled_form_id)
      |> render_submit(%{"select_ecto_controlled" => %{"country" => ""}})

    controlled_html = controlled_form_html(html)
    assert controlled_html =~ "can&#39;t be blank"
  end

  test "ecto controlled change with country clears error and syncs value", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/select/live-form")

    html =
      view
      |> form(@controlled_form_id)
      |> render_submit(%{"select_ecto_controlled" => %{"country" => ""}})

    assert controlled_form_html(html) =~ "can&#39;t be blank"

    html =
      view
      |> form(@controlled_form_id)
      |> render_change(%{"select_ecto_controlled" => %{"country" => "fra"}})

    controlled_html = controlled_form_html(html)
    refute controlled_html =~ "can&#39;t be blank"

    assert controlled_html =~
             ~r/id="select-live-form-ecto-controlled_country"[^>]*data-value="fra"/
  end

  test "ecto controlled save with country pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/select/live-form")

    view
    |> form(@controlled_form_id)
    |> render_submit(%{"select_ecto_controlled" => %{"country" => "fra"}})

    assert_push_event(view, "toast-create", %{
      description: "country=fra",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "ecto invalid shows data-invalid after submit", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/select/live-form")

    html =
      view
      |> form(@invalid_form_id)
      |> render_submit(%{"select_ecto_invalid" => %{"country" => ""}})

    invalid_html = invalid_form_html(html)
    assert invalid_html =~ "can&#39;t be blank"
    assert invalid_html =~ ~r/id="select-live-form-ecto-invalid_country"[^>]*data-invalid=""/
  end

  test "ecto invalid change with country clears error and data-invalid", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/select/live-form")

    html =
      view
      |> form(@invalid_form_id)
      |> render_submit(%{"select_ecto_invalid" => %{"country" => ""}})

    invalid_html = invalid_form_html(html)
    assert invalid_html =~ "can&#39;t be blank"
    assert invalid_html =~ ~r/id="select-live-form-ecto-invalid_country"[^>]*data-invalid=""/

    html =
      view
      |> form(@invalid_form_id)
      |> render_change(%{"select_ecto_invalid" => %{"country" => "fra"}})

    invalid_html = invalid_form_html(html)
    refute invalid_html =~ "can&#39;t be blank"
    refute invalid_html =~ ~r/id="select-live-form-ecto-invalid_country"[^>]*data-invalid=""/
    assert invalid_html =~ ~s/data-value="fra"/
  end
end
