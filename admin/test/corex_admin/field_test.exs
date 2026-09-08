defmodule CorexAdmin.FieldTest do
  use ExUnit.Case, async: true

  alias CorexAdmin.Field
  alias CorexAdmin.Resource.Field, as: FieldSpec

  test "built-in types have no host module" do
    assert Field.module(%FieldSpec{type: :text}) == nil
    assert Field.module(%FieldSpec{type: :select}) == nil
  end

  test "resolves a host module" do
    field = %FieldSpec{type: :custom, mod: CorexAdmin.Test.Fields.Uppercase, name: :title}
    assert Field.module(field) == CorexAdmin.Test.Fields.Uppercase
    assert Field.export(field, %{title: "Hi"}) == "Hi"
  end

  test "formats booleans and redaction" do
    assert Field.format(%FieldSpec{name: :ok, type: :boolean}, %{ok: true}) == "Yes"

    assert Field.format(%FieldSpec{name: :secret, type: :text, redact: true}, %{secret: "x"}) ==
             "••••"
  end
end
