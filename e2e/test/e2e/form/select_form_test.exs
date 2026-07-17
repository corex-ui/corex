defmodule E2e.Form.SelectFormTest do
  use ExUnit.Case, async: true

  import Phoenix.Component

  alias E2e.Form.SelectForm

  test "changeset uses custom required message" do
    cs = SelectForm.changeset(%SelectForm{}, %{"country" => ""})
    assert %{valid?: false} = cs
    assert [{msg, _} | _] = Keyword.get_values(cs.errors, :country)
    assert msg == "can't be blank"
  end

  test "to_form exposes country field name and id for basic form" do
    cs = SelectForm.changeset(%SelectForm{}, %{})
    f = to_form(cs, as: :select_form, id: "select-form")
    assert f[:country].name == "select_form[country]"
    assert f[:country].id == "select-form_country"
  end

  test "to_form exposes country field name for strict form" do
    cs = SelectForm.changeset(%SelectForm{}, %{})
    f = to_form(cs, as: :select_strict, id: "select-strict-form-live")
    assert f[:country].name == "select_strict[country]"
    assert f[:country].id == "select-strict-form-live_country"
  end
end
