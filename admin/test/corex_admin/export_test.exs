defmodule CorexAdmin.ExportTest do
  use ExUnit.Case, async: true

  alias CorexAdmin.Export
  alias CorexAdmin.Resource.Field
  alias CorexAdmin.Test.TicketResource

  test "csv includes headers and rows" do
    spec = TicketResource.__corex_admin_resource__()
    title = Enum.find(spec.fields, &(&1.name == :title))
    records = [%{title: "Hello", email: "a@b.test"}]

    body = Export.encode(:csv, [title], records) |> Enum.join()
    assert body =~ "Title"
    assert body =~ "Hello"
  end

  test "json encodes maps" do
    field = %Field{name: :title, type: :text, label: "Title"}
    body = Export.encode(:json, [field], [%{title: "Hello"}]) |> Enum.join()
    assert Jason.decode!(body) == [%{"title" => "Hello"}]
  end

  test "redacted fields export as empty" do
    field = %Field{name: :secret, type: :text, label: "Secret", redact: true}
    body = Export.encode(:csv, [field], [%{secret: "s3cret"}]) |> Enum.join()
    refute body =~ "s3cret"
  end
end
