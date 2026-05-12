defmodule E2e.Form.ComboboxFormTest do
  use ExUnit.Case, async: true

  import Phoenix.Component

  alias E2e.Form.Combobox

  test "changeset_validate uses custom required message" do
    cs = Combobox.changeset_validate(%Combobox{}, %{"country" => ""})
    assert %{valid?: false} = cs
    assert [{msg, _} | _] = Keyword.get_values(cs.errors, :country)
    assert msg == "can't be blank"
  end

  test "to_form exposes country field name and id for basic form" do
    cs = Combobox.changeset(%Combobox{}, %{})
    f = to_form(cs, as: :combobox, id: "combobox-live-form")
    assert f[:country].name == "combobox[country]"
    assert f[:country].id == "combobox-live-form_country"
  end

  test "to_form exposes country field name for strict form" do
    cs = Combobox.changeset_validate(%Combobox{}, %{})
    f = to_form(cs, as: :combobox_strict, id: "combobox-strict-form-live")
    assert f[:country].name == "combobox_strict[country]"
    assert f[:country].id == "combobox-strict-form-live_country"
  end
end
