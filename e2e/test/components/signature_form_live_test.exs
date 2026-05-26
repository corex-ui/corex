defmodule E2eWeb.SignatureFormLiveTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  test "ecto validate shows required error for empty signature", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/signature-pad/live-form")

    html =
      view
      |> form("#signature-live-form-ecto")
      |> render_change(%{"signature_ecto" => %{"signature" => ""}})

    assert html =~ "can&#39;t be blank"
  end

  test "ecto save with signature data pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/signature-pad/live-form")

    view
    |> form("#signature-live-form-ecto")
    |> render_submit(%{"signature_ecto" => %{"signature" => ["path-data-mv"]}})

    assert_push_event(view, "toast-create", %{
      description: "signature=[\"path-data-mv\"]",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "phoenix save pushes toast with path array", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/signature-pad/live-form")

    view
    |> form("#signature-live-form-phoenix")
    |> render_submit(%{"signature_phoenix" => %{"signature" => ["M0,0L1,1Z"]}})

    assert_push_event(view, "toast-create", %{
      description: "signature=[\"M0,0L1,1Z\"]",
      title: "Submitted",
      type: "info"
    })
  end
end
