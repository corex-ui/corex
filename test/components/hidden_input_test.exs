defmodule Corex.HiddenInputTest do
  use CorexTest.ComponentCase, async: true

  describe "hidden_input/1" do
    test "renders hidden input with id, name, value" do
      result =
        render_component(&Corex.HiddenInput.hidden_input/1,
          id: "user-id",
          name: "user[id]",
          value: "123"
        )

      elements = find_in_html(result, "input[type=hidden]#user-id")
      assert [_] = elements
      assert Floki.attribute(elements, "name") == ["user[id]"]
      assert Floki.attribute(elements, "value") == ["123"]
    end

    test "renders hidden input without field generates unique id" do
      result =
        render_component(&Corex.HiddenInput.hidden_input/1, name: "user[token]", value: "abc")

      elements = find_in_html(result, "input[type=hidden][name='user[token]']")
      assert [_] = elements
      assert Floki.attribute(elements, "value") == ["abc"]
    end

    test "renders hidden input with form field" do
      form = Phoenix.Component.to_form(%{"id" => "42"}, as: :user)
      field = form[:id]
      result = render_component(&Corex.HiddenInput.hidden_input/1, field: field)
      assert [_] = find_in_html(result, ~s(input[type=hidden][name="user[id]"]))
    end
  end
end
