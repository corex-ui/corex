defmodule E2eWeb.FileUploadFormSubmitTest do
  use E2eWeb.ConnCase

  setup do
    Localize.put_locale(:en)
    :ok
  end

  defp post_form(params) do
    build_conn()
    |> Plug.Conn.put_private(:plug_skip_csrf_protection, true)
    |> post(~p"/file-upload/form", params)
  end

  test "POST phoenix form with empty attachment string succeeds", %{conn: _conn} do
    conn =
      post_form(%{
        "_file_upload_form" => "phoenix",
        "file_upload_phoenix" => %{"attachment" => ""}
      })

    assert redirected_to(conn) =~ "/file-upload/form#file-upload-form-phoenix"
    assert Phoenix.Flash.get(conn.assigns.flash, :info) == "Submitted: attachment=(none)"
    refute Phoenix.Flash.get(conn.assigns.flash, :error)
  end

  test "POST phoenix form without attachment key succeeds via _file_upload_form", %{conn: _conn} do
    conn =
      post_form(%{
        "_file_upload_form" => "phoenix",
        "file_upload_phoenix" => %{}
      })

    assert redirected_to(conn) =~ "/file-upload/form#file-upload-form-phoenix"
    assert Phoenix.Flash.get(conn.assigns.flash, :info) == "Submitted: attachment=(none)"
    refute Phoenix.Flash.get(conn.assigns.flash, :error)
  end

  test "POST phoenix form with list prefers Plug.Upload over empty string", %{conn: _conn} do
    path = Path.join(System.tmp_dir!(), "fu_list_#{System.unique_integer([:positive])}.txt")
    File.write!(path, "hello")

    upload = %Plug.Upload{path: path, filename: "fu_list.txt", content_type: "text/plain"}

    conn =
      post_form(%{
        "_file_upload_form" => "phoenix",
        "file_upload_phoenix" => ["", upload]
      })

    assert Phoenix.Flash.get(conn.assigns.flash, :info) == "Submitted: attachment=fu_list.txt"
  end

  test "POST phoenix form with attachment_label shows filenames", %{conn: _conn} do
    conn =
      post_form(%{
        "_file_upload_form" => "phoenix",
        "file_upload_phoenix" => %{"attachment_label" => "report.pdf, notes.txt"}
      })

    assert Phoenix.Flash.get(conn.assigns.flash, :info) ==
             "Submitted: attachment=report.pdf, notes.txt"
  end

  test "POST ecto form without file re-renders with validation error", %{conn: _conn} do
    conn =
      post_form(%{
        "_file_upload_form" => "ecto",
        "file_upload_ecto" => %{"_sent" => "1"}
      })

    html = html_response(conn, 200)
    assert html =~ "can&#39;t be blank"
    assert html =~ "file-upload-form-ecto"
    refute Phoenix.Flash.get(conn.assigns.flash, :error)
  end

  test "POST phoenix form with upload succeeds", %{conn: _conn} do
    path = Path.join(System.tmp_dir!(), "fu_test_#{System.unique_integer([:positive])}.txt")
    File.write!(path, "hello")

    upload = %Plug.Upload{path: path, filename: "fu_test.txt", content_type: "text/plain"}

    conn =
      post_form(%{
        "_file_upload_form" => "phoenix",
        "file_upload_phoenix" => %{"attachment" => upload}
      })

    assert Phoenix.Flash.get(conn.assigns.flash, :info) == "Submitted: attachment=fu_test.txt"
    refute Phoenix.Flash.get(conn.assigns.flash, :error)
  end

  test "POST native form without avatar key succeeds via _file_upload_form", %{conn: _conn} do
    conn =
      post_form(%{
        "_file_upload_form" => "native",
        "_csrf_token" => "ignored"
      })

    assert redirected_to(conn) =~ "/file-upload/form#file-upload-form-native"
    assert Phoenix.Flash.get(conn.assigns.flash, :info) == "Submitted: avatar=(none)"
    refute Phoenix.Flash.get(conn.assigns.flash, :error)
  end

  test "GET form page includes form markers and sentinel", %{conn: _conn} do
    html =
      build_conn()
      |> get(~p"/file-upload/form")
      |> html_response(200)

    assert html =~ ~S(name="_file_upload_form" value="phoenix")
    assert html =~ ~S(name="_file_upload_form" value="ecto")
    assert html =~ ~S(name="_file_upload_form" value="native")
    assert html =~ "file_upload_phoenix[attachment]"
    assert html =~ "hidden-input-sentinel"
    assert html =~ ~S(id="file-upload-phoenix-form")
    assert html =~ ~S(form="file-upload-phoenix-form")
    assert html =~ ~S(id="file-upload-ecto-form")
    assert html =~ ~S(form="file-upload-ecto-form")
    assert html =~ ~S(id="file-upload-plain-form" enctype="multipart/form-data")
  end
end
