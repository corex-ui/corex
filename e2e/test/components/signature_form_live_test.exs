defmodule E2eWeb.SignatureFormLiveTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  test "validate shows required error for empty signature", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/signature-pad/live-form")

    html =
      view
      |> form("#signature-form")
      |> render_change(%{"signature_form" => %{"signature" => ""}})

    assert html =~ "can&#39;t be blank"
  end

  test "save with signature data pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/signature-pad/live-form")

    view
    |> form("#signature-form")
    |> render_submit(%{"signature_form" => %{"signature" => "path-data-mv"}})

    assert_push_event(view, "toast-create", %{
      description: "Submitted: signature=path-data-mv...",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end
end
