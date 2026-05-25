defmodule E2e.Form.PinInputFormTest do
  use ExUnit.Case, async: true

  import Phoenix.Component

  alias E2e.Form.PinInputForm

  test "to_form exposes pin field name and id" do
    cs = PinInputForm.changeset(%PinInputForm{}, %{})
    f = to_form(cs, as: :pin_input_form, id: "pin-input-form")
    assert f[:pin].name == "pin_input_form[pin]"
    assert f[:pin].id == "pin-input-form_pin"
  end

  test "changeset applies pin array" do
    cs = PinInputForm.changeset(%PinInputForm{}, %{"pin" => ["1", "2", "3", "4"]})
    assert cs.valid?
    assert Ecto.Changeset.apply_changes(cs).pin == ["1", "2", "3", "4"]
  end

  test "changeset_validate requires four single-character digits" do
    cs = PinInputForm.changeset_validate(%PinInputForm{}, %{"pin" => ["1", "2", "3", "4"]})
    assert cs.valid?
  end
end
