defmodule E2eWeb.FileUploadFormLiveTest do
  use E2eWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  test "phoenix save with no uploads pushes toast-create", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/file-upload-live/form")

    view
    |> form("#file-upload-live-form-phoenix")
    |> render_submit(%{})

    assert_push_event(view, "toast-create", %{
      description: "attachment=(none)",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "ecto save after file_upload_changed shows toast with filenames", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/file-upload-live/form")

    render_hook(view, "file_upload_changed", %{
      "id" => "file-upload-live-form-ecto_attachment",
      "acceptedNames" => ["report.pdf"]
    })

    view
    |> form("#file-upload-live-form-ecto")
    |> render_submit(%{"file_upload_ecto" => %{}})

    assert_push_event(view, "toast-create", %{
      description: "attachment=report.pdf",
      duration: 5000,
      groupId: "layout-toast",
      title: "Submitted",
      type: "info"
    })
  end

  test "ecto save without file shows validation error", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/file-upload-live/form")

    html =
      view
      |> form("#file-upload-live-form-ecto")
      |> render_submit(%{"file_upload_ecto" => %{"_sent" => "1"}})

    assert html =~ "file-upload-live-form-ecto_attachment"
    assert html =~ ~S|data-part="error"|
    assert html =~ "can&#39;t be blank"
    refute_push_event(view, "toast-create", %{})
  end

  test "ecto save ignores stale attachment_label when no files are selected", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/file-upload-live/form")

    html =
      view
      |> form("#file-upload-live-form-ecto")
      |> render_submit(%{
        "file_upload_ecto" => %{"_sent" => "1", "attachment_label" => "stale.pdf"}
      })

    assert html =~ ~S|data-part="error"|
    assert html =~ "can&#39;t be blank"
    refute_push_event(view, "toast-create", %{})
  end

  test "ecto shows error after clearing selected files", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/file-upload-live/form")

    render_hook(view, "file_upload_changed", %{
      "id" => "file-upload-live-form-ecto_attachment",
      "acceptedNames" => ["report.pdf"]
    })

    render_hook(view, "file_upload_changed", %{
      "id" => "file-upload-live-form-ecto_attachment",
      "acceptedNames" => []
    })

    html =
      view
      |> form("#file-upload-live-form-ecto")
      |> render_submit(%{"file_upload_ecto" => %{"_sent" => "1"}})

    assert html =~ ~S|data-part="error"|
    assert html =~ "can&#39;t be blank"
    refute_push_event(view, "toast-create", %{})
  end
end
