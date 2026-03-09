defmodule Corex.NativeInputTest do
  use CorexTest.ComponentCase, async: true
  import Phoenix.Component

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

    test "renders with form field" do
      form = %Phoenix.HTML.Form{id: "user", name: "user", data: %{}, params: %{}}
      field = %Phoenix.HTML.FormField{form: form, field: :email, id: "user_email", name: "user[email]", value: "test@example.com", errors: []}
      
      result =
        render_component(&Corex.NativeInput.native_input/1,
          type: "email",
          field: field
        )

      assert [_] = find_in_html(result, ~s(input[type=email][name="user[email]"][value="test@example.com"]))
    end

    test "renders with form field with multiple true" do
      form = %Phoenix.HTML.Form{id: "user", name: "user", data: %{}, params: %{}}
      field = %Phoenix.HTML.FormField{form: form, field: :roles, id: "user_roles", name: "user[roles]", value: [], errors: []}
      
      result =
        render_component(&Corex.NativeInput.native_input/1,
          type: "select",
          multiple: true,
          field: field,
          options: ["Admin", "User"]
        )

      assert [_] = find_in_html(result, ~s(select[name="user[roles][]"]))
    end

    test "renders with icon" do
      assigns = %{}
      result = render_component(fn _assigns ->
        ~H"""
        <Corex.NativeInput.native_input type="email" name="email">
          <:icon>Icon Content</:icon>
        </Corex.NativeInput.native_input>
        """
      end, assigns)

      assert result =~ "Icon Content"
      refute result =~ "data-no-icon"
    end
  end
end
