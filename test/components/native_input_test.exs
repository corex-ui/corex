defmodule Corex.NativeInputTest do
  use CorexTest.ComponentCase, async: true

  describe "native_input/1" do
    test "renders text input" do
      result =
        render_component(&Corex.NativeInput.native_input/1,
          type: "text",
          id: "name",
          name: "user[name]",
          value: "John"
        )

      elements =
        find_in_html(result, ~s([data-scope="native-input"] input[type=text][name="user[name]"]))

      assert [_] = elements
      assert Floki.attribute(elements, "value") == ["John"]
    end

    test "renders textarea" do
      result =
        render_component(&Corex.NativeInput.native_input/1,
          type: "textarea",
          name: "user[bio]",
          value: "Hello"
        )

      assert [_] = find_in_html(result, ~s(textarea[name="user[bio]"]))
    end

    test "renders checkbox" do
      result =
        render_component(&Corex.NativeInput.native_input/1,
          type: "checkbox",
          name: "user[agree]",
          value: true
        )

      assert [_] = find_in_html(result, ~s(input[type=checkbox][name="user[agree]"]))
    end

    test "renders select with options" do
      result =
        render_component(&Corex.NativeInput.native_input/1,
          type: "select",
          name: "user[role]",
          options: [Admin: "admin", User: "user"],
          prompt: "Choose..."
        )

      assert [_] = find_in_html(result, ~s(select[name="user[role]"]))
    end

    test "renders radio with options" do
      result =
        render_component(&Corex.NativeInput.native_input/1,
          type: "radio",
          name: "user[size]",
          options: [Small: "s", Medium: "m", Large: "l"],
          value: "m"
        )

      assert find_in_html(result, ~s(input[type=radio][name="user[size]"])) != []
    end
  end
end
