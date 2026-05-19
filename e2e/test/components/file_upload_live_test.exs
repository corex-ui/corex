defmodule E2eWeb.FileUploadLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  test "playground renders", %{conn: conn} do
    {_view, html} = live_ok!(conn, ~p"/file-upload/playground")
    assert html =~ "file-upload-playground"
  end

  test "api page renders", %{conn: conn} do
    {_view, html} = live_ok!(conn, ~p"/file-upload/api")
    assert html =~ "file-upload-api-page"
  end

  test "events page renders", %{conn: conn} do
    {_view, html} = live_ok!(conn, ~p"/file-upload/events")
    assert html =~ "file-upload-events-page"
  end

  test "fu_ev_server inserts a log row", %{conn: conn} do
    {view, _html} = live_ok!(conn, ~p"/file-upload/events")

    html =
      render_click(view, "fu_ev_server", %{
        "id" => "file-upload-events-server",
        "acceptedCount" => 1,
        "rejectedCount" => 0
      })

    assert html =~ ~S(data-part="row")
  end

  test "anatomy page GET", %{conn: conn} do
    conn = get(conn, ~p"/file-upload/anatomy")
    body = html_response(conn, 200)
    assert body =~ "file-upload-anatomy-page"
    assert body =~ "file-upload-anatomy-custom-slots"
  end

  test "controller form page GET", %{conn: conn} do
    conn = get(conn, ~p"/file-upload/form")
    assert html_response(conn, 200) =~ "file-upload-form-page"
  end

  test "file upload live playground renders", %{conn: conn} do
    {_view, html} = live_ok!(conn, ~p"/file-upload-live/playground")
    assert html =~ "file-upload-live-playground"
  end

  test "file upload live anatomy renders", %{conn: conn} do
    {_view, html} = live_ok!(conn, ~p"/file-upload-live/anatomy")
    assert html =~ "file-upload-live-anatomy-page"
    assert html =~ "file-upload-live-anatomy-custom-slots"
  end

  test "file upload live form renders", %{conn: conn} do
    {_view, html} = live_ok!(conn, ~p"/file-upload-live/form")
    assert html =~ "file-upload-form-live-page"
    assert html =~ "file-upload-live-field"
  end

  test "multipart POST validate branch shows attachment error when empty", %{conn: conn} do
    conn =
      post(conn, ~p"/file-upload/form", %{
        "file_upload_validate" => %{"_sent" => "1", "attachment" => ""}
      })

    body = html_response(conn, 200)
    assert body =~ ~S(data-part="error")
    assert body =~ "can&#39;t be blank" or body =~ "can't be blank"
  end

  test "multipart POST changeset branch succeeds", %{conn: conn} do
    tmp = Path.join(System.tmp_dir!(), "corex_fu_test_#{System.unique_integer([:positive])}")

    try do
      :ok = File.write!(tmp, "hello")

      upload = %Plug.Upload{
        path: tmp,
        filename: "note.txt",
        content_type: "text/plain"
      }

      conn =
        post(conn, ~p"/file-upload/form", %{
          "file_upload_changeset" => %{"attachment" => upload}
        })

      assert redirected_to(conn) == ~p"/file-upload/form#file-upload-form-changeset"
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Submitted (changeset)"
    after
      _ = File.rm(tmp)
    end
  end
end
