defmodule E2e.Form.FileUploadFormTest do
  use ExUnit.Case, async: true

  alias E2e.Form.FileUploadForm

  test "names_label/1 with Plug.Upload" do
    upload = %Plug.Upload{filename: "report.pdf", path: "/tmp/x", content_type: "application/pdf"}
    assert FileUploadForm.names_label(upload) == "report.pdf"
  end

  test "names_label/1 with multiple names" do
    assert FileUploadForm.names_label(["a.png", "b.pdf"]) == "a.png, b.pdf"
  end

  test "names_from_event/1" do
    assert FileUploadForm.names_from_event(%{"acceptedNames" => ["doc.txt"]}) == "doc.txt"
    assert FileUploadForm.names_from_event(%{}) == "(none)"
  end

  test "submit_label/3 uses attachment_label when no Plug.Upload" do
    assert FileUploadForm.submit_label(nil, %{"attachment_label" => "a.pdf"}, "attachment_label") ==
             "a.pdf"
  end

  test "changeset_validate/2 accepts attachment_label without Plug.Upload" do
    assert %FileUploadForm{}
           |> FileUploadForm.changeset_validate(%{"attachment_label" => "report.pdf"})
           |> then(& &1.valid?)
  end

  test "put_attachment_label/2 merges accepted names" do
    assert FileUploadForm.put_attachment_label(%{}, ["a.pdf", "b.txt"]) == %{
             "attachment_label" => "a.pdf, b.txt"
           }
  end
end
